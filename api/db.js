import { createClient } from "@libsql/client";

export default async function handler(req, res) {
  // Verificación de variables para asegurar que Node 24 las lea
  const url = process.env.TURSO_URL;
  const authToken = process.env.TURSO_AUTH_TOKEN;

  const db = createClient({
    url: url,
    authToken: authToken,
    // Esto es CRUCIAL:
    // Al no definir 'syncUrl', el driver NO debería buscar "migration jobs".
    // Pero en algunas versiones bugueadas, hay que asegurar que no intente
    // usar protocolos de replicación.
  });

  try {
    // Usamos el método .execute con el formato de objeto que es más robusto
    const result = await db.execute({
      sql: "SELECT * FROM client WHERE id = ?",
      args: [1]
    });

    if (!result.rows || result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    // La librería aquí YA mapea las columnas con sus valores automáticamente
    return res.status(200).json(result.rows[0]);

  } catch (error) {
    // Si vuelve a fallar, el error nos dirá si es por el mismo motivo
    return res.status(500).json({ 
      error: "Error detectado por la librería",
      detalle: error.message 
    });
  }
}