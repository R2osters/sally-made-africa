// route.js
import express from "express";
import { creerEsim } from "./esim-client.js";

const router = express.Router();

router.post("/esim", async (req, res) => {
  try {
    const data = await creerEsim({ plan: req.body.plan, refUtilisateur: req.body.userId });
    res.json(data); // { lpa, iccid, smdp, matchingId }
  } catch (e) {
    res.status(502).json({ error: e.message });
  }
});

export default router;
