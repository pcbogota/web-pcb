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
          { type: "execute", stmt: { sql: "SELECT * FROM client WHERE id = 2" } },
          { type: "close" },
        ],
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      return res.status(response.status).json({ error: "Error en Turso", detalle: data });
    }

    const result = data.results[0].response.result;
    const columns = result.cols; 
    const rows = result.rows;    

    // MAPEADO DE TODOS LOS REGISTROS
    const cleanList = rows.map((row) => {
      let item = {};
      columns.forEach((col, index) => {
        item[col.name] = row[index].value;
      });
      return item;
    });

    // Devolvemos la lista completa de clientes
    return res.status(200).json(cleanList);

  } catch (error) {
    return res.status(500).json({ error: "Error de servidor", detalle: error.message });
  }
}