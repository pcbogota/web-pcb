export default async function handler(req, res) {
  const url = process.env.TURSO_URL.replace("libsql://", "https://");
  const token = process.env.TURSO_AUTH_TOKEN;

  try {
    const response = await fetch(`${url}/v2/pipeline`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        requests: [
          { type: "execute", stmt: { sql: "SELECT * FROM client WHERE id = 1" } },
          { type: "close" },
        ],
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      return res.status(response.status).json({ error: "Error en Turso API", detalle: data });
    }

    // Turso devuelve un array de resultados, extraemos el primero
    const rows = data.results[0].response.result.rows;

    if (rows.length === 0) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    return res.status(200).json(rows[0]);
  } catch (error) {
    return res.status(500).json({ error: "Error nativo de Fetch", detalle: error.message });
  }
}