// esim-client.js  (Node 18+, fetch natif)
// Commande une eSIM temporaire chez l'opérateur -> renvoie la chaîne LPA à installer.

const API = process.env.ESIM_API_URL;   // URL de base de l'API opérateur/agrégateur
const KEY = process.env.ESIM_API_KEY;   // ton token d'API

export async function creerEsim({ plan, refUtilisateur }) {
  const r = await fetch(`${API}/esims`, {
    method: "POST",
    headers: { Authorization: `Bearer ${KEY}`, "Content-Type": "application/json" },
    body: JSON.stringify({ plan, reference: refUtilisateur }),
  });

  if (!r.ok) throw new Error(`Commande eSIM échouée : ${r.status} ${await r.text()}`);

  const d = await r.json();

  // Chaque opérateur nomme ses champs différemment : adapte ces 2 lignes à TA réponse.
  const smdp = d.smdp_address ?? d.smdpAddress;
  const matchingId = d.matching_id ?? d.matchingId ?? d.activationCode;

  return {
    lpa: d.lpa ?? `LPA:1$${smdp}$${matchingId}`, // <- à passer à l'OS pour l'installation
    iccid: d.iccid,
    smdp,
    matchingId,
  };
}
