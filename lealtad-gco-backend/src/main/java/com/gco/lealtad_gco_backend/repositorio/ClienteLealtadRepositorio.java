package com.gco.lealtad_gco_backend.repositorio;

import com.gco.lealtad_gco_backend.modelo.ClienteLealtad;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

/**
 * Repositorio encargado de gestionar la persistencia del perfil de lealtad del
 * cliente.
 */
public interface ClienteLealtadRepositorio extends JpaRepository<ClienteLealtad, Long> {

    /**
     * Permite precargar la informacion consultando por el correo de la sesion
     * activa.
     */
    Optional<ClienteLealtad> findByCorreoElectronico(String correoElectronico);
}
