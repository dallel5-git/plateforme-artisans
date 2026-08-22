-- BE-23 : agrégat journalier DailyProviderStat (cadrage technique §2.2, modèle repris tel quel).
-- Pas de Postgres local dans cet environnement de dev — migration écrite à la main en suivant
-- exactement la syntaxe générée par Prisma pour les tables voisines (profile_views,
-- contact_events) de la migration initiale, même précédent que 20260822021153.

-- CreateTable
CREATE TABLE "daily_provider_stats" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "date" DATE NOT NULL,
    "searchImpressions" INTEGER NOT NULL DEFAULT 0,
    "profileViews" INTEGER NOT NULL DEFAULT 0,
    "uniqueProfileViews" INTEGER NOT NULL DEFAULT 0,
    "phoneClicks" INTEGER NOT NULL DEFAULT 0,
    "whatsappClicks" INTEGER NOT NULL DEFAULT 0,
    "newReviews" INTEGER NOT NULL DEFAULT 0,
    "avgSearchPosition" DECIMAL(6,2),
    "computedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "daily_provider_stats_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "daily_provider_stats_providerId_date_key" ON "daily_provider_stats"("providerId", "date");

-- CreateIndex
CREATE INDEX "daily_provider_stats_date_idx" ON "daily_provider_stats"("date");

-- AddForeignKey
ALTER TABLE "daily_provider_stats" ADD CONSTRAINT "daily_provider_stats_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
