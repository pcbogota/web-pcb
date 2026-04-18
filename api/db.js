import { createClient } from "@libsql/client/web";

export default async function handler(req, res) {
  const db = createClient({
    url: process.env.TURSO_URL,
    authToken: process.env.TURSO_AUTH_TOKEN,
    // Obligamos al driver a usar solo HTTP y nada más.
    // Esto evita que busque "migration jobs".
    intemodal: false 
  });

  try {
    // Usamos el formato que querías originalmente
    const result = await db.execute({
      sql: "SELECT * FROM client WHERE id = ?",
      args: [1],
    });

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    // Aquí la librería SÍ te devuelve el objeto limpio
    res.status(200).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ 
      error: "Error de librería LibSQL",
      mensaje: error.message 
    });
  }
}