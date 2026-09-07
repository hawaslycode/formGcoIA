import { useState, useEffect } from "react";
import "./RegistroLealtad.css";
import logoGco from "../assets/gcologo.png";
import { fetchConAuth } from "../api/clienteApi";


/**
 * Objeto con los beneficios exclusivos simulados por cada marca de GCO.
 */
const beneficiosPorMarcaSimulados = {
  1: [
    { titulo: "Bono de Bienvenida", descripcion: "20% de descuento en tu primera compra como miembro." },
    { titulo: "Cashback Exclusivo", descripcion: "Acumula el 5% de tus compras en puntos redimibles." },
  ],
  2: [
    { titulo: "Acceso Anticipado VIP", descripcion: "Entrada preferencial a colecciones de temporada." },
    { titulo: "Obsequio de Cumpleaños", descripcion: "Bono de $50.000 COP durante tu mes de cumpleaños." },
  ],
  3: [
    { titulo: "Envío Gratuito", descripcion: "Envíos sin costo en todas tus compras digitales." },
    { titulo: "Garantía Extendida", descripcion: "Garantía preferencial en chaquetas de cuero." },
  ],
  4: [
    { titulo: "Descuento Aniversario", descripcion: "30% de descuento durante el mes de aniversario." },
    { titulo: "Taller de Estilo", descripcion: "Invitación exclusiva a asesorías de imagen." },
  ],
  5: [
    { titulo: "Preventa Flash", descripcion: "Descuentos de hasta 40% antes del público general." },
    { titulo: "Acumulación Doble", descripcion: "Doble acumulación de puntos los fines de semana." },
  ],
  6: [
    { titulo: "Puntos Redimibles", descripcion: "1 punto por cada $1.000 COP gastados en tiendas." },
    { titulo: "Mantenimiento de Prendas", descripcion: "Ajustes y dobladillos sin costo en jeans." },
  ],
};

/** Íconos SVG para la navbar */
const IconoSalir = () => (
  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
    <polyline points="16,17 21,12 16,7"/>
    <line x1="21" y1="12" x2="9" y2="12"/>
  </svg>
);

export const RegistroLealtad = ({ usuarioActual, alCerrarSesion }) => {
  const [datosFormulario, establecerDatosFormulario] = useState({
    tipoIdentificacion: "",
    numeroIdentificacion: "",
    nombres: "",
    apellidos: "",
    fechaNacimiento: "",
    direccion: "",
    pais: "",
    departamento: "",
    ciudad: "",
    idMarca: "",
  });

  const [listaTiposId, establecerListaTiposId] = useState([]);
  const [listaPaises, establecerListaPaises] = useState([]);
  const [listaDepartamentos, establecerListaDepartamentos] = useState([]);
  const [listaCiudades, establecerListaCiudades] = useState([]);
  const [listaMarcas, establecerListaMarcas] = useState([]);

  const [paisSeleccionadoId, establecerPaisSeleccionadoId] = useState("");
  const [departamentoSeleccionadoId, establecerDepartamentoSeleccionadoId] = useState("");

  const [mensajeAlerta, establecerMensajeAlerta] = useState({ texto: "", tipo: "" });
  const [estaCargando, establecerEstaCargando] = useState(false);

  /**
   * 1. EFECTO PRINCIPAL: Cargar catálogos iniciales y precargar los datos del usuario.
   * Se ha inyectado el JWT en las cabeceras para sortear el Filtro de Seguridad.
   */
  useEffect(() => {
    let estaMontado = true;

    const inicializarDatosVista = async () => {
      const tokenDeAcceso = localStorage.getItem("tokenAcceso");

      if (!tokenDeAcceso) {
        console.warn("Acceso denegado: No se encontró un token de sesión.");
        return;
      }

      const configuracionPeticion = {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${tokenDeAcceso}`,
        },
      };

      try {
        const resTipos = await fetchConAuth(
          "/api/catalogos/tipos-identificacion",
          configuracionPeticion,
        );
        if (resTipos.ok && estaMontado)
          establecerListaTiposId(await resTipos.json());

        const resPaises = await fetchConAuth(
          "/api/catalogos/paises",
          configuracionPeticion,
        );
        if (resPaises.ok && estaMontado)
          establecerListaPaises(await resPaises.json());

        const resMarcas = await fetchConAuth(
          "/api/catalogos/marcas",
          configuracionPeticion,
        );
        if (resMarcas.ok && estaMontado)
          establecerListaMarcas(await resMarcas.json());

        if (usuarioActual?.correo) {
          const respuestaCliente = await fetchConAuth(
            `/api/lealtad/cliente/correo/${usuarioActual.correo}`,
            configuracionPeticion,
          );

          if (respuestaCliente.ok && estaMontado) {
            const datosCliente = await respuestaCliente.json();
            establecerDatosFormulario({
              tipoIdentificacion: datosCliente.tipoIdentificacion || "",
              numeroIdentificacion: datosCliente.numeroIdentificacion || "",
              nombres: datosCliente.nombres || "",
              apellidos: datosCliente.apellidos || "",
              fechaNacimiento: datosCliente.fechaNacimiento || "",
              direccion: datosCliente.direccion || "",
              pais: datosCliente.pais || "",
              departamento: datosCliente.departamento || "",
              ciudad: datosCliente.ciudad || "",
              idMarca: datosCliente.idMarca ? String(datosCliente.idMarca) : "",
            });

            establecerMensajeAlerta({
              texto: "¡Datos de lealtad precargados exitosamente desde la base de datos!",
              tipo: "exito",
            });
          } else if (respuestaCliente.status === 404 && estaMontado) {
            console.info("Info: Usuario nuevo, formulario en blanco.");
            establecerMensajeAlerta({
              texto: "¡Bienvenido! Complete sus datos para registrarse en el programa de lealtad.",
              tipo: "info",
            });
          }
        }
      } catch (error) {
        if (estaMontado)
          console.error("Error al inicializar la vista de lealtad:", error);
      }
    };

    inicializarDatosVista();

    return () => { estaMontado = false; };
  }, [usuarioActual]);

  /**
   * 2. EFECTO SECUNDARIO: Cargar departamentos dependientes del país.
   */
  useEffect(() => {
    let estaMontado = true;
    const cargarDepartamentos = async () => {
      const tokenDeAcceso = localStorage.getItem("tokenAcceso");
      if (paisSeleccionadoId && tokenDeAcceso) {
        try {
          const respuesta = await fetchConAuth(
            `/api/catalogos/departamentos/${paisSeleccionadoId}`,
            { method: "GET", headers: { Authorization: `Bearer ${tokenDeAcceso}` } },
          );

          if (respuesta.ok && estaMontado) {
            establecerListaDepartamentos(await respuesta.json());
            const paisObj = listaPaises.find((p) => String(p.id) === String(paisSeleccionadoId));
            if (paisObj) {
              establecerDatosFormulario((prev) => ({ ...prev, pais: paisObj.nombre }));
            }
          }
        } catch (error) {
          if (estaMontado) console.error("Error al cargar departamentos:", error);
        }
      }
    };

    cargarDepartamentos();
    return () => { estaMontado = false; };
  }, [paisSeleccionadoId, listaPaises]);

  /**
   * 3. EFECTO TRES: Cargar ciudades dependientes del departamento.
   */
  useEffect(() => {
    let estaMontado = true;
    const cargarCiudades = async () => {
      const tokenDeAcceso = localStorage.getItem("tokenAcceso");
      if (departamentoSeleccionadoId && tokenDeAcceso) {
        try {
          const respuesta = await fetchConAuth(
            `/api/catalogos/ciudades/${departamentoSeleccionadoId}`,
            { method: "GET", headers: { Authorization: `Bearer ${tokenDeAcceso}` } },
          );

          if (respuesta.ok && estaMontado) {
            establecerListaCiudades(await respuesta.json());
            const depObj = listaDepartamentos.find((d) => String(d.id) === String(departamentoSeleccionadoId));
            if (depObj) {
              establecerDatosFormulario((prev) => ({ ...prev, departamento: depObj.nombre }));
            }
          }
        } catch (error) {
          if (estaMontado) console.error("Error al cargar ciudades:", error);
        }
      }
    };

    cargarCiudades();
    return () => { estaMontado = false; };
  }, [departamentoSeleccionadoId, listaDepartamentos]);

  const listaBeneficios = datosFormulario.idMarca
    ? beneficiosPorMarcaSimulados[datosFormulario.idMarca] || []
    : [];

  const manejarCambio = (evento) => {
    const { name, value } = evento.target;
    establecerDatosFormulario({ ...datosFormulario, [name]: value });
  };

  /**
   * Maneja el envío del formulario hacia el backend.
   */
  const manejarEnvioFormulario = async (evento) => {
    evento.preventDefault();

    const tokenDeAcceso = localStorage.getItem("tokenAcceso");
    const cargaUtilDeDatos = {
      ...datosFormulario,
      correoElectronico: usuarioActual.correo,
    };

    establecerEstaCargando(true);
    establecerMensajeAlerta({ texto: "", tipo: "" });

    try {
      const respuesta = await fetchConAuth("/api/lealtad/registrar", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${tokenDeAcceso}`,
        },
        body: JSON.stringify(cargaUtilDeDatos),
      });

      if (respuesta.ok) {
        establecerMensajeAlerta({
          texto: "¡Información guardada y actualizada en el programa de fidelidad con éxito!",
          tipo: "exito",
        });
      } else {
        if (respuesta.status === 401 || respuesta.status === 403) {
          establecerMensajeAlerta({
            texto: "Su sesión ha expirado o no tiene permisos. Por favor, inicie sesión nuevamente.",
            tipo: "error",
          });
        } else {
          const textoDeError = await respuesta.text();
          establecerMensajeAlerta({
            texto: textoDeError || "Ocurrió un error al procesar el registro.",
            tipo: "error",
          });
        }
      }
    } catch (excepcion) {
      console.error("Error enviando datos protegidos:", excepcion);
      establecerMensajeAlerta({
        texto: "Error de conexión con el servidor backend en Spring Boot.",
        tipo: "error",
      });
    } finally {
      establecerEstaCargando(false);
    }
  };

  return (
    <div className="pagina-lealtad">

      {/* ==================== NAVBAR ==================== */}
      <nav className="navbar-lealtad">
        <div className="navbar-logo-area">
          <img src={logoGco} alt="GCO" className="navbar-logo" />
          <div className="navbar-separador" />
          <span className="navbar-titulo">Programa de Lealtad</span>
        </div>
        <div className="navbar-acciones">
          <div className="navbar-correo">
            <span className="navbar-correo-punto" />
            <span>{usuarioActual?.correo}</span>
          </div>
          <button
            type="button"
            id="boton-cerrar-sesion"
            className="boton-cerrar-sesion"
            onClick={alCerrarSesion}
          >
            <IconoSalir />
            Cerrar Sesión
          </button>
        </div>
      </nav>

      {/* ==================== HERO BANNER ==================== */}
      <header className="hero-lealtad">
        <div className="hero-badge">⭐ Programa Exclusivo</div>
        <h1 className="hero-titulo">
          Bienvenido al Programa de <span>Lealtad GCO</span>
        </h1>
        <p className="hero-descripcion">
          Gestione sus datos personales, seleccione su marca favorita y acceda a beneficios exclusivos diseñados para nuestros clientes más fieles.
        </p>
      </header>

      {/* ==================== CUERPO ==================== */}
      <main className="cuerpo-lealtad">
        <form
          className="tarjeta-formulario-lealtad"
          onSubmit={manejarEnvioFormulario}
        >

          {/* Alertas */}
          {mensajeAlerta.texto && (
            <div className="area-alertas" style={{ paddingTop: "24px" }}>
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
            </div>
          )}

          {/* ======== SECCIÓN 1: IDENTIFICACIÓN ======== */}
          <section className="seccion-formulario">
            <div className="cabecera-seccion">
              <div className="icono-seccion">🪪</div>
              <h2 className="titulo-seccion">Identificación</h2>
              <span className="numero-seccion">01 / 04</span>
            </div>
            <div className="fila-formulario">
              <div className="grupo-input">
                <label htmlFor="tipoIdentificacion">Tipo de Identificación</label>
                <div className="wrapper-select">
                  <select
                    id="tipoIdentificacion"
                    name="tipoIdentificacion"
                    value={datosFormulario.tipoIdentificacion}
                    onChange={manejarCambio}
                    required
                  >
                    <option value="">Seleccione...</option>
                    {listaTiposId.map((tipo) => (
                      <option key={tipo.id} value={tipo.nombre}>
                        {tipo.nombre}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="grupo-input">
                <label htmlFor="numeroIdentificacion">Número de Identificación</label>
                <input
                  type="text"
                  id="numeroIdentificacion"
                  name="numeroIdentificacion"
                  value={datosFormulario.numeroIdentificacion}
                  onChange={manejarCambio}
                  placeholder="Ej. 1023456789"
                  required
                />
              </div>
            </div>
          </section>

          {/* ======== SECCIÓN 2: DATOS PERSONALES ======== */}
          <section className="seccion-formulario">
            <div className="cabecera-seccion">
              <div className="icono-seccion">👤</div>
              <h2 className="titulo-seccion">Datos Personales</h2>
              <span className="numero-seccion">02 / 04</span>
            </div>
            <div className="fila-formulario">
              <div className="grupo-input">
                <label htmlFor="nombres">Nombres</label>
                <input
                  type="text"
                  id="nombres"
                  name="nombres"
                  value={datosFormulario.nombres}
                  onChange={manejarCambio}
                  placeholder="Ingrese sus nombres"
                  required
                />
              </div>
              <div className="grupo-input">
                <label htmlFor="apellidos">Apellidos</label>
                <input
                  type="text"
                  id="apellidos"
                  name="apellidos"
                  value={datosFormulario.apellidos}
                  onChange={manejarCambio}
                  placeholder="Ingrese sus apellidos"
                  required
                />
              </div>
            </div>
            <div className="fila-formulario" style={{ marginTop: "14px" }}>
              <div className="grupo-input">
                <label htmlFor="fechaNacimiento">Fecha de Nacimiento</label>
                <input
                  type="date"
                  id="fechaNacimiento"
                  name="fechaNacimiento"
                  value={datosFormulario.fechaNacimiento}
                  onChange={manejarCambio}
                  required
                />
              </div>
            </div>
          </section>

          {/* ======== SECCIÓN 3: UBICACIÓN ======== */}
          <section className="seccion-formulario">
            <div className="cabecera-seccion">
              <div className="icono-seccion">📍</div>
              <h2 className="titulo-seccion">Ubicación</h2>
              <span className="numero-seccion">03 / 04</span>
            </div>
            <div className="fila-formulario">
              <div className="grupo-input">
                <label htmlFor="paisSeleccionado">País</label>
                <div className="wrapper-select">
                  <select
                    id="paisSeleccionado"
                    value={paisSeleccionadoId}
                    onChange={(e) => {
                      establecerPaisSeleccionadoId(e.target.value);
                      establecerDepartamentoSeleccionadoId("");
                      establecerListaCiudades([]);
                      establecerDatosFormulario((prev) => ({ ...prev, departamento: "", ciudad: "" }));
                    }}
                    required
                  >
                    <option value="">Seleccione un país...</option>
                    {listaPaises.map((pais) => (
                      <option key={pais.id} value={pais.id}>
                        {pais.nombre}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="grupo-input">
                <label htmlFor="departamentoSeleccionado">Departamento / Estado</label>
                <div className="wrapper-select">
                  <select
                    id="departamentoSeleccionado"
                    value={departamentoSeleccionadoId}
                    onChange={(e) => {
                      establecerDepartamentoSeleccionadoId(e.target.value);
                      establecerListaCiudades([]);
                      establecerDatosFormulario((prev) => ({ ...prev, ciudad: "" }));
                    }}
                    required
                    disabled={!paisSeleccionadoId}
                  >
                    <option value="">Seleccione departamento...</option>
                    {listaDepartamentos.map((dep) => (
                      <option key={dep.id} value={dep.id}>
                        {dep.nombre}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
            </div>
            <div className="fila-formulario" style={{ marginTop: "14px" }}>
              <div className="grupo-input">
                <label htmlFor="ciudad">Ciudad</label>
                <div className="wrapper-select">
                  <select
                    id="ciudad"
                    name="ciudad"
                    value={datosFormulario.ciudad}
                    onChange={manejarCambio}
                    required
                    disabled={!departamentoSeleccionadoId}
                  >
                    <option value="">Seleccione ciudad...</option>
                    {listaCiudades.map((ciu) => (
                      <option key={ciu.id} value={ciu.nombre}>
                        {ciu.nombre}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="grupo-input">
                <label htmlFor="direccion">Dirección</label>
                <input
                  type="text"
                  id="direccion"
                  name="direccion"
                  value={datosFormulario.direccion}
                  onChange={manejarCambio}
                  placeholder="Ej. Calle 100 # 15-20"
                  required
                />
              </div>
            </div>
          </section>

          {/* ======== SECCIÓN 4: SELECCIÓN DE MARCA ======== */}
          <section className="seccion-formulario">
            <div className="cabecera-seccion">
              <div className="icono-seccion">🏷️</div>
              <h2 className="titulo-seccion">Selección de Marca</h2>
              <span className="numero-seccion">04 / 04</span>
            </div>

            {/* Grid visual de marcas (cuando ya están cargadas desde el backend) */}
            {listaMarcas.length > 0 ? (
              <div className="grid-marcas-seleccion">
                {listaMarcas.map((marca) => (
                  <div
                    key={marca.id}
                    className={`tarjeta-marca-opcion ${String(datosFormulario.idMarca) === String(marca.id) ? "seleccionada" : ""}`}
                    onClick={() =>
                      establecerDatosFormulario((prev) => ({
                        ...prev,
                        idMarca: String(marca.id),
                      }))
                    }
                    role="button"
                    tabIndex={0}
                    onKeyDown={(e) => {
                      if (e.key === "Enter" || e.key === " ") {
                        establecerDatosFormulario((prev) => ({
                          ...prev,
                          idMarca: String(marca.id),
                        }));
                      }
                    }}
                    aria-pressed={String(datosFormulario.idMarca) === String(marca.id)}
                  >
                    <span className="emoji-marca">
                      {["👗", "🦅", "🧥", "✨", "🌸", "👖"][marca.id - 1] || "🏷️"}
                    </span>
                    <span className="nombre-marca-opcion">{marca.nombre}</span>
                  </div>
                ))}
              </div>
            ) : (
              /* Fallback: select estándar si aún no cargaron las marcas */
              <div className="grupo-input select-marca-contenedor">
                <label htmlFor="idMarca">Marca a la que desea registrarse</label>
                <div className="wrapper-select">
                  <select
                    id="idMarca"
                    name="idMarca"
                    value={datosFormulario.idMarca}
                    onChange={manejarCambio}
                    required
                  >
                    <option value="">Seleccione una marca...</option>
                  </select>
                </div>
              </div>
            )}

            {/* Input oculto para enviar el valor de idMarca al formulario */}
            <input
              type="hidden"
              name="idMarca"
              value={datosFormulario.idMarca}
            />
          </section>

          {/* ======== BENEFICIOS DE MARCA ======== */}
          {listaBeneficios.length > 0 && (
            <div className="contenedor-beneficios-marca">
              <div className="cabecera-beneficios">
                <span style={{ fontSize: "1.2rem" }}>🎁</span>
                <h3 className="titulo-beneficios">Beneficios Exclusivos de su Marca</h3>
              </div>
              <div className="tarjetas-beneficios">
                {listaBeneficios.map((beneficio, indice) => (
                  <div key={indice} className="tarjeta-beneficio-item">
                    <strong>{beneficio.titulo}</strong>
                    <p>{beneficio.descripcion}</p>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* ======== FOOTER CON BOTONES ======== */}
          <div className="footer-formulario">
            <button
              type="submit"
              id="boton-guardar-lealtad"
              className="boton-registro"
              disabled={estaCargando}
            >
              {estaCargando ? (
                <div className="contenedor-cargador">
                  <span className="cargador-giratorio"></span>
                  <span>Procesando...</span>
                </div>
              ) : (
                "💾  Guardar y Actualizar Información"
              )}
            </button>
            <button
              type="button"
              id="boton-salir-lealtad"
              className="boton-salir-secundario"
              onClick={alCerrarSesion}
            >
              Salir / Cerrar Sesión
            </button>
          </div>

        </form>
      </main>
    </div>
  );
};
