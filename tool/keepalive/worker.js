// Calls the keep_alive() database function once a day (see wrangler.jsonc).
export default {
  async scheduled(event, env, ctx) {
    const res = await fetch(`${env.SUPABASE_URL}/rest/v1/rpc/keep_alive`, {
      method: 'POST',
      headers: {
        apikey: env.SUPABASE_KEY,
        'Content-Type': 'application/json',
      },
      body: '{}',
    });
    const text = await res.text();
    console.log(`keep_alive: ${res.status} ${text}`);
    if (!res.ok) throw new Error(`keep_alive failed: ${res.status} ${text}`);
  },
};
