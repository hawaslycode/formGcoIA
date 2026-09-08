import { useState } from "react";
import { Autenticacion } from "./pages/Autenticacion";
import { RegistroLealtad } from "./pages/RegistroLealtad";
import { RestablecerContrasena } from "./pages/RestablecerContrasena";

/**
 * Componente raiz de la aplicacion.
 * Actua como Guardian de Sesion utilizando Inicializacion Perezosa (Lazy Initialization)
 * para maximizar el rendimiento y evitar renderizados en cascada.
 * Gestiona ademas el enrutamiento manual para las vistas publicas de recuperacion de claves.
 */
export const App = () => {
  /**
   * ESTADO GLOBAL DE USUARIO (Inicializacion Perezosa)
   * Pasamos una funcion anonima a useState. React ejecutara esta funcion
   * de forma sincrona una unica vez al instanciar el componente, interceptando
   * las credenciales del Local Storage antes del primer renderizado.
   */
  const [usuarioActual, establecerUsuarioActual] = useState(() => {
    const tokenGuardado = localStorage.getItem("tokenAcceso");
    const correoGuardado = localStorage.getItem("correoUsuario");

    // Si existen credenciales validas, retornamos el objeto del usuario inmediatamente
    if (tokenGuardado && correoGuardado) {
      return { correo: correoGuardado };
    }
    
    // Si no hay sesion, el estado inicia en null
    return null;
  });

  /**
   * Funcion inyectada al componente de Autenticacion para elevar el estado al autenticarse.
   * 
   * @param {Object} datosUsuario - Objeto que contiene el correo del usuario validado.
   */
  const manejarAutenticacion = (datosUsuario) => {
    establecerUsuarioActual(datosUsuario);
  };

  /**
   * Maneja el cierre de sesion seguro del usuario.
   * Destruye el rastro criptografico en la boveda del navegador y purga el estado global.
   */
  const manejarCierreSesion = () => {
    localStorage.removeItem("tokenAcceso");
    localStorage.removeItem("correoUsuario");
    establecerUsuarioActual(null);
  };

  // Detectamos si el usuario ingreso a traves del enlace seguro enviado a su correo
  const esRutaRecuperacion = window.location.pathname === "/restablecer-contrasena";

  if (esRutaRecuperacion) {
    return (
      <main>
        <RestablecerContrasena />
      </main>
    );
  }

  return (
    <main>
      {/* 
        Si usuarioActual tiene datos (leidos del localStorage o por login reciente), 
        renderiza el sistema. Si es null, bloquea la ruta y muestra el Login. 
      */}
      {usuarioActual ? (
        <RegistroLealtad 
          usuarioActual={usuarioActual} 
          alCerrarSesion={manejarCierreSesion} 
        />
      ) : (
        <Autenticacion alAutenticar={manejarAutenticacion} />
      )}
    </main>
  );
};

export default App;