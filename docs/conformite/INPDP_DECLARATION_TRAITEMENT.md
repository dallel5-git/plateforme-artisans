# Dossier de Déclaration Préalable & Conformité Légale INPDP
## Traitement de Données à Caractère Personnel Sensibles : Vérification d'Identité (CIN) des Artisans

* **Cadre Juridique :** République Tunisienne — Loi organique n° 2004-63 du 27 juillet 2004, portant sur la protection des données à caractère personnel.
* **Autorité de Contrôle :** Instance Nationale de Protection des Données Personnelles (INPDP).
* **Référence Projet :** Plateforme Sanaya (`صنايعية`) — Module KYC & Vérification Artisan (`BE-30a`, `BE-30b`, `BE-30c`, `BE-31a`, `MOB-030`, `MOB-031`, `FW-20a`, `FW-20b`).
* **Version du Document :** 1.0 (Novembre 2026)
* **Statut :** Formulaire technique et juridique pour dépôt auprès de l'INPDP.

---

## 1. Identification du Responsable de Traitement & Contact DPO

### 1.1 Responsable du Traitement
* **Organisme / Société :** Sanaya Technologies Tunisie (Éditrice de la plateforme d'intermédiation artisanale Sanaya).
* **Siège Social :** Tunis, République Tunisienne.
* **Représentant Légal :** Direction Générale Sanaya.
* **Contact Institutionnel :** `contact@sanaya.tn`

### 1.2 Délégué à la Protection des Données (DPO / Correspondant INPDP)
* **Fonction :** Délégué à la Protection des Données Personnelles (DPO).
* **Courriel dédié :** `dpo@sanaya.tn` / `conformite@sanaya.tn`.
* **Mission :** Tenue du registre des activités de traitement, interface exclusive avec l'INPDP, traitement des demandes d'exercice des droits (accès, rectification, opposition, effacement) et pilotage des audits de sécurité.

---

## 2. Finalités du Traitement & Base Légale (Loi n° 2004-63)

### 2.1 Finalité Principale
Le traitement des données d'identité et des clichés de la Carte d'Identité Nationale (CIN) poursuit une finalité exclusive, déterminée, explicite et légitime (Articles 10, 11 et 12 de la loi n° 2004-63) :
1. **Certification de l'identité des professionnels :** Confirmer avec certitude que la personne physique inscrite sur la plateforme Sanaya en qualité d'artisan / professionnel indépendant est bien titulaire de l'identité civile déclarée.
2. **Prévention de l'usurpation d'identité et de la fraude :** Empêcher qu'un tiers n'utilise frauduleusement le nom, le numéro de téléphone ou la réputation d'un professionnel enregistré.
3. **Sécurisation de la mise en relation avec le public :** Protéger les particuliers et clients qui font entrer des artisans à leur domicile pour des travaux de bâtiment, en attestant de la traçabilité légale et de la vérification de l'intervenant par l'octroi d'un badge public « Vérifié » (*Charte de Confiance Sanaya*).

### 2.2 Interdiction de Détournement de Finalité
* **Non-commercialisation :** Les clichés de la CIN et les numéros nationaux ne font l'objet d'aucune exploitation publicitaire, statistique commerciale, cession, location ou partage avec des partenaires tiers ou régies publicitaires.
* **Absence de profilage automatisé :** Le traitement d'instruction ne repose sur aucun algorithme de décision totalement automatisé ou système de notation prédictive du comportement de l'artisan. Toute décision de validation ou de rejet est instruite par un modérateur humain qualifié (Back-Office Admin, règles `FW-20a` et `FW-20b`).

### 2.3 Base Légale & Consentement de la Personne Concernée (Article 7)
Conformément à l'Article 7 de la loi n° 2004-63, le traitement est fondé sur le **consentement exprès, préalable, libre et éclairé** de l'artisan :
* Au moment de la soumission de sa pièce d'identité sur l'application mobile (`MOB-030`), l'artisan valide activement une case à cocher obligatoire et non pré-cochée comportant la mention suivante :
  > *« J'autorise expressément la plateforme Sanaya à traiter les clichés de ma Carte d'Identité Nationale (recto et verso) aux seules fins exclusives de vérification de mon identité conformément à la loi tunisienne n° 2004-63. Je reconnais avoir pris connaissance de mes droits d'accès, de rectification et d'effacement. »*
* La date, l'heure (ISO 8601), l'adresse IP et l'identifiant du compte sont immédiatement enregistrés dans le champ immuable `consentGivenAt` de la table `KycVerification`.

---

## 3. Registre des Catégories de Données Collectées

| Donnée Collectée | Nature | Justification Technique / Métier | Modalité de Stockage |
| :--- | :--- | :--- | :--- |
| **Numéro CIN** | 8 chiffres tunisiens | Identifiant unique national anti-doublon et confrontation visuelle | Hashé / chiffré dans la base PostgreSQL (champ `cinNumber`) |
| **Date d'émission CIN** | Date (JJ/MM/AAAA) | Validation de la validité de la pièce d'identité | Colonne date (`cinIssuedAt`) |
| **Cliché CIN Recto** | Image (JPEG/PNG/WebP, max 5 Mo) | Vérification de la photo, du nom, du prénom et du numéro officiel | Coffre Cloudflare R2 privé chiffré (`kyc-vault.ts`) |
| **Cliché CIN Verso** | Image (JPEG/PNG/WebP, max 5 Mo) | Contrôle des éléments de sécurité et concordance des informations | Coffre Cloudflare R2 privé chiffré (`kyc-vault.ts`) |
| **Empreinte SHA-256** | Hash cryptographique | Garantie de l'intégrité du fichier et non-altération depuis l'upload | Table `KycVerification` (`frontChecksum`, `backChecksum`) |
| **Métadonnées techniques** | IP, User-Agent, horodatage | Détection de fraudes et traçabilité de la transmission | Table `KycVerification` et table `AuditLog` |

---

## 4. Mesures de Sécurité Organisationnelles & Techniques (Articles 23 & 43)

La plateforme Sanaya déploie une politique de défense en profondeur conforme aux standards de l'INPDP et aux règles d'architecture du projet :

### 4.1 Chiffrement au Repos (*At Rest*) & Isolation Physique
* **Coffre-fort R2 Privé :** Les images des CIN ne sont jamais stockées sur des serveurs applicatifs, conteneurs Docker éphémères ou hébergements web publics. Elles sont hébergées au sein d'un bucket privé dédié Cloudflare R2 (`kyc-vault.ts`), dont l'accès public est totalement désactivé (pas de nom de domaine public, blocage total des requêtes anonymes).
* **Chiffrement matériel :** Les objets stockés dans le bucket R2 sont chiffrés au repos au moyen de l'algorithme AES-256 (Server-Side Encryption SSE-S3).
* **Absence de stockage relationnel en clair :** Aucune donnée binaire d'image n'est injectée dans la base PostgreSQL ; seules les clés d'objet privées (`kyc/cin/{providerId}/{hash}.jpg`) sont conservées.

### 4.2 Chiffrement en Transit (*In Transit*)
* L'ensemble des communications réseau entre l'application mobile de l'artisan, l'API Sanaya et l'infrastructure R2 s'effectue sous protocole sécurisé **TLS 1.3** avec suite de chiffrement moderne interdisant le downgrade.
* Le transfert des clichés se fait directement via des requêtes HTTP signées générées par le backend (`presigned URL` éphémère à usage unique, durée de vie maximale : 15 minutes).

### 4.3 Contrôle d'Accès & Principe du Moindre Privilège
* **Ségrégation stricte des rôles (RBAC) :** Seuls les agents de modération détenant les rôles authentifiés `ADMIN` ou `MODERATOR` disposent des autorisations nécessaires pour instruire les vérifications d'identité.
* **URLs de visualisation ultra-éphémères (5 minutes) :** Pour visualiser un document dans l'interface de revue (`FW-20b`), l'application admin sollicite l'endpoint sécurisé `GET /v1/admin/verifications/{id}/documents`. Celui-ci génère une URL pré-signée dont la validité est bridée à **300 secondes (5 minutes)**. Passé ce délai, le lien expire irrévocablement.

### 4.4 Règle d'Intégrité de Modération Humaine (`FW-20b`)
L'interface de modération intègre un garde-fou technique matériel : le bouton d'approbation d'un dossier KYC demeure désactivé et infranchissable tant que l'instructeur n'a pas basculé et inspecté visuellement l'intégralité des deux faces de la pièce (Face Recto consultée ET Face Verso consultée).

### 4.5 Journalisation Inaltérable des Accès (`AuditLog`)
Toute opération réalisée sur les pièces d'identité donne lieu à une entrée immédiate dans le journal d'audit (`AuditLog`), conservée de manière infalsifiable :
* Identifiant de l'agent modérateur (`actorId`).
* Date et heure précises de la consultation (horodatage UTC synchronisé NTP).
* Type d'action : `KYC_DOCUMENT_VIEWED` (recto/verso), `KYC_APPROVED`, `KYC_REJECTED`.
* Adresse IP de l'agent et empreinte de l'environnement client (`User-Agent`).
* Motif obligatoire et détaillé en cas de rejet (ex. *document illisible*, *document incomplet*, *CIN expirée*, *incohérence nom/prénom*).

---

## 5. Politique de Rétention et Purge Automatisée (`BE-30c`)

En application du principe de proportionnalité et de limitation de la conservation :

1. **Phase d'Instruction :** Les clichés sont conservés tant que le dossier est dans l'état `PENDING`.
2. **Phase Post-Décision (Règle J+30) :**
   * Dès qu'une décision d'approbation ou de rejet est entérinée par l'équipe de modération, le champ `retentionExpiresAt` est fixé à la date `Décision + 30 jours calendaires`.
   * Cette période de 30 jours constitue le délai légal strictement nécessaire pour gérer les éventuelles contestations ou réclamations de l'artisan.
3. **Purge Automatique Définitive (`BE-30c`) :**
   * Un worker planifié s'exécute de manière quotidienne pour purger tous les dossiers dont `retentionExpiresAt` est dépassé.
   * L'exécution du worker procède à :
     1. L'appel de suppression physique définitive de l'objet sur Cloudflare R2 (`DeleteObjectCommand`).
     2. L'écrasement des clés d'objet dans la base de données (`frontMediaKey = null`, `backMediaKey = null`).
     3. L'inscription dans le journal d'audit de la mention `KYC_DOCUMENTS_PURGED`.
4. **Effacement Immédiat sur Demande :**
   * Tout artisan peut à tout moment solliciter la suppression immédiate de ses pièces de vérification via l'application ou par courriel au DPO. Dans ce cas, la suppression physique sur R2 est exécutée sous 24 heures ouvrées.

---

## 6. Exercice des Droits des Personnes Concernées (Articles 32 à 37)

Sanaya garantit aux artisans l'exercice effectif de leurs droits reconnus par la loi n° 2004-63 :

* **Droit d'Accès :** L'artisan visualise en temps réel depuis son application mobile le statut de son dossier (`En attente de vérification`, `Vérifié`, `Rejeté`), la date de sa demande et l'historique de son badge de confiance.
* **Droit de Rectification :** En cas de document flou, illisible ou d'erreur matérielle ayant conduit à un rejet motivé, l'artisan reçoit une notification avec le motif précis et un bouton d'action lui permettant de soumettre de nouveaux clichés conformes.
* **Droit d'Effacement / Retrait du Consentement :** L'artisan peut révoquer son consentement à tout moment. Cette révocation entraîne la perte immédiate du badge « Vérifié » et la purge irréversible des clichés d'identité de l'infrastructure de stockage.
* **Canal d'Exercice :** Toute demande peut être adressée :
  * Via l'application mobile : Rubrique `Profil` > `Informations & Légal` > `Protection des Données`.
  * Par voie électronique : `dpo@sanaya.tn`.
  * Délai maximal de réponse garanti : 15 jours ouvrés à compter de la réception de la demande.

---

## 7. Gestion des Incidents de Sécurité & Notification

Conformément aux directives de l'INPDP :
* Tout incident de sécurité avéré susceptible de porter atteinte à la confidentialité ou à l'intégrité des données de vérification d'identité fera l'objet d'un rapport immédiat.
* Notification officielle auprès de l'INPDP dans un délai maximal de **48 heures** après qualification de l'incident.
* Information directe des artisans concernés si l'incident présente un risque pour leurs droits ou leur identité civile.

---

## 8. Déclaration sur l'Honneur & Engagement

La direction de Sanaya Technologies atteste sur l'honneur que l'ensemble des mesures techniques, organisationnelles et juridiques décrites dans le présent dossier sont effectivement implémentées et maintenues en conditions opérationnelles dans la base de code et l'infrastructure de la plateforme.

Fait à Tunis, le 24 Novembre 2026.  
**Pour Sanaya Technologies — Direction Générale & DPO**
