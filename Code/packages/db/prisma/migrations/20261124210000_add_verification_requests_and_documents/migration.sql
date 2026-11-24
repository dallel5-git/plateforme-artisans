-- BE-30b / BE-31 : Tables de vérification d'identité KYC (VerificationRequest & VerificationDocument).
-- Conformité INPDP (loi n° 2004-63) et ADR-002 :
-- - Le numéro de CIN est stocké sous forme de hash SHA-256 salé (cinNumberHash) et de texte chiffré AES-256-GCM (cinNumberCipher).
-- - Les pièces jointes sont référencées dans verification_documents avec le type de document (CIN_FRONT, CIN_BACK).

-- CreateEnum
CREATE TYPE "VerificationDocumentType" AS ENUM ('CIN_FRONT', 'CIN_BACK', 'SELFIE_WITH_ID', 'PATENTE', 'DIPLOMA', 'INSURANCE', 'OTHER');

-- CreateTable
CREATE TABLE "verification_requests" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "status" "VerificationStatus" NOT NULL DEFAULT 'PENDING',
    "cinNumberHash" VARCHAR(64),
    "cinNumberCipher" TEXT,
    "fullNameOnId" VARCHAR(160),
    "submittedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "reviewedAt" TIMESTAMP(3),
    "reviewedById" UUID,
    "rejectionReason" VARCHAR(400),
    "internalNote" TEXT,
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "verification_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification_documents" (
    "id" UUID NOT NULL,
    "requestId" UUID NOT NULL,
    "mediaId" UUID NOT NULL,
    "type" "VerificationDocumentType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "verification_documents_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "verification_requests_status_submittedAt_idx" ON "verification_requests"("status", "submittedAt");

-- CreateIndex
CREATE INDEX "verification_requests_providerId_status_idx" ON "verification_requests"("providerId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "verification_documents_requestId_type_key" ON "verification_documents"("requestId", "type");

-- AddForeignKey
ALTER TABLE "verification_requests" ADD CONSTRAINT "verification_requests_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "provider_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_requests" ADD CONSTRAINT "verification_requests_reviewedById_fkey" FOREIGN KEY ("reviewedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_documents" ADD CONSTRAINT "verification_documents_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "verification_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_documents" ADD CONSTRAINT "verification_documents_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES "media_assets"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
