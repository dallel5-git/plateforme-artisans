-- BE-02 : contraintes et index que Prisma ne sait pas exprimer nativement (CHECK, index
-- partiels, triggers). Une contrainte en base est un filet ; une validation applicative
-- n'est qu'une intention (cadrage §2.3, CLAUDE.md §3.2).
--
-- Périmètre BE-02 uniquement (issue #8) : bornes de notation, cohérence des tarifs,
-- catégorie principale unique, index des profils publiés, anti-auto-avis. Le reste des
-- items du cadrage §2.3 (index trigram, index géospatial, contraintes sur subscriptions/
-- boosts/ad_campaigns/credit_wallets) est hors du sous-ensemble MVP S1 (BE-01) ou reporté
-- (BE-42).
--
-- Note : le schéma Prisma de BE-01 n'ajoute pas de @map par champ (seulement @@map par
-- table) — les colonnes restent en camelCase telles que générées, d'où les identifiants
-- entre guillemets ci-dessous (le cadrage §2.3 les présente en snake_case, mais c'est la
-- forme réellement présente en base qui prévaut).

-- 1. Bornes de notation
ALTER TABLE "reviews" ADD CONSTRAINT chk_reviews_rating CHECK ("rating" BETWEEN 1 AND 5);
ALTER TABLE "reviews" ADD CONSTRAINT chk_reviews_sub_ratings CHECK (
  ("ratingPunctuality" IS NULL OR "ratingPunctuality" BETWEEN 1 AND 5) AND
  ("ratingQuality"     IS NULL OR "ratingQuality"     BETWEEN 1 AND 5) AND
  ("ratingValue"       IS NULL OR "ratingValue"       BETWEEN 1 AND 5)
);

-- 2. Cohérence des tarifs
ALTER TABLE "service_offerings" ADD CONSTRAINT chk_price_range
  CHECK ("priceMin" IS NULL OR "priceMax" IS NULL OR "priceMin" <= "priceMax");

-- 3. Une seule catégorie principale par prestataire
CREATE UNIQUE INDEX uniq_primary_category_per_provider
  ON "provider_categories" ("providerId") WHERE "isPrimary" = true;

-- 4. Index partiel sur les profils réellement affichables (le cas 95 % du temps)
CREATE INDEX idx_provider_published_ranking
  ON "provider_profiles" ("rankingScore" DESC)
  WHERE "publicationStatus" = 'PUBLISHED';

-- 5. Un artisan ne peut pas s'auto-évaluer (contrôle applicatif + garde-fou par trigger)
CREATE OR REPLACE FUNCTION prevent_self_review() RETURNS trigger AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM "provider_profiles" p
    WHERE p."id" = NEW."providerId" AND p."userId" = NEW."clientId"
  ) THEN
    RAISE EXCEPTION 'Un prestataire ne peut pas evaluer son propre profil';
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_self_review
  BEFORE INSERT OR UPDATE ON "reviews"
  FOR EACH ROW EXECUTE FUNCTION prevent_self_review();
