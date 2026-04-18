import { createClient } from "@libsql/client/web";

export default async function handler(req, res) {
  // Configuramos el cliente de Turso con tus variables de entorno
  const db = createClient({
    url: process.env.TURSO_URL,
    authToken: process.env.TURSO_AUTH_TOKEN,
  });

  try {
    // Consulta simple: Traer el cliente con ID 1
    const result = await db.execute({
      sql: "SELECT * FROM client WHERE id = ?",
      args: [1],
    });

    // Si no hay resultados
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    // Devolvemos el primer registro encontrado
    res.status(200).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}