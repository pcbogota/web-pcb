import { createClient } from "@libsql/client/web";

export default async function handler(req, res) {
  const db = createClient({
    url: process.env.TURSO_URL,
    authToken: process.env.TURSO_AUTH_TOKEN,
  });

  try {
    // Usamos una consulta simple de texto para evitar líos de objetos
    const result = await db.execute("SELECT * FROM client WHERE id = 1");

    // IMPORTANTE: En la versión web, a veces el acceso es directo a 'rows'
    if (!result || !result.rows || result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    // Enviamos el primer registro
    return res.status(200).json(result.rows[0]);
  } catch (error) {
    // Si algo falla aquí, necesitamos el mensaje real en el navegador
    return res.status(500).json({ 
      error: "Fallo en el procesamiento de datos",
      detalle: error.message 
    });
  }
}