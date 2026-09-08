package com.gco.lealtad_gco_backend.servicio;

import com.gco.lealtad_gco_backend.modelo.TokenRecuperacion;
import com.gco.lealtad_gco_backend.modelo.Usuario;
import com.gco.lealtad_gco_backend.repositorio.TokenRecuperacionRepositorio;
import com.gco.lealtad_gco_backend.repositorio.UsuarioRepositorio;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Servicio encargado de orquestar la logica de negocio para la recuperacion de contrasenas.
 * Gestiona la generacion de tokens seguros, el despacho de correos SMTP y el cambio de claves con BCrypt.
 */
@Service
public class ServicioRecuperacion {

    private final TokenRecuperacionRepositorio tokenRecuperacionRepositorio;
    private final JavaMailSender despachadorDeCorreos;
    private final UsuarioRepositorio usuarioRepositorio;
    private final PasswordEncoder codificadorContrasenas;

    @Value("${app.frontend.url:https://formulariogcolealtad.vercel.app}")
    private String urlFrontend;

    /**
     * Inyeccion de dependencias mediante el constructor de la clase.
     */
    public ServicioRecuperacion(TokenRecuperacionRepositorio tokenRecuperacionRepositorio,
            JavaMailSender despachadorDeCorreos,
            UsuarioRepositorio usuarioRepositorio,
            PasswordEncoder codificadorContrasenas) {
        this.tokenRecuperacionRepositorio = tokenRecuperacionRepositorio;
        this.despachadorDeCorreos = despachadorDeCorreos;
        this.usuarioRepositorio = usuarioRepositorio;
        this.codificadorContrasenas = codificadorContrasenas;
    }

    /**
     * Procesa la solicitud inicial de recuperacion: depura tokens viejos, genera un nuevo UUID,
     * almacena el registro en PostgreSQL y envia las instrucciones al correo del usuario[cite: 2].
     * 
     * @param correoUsuario Correo electronico del usuario que solicita la recuperacion.
     */
    @Transactional
    public void procesarSolicitudRecuperacion(String correoUsuario) {
        if (correoUsuario == null || correoUsuario.trim().isEmpty()) {
            throw new IllegalArgumentException("Debe ingresar un correo electrónico válido.");
        }

        // 1. Verificamos si el correo existe en la base de datos de usuarios
        boolean existeUsuario = usuarioRepositorio.findByCorreoElectronico(correoUsuario).isPresent();
        if (!existeUsuario) {
            throw new IllegalArgumentException("El correo electrónico ingresado no se encuentra registrado en el sistema.");
        }

        // 2. Limpiamos cualquier token previo asociado a este correo
        tokenRecuperacionRepositorio.deleteByCorreoUsuario(correoUsuario);

        // 3. Generamos un identificador criptografico unico (UUID)
        String tokenGenerado = UUID.randomUUID().toString();

        // 4. Creamos el token con una vigencia estricta de 15 minutos
        TokenRecuperacion nuevoToken = new TokenRecuperacion(tokenGenerado, correoUsuario, 15);
        
        // 5. Guardamos la entidad en la base de datos PostgreSQL
        tokenRecuperacionRepositorio.save(nuevoToken);

        // 6. Despachamos el correo electronico mediante SMTP con resguardo (fallback) en consola
        try {
            enviarCorreoRecuperacion(correoUsuario, tokenGenerado);
        } catch (Exception excepcionSmtp) {
            System.err.println("[SMTP ADVERTENCIA] No se pudo enviar el correo mediante el servidor SMTP: " + excepcionSmtp.getMessage());
            System.out.println("[INFO] Enlace de recuperación generado: " + urlFrontend + "/restablecer-contrasena?token=" + tokenGenerado);
        }
    }

    /**
     * Construye la estructura del mensaje de correo electronico con el enlace de restablecimiento seguro.
     * 
     * @param destinatario Correo destino del usuario.
     * @param token Token criptografico unico generado.
     */
    private void enviarCorreoRecuperacion(String destinatario, String token) {
        String enlaceRecuperacion = urlFrontend + "/restablecer-contrasena?token=" + token;

        SimpleMailMessage mensajeCorreo = new SimpleMailMessage();
        mensajeCorreo.setFrom("hawaslycode@gmail.com");
        mensajeCorreo.setTo(destinatario);
        mensajeCorreo.setSubject("GCO - Instrucciones de Recuperación de Contraseña");
        mensajeCorreo.setText("Hola,\n\n"
                + "Hemos recibido una solicitud para restablecer su contraseña en el programa de fidelidad GCO.\n"
                + "Por favor, haga clic en el siguiente enlace seguro para crear una nueva contraseña. "
                + "Este enlace caducará en 15 minutos por motivos de seguridad:\n\n"
                + enlaceRecuperacion + "\n\n"
                + "Si usted no solicitó este cambio, ignore y elimine este mensaje.\n\n"
                + "Atentamente,\nEquipo de Seguridad GCO");

        despachadorDeCorreos.send(mensajeCorreo);
    }

    /**
     * Valida la autenticidad y vigencia del token recibido, busca al usuario en la base de datos,
     * cifra la nueva contrasena con BCrypt, actualiza el registro y elimina el token de un solo uso[cite: 2].
     * 
     * @param tokenAcceso El token unico proveniente de la URL del frontend.
     * @param nuevaContrasena La nueva contrasena en texto plano introducida por el usuario.
     */
    @Transactional
    public void cambiarContrasenaConToken(String tokenAcceso, String nuevaContrasena) {
        // 1. Verificamos la existencia del token en PostgreSQL
        TokenRecuperacion tokenGuardado = tokenRecuperacionRepositorio.findByTokenAcceso(tokenAcceso)
                .orElseThrow(() -> new IllegalArgumentException("El token de seguridad es inválido o no existe."));

        // 2. Validamos si el token ha superado los 15 minutos de caducidad
        if (tokenGuardado.getFechaExpiracion().isBefore(LocalDateTime.now())) {
            tokenRecuperacionRepositorio.delete(tokenGuardado);
            throw new IllegalArgumentException("El enlace de recuperación ha expirado. Por favor, solicite uno nuevo.");
        }

        // 3. Localizamos al usuario dueno del correo asociado al token
        Usuario usuario = usuarioRepositorio.findByCorreoElectronico(tokenGuardado.getCorreoUsuario())
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado en el sistema."));

        // 4. Encriptamos la nueva contrasena utilizando BCrypt
        usuario.setContrasena(codificadorContrasenas.encode(nuevaContrasena));
        
        // 5. Persistimos los cambios del usuario
        usuarioRepositorio.save(usuario);

        // 6. Eliminamos el token utilizado para garantizar que no pueda ser reutilizado
        tokenRecuperacionRepositorio.delete(tokenGuardado);
    }
}