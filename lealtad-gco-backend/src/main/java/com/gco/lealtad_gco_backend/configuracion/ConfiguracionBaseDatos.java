package com.gco.lealtad_gco_backend.configuracion;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;
import java.net.URI;

/**
 * Configuración adaptativa del DataSource.
 * Soporta URLs estándar JDBC (jdbc:postgresql://...) y URLs nativas de plataformas 
 * Cloud como Render, Railway, Supabase o Neon (postgres://user:pass@host:port/db o postgresql://...).
 */
@Configuration
public class ConfiguracionBaseDatos {

    @Value("${spring.datasource.url:jdbc:postgresql://localhost:5432/db_lealtad_gco}")
    private String urlBaseDatos;

    @Value("${spring.datasource.username:postgres}")
    private String usuario;

    @Value("${spring.datasource.password:admin}")
    private String contrasena;

    @Bean
    @Primary
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();

        String urlProcesada = urlBaseDatos != null ? urlBaseDatos.trim() : "";
        String userProcesado = usuario;
        String passProcesado = contrasena;

        // Si la URL viene en formato postgres:// o postgresql:// (común en Render / Neon / Supabase)
        if (urlProcesada.startsWith("postgres://") || urlProcesada.startsWith("postgresql://")) {
            try {
                URI uri = new URI(urlProcesada);
                String host = uri.getHost();
                int port = uri.getPort() > 0 ? uri.getPort() : 5432;
                String path = uri.getPath();
                String dbName = (path != null && path.length() > 1) ? path.substring(1) : "db_lealtad_gco";

                if (uri.getUserInfo() != null) {
                    String[] credenciales = uri.getUserInfo().split(":", 2);
                    if (credenciales.length > 0 && !credenciales[0].isEmpty()) {
                        userProcesado = credenciales[0];
                    }
                    if (credenciales.length > 1) {
                        passProcesado = credenciales[1];
                    }
                }

                urlProcesada = "jdbc:postgresql://" + host + ":" + port + "/" + dbName;
                if (uri.getQuery() != null && !uri.getQuery().isEmpty()) {
                    urlProcesada += "?" + uri.getQuery();
                }
            } catch (Exception e) {
                if (!urlProcesada.startsWith("jdbc:")) {
                    urlProcesada = "jdbc:" + urlProcesada;
                }
            }
        } else if (!urlProcesada.startsWith("jdbc:") && !urlProcesada.isEmpty()) {
            urlProcesada = "jdbc:" + urlProcesada;
        }

        config.setJdbcUrl(urlProcesada);
        config.setUsername(userProcesado);
        config.setPassword(passProcesado);
        config.setDriverClassName("org.postgresql.Driver");

        return new HikariDataSource(config);
    }
}
