// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : contracts/openapi.json
// Régénérer : pnpm web:client

export interface paths {
    "/v1/health": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Vérifie la disponibilité réelle de PostgreSQL et Redis (pas un {ok:true} de façade). */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** @enum {string} */
                            status: "ok" | "degraded";
                            /** @enum {string} */
                            db: "up" | "down";
                            /** @enum {string} */
                            redis: "up" | "down";
                        };
                    };
                };
                /** @description Default Response */
                503: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** @enum {string} */
                            status: "ok" | "degraded";
                            /** @enum {string} */
                            db: "up" | "down";
                            /** @enum {string} */
                            redis: "up" | "down";
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/auth/me": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Profil de l'utilisateur authentifié, rôles inclus. */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            phone: string;
                            phoneVerifiedAt: string | null;
                            email: string | null;
                            emailVerifiedAt: string | null;
                            firstName: string | null;
                            lastName: string | null;
                            avatarMediaId: string | null;
                            roles: ("CLIENT" | "PROVIDER" | "MODERATOR" | "SUPPORT" | "SALES" | "FINANCE" | "ADMIN" | "SUPER_ADMIN")[];
                            /** @enum {string} */
                            status: "PENDING_VERIFICATION" | "ACTIVE" | "SUSPENDED" | "DELETED";
                            locale: string;
                            lastLoginAt: string | null;
                            marketingOptIn: boolean;
                            /** Format: date-time */
                            createdAt: string;
                            /** Format: date-time */
                            updatedAt: string;
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/auth/otp/request": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Demande un code OTP par SMS. Réponse identique, que le numéro existe déjà ou non (anti-énumération). Rate-limit : 5/h par numéro et par IP. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        phone: string;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** @enum {string} */
                            status: "sent";
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/auth/otp/verify": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Vérifie le code OTP, crée le compte au besoin, émet les tokens de session. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        phone: string;
                        code: string;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            accessToken: string;
                            refreshToken: string;
                            user: {
                                /** Format: uuid */
                                id: string;
                                phone: string;
                                phoneVerifiedAt: string | null;
                                email: string | null;
                                emailVerifiedAt: string | null;
                                firstName: string | null;
                                lastName: string | null;
                                avatarMediaId: string | null;
                                roles: ("CLIENT" | "PROVIDER" | "MODERATOR" | "SUPPORT" | "SALES" | "FINANCE" | "ADMIN" | "SUPER_ADMIN")[];
                                /** @enum {string} */
                                status: "PENDING_VERIFICATION" | "ACTIVE" | "SUSPENDED" | "DELETED";
                                locale: string;
                                lastLoginAt: string | null;
                                marketingOptIn: boolean;
                                /** Format: date-time */
                                createdAt: string;
                                /** Format: date-time */
                                updatedAt: string;
                            };
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/auth/refresh": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Fait tourner le refresh token. Un rejeu révoque toute la famille de sessions. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        refreshToken: string;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": components["schemas"]["AuthTokens"];
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/auth/logout": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Révoque la session associée au refresh token présenté. Idempotent. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        refreshToken: string;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** @enum {string} */
                            status: "ok";
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/categories": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Arbre complet des catégories, libellés FR et AR. Cache Redis 1h. */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            categories: components["schemas"]["CategoryTreeNode"][];
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/governorates": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description 24 gouvernorats, libellés FR et AR. Cache Redis 1h. */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            governorates: {
                                /** Format: uuid */
                                id: string;
                                code: string;
                                nameFr: string;
                                nameAr: string;
                                slug: string;
                                latitude: number | null;
                                longitude: number | null;
                                sortOrder: number;
                            }[];
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/governorates/{id}/delegations": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Délégations actives d’un gouvernorat, libellés FR et AR. Cache Redis 1h. */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    id: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            delegations: {
                                /** Format: uuid */
                                id: string;
                                /** Format: uuid */
                                governorateId: string;
                                code: string | null;
                                nameFr: string;
                                nameAr: string;
                                slug: string;
                                postalCode: string | null;
                                latitude: number | null;
                                longitude: number | null;
                            }[];
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/media/presign": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Crée un `MediaAsset` (bucket public) et renvoie une URL PUT pré-signée (~10 min) pour un téléversement direct vers R2, sans transiter par l'API (P5). Le traitement (variantes WebP) se fait ensuite via `POST /v1/media/:id/process`. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        filename: string;
                        mimeType: string;
                        sizeBytes: number;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            mediaId: string;
                            uploadUrl: string;
                            /** Format: date-time */
                            expiresAt: string;
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/media/{id}/process": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Télécharge l'original téléversé par le client (voir `POST /v1/media/presign`), génère les 3 variantes WebP (thumb/card/full — BE-20) et les téléverse sur R2. `MediaAsset.publicUrl`/`width`/`height` reflètent la variante `full`. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    id: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            publicUrl: string;
                            thumbUrl: string;
                            cardUrl: string;
                            fullUrl: string;
                            width: number;
                            height: number;
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/search": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Recherche d’artisans : catégorie/gouvernorat/délégation/vérifié/note/disponibilité, tri par score de ranking calculé, pagination par curseur. Mode debug via ?debug=true. */
        get: {
            parameters: {
                query: {
                    category?: string;
                    governorate: string;
                    delegation?: string;
                    verified?: "true" | "false";
                    minRating?: number;
                    availability?: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                    cursor?: string;
                    limit?: number;
                    debug?: "true" | "false";
                };
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            items: {
                                /** Format: uuid */
                                id: string;
                                slug: string;
                                businessName: string;
                                headline: string | null;
                                isVerified: boolean;
                                ratingAvg: number;
                                ratingCount: number;
                                completionScore: number;
                                /** @enum {string} */
                                availabilityStatus: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                                categories: {
                                    slug: string;
                                    nameFr: string;
                                    nameAr: string;
                                    isPrimary: boolean;
                                }[];
                                score?: number;
                                matchReason?: {
                                    geo: number;
                                    rating: number;
                                    trust: number;
                                    completion: number;
                                    responsiveness: number;
                                    plan: number;
                                    penalty: number;
                                };
                            }[];
                            nextCursor: string | null;
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/{slug}": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Fiche artisan publique — profil, catégories, offres tarifées, zones de couverture, galerie, agrégat d’avis. Jamais de numéro de téléphone (voir POST /contact-events, BE-21). */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    slug: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            slug: string;
                            businessName: string;
                            headline: string | null;
                            bio: string | null;
                            yearsExperience: number | null;
                            spokenLanguages: ("FR" | "AR" | "EN")[];
                            baseGovernorate: {
                                slug: string;
                                nameFr: string;
                                nameAr: string;
                            };
                            baseDelegation: {
                                slug: string;
                                nameFr: string;
                                nameAr: string;
                            } | null;
                            latitude: number | null;
                            longitude: number | null;
                            isVerified: boolean;
                            /** @enum {string} */
                            availabilityStatus: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                            availableAgainAt: string | null;
                            acceptsEmergency: boolean;
                            completionScore: number;
                            categories: {
                                slug: string;
                                nameFr: string;
                                nameAr: string;
                                isPrimary: boolean;
                                yearsExperience: number | null;
                            }[];
                            offerings: {
                                /** Format: uuid */
                                id: string;
                                category: {
                                    slug: string;
                                    nameFr: string;
                                    nameAr: string;
                                };
                                titleFr: string;
                                titleAr: string | null;
                                description: string | null;
                                priceMin: number | null;
                                priceMax: number | null;
                                /** @enum {string} */
                                priceUnit: "FIXED" | "HOUR" | "DAY" | "SQUARE_METER" | "LINEAR_METER" | "ON_QUOTE";
                                isNegotiable: boolean;
                                displayPrice: string;
                            }[];
                            coverageAreas: {
                                governorate: {
                                    slug: string;
                                    nameFr: string;
                                    nameAr: string;
                                };
                                delegation: {
                                    slug: string;
                                    nameFr: string;
                                    nameAr: string;
                                } | null;
                                travelFee: number | null;
                            }[];
                            gallery: {
                                /** Format: uuid */
                                id: string;
                                url: string;
                                width: number | null;
                                height: number | null;
                                blurhash: string | null;
                                caption: string | null;
                                category: {
                                    slug: string;
                                    nameFr: string;
                                    nameAr: string;
                                } | null;
                            }[];
                            reviewAggregate: {
                                average: number;
                                count: number;
                                breakdown: {
                                    1: number;
                                    2: number;
                                    3: number;
                                    4: number;
                                    5: number;
                                };
                            };
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/{slug}/reviews": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Avis PUBLISHED d’un artisan, triés par date décroissante, pagination par curseur. Nom de l’auteur anonymisé ("Utilisateur supprimé") si le compte a été supprimé. Sous-notes et réponse de l’artisan hors périmètre (voir backlog). */
        get: {
            parameters: {
                query?: {
                    cursor?: string;
                    limit?: number;
                };
                header?: never;
                path: {
                    slug: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            items: {
                                /** Format: uuid */
                                id: string;
                                rating: number;
                                comment: string | null;
                                isVerifiedContact: boolean;
                                /** Format: date-time */
                                createdAt: string;
                                authorDisplayName: string;
                            }[];
                            nextCursor: string | null;
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/{id}/reviews": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Dépose un avis rattaché à un ContactEvent réel (BE-22, P9/P10). Sélection automatique du contact éligible (>12h, <60j, pas déjà avisé) — 403 REVIEW_REQUIRES_CONTACT sinon. Auto-évaluation rejetée. Publié immédiatement (pas de filtrage anti-spam pour l'instant). */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    id: string;
                };
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        rating: number;
                        comment?: string;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            rating: number;
                            comment: string | null;
                            isVerifiedContact: boolean;
                            /** Format: date-time */
                            createdAt: string;
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/me": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Profil artisan complet de l'utilisateur authentifié (vue propriétaire : mêmes champs que la fiche publique, plus les champs privés utiles à l’édition — availabilityStatus, availableAgainAt, acceptsEmergency, workingHours, publicationStatus, completionScore). BE-44. */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            slug: string;
                            businessName: string;
                            headline: string | null;
                            bio: string | null;
                            yearsExperience: number | null;
                            whatsappPhone: string | null;
                            publicPhone: string | null;
                            spokenLanguages: ("FR" | "AR" | "EN")[];
                            /** Format: uuid */
                            baseGovernorateId: string;
                            baseDelegationId: string | null;
                            latitude: number | null;
                            longitude: number | null;
                            /** @enum {string} */
                            publicationStatus: "DRAFT" | "PUBLISHED" | "HIDDEN" | "SUSPENDED";
                            /** @enum {string} */
                            availabilityStatus: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                            availableAgainAt: string | null;
                            acceptsEmergency: boolean;
                            workingHours: unknown | null;
                            isVerified: boolean;
                            verifiedAt: string | null;
                            ratingAvg: number;
                            ratingCount: number;
                            totalProfileViews: number;
                            totalContacts: number;
                            completionScore: number;
                            rankingScore: number;
                            lastActiveAt: string | null;
                            /** Format: date-time */
                            createdAt: string;
                            /** Format: date-time */
                            updatedAt: string;
                        };
                    };
                };
            };
        };
        put?: never;
        /** @description Crée le profil artisan de l'utilisateur authentifié. Le promeut PROVIDER s'il ne l'est pas déjà (US-P-01 : devenir prestataire sans créer un second compte) et émet un nouveau couple de tokens reflétant ce rôle. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        businessName: string;
                        /** Format: uuid */
                        baseGovernorateId: string;
                        /** Format: uuid */
                        baseDelegationId?: string;
                        headline?: string;
                        bio?: string;
                        yearsExperience?: number;
                        whatsappPhone?: string;
                        publicPhone?: string;
                        spokenLanguages?: ("FR" | "AR" | "EN")[];
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            accessToken: string;
                            refreshToken: string;
                            provider: {
                                /** Format: uuid */
                                id: string;
                                slug: string;
                                businessName: string;
                                headline: string | null;
                                bio: string | null;
                                yearsExperience: number | null;
                                whatsappPhone: string | null;
                                publicPhone: string | null;
                                spokenLanguages: ("FR" | "AR" | "EN")[];
                                /** Format: uuid */
                                baseGovernorateId: string;
                                baseDelegationId: string | null;
                                latitude: number | null;
                                longitude: number | null;
                                /** @enum {string} */
                                publicationStatus: "DRAFT" | "PUBLISHED" | "HIDDEN" | "SUSPENDED";
                                /** @enum {string} */
                                availabilityStatus: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                                availableAgainAt: string | null;
                                acceptsEmergency: boolean;
                                workingHours: unknown | null;
                                isVerified: boolean;
                                verifiedAt: string | null;
                                ratingAvg: number;
                                ratingCount: number;
                                totalProfileViews: number;
                                totalContacts: number;
                                completionScore: number;
                                rankingScore: number;
                                lastActiveAt: string | null;
                                /** Format: date-time */
                                createdAt: string;
                                /** Format: date-time */
                                updatedAt: string;
                            };
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        /** @description Met à jour le profil artisan de l'utilisateur authentifié. `completionScore` est recalculé à chaque appel ; publier (`publicationStatus: PUBLISHED`) est refusé sous 60 % de complétude, avec la liste des champs manquants. */
        patch: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        businessName?: string;
                        headline?: string;
                        bio?: string;
                        yearsExperience?: number;
                        whatsappPhone?: string;
                        publicPhone?: string;
                        /** @enum {string} */
                        availabilityStatus?: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                        availableAgainAt?: unknown | null;
                        acceptsEmergency?: boolean;
                        workingHours?: unknown;
                        /** @enum {string} */
                        publicationStatus?: "DRAFT" | "PUBLISHED";
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            slug: string;
                            businessName: string;
                            headline: string | null;
                            bio: string | null;
                            yearsExperience: number | null;
                            whatsappPhone: string | null;
                            publicPhone: string | null;
                            spokenLanguages: ("FR" | "AR" | "EN")[];
                            /** Format: uuid */
                            baseGovernorateId: string;
                            baseDelegationId: string | null;
                            latitude: number | null;
                            longitude: number | null;
                            /** @enum {string} */
                            publicationStatus: "DRAFT" | "PUBLISHED" | "HIDDEN" | "SUSPENDED";
                            /** @enum {string} */
                            availabilityStatus: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                            availableAgainAt: string | null;
                            acceptsEmergency: boolean;
                            workingHours: unknown | null;
                            isVerified: boolean;
                            verifiedAt: string | null;
                            ratingAvg: number;
                            ratingCount: number;
                            totalProfileViews: number;
                            totalContacts: number;
                            completionScore: number;
                            rankingScore: number;
                            lastActiveAt: string | null;
                            /** Format: date-time */
                            createdAt: string;
                            /** Format: date-time */
                            updatedAt: string;
                        };
                    };
                };
            };
        };
        trace?: never;
    };
    "/v1/providers/me/categories": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        /** @description Remplace tout le set de catégories de l’artisan authentifié (une seule catégorie principale, exactement un `isPrimary: true`). Limite du plan FREE : 3 catégories. `completionScore` recalculé. */
        put: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        categories: {
                            /** Format: uuid */
                            categoryId: string;
                            isPrimary: boolean;
                            yearsExperience?: number;
                        }[];
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            categories: {
                                /** Format: uuid */
                                categoryId: string;
                                isPrimary: boolean;
                                yearsExperience: number | null;
                            }[];
                            completionScore: number;
                        };
                    };
                };
            };
        };
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/me/coverage-areas": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        /** @description Remplace tout le set de zones d'intervention de l'artisan authentifié. `delegationId` absent = tout le gouvernorat. Limite du plan FREE : 1 gouvernorat distinct (plusieurs délégations du même gouvernorat ne comptent qu'une fois). `completionScore` recalculé. */
        put: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        coverageAreas: {
                            /** Format: uuid */
                            governorateId: string;
                            /** Format: uuid */
                            delegationId?: string;
                            travelFee?: number;
                        }[];
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            coverageAreas: {
                                /** Format: uuid */
                                id: string;
                                /** Format: uuid */
                                governorateId: string;
                                delegationId: string | null;
                                travelFee: number | null;
                            }[];
                            completionScore: number;
                        };
                    };
                };
            };
        };
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/me/portfolio": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Rattache au profil artisan un `MediaAsset` déjà traité (`POST /v1/media/:id/process`, BE-20c) — le média doit appartenir à l'appelant et être `APPROVED`. Limite du plan FREE : 5 photos (US-P-04). */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        /** Format: uuid */
                        mediaId: string;
                        /** Format: uuid */
                        categoryId?: string;
                        caption?: string;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            /** Format: uuid */
                            mediaId: string;
                            categoryId: string | null;
                            caption: string | null;
                            sortOrder: number;
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/me/portfolio/{id}": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        post?: never;
        /** @description Détache un élément de la galerie de l'artisan authentifié. */
        delete: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    id: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content?: never;
                };
            };
        };
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/me/offerings": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Ajoute une offre (tarif) au profil de l'artisan authentifié. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        /** Format: uuid */
                        categoryId: string;
                        titleFr: string;
                        titleAr?: string;
                        description?: string;
                        priceMin?: number;
                        priceMax?: number;
                        /** @enum {string} */
                        priceUnit?: "FIXED" | "HOUR" | "DAY" | "SQUARE_METER" | "LINEAR_METER" | "ON_QUOTE";
                        isNegotiable?: boolean;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            category: {
                                slug: string;
                                nameFr: string;
                                nameAr: string;
                            };
                            titleFr: string;
                            titleAr: string | null;
                            description: string | null;
                            priceMin: number | null;
                            priceMax: number | null;
                            /** @enum {string} */
                            priceUnit: "FIXED" | "HOUR" | "DAY" | "SQUARE_METER" | "LINEAR_METER" | "ON_QUOTE";
                            isNegotiable: boolean;
                            displayPrice: string;
                        };
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/providers/me/offerings/{id}": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        post?: never;
        /** @description Retire une offre de l'artisan authentifié (désactivation, pas de suppression physique). */
        delete: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    id: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content?: never;
                };
            };
        };
        options?: never;
        head?: never;
        /** @description Modifie une offre de l'artisan authentifié (catégorie non modifiable). */
        patch: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    id: string;
                };
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        titleFr?: string;
                        titleAr?: string | null;
                        description?: string | null;
                        priceMin?: number | null;
                        priceMax?: number | null;
                        /** @enum {string} */
                        priceUnit?: "FIXED" | "HOUR" | "DAY" | "SQUARE_METER" | "LINEAR_METER" | "ON_QUOTE";
                        isNegotiable?: boolean;
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            id: string;
                            category: {
                                slug: string;
                                nameFr: string;
                                nameAr: string;
                            };
                            titleFr: string;
                            titleAr: string | null;
                            description: string | null;
                            priceMin: number | null;
                            priceMax: number | null;
                            /** @enum {string} */
                            priceUnit: "FIXED" | "HOUR" | "DAY" | "SQUARE_METER" | "LINEAR_METER" | "ON_QUOTE";
                            isNegotiable: boolean;
                            displayPrice: string;
                        };
                    };
                };
            };
        };
        trace?: never;
    };
    "/v1/providers/me/stats": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Tableau de bord de l'artisan authentifié (US-P-07/US-P-08) : totaux et série journalière sur 30 jours (vues, vues dédupliquées, contacts, ratio vue→contact), jours à zéro inclus. `searchImpressions`/`avgSearchPosition` sont absents : aucun module `search` n'existe encore pour les alimenter (BE-43). */
        get: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            totals: {
                                profileViews: number;
                                uniqueProfileViews: number;
                                contacts: number;
                                contactsByChannel: {
                                    phone: number;
                                    whatsapp: number;
                                };
                                viewToContactRatio: number;
                            };
                            series: {
                                /** Format: date-time */
                                date: string;
                                profileViews: number;
                                uniqueProfileViews: number;
                                contacts: number;
                            }[];
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/contact-events": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Historique des contacts du client authentifié (US-C-09), trié par date décroissante, pagination par curseur. Chaque item porte déjà les libellés d'affichage (P3, pas de second appel GET /providers/:slug côté mobile) et `hasReview` pour le CTA de dépôt d'avis (FM-31). */
        get: {
            parameters: {
                query?: {
                    cursor?: string;
                    limit?: number;
                };
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            items: {
                                /** Format: uuid */
                                id: string;
                                /** Format: uuid */
                                providerId: string;
                                slug: string;
                                businessName: string;
                                categoryName: string | null;
                                /** @enum {string} */
                                channel: "PHONE" | "WHATSAPP";
                                /** Format: date-time */
                                contactedAt: string;
                                hasReview: boolean;
                            }[];
                            nextCursor: string | null;
                        };
                    };
                };
            };
        };
        put?: never;
        /** @description Révèle le numéro d'un prestataire et trace l'événement (P9). Canal PHONE ou WHATSAPP uniquement. Déduplique deux clics de la même session sur le même artisan/canal en 30 min. Rate-limit 30/j par identité et par IP. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        /** Format: uuid */
                        providerId: string;
                        /** @enum {string} */
                        channel: "PHONE" | "WHATSAPP";
                        /** Format: uuid */
                        categoryId?: string;
                        /** @enum {string} */
                        sourceScreen?: "search" | "profile" | "boost" | "ad" | "seo_page";
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": components["schemas"]["ContactEventResponse"];
                    };
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/favorites/{providerId}": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        /** @description Ajoute un prestataire aux favoris du client authentifié — idempotent (clé composite (userId, providerId), deux appels successifs ne créent jamais de doublon). 404 si le prestataire n'existe pas ou n'est pas publié. */
        put: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    providerId: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            /** Format: uuid */
                            providerId: string;
                            /** Format: date-time */
                            createdAt: string;
                        };
                    };
                };
            };
        };
        post?: never;
        /** @description Retire un prestataire des favoris du client authentifié — idempotent, 204 même si le favori n'existait pas. */
        delete: {
            parameters: {
                query?: never;
                header?: never;
                path: {
                    providerId: string;
                };
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content?: never;
                };
            };
        };
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/favorites": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        /** @description Favoris du client authentifié, triés par date d'ajout décroissante, pagination par curseur. */
        get: {
            parameters: {
                query?: {
                    cursor?: string;
                    limit?: number;
                };
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody?: never;
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content: {
                        "application/json": {
                            items: {
                                /** Format: uuid */
                                providerId: string;
                                slug: string;
                                businessName: string;
                                headline: string | null;
                                isVerified: boolean;
                                ratingAvg: number;
                                ratingCount: number;
                                /** @enum {string} */
                                availabilityStatus: "AVAILABLE" | "BUSY" | "ON_HOLIDAY";
                                /** Format: date-time */
                                favoritedAt: string;
                            }[];
                            nextCursor: string | null;
                        };
                    };
                };
            };
        };
        put?: never;
        post?: never;
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
    "/v1/profile-views": {
        parameters: {
            query?: never;
            header?: never;
            path?: never;
            cookie?: never;
        };
        get?: never;
        put?: never;
        /** @description Trace la vue d'un profil artisan (P9). Déduplique par empreinte de session sur un jour calendaire UTC (une vue = une ligne par session et par jour) et met à jour l'agrégat journalier DailyProviderStat. Rate-limit 200/j par identité et par IP. */
        post: {
            parameters: {
                query?: never;
                header?: never;
                path?: never;
                cookie?: never;
            };
            requestBody: {
                content: {
                    "application/json": {
                        /** Format: uuid */
                        providerId: string;
                        /** @enum {string} */
                        source?: "search" | "profile" | "boost" | "ad" | "seo_page";
                    };
                };
            };
            responses: {
                /** @description Default Response */
                200: {
                    headers: {
                        [name: string]: unknown;
                    };
                    content?: never;
                };
            };
        };
        delete?: never;
        options?: never;
        head?: never;
        patch?: never;
        trace?: never;
    };
}
export type webhooks = Record<string, never>;
export interface components {
    schemas: {
        AuthTokensInput: {
            accessToken: string;
            refreshToken: string;
        };
        CategoryTreeNodeInput: {
            /** Format: uuid */
            id: string;
            slug: string;
            nameFr: string;
            nameAr: string;
            descriptionFr: string | null;
            descriptionAr: string | null;
            iconKey: string | null;
            colorHex: string | null;
            sortOrder: number;
            children: components["schemas"]["CategoryTreeNodeInput"][];
        };
        ContactEventResponseInput: {
            /** Format: uuid */
            contactEventId: string;
            /** Format: uuid */
            providerId: string;
            /** @enum {string} */
            channel: "PHONE" | "WHATSAPP";
            phone: string;
            whatsappMessage?: string;
            deduplicated: boolean;
        };
        AuthTokens: {
            accessToken: string;
            refreshToken: string;
        };
        CategoryTreeNode: {
            /** Format: uuid */
            id: string;
            slug: string;
            nameFr: string;
            nameAr: string;
            descriptionFr: string | null;
            descriptionAr: string | null;
            iconKey: string | null;
            colorHex: string | null;
            sortOrder: number;
            children: components["schemas"]["CategoryTreeNode"][];
        };
        ContactEventResponse: {
            /** Format: uuid */
            contactEventId: string;
            /** Format: uuid */
            providerId: string;
            /** @enum {string} */
            channel: "PHONE" | "WHATSAPP";
            phone: string;
            whatsappMessage?: string;
            deduplicated: boolean;
        };
    };
    responses: never;
    parameters: never;
    requestBodies: never;
    headers: never;
    pathItems: never;
}
export type $defs = Record<string, never>;
export type operations = Record<string, never>;
