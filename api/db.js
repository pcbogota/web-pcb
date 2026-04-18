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
      return res.status(response.status).json({ error: "Error en Turso", detalle: data });
    }

    // --- PROCESAMIENTO DE DATOS ---
    const result = data.results[0].response.result;
    const columns = result.cols; // Los nombres de tus columnas
    const rows = result.rows;    // Los valores

    if (rows.length === 0) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }

    // Mapeamos el array feo a un objeto { columna: valor }
    const cleanClient = {};
    columns.forEach((col, index) => {
      cleanClient[col.name] = rows[0][index].value;
    });

    // Resultado final limpio
    return res.status(200).json(cleanClient);

  } catch (error) {
    return res.status(500).json({ error: "Error de servidor", detalle: error.message });
  }
}