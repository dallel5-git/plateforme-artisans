-- BE-21b : index manquant pour le dédup anonyme par empreinte de session. Aucun index
-- existant ne couvre "sessionHash" (seuls providerId/clientId/createdAt le sont) —
-- findRecentContactEventByFingerprint scannerait "contact_events" en séquentiel sinon.

CREATE INDEX "contact_events_sessionHash_createdAt_idx"
  ON "contact_events" ("sessionHash", "createdAt" DESC);
