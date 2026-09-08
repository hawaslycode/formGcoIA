package com.gco.lealtad_gco_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Clase principal que arranca la aplicacion backend del programa de lealtad
 * GCO.
 */
@SpringBootApplication
public class LealtadGcoBackendApplication {

    /**
     * Metodo principal de ejecucion.
     * 
     * @param argumentos Argumentos de linea de comandos.
     */
    public static void main(String[] argumentos) {
        SpringApplication.run(LealtadGcoBackendApplication.class, argumentos);
    }
}