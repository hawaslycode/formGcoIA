import { useState } from "react";
import "./Autenticacion.css";
import logoGco from "../assets/gcologo.png";
import { fetchConAuth } from "../api/clienteApi";


/**
 * Íconos SVG inline para los inputs (evita dependencia de librerías externas).
 */
const IconoCorreo = () => (
  <svg className="icono-input" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
    <polyline points="22,6 12,13 2,6"/>
  </svg>
);

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

/** Marcas del Grupo GCO para el panel lateral */
const MARCAS_GCO = [
  "Americanino",
  "Amer. Eagle",
  "Chevignon",
  "Esprit",
  "Naf Naf",
  "Rifle",
];

/**
 * Componente para el inicio de sesión y registro de usuarios.
 * Diseño split-screen premium — lógica de negocio intacta.
 */
export const Autenticacion = ({ alAutenticar }) => {
  const [esRegistro, establecerEsRegistro] = useState(false);
  const [correoElectronico, establecerCorreoElectronico] = useState("");
  const [contrasena, establecerContrasena] = useState("");
  const [aceptaTerminos, establecerAceptaTerminos] = useState(false);
  const [verContrasena, establecerVerContrasena] = useState(false);

  const [estaCargando, establecerEstaCargando] = useState(false);

  const [mensajeAlerta, establecerMensajeAlerta] = useState({
    texto: "",
    tipo: "",
  });

  const manejarEnvioAutenticacion = async (evento) => {
    evento.preventDefault();

    if (!aceptaTerminos) {
      establecerMensajeAlerta({
        texto: "Debe aceptar los términos, condiciones y la política de tratamiento de datos personales para continuar.",
        tipo: "error",
      });
      return;
    }

    const endpoint = esRegistro
      ? "/api/autenticacion/registrar"
      : "/api/autenticacion/login";

    establecerEstaCargando(true);
    establecerMensajeAlerta({ texto: "", tipo: "" });

    try {
      const respuesta = await fetchConAuth(`${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ correoElectronico, contrasena }),
      });

      if (respuesta.ok) {
        const datosRespuesta = await respuesta.json();

        if (!esRegistro) {
          localStorage.setItem("tokenAcceso", datosRespuesta.tokenAcceso);
          localStorage.setItem(
            "correoUsuario",
            datosRespuesta.usuario.correoElectronico,
          );
        }

        establecerMensajeAlerta({
          texto: esRegistro
            ? "¡Cuenta creada con éxito! Por favor, inicie sesión."
            : "¡Inicio de sesión exitoso!",
          tipo: "exito",
        });

        setTimeout(() => {
          if (esRegistro) {
            establecerEsRegistro(false);
            establecerMensajeAlerta({ texto: "", tipo: "" });
            establecerContrasena("");
          } else {
            alAutenticar({ correo: datosRespuesta.usuario.correoElectronico });
          }
        }, 1500);
      } else {
        const textoError = await respuesta.text();

        if (respuesta.status === 404 && !esRegistro) {
          establecerMensajeAlerta({
            texto: "El correo ingresado no se encuentra registrado. ¿Desea crear una cuenta?",
            tipo: "sugerencia-registro",
          });
        } else {
          establecerMensajeAlerta({
            texto: textoError || "Ocurrió un error en la autenticación.",
            tipo: "error",
          });
        }
      }
    } catch {
      establecerMensajeAlerta({
        texto: "Error de conexión con el servidor backend en Spring Boot.",
        tipo: "error",
      });
    } finally {
      establecerEstaCargando(false);
    }
  };

  /**
   * Maneja la solicitud de recuperación de contraseña.
   */
  const manejarRecuperacionContrasena = async () => {
    if (!correoElectronico) {
      establecerMensajeAlerta({
        texto: "Por favor, ingrese su correo electrónico para recuperar su contraseña.",
        tipo: "info",
      });
      return;
    }

    establecerEstaCargando(true);
    establecerMensajeAlerta({ texto: "", tipo: "" });

    try {
      const respuesta = await fetch(
        "http://localhost:8080/api/autenticacion/olvide-contrasena",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ correoElectronico }),
        },
      );

      if (respuesta.ok) {
        establecerMensajeAlerta({
          texto: `Hemos enviado las instrucciones de recuperación a: ${correoElectronico}`,
          tipo: "exito",
        });
      } else {
        const textoErrorServidor = await respuesta.text();
        establecerMensajeAlerta({
          texto: textoErrorServidor || "Ocurrió un error al procesar la solicitud.",
          tipo: "error",
        });
      }
    } catch (excepcion) {
      console.error("Error de conexión al recuperar contraseña:", excepcion);
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

      {/* ==================== PANEL IZQUIERDO — MARCA ==================== */}
      <aside className="panel-marca">
        <img
          src={logoGco}
          alt="Logotipo GCO"
          className="logo-panel-marca"
        />
        <h1 className="titulo-panel-marca">
          Programa de Lealtad GCO
        </h1>
        <p className="subtitulo-panel-marca">
          Únase a nuestro programa exclusivo y disfrute beneficios únicos en las marcas más reconocidas del país.
        </p>
        <div className="grid-marcas">
          {MARCAS_GCO.map((marca) => (
            <div key={marca} className="badge-marca">
              {marca}
            </div>
          ))}
        </div>
        <div className="divisor-panel" />
      </aside>

      {/* ==================== PANEL DERECHO — FORMULARIO ==================== */}
      <section className="panel-formulario">
        <div className="tarjeta-autenticacion">

          {/* Logo solo visible en mobile */}
          <div className="contenedor-logo-auth">
            <img
              src={logoGco}
              alt="Logotipo GCO Programas de Lealtad"
              className="imagen-logo-auth"
            />
          </div>

          <h2 className="titulo-autenticacion">
            {esRegistro ? "Crear Cuenta" : "Iniciar Sesión"}
          </h2>
          <p className="descripcion-autenticacion">
            {esRegistro
              ? "Regístrese para acceder al sistema de lealtad GCO."
              : "Ingrese sus credenciales de acceso al sistema."}
          </p>

          {/* Alertas */}
          {mensajeAlerta.texto && (
            <div className={`aviso-alerta ${mensajeAlerta.tipo}`}>
              <span>{mensajeAlerta.texto}</span>
              {mensajeAlerta.tipo === "sugerencia-registro" ? (
                <button
                  type="button"
                  className="boton-accion-sugerencia"
                  onClick={() => {
                    establecerEsRegistro(true);
                    establecerMensajeAlerta({ texto: "", tipo: "" });
                  }}
                >
                  Registrarse ahora
                </button>
              ) : (
                <button
                  type="button"
                  className="boton-cerrar-aviso"
                  onClick={() => establecerMensajeAlerta({ texto: "", tipo: "" })}
                >
                  &times;
                </button>
              )}
            </div>
          )}

          <form onSubmit={manejarEnvioAutenticacion}>
            {/* Campo correo */}
            <div className="grupo-input">
              <label htmlFor="correo">Correo Electrónico</label>
              <div className="input-con-icono">
                <IconoCorreo />
                <input
                  type="email"
                  id="correo"
                  value={correoElectronico}
                  onChange={(e) => establecerCorreoElectronico(e.target.value)}
                  placeholder="correo@ejemplo.com"
                  required
                  disabled={estaCargando}
                />
              </div>
            </div>

            {/* Campo contraseña */}
            <div className="grupo-input">
              <label htmlFor="contrasena">Contraseña</label>
              <div className="input-con-icono">
                <IconoCandado />
                <input
                  type={verContrasena ? "text" : "password"}
                  id="contrasena"
                  value={contrasena}
                  onChange={(e) => establecerContrasena(e.target.value)}
                  placeholder="••••••••"
                  required
                  disabled={estaCargando}
                  style={{ paddingRight: "44px" }}
                />
                <button
                  type="button"
                  className="boton-toggle-password"
                  onClick={() => establecerVerContrasena((v) => !v)}
                  tabIndex={-1}
                  aria-label={verContrasena ? "Ocultar contraseña" : "Mostrar contraseña"}
                >
                  {verContrasena ? <IconoOjoCerrado /> : <IconoOjoAbierto />}
                </button>
              </div>
            </div>

            {/* Enlace recuperar contraseña (solo en login) */}
            {!esRegistro && (
              <div className="contenedor-recuperar-contrasena">
                <span
                  className="enlace-recuperar"
                  onClick={manejarRecuperacionContrasena}
                >
                  ¿Olvidó su contraseña?
                </span>
              </div>
            )}

            {/* Checkbox términos */}
            <div className="grupo-checkbox">
              <label className="etiqueta-checkbox">
                <input
                  type="checkbox"
                  checked={aceptaTerminos}
                  onChange={(e) => establecerAceptaTerminos(e.target.checked)}
                  required
                  disabled={estaCargando}
                />
                <span>
                  Acepto los términos, condiciones y la política de tratamiento de datos personales.
                </span>
              </label>
            </div>

            {/* Botón principal */}
            <button
              type="submit"
              id="boton-submit-auth"
              className="boton-principal-auth"
              disabled={estaCargando}
            >
              {estaCargando ? (
                <div className="contenedor-cargador">
                  <span className="cargador-giratorio"></span>
                  <span>Procesando...</span>
                </div>
              ) : esRegistro ? (
                "Crear Cuenta"
              ) : (
                "Ingresar al Sistema"
              )}
            </button>
          </form>

          {/* Toggle entre login y registro */}
          <div className="enlace-cambio-modo">
            {esRegistro ? (
              <p>
                ¿Ya tiene una cuenta?{" "}
                <span
                  onClick={() => !estaCargando && establecerEsRegistro(false)}
                  style={{ cursor: estaCargando ? "not-allowed" : "pointer" }}
                >
                  Inicie sesión aquí
                </span>
              </p>
            ) : (
              <p>
                ¿No tiene cuenta registrada?{" "}
                <span
                  onClick={() => !estaCargando && establecerEsRegistro(true)}
                  style={{ cursor: estaCargando ? "not-allowed" : "pointer" }}
                >
                  Regístrese aquí
                </span>
              </p>
            )}
          </div>
        </div>
      </section>
    </div>
  );
};