package com.gco.lealtad_gco_backend.modelo;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entidad que representa la tabla 'tokens_recuperacion' en la base de datos PostgreSQL.
 * Almacena de forma temporal los tokens criptograficos de un solo uso para la recuperacion de contrasenas.
 */
@Entity
@Table(name = "tokens_recuperacion")
public class TokenRecuperacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Token criptografico unico que se enviara embebido en la URL del correo electronico
    @Column(nullable = false, unique = true)
    private String tokenAcceso;

    // Correo electronico del usuario que solicita la recuperacion de su cuenta
    @Column(nullable = false)
    private String correoUsuario;

    // Fecha y hora exacta de expiracion del token por motivos de seguridad (ej. 15 minutos)
    @Column(nullable = false)
    private LocalDateTime fechaExpiracion;

    /**
     * Constructor vacio predeterminado requerido por la especificacion de JPA (Hibernate).
     */
    public TokenRecuperacion() {
    }

    /**
     * Constructor principal para instanciar un nuevo token de recuperacion con calculo automatico de expiracion.
     * 
     * @param tokenAcceso El token unico generado.
     * @param correoUsuario El correo del usuario solicitante.
     * @param minutosValidez El tiempo de vida util expresado en minutos.
     */
    public TokenRecuperacion(String tokenAcceso, String correoUsuario, int minutosValidez) {
        this.tokenAcceso = tokenAcceso;
        this.correoUsuario = correoUsuario;
        this.fechaExpiracion = LocalDateTime.now().plusMinutes(minutosValidez);
    }

    // Getters y setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTokenAcceso() {
        return tokenAcceso;
    }

    public void setTokenAcceso(String tokenAcceso) {
        this.tokenAcceso = tokenAcceso;
    }

    public String getCorreoUsuario() {
        return correoUsuario;
    }

    public void setCorreoUsuario(String correoUsuario) {
        this.correoUsuario = correoUsuario;
    }

    public LocalDateTime getFechaExpiracion() {
        return fechaExpiracion;
    }

    public void setFechaExpiracion(LocalDateTime fechaExpiracion) {
        this.fechaExpiracion = fechaExpiracion;
    }
}