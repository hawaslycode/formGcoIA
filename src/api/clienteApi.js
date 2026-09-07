export const API_URL = import.meta.env.VITE_API_URL || http://localhost:8080;

export const fetchConAuth = async (endpoint, opciones = {}) => {
  const token = localStorage.getItem(tokenAcceso);
  const headers = {
    Content-Type: application/json,
    ...opciones.headers,
  };
  if (token) {
    headers.Authorization = Bearer ;
  }
  return fetch(${API_URL}, {
    ...opciones,
    headers,
  });
};
