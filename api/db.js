import { createClient } from "@libsql/client/web";

export default async function handler(req, res) {
  const db = createClient({
    url: process.env.TURSO_URL,
    authToken: process.env.TURSO_AUTH_TOKEN,
    // ESTA LÍNEA ES LA QUE FALTA:
    fetch: fetch 
  });

  try {
    // Usamos .execute() pero con el formato más crudo posible
    const result = await db.execute("SELECT * FROM client WHERE id = 1");

    if (!result || !result.rows || result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    return res.status(200).json(result.rows[0]);
  } catch (error) {
    return res.status(500).json({ 
      error: "Fallo en el procesamiento de datos",
      detalle: error.message,
      // Agregamos el código para ver si es un error de Turso o del driver
      codigo: error.code 
    });
  }
}