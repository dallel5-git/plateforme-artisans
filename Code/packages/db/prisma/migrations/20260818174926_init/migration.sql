-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "citext";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "postgis";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "unaccent";

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('CLIENT', 'PROVIDER', 'MODERATOR', 'SUPPORT', 'SALES', 'FINANCE', 'ADMIN', 'SUPER_ADMIN');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED', 'DELETED');

-- CreateEnum
CREATE TYPE "Locale" AS ENUM ('FR', 'AR', 'EN');

-- CreateEnum
CREATE TYPE "ProviderPublicationStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'HIDDEN', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "AvailabilityStatus" AS ENUM ('AVAILABLE', 'BUSY', 'ON_HOLIDAY');

-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('NOT_SUBMITTED', 'PENDING', 'MORE_INFO_REQUIRED', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "MediaType" AS ENUM ('IMAGE', 'VIDEO', 'DOCUMENT');

-- CreateEnum
CREATE TYPE "ModerationStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'HIDDEN');

-- CreateEnum
CREATE TYPE "PriceUnit" AS ENUM ('FIXED', 'HOUR', 'DAY', 'SQUARE_METER', 'LINEAR_METER', 'ON_QUOTE');

-- CreateEnum
CREATE TYPE "ContactChannel" AS ENUM ('PHONE_CALL', 'WHATSAPP', 'IN_APP_MESSAGE');

-- CreateEnum
CREATE TYPE "ReviewStatus" AS ENUM ('PENDING', 'PUBLISHED', 'FLAGGED', 'HIDDEN', 'REMOVED');

-- CreateEnum
CREATE TYPE "OtpPurpose" AS ENUM ('SIGNUP', 'LOGIN', 'PHONE_CHANGE', 'PASSWORD_RESET');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "phone" VARCHAR(20) NOT NULL,
    "phoneVerifiedAt" TIMESTAMP(3),
    "email" CITEXT,
    "emailVerifiedAt" TIMESTAMP(3),
    "passwordHash" VARCHAR(255),
    "firstName" VARCHAR(80),
    "lastName" VARCHAR(80),
    "avatarMediaId" UUID,
    "roles" "UserRole"[] DEFAULT ARRAY['CLIENT']::"UserRole"[],
    "status" "UserStatus" NOT NULL DEFAULT 'PENDING_VERIFICATION',
    "locale" "Locale" NOT NULL DEFAULT 'FR',
    "twoFactorSecret" VARCHAR(255),
    "lastLoginAt" TIMESTAMP(3),
    "acceptedTermsVersion" VARCHAR(20),
    "acceptedTermsAt" TIMESTAMP(3),
    "marketingOptIn" BOOLEAN NOT NULL DEFAULT false,
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "refreshTokenHash" VARCHAR(255) NOT NULL,
    "userAgent" VARCHAR(400),
    "ipHash" VARCHAR(64),
    "deviceLabel" VARCHAR(120),
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "otp_codes" (
    "id" UUID NOT NULL,
    "userId" UUID,
    "phone" VARCHAR(20) NOT NULL,
    "codeHash" VARCHAR(255) NOT NULL,
    "purpose" "OtpPurpose" NOT NULL,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "maxAttempts" INTEGER NOT NULL DEFAULT 3,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "consumedAt" TIMESTAMP(3),
    "ipHash" VARCHAR(64),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "otp_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "governorates" (
    "id" UUID NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "nameFr" VARCHAR(80) NOT NULL,
    "nameAr" VARCHAR(80) NOT NULL,
    "slug" VARCHAR(80) NOT NULL,
    "latitude" DECIMAL(9,6),
    "longitude" DECIMAL(9,6),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "governorates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "delegations" (
    "id" UUID NOT NULL,
    "governorateId" UUID NOT NULL,
    "code" VARCHAR(20),
    "nameFr" VARCHAR(120) NOT NULL,
    "nameAr" VARCHAR(120) NOT NULL,
    "slug" VARCHAR(120) NOT NULL,
    "postalCode" VARCHAR(10),
    "latitude" DECIMAL(9,6),
    "longitude" DECIMAL(9,6),
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "delegations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" UUID NOT NULL,
    "parentId" UUID,
    "slug" VARCHAR(80) NOT NULL,
    "nameFr" VARCHAR(120) NOT NULL,
    "nameAr" VARCHAR(120) NOT NULL,
    "descriptionFr" TEXT,
    "descriptionAr" TEXT,
    "iconKey" VARCHAR(60),
    "colorHex" VARCHAR(7),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "seoTitleFr" VARCHAR(180),
    "seoTitleAr" VARCHAR(180),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_profiles" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "slug" VARCHAR(140) NOT NULL,
    "businessName" VARCHAR(140) NOT NULL,
    "headline" VARCHAR(160),
    "bio" TEXT,
    "yearsExperience" INTEGER,
    "whatsappPhone" VARCHAR(20),
    "publicPhone" VARCHAR(20),
    "spokenLanguages" "Locale"[] DEFAULT ARRAY['FR', 'AR']::"Locale"[],
    "baseGovernorateId" UUID NOT NULL,
    "baseDelegationId" UUID,
    "latitude" DECIMAL(9,6),
    "longitude" DECIMAL(9,6),
    "publicationStatus" "ProviderPublicationStatus" NOT NULL DEFAULT 'DRAFT',
    "availabilityStatus" "AvailabilityStatus" NOT NULL DEFAULT 'AVAILABLE',
    "availableAgainAt" TIMESTAMP(3),
    "acceptsEmergency" BOOLEAN NOT NULL DEFAULT false,
    "workingHours" JSONB,
    "verificationStatus" "VerificationStatus" NOT NULL DEFAULT 'NOT_SUBMITTED',
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "verifiedAt" TIMESTAMP(3),
    "ratingAvg" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "ratingCount" INTEGER NOT NULL DEFAULT 0,
    "reviewCountByStar" JSONB,
    "totalProfileViews" INTEGER NOT NULL DEFAULT 0,
    "totalContacts" INTEGER NOT NULL DEFAULT 0,
    "completionScore" INTEGER NOT NULL DEFAULT 0,
    "rankingScore" DECIMAL(10,4) NOT NULL DEFAULT 0,
    "lastActiveAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "provider_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_categories" (
    "providerId" UUID NOT NULL,
    "categoryId" UUID NOT NULL,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "yearsExperience" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "provider_categories_pkey" PRIMARY KEY ("providerId","categoryId")
);

-- CreateTable
CREATE TABLE "service_offerings" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "categoryId" UUID NOT NULL,
    "titleFr" VARCHAR(160) NOT NULL,
    "titleAr" VARCHAR(160),
    "description" TEXT,
    "priceMin" DECIMAL(10,3),
    "priceMax" DECIMAL(10,3),
    "priceUnit" "PriceUnit" NOT NULL DEFAULT 'FIXED',
    "isNegotiable" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_offerings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "coverage_areas" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "governorateId" UUID NOT NULL,
    "delegationId" UUID,
    "travelFee" DECIMAL(10,3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "coverage_areas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "media_assets" (
    "id" UUID NOT NULL,
    "uploadedById" UUID,
    "bucket" VARCHAR(60) NOT NULL,
    "storageKey" VARCHAR(400) NOT NULL,
    "publicUrl" VARCHAR(600),
    "type" "MediaType" NOT NULL DEFAULT 'IMAGE',
    "mimeType" VARCHAR(80) NOT NULL,
    "sizeBytes" INTEGER NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "blurhash" VARCHAR(64),
    "checksumSha256" VARCHAR(64),
    "isPrivate" BOOLEAN NOT NULL DEFAULT false,
    "moderationStatus" "ModerationStatus" NOT NULL DEFAULT 'PENDING',
    "purgeAfter" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "media_assets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "portfolio_items" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "mediaId" UUID NOT NULL,
    "categoryId" UUID,
    "caption" VARCHAR(300),
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "status" "ModerationStatus" NOT NULL DEFAULT 'APPROVED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "portfolio_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contact_events" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "clientId" UUID,
    "categoryId" UUID,
    "channel" "ContactChannel" NOT NULL,
    "sourceScreen" VARCHAR(60),
    "sessionHash" VARCHAR(64),
    "ipHash" VARCHAR(64),
    "isSuspicious" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "contact_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profile_views" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "viewerId" UUID,
    "sessionHash" VARCHAR(64) NOT NULL,
    "viewDate" DATE NOT NULL,
    "source" VARCHAR(60),
    "isBot" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "profile_views_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "clientId" UUID NOT NULL,
    "contactEventId" UUID,
    "rating" INTEGER NOT NULL,
    "ratingPunctuality" INTEGER,
    "ratingQuality" INTEGER,
    "ratingValue" INTEGER,
    "comment" VARCHAR(1000),
    "status" "ReviewStatus" NOT NULL DEFAULT 'PENDING',
    "isVerifiedContact" BOOLEAN NOT NULL DEFAULT false,
    "moderatedById" UUID,
    "moderatedAt" TIMESTAMP(3),
    "moderationReason" VARCHAR(400),
    "editableUntil" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "favorites" (
    "userId" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "favorites_pkey" PRIMARY KEY ("userId","providerId")
);

-- CreateTable
CREATE TABLE "plans" (
    "id" UUID NOT NULL,
    "code" VARCHAR(40) NOT NULL,
    "nameFr" VARCHAR(80) NOT NULL,
    "nameAr" VARCHAR(80) NOT NULL,
    "descriptionFr" TEXT,
    "price" DECIMAL(10,3) NOT NULL,
    "billingPeriodDays" INTEGER NOT NULL,
    "maxCategories" INTEGER NOT NULL DEFAULT 3,
    "maxCoverageAreas" INTEGER NOT NULL DEFAULT 1,
    "maxPortfolioItems" INTEGER NOT NULL DEFAULT 5,
    "grantsVerifiedBadge" BOOLEAN NOT NULL DEFAULT false,
    "rankingBoostFactor" DECIMAL(4,2) NOT NULL DEFAULT 1.0,
    "instantLeadAccess" BOOLEAN NOT NULL DEFAULT false,
    "advancedStats" BOOLEAN NOT NULL DEFAULT false,
    "welcomeCredits" INTEGER NOT NULL DEFAULT 0,
    "features" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "actorId" UUID,
    "action" VARCHAR(80) NOT NULL,
    "entityType" VARCHAR(60) NOT NULL,
    "entityId" UUID,
    "before" JSONB,
    "after" JSONB,
    "ipHash" VARCHAR(64),
    "userAgent" VARCHAR(400),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "app_settings" (
    "key" VARCHAR(80) NOT NULL,
    "value" JSONB NOT NULL,
    "description" VARCHAR(300),
    "updatedById" UUID,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "app_settings_pkey" PRIMARY KEY ("key")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_status_idx" ON "users"("status");

-- CreateIndex
CREATE INDEX "users_createdAt_idx" ON "users"("createdAt");

-- CreateIndex
CREATE INDEX "users_deletedAt_idx" ON "users"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_refreshTokenHash_key" ON "sessions"("refreshTokenHash");

-- CreateIndex
CREATE INDEX "sessions_userId_revokedAt_idx" ON "sessions"("userId", "revokedAt");

-- CreateIndex
CREATE INDEX "sessions_expiresAt_idx" ON "sessions"("expiresAt");

-- CreateIndex
CREATE INDEX "otp_codes_phone_purpose_createdAt_idx" ON "otp_codes"("phone", "purpose", "createdAt");

-- CreateIndex
CREATE INDEX "otp_codes_expiresAt_idx" ON "otp_codes"("expiresAt");

-- CreateIndex
CREATE UNIQUE INDEX "governorates_code_key" ON "governorates"("code");

-- CreateIndex
CREATE UNIQUE INDEX "governorates_slug_key" ON "governorates"("slug");

-- CreateIndex
CREATE INDEX "governorates_isActive_idx" ON "governorates"("isActive");

-- CreateIndex
CREATE INDEX "delegations_governorateId_isActive_idx" ON "delegations"("governorateId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "delegations_governorateId_slug_key" ON "delegations"("governorateId", "slug");

-- CreateIndex
CREATE UNIQUE INDEX "categories_slug_key" ON "categories"("slug");

-- CreateIndex
CREATE INDEX "categories_parentId_isActive_sortOrder_idx" ON "categories"("parentId", "isActive", "sortOrder");

-- CreateIndex
CREATE UNIQUE INDEX "provider_profiles_userId_key" ON "provider_profiles"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "provider_profiles_slug_key" ON "provider_profiles"("slug");

-- CreateIndex
CREATE INDEX "provider_profiles_publicationStatus_verificationStatus_idx" ON "provider_profiles"("publicationStatus", "verificationStatus");

-- CreateIndex
CREATE INDEX "provider_profiles_baseGovernorateId_publicationStatus_idx" ON "provider_profiles"("baseGovernorateId", "publicationStatus");

-- CreateIndex
CREATE INDEX "provider_profiles_baseDelegationId_idx" ON "provider_profiles"("baseDelegationId");

-- CreateIndex
CREATE INDEX "provider_profiles_rankingScore_idx" ON "provider_profiles"("rankingScore" DESC);

-- CreateIndex
CREATE INDEX "provider_profiles_ratingAvg_ratingCount_idx" ON "provider_profiles"("ratingAvg" DESC, "ratingCount" DESC);

-- CreateIndex
CREATE INDEX "provider_categories_categoryId_idx" ON "provider_categories"("categoryId");

-- CreateIndex
CREATE INDEX "service_offerings_providerId_isActive_idx" ON "service_offerings"("providerId", "isActive");

-- CreateIndex
CREATE INDEX "service_offerings_categoryId_priceMin_idx" ON "service_offerings"("categoryId", "priceMin");

-- CreateIndex
CREATE INDEX "coverage_areas_governorateId_delegationId_idx" ON "coverage_areas"("governorateId", "delegationId");

-- CreateIndex
CREATE UNIQUE INDEX "coverage_areas_providerId_governorateId_delegationId_key" ON "coverage_areas"("providerId", "governorateId", "delegationId");

-- CreateIndex
CREATE UNIQUE INDEX "media_assets_storageKey_key" ON "media_assets"("storageKey");

-- CreateIndex
CREATE INDEX "media_assets_moderationStatus_idx" ON "media_assets"("moderationStatus");

-- CreateIndex
CREATE INDEX "media_assets_purgeAfter_idx" ON "media_assets"("purgeAfter");

-- CreateIndex
CREATE INDEX "portfolio_items_providerId_status_sortOrder_idx" ON "portfolio_items"("providerId", "status", "sortOrder");

-- CreateIndex
CREATE INDEX "contact_events_providerId_createdAt_idx" ON "contact_events"("providerId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "contact_events_clientId_createdAt_idx" ON "contact_events"("clientId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "contact_events_createdAt_idx" ON "contact_events"("createdAt");

-- CreateIndex
CREATE INDEX "profile_views_providerId_viewDate_idx" ON "profile_views"("providerId", "viewDate");

-- CreateIndex
CREATE UNIQUE INDEX "profile_views_providerId_sessionHash_viewDate_key" ON "profile_views"("providerId", "sessionHash", "viewDate");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_contactEventId_key" ON "reviews"("contactEventId");

-- CreateIndex
CREATE INDEX "reviews_providerId_status_createdAt_idx" ON "reviews"("providerId", "status", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "reviews_clientId_createdAt_idx" ON "reviews"("clientId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "reviews_status_createdAt_idx" ON "reviews"("status", "createdAt");

-- CreateIndex
CREATE INDEX "favorites_providerId_idx" ON "favorites"("providerId");

-- CreateIndex
CREATE UNIQUE INDEX "plans_code_key" ON "plans"("code");

-- CreateIndex
CREATE INDEX "plans_isActive_sortOrder_idx" ON "plans"("isActive", "sortOrder");

-- CreateIndex
CREATE INDEX "audit_logs_entityType_entityId_createdAt_idx" ON "audit_logs"("entityType", "entityId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "audit_logs_actorId_createdAt_idx" ON "audit_logs"("actorId", "createdAt" DESC);

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_avatarMediaId_fkey" FOREIGN KEY ("avatarMediaId") REFERENCES "media_assets"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "otp_codes" ADD CONSTRAINT "otp_codes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delegations" ADD CONSTRAINT "delegations_governorateId_fkey" FOREIGN KEY ("governorateId") REFERENCES "governorates"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_profiles" ADD CONSTRAINT "provider_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_profiles" ADD CONSTRAINT "provider_profiles_baseGovernorateId_fkey" FOREIGN KEY ("baseGovernorateId") REFERENCES "governorates"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_profiles" ADD CONSTRAINT "provider_profiles_baseDelegationId_fkey" FOREIGN KEY ("baseDelegationId") REFERENCES "delegations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_categories" ADD CONSTRAINT "provider_categories_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_categories" ADD CONSTRAINT "provider_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_offerings" ADD CONSTRAINT "service_offerings_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_offerings" ADD CONSTRAINT "service_offerings_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coverage_areas" ADD CONSTRAINT "coverage_areas_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coverage_areas" ADD CONSTRAINT "coverage_areas_governorateId_fkey" FOREIGN KEY ("governorateId") REFERENCES "governorates"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coverage_areas" ADD CONSTRAINT "coverage_areas_delegationId_fkey" FOREIGN KEY ("delegationId") REFERENCES "delegations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media_assets" ADD CONSTRAINT "media_assets_uploadedById_fkey" FOREIGN KEY ("uploadedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "portfolio_items" ADD CONSTRAINT "portfolio_items_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "portfolio_items" ADD CONSTRAINT "portfolio_items_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES "media_assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "portfolio_items" ADD CONSTRAINT "portfolio_items_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_events" ADD CONSTRAINT "contact_events_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_events" ADD CONSTRAINT "contact_events_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_events" ADD CONSTRAINT "contact_events_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile_views" ADD CONSTRAINT "profile_views_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile_views" ADD CONSTRAINT "profile_views_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_contactEventId_fkey" FOREIGN KEY ("contactEventId") REFERENCES "contact_events"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_moderatedById_fkey" FOREIGN KEY ("moderatedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favorites" ADD CONSTRAINT "favorites_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favorites" ADD CONSTRAINT "favorites_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
