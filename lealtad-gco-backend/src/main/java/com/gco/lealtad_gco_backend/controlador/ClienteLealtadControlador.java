package com.gco.lealtad_gco_backend.controlador;

import com.gco.lealtad_gco_backend.modelo.ClienteLealtad;
import com.gco.lealtad_gco_backend.repositorio.ClienteLealtadRepositorio;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

/**
 * Controlador REST encargado de gestionar los perfiles del programa de lealtad.
 */
@RestController
@RequestMapping("/api/lealtad")
@CrossOrigin(originPatterns = "*")
public class ClienteLealtadControlador {

    private final ClienteLealtadRepositorio repositorioDeLealtad;

    public ClienteLealtadControlador(ClienteLealtadRepositorio repositorioDeLealtad) {
        this.repositorioDeLealtad = repositorioDeLealtad;
    }

    /**
     * Endpoint GET que facilita la precarga automatica de datos en el frontend de
     * React.
     * 
     * @param correoElectronico Correo asociado a la sesion del usuario.
     * @return Los datos del cliente registrados previamente.
     */
    @GetMapping("/cliente/correo/{correoElectronico}")
    public ResponseEntity<?> obtenerPerfilPorCorreo(@PathVariable String correoElectronico) {
        try {
            Optional<ClienteLealtad> perfilEncontrado = repositorioDeLealtad
                    .findByCorreoElectronicoIgnoreCase(correoElectronico);

            if (perfilEncontrado.isPresent()) {
                return ResponseEntity.ok(perfilEncontrado.get());
            }

            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No existen datos de lealtad registrados para este correo.");
        } catch (Exception excepcion) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ocurrio un error al consultar el perfil de lealtad.");
        }
    }

    /**
     * Endpoint POST que ejecuta logica de 'Upsert' por correo y numero de identificacion.
     */
    @PostMapping("/registrar")
    public ResponseEntity<?> registrarOActualizarPerfil(@RequestBody ClienteLealtad datosFormulario) {
        try {
            if (datosFormulario.getCorreoElectronico() == null || datosFormulario.getCorreoElectronico().trim().isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("El correo electronico es obligatorio.");
            }

            if (datosFormulario.getNumeroIdentificacion() == null || datosFormulario.getNumeroIdentificacion().trim().isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("El numero de identificacion es obligatorio.");
            }

            String correo = datosFormulario.getCorreoElectronico().trim();
            String doc = datosFormulario.getNumeroIdentificacion().trim();

            datosFormulario.setCorreoElectronico(correo);
            datosFormulario.setNumeroIdentificacion(doc);

            Optional<ClienteLealtad> registroPorCorreo = repositorioDeLealtad.findByCorreoElectronicoIgnoreCase(correo);
            Optional<ClienteLealtad> registroPorDocumento = repositorioDeLealtad.findByNumeroIdentificacion(doc);

            ClienteLealtad perfilDestino;

            if (registroPorCorreo.isPresent() && registroPorDocumento.isPresent()) {
                if (!registroPorCorreo.get().getIdCliente().equals(registroPorDocumento.get().getIdCliente())) {
                    return ResponseEntity.status(HttpStatus.CONFLICT)
                            .body("El numero de identificacion ya se encuentra registrado para otra cuenta de usuario.");
                }
                perfilDestino = registroPorCorreo.get();
            } else if (registroPorCorreo.isPresent()) {
                perfilDestino = registroPorCorreo.get();
            } else if (registroPorDocumento.isPresent()) {
                perfilDestino = registroPorDocumento.get();
                perfilDestino.setCorreoElectronico(correo);
            } else {
                perfilDestino = datosFormulario;
            }

            perfilDestino.setTipoIdentificacion(datosFormulario.getTipoIdentificacion());
            perfilDestino.setNumeroIdentificacion(doc);
            perfilDestino.setNombres(datosFormulario.getNombres());
            perfilDestino.setApellidos(datosFormulario.getApellidos());
            perfilDestino.setFechaNacimiento(datosFormulario.getFechaNacimiento());
            perfilDestino.setDireccion(datosFormulario.getDireccion());
            perfilDestino.setPais(datosFormulario.getPais());
            perfilDestino.setDepartamento(datosFormulario.getDepartamento());
            perfilDestino.setCiudad(datosFormulario.getCiudad());
            perfilDestino.setIdMarca(datosFormulario.getIdMarca());

            ClienteLealtad perfilGuardado = repositorioDeLealtad.save(perfilDestino);
            return ResponseEntity.ok(perfilGuardado);

        } catch (Exception excepcion) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al procesar el registro de lealtad: " + excepcion.getMessage());
        }
    }
}