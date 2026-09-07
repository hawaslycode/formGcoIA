import { useState } from "react";
import "./Autenticacion.css";
import { fetchConAuth } from "../api/clienteApi";

/**
 * Indicador visual de fortaleza de contraseña.
 * Evalúa longitud, mayúsculas, números y caracteres especiales.
 */
const calcularFortaleza = (contrasena) => {
  if (!contrasena) return { nivel: 0, etiqueta: "", color: "" };
  let puntos = 0;
  if (contrasena.length >= 8) puntos++;
  if (/[A-Z]/.test(contrasena)) puntos++;
  if (/[0-9]/.test(contrasena)) puntos++;
  if (/[^A-Za-z0-9]/.test(contrasena)) puntos++;

  const niveles = [
    { nivel: 1, etiqueta: "Muy débil", color: "#e63946" },
    { nivel: 2, etiqueta: "Débil", color: "#f4a261" },
    { nivel: 3, etiqueta: "Buena", color: "#2a9d8f" },
    { nivel: 4, etiqueta: "Muy segura", color: "#1a936f" },
  ];
  return niveles[puntos - 1] || { nivel: 0, etiqueta: "", color: "" };
};

const IconoCandado = () => (
  <svg className="icono-input" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
  </svg>
);

const IconoOjoAbierto = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
    <circle cx="12" cy="12" r="3"/>
  </svg>
);

const IconoOjoCerrado = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
    <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
    <line x1="1" y1="1" x2="23" y2="23"/>
  </svg>
);

const IconoEscudoSeguridad = () => (
  <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#ffffff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
    <rect x="9" y="11" width="6" height="5" rx="1"/>
    <path d="M10 11V9.5a2 2 0 0 1 4 0V11"/>
  </svg>
);

const IconoCheckVerde = () => (
  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#22c55e" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="20 6 9 17 4 12"/>
  </svg>
);

/**
 * Componente funcional encargado de renderizar la vista para crear una nueva contraseña.
 */
export const RestablecerContrasena = () => {
  const [contrasenaNueva, establecerContrasenaNueva] = useState("");
  const [confirmarContrasena, establecerConfirmarContrasena] = useState("");
  const [estaCargando, establecerEstaCargando] = useState(false);
  const [verContrasena, establecerVerContrasena] = useState(false);
  const [verConfirmar, establecerVerConfirmar] = useState(false);

  const [tokenRecuperacion] = useState(() => {
    const parametrosUrl = new URLSearchParams(window.location.search);
    return parametrosUrl.get("token");
  });

  const [mensajeAlerta, establecerMensajeAlerta] = useState(() => {
    if (!tokenRecuperacion) {
      return {
        texto: "Enlace inválido o corrupto. No se detectó un token de seguridad en la URL.",
        tipo: "error",
      };
    }
    return { texto: "", tipo: "" };
  });

  const fortaleza = calcularFortaleza(contrasenaNueva);
  const coinciden = contrasenaNueva && confirmarContrasena && contrasenaNueva === confirmarContrasena;

  const manejarActualizacionContrasena = async (evento) => {
    evento.preventDefault();

    if (contrasenaNueva !== confirmarContrasena) {
      establecerMensajeAlerta({
        texto: "Las contraseñas no coinciden. Por favor, verifíquelas e intente nuevamente.",
        tipo: "error",
      });
      return;
    }

    if (!tokenRecuperacion) {
      establecerMensajeAlerta({
        texto: "No es posible procesar la solicitud sin un token de seguridad válido.",
        tipo: "error",
      });
      return;
    }

    establecerEstaCargando(true);
    establecerMensajeAlerta({ texto: "", tipo: "" });

    try {
      const respuesta = await fetchConAuth("/api/autenticacion/cambiar-contrasena", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          tokenAcceso: tokenRecuperacion,
          nuevaContrasena: contrasenaNueva,
        }),
      });

      if (respuesta.ok) {
        establecerMensajeAlerta({
          texto: "¡Contraseña actualizada con éxito! Ya puede regresar a la pantalla de inicio de sesión.",
          tipo: "exito",
        });
        establecerContrasenaNueva("");
        establecerConfirmarContrasena("");
      } else {
        const mensajeError = await respuesta.text();
        establecerMensajeAlerta({
          texto: mensajeError || "No se pudo actualizar la contraseña en el servidor.",
          tipo: "error",
        });
      }
    } catch (excepcion) {
      console.error("Error al actualizar la contraseña:", excepcion);
      establecerMensajeAlerta({
        texto: "Error de conexión con el servidor backend en Spring Boot.",
        tipo: "error",
      });
    } finally {
      establecerEstaCargando(false);
    }
  };

  return (
    <div className="contenedor-autenticacion">

      {/* ==================== PANEL IZQUIERDO — SEGURIDAD ==================== */}
      <aside className="panel-marca">
        <div style={{
          width: "90px",
          height: "90px",
          borderRadius: "50%",
          background: "rgba(255,255,255,0.1)",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          marginBottom: "32px",
          animation: "flotar 4s ease-in-out infinite",
          position: "relative",
          zIndex: 1,
        }}>
          <IconoEscudoSeguridad />
        </div>
        <h1 className="titulo-panel-marca">
          Restablecer Contraseña
        </h1>
        <p className="subtitulo-panel-marca">
          Cree una nueva contraseña segura para proteger su cuenta en el Programa de Lealtad GCO.
        </p>

        {/* Tips de seguridad */}
        <div style={{
          background: "rgba(255,255,255,0.08)",
          borderRadius: "12px",
          padding: "20px",
          maxWidth: "300px",
          width: "100%",
          position: "relative",
          zIndex: 1,
        }}>
          <p style={{ color: "rgba(255,255,255,0.6)", fontSize: "0.72rem", fontWeight: "700", letterSpacing: "0.5px", textTransform: "uppercase", marginBottom: "12px" }}>
            Consejos de Seguridad
          </p>
          {[
            "Mínimo 8 caracteres",
            "Al menos una mayúscula",
            "Al menos un número",
            "Un carácter especial (!@#$%)",
          ].map((tip) => (
            <div key={tip} style={{ display: "flex", alignItems: "center", gap: "8px", color: "rgba(255,255,255,0.85)", fontSize: "0.82rem", marginBottom: "6px" }}>
              <IconoCheckVerde />
              <span>{tip}</span>
            </div>
          ))}
        </div>

        <div className="divisor-panel" />
      </aside>

      {/* ==================== PANEL DERECHO — FORMULARIO ==================== */}
      <section className="panel-formulario">
        <div className="tarjeta-autenticacion">

          <h2 className="titulo-autenticacion">Crear Nueva Contraseña</h2>
          <p className="descripcion-autenticacion">
            Ingrese y confirme su nueva contraseña de acceso seguro.
          </p>

          {/* Alertas */}
          {mensajeAlerta.texto && (
            <div className={`aviso-alerta ${mensajeAlerta.tipo}`}>
              <span>{mensajeAlerta.texto}</span>
              <button
                type="button"
                className="boton-cerrar-aviso"
                onClick={() => establecerMensajeAlerta({ texto: "", tipo: "" })}
              >
                &times;
              </button>
            </div>
          )}

          <form onSubmit={manejarActualizacionContrasena}>
            {/* Nueva contraseña */}
            <div className="grupo-input">
              <label htmlFor="contrasenaNueva">Nueva Contraseña</label>
              <div className="input-con-icono">
                <IconoCandado />
                <input
                  type={verContrasena ? "text" : "password"}
                  id="contrasenaNueva"
                  value={contrasenaNueva}
                  onChange={(e) => establecerContrasenaNueva(e.target.value)}
                  placeholder="••••••••"
                  required
                  disabled={estaCargando || !tokenRecuperacion}
                  style={{ paddingRight: "44px" }}
                />
                <button
                  type="button"
                  className="boton-toggle-password"
                  onClick={() => establecerVerContrasena((v) => !v)}
                  tabIndex={-1}
                >
                  {verContrasena ? <IconoOjoCerrado /> : <IconoOjoAbierto />}
                </button>
              </div>

              {/* Indicador de fortaleza */}
              {contrasenaNueva && (
                <div style={{ marginTop: "8px" }}>
                  <div style={{ display: "flex", gap: "4px", marginBottom: "4px" }}>
                    {[1, 2, 3, 4].map((n) => (
                      <div
                        key={n}
                        style={{
                          flex: 1,
                          height: "4px",
                          borderRadius: "2px",
                          background: n <= fortaleza.nivel ? fortaleza.color : "#e5e7eb",
                          transition: "background 0.3s ease",
                        }}
                      />
                    ))}
                  </div>
                  {fortaleza.etiqueta && (
                    <p style={{ fontSize: "0.75rem", color: fortaleza.color, fontWeight: "600" }}>
                      {fortaleza.etiqueta}
                    </p>
                  )}
                </div>
              )}
            </div>

            {/* Confirmar contraseña */}
            <div className="grupo-input">
              <label htmlFor="confirmarContrasena">Confirmar Contraseña</label>
              <div className="input-con-icono">
                <IconoCandado />
                <input
                  type={verConfirmar ? "text" : "password"}
                  id="confirmarContrasena"
                  value={confirmarContrasena}
                  onChange={(e) => establecerConfirmarContrasena(e.target.value)}
                  placeholder="••••••••"
                  required
                  disabled={estaCargando || !tokenRecuperacion}
                  style={{
                    paddingRight: "44px",
                    borderColor: confirmarContrasena
                      ? coinciden
                        ? "#22c55e"
                        : "#e63946"
                      : undefined,
                  }}
                />
                <button
                  type="button"
                  className="boton-toggle-password"
                  onClick={() => establecerVerConfirmar((v) => !v)}
                  tabIndex={-1}
                >
                  {verConfirmar ? <IconoOjoCerrado /> : <IconoOjoAbierto />}
                </button>
              </div>
              {confirmarContrasena && (
                <p style={{
                  fontSize: "0.75rem",
                  fontWeight: "600",
                  color: coinciden ? "#22c55e" : "#e63946",
                  marginTop: "4px",
                }}>
                  {coinciden ? "✓ Las contraseñas coinciden" : "✗ Las contraseñas no coinciden"}
                </p>
              )}
            </div>

            {/* Botón principal */}
            <button
              type="submit"
              id="boton-actualizar-contrasena"
              className="boton-principal-auth"
              disabled={estaCargando || !tokenRecuperacion}
            >
              {estaCargando ? (
                <div className="contenedor-cargador">
                  <span className="cargador-giratorio"></span>
                  <span>Procesando...</span>
                </div>
              ) : (
                "Actualizar Contraseña"
              )}
            </button>
          </form>

          <div className="enlace-cambio-modo">
            <p>
              ¿Recordó su contraseña?{" "}
              <a href="/" style={{ color: "var(--color-azul-oscuro)", fontWeight: "700", textDecoration: "none" }}>
                Inicie sesión aquí
              </a>
            </p>
          </div>
        </div>
      </section>
    </div>
  );
};