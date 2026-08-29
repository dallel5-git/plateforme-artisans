# Runbook — Sanaya

> Procédures opérationnelles sensibles : perte, rotation, restauration. Chaque section décrit
> une manipulation qui ne s'improvise pas le jour où elle devient nécessaire.

---

## 1. Keystore de release Android (FM-14)

### 1.1 Pourquoi c'est critique

Android exige que **chaque mise à jour d'une application soit signée avec la même clé** que la
version installée sur l'appareil de l'utilisateur. **Perdre le keystore de release — le fichier
ou ses mots de passe — rend l'application définitivement non mise à jour** : la seule issue est
de publier une nouvelle fiche store avec un nouveau `applicationId`, ce qui signifie repartir de
zéro sur les installations existantes. Ce n'est pas un secret comme les autres : un token API se
révoque et se régénère, un keystore de release perdu ne se régénère pas à l'identique.

Conséquence directe : ce keystore est généré **une seule fois**, sauvegardé **avant** tout usage
en CI, et sa perte est traitée comme un incident majeur, pas un oubli à corriger au prochain
sprint.

### 1.2 Génération

À exécuter **hors du dépôt** (ex. un répertoire de travail temporaire, jamais `Code/apps/mobile`
ni un sous-répertoire suivi par git), avec un JDK disposant de `keytool` (celui livré avec le SDK
Android ou Flutter convient).

```bash
keytool -genkeypair -v \
  -storetype PKCS12 \
  -keystore sanaya-release.jks \
  -alias sanaya-release \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -dname "CN=Sanaya, OU=Mobile, O=Sanaya, L=Sousse, ST=Sousse, C=TN"
```

Notes sur les choix :
- **PKCS12**, pas le format `JKS` historique (déprécié par le JDK depuis la version 9). En
  PKCS12, le mot de passe de la clé (`-keypass`) est nécessairement identique à celui du magasin
  (`-storepass`) — c'est une contrainte du format, pas un choix de facilité.
- **RSA 2048 / validité 10000 jours** (~27 ans, au-delà de l'échéance 2033 minimale exigée par
  Google Play) : si cette même clé sert un jour de clé d'upload Play Store (S3, hors périmètre
  FM-14), elle reste valide sans devoir être régénérée.
- **`keytool` ne doit jamais recevoir `-storepass`/`-keypass` en argument de ligne de commande**
  sur cette machine : la commande atterrit en clair dans l'historique du shell (bash/PowerShell).
  Laisser `keytool` les demander de façon interactive.

### 1.3 Vérification immédiate après génération

```bash
# Contenu et validité
keytool -list -v -keystore sanaya-release.jks -alias sanaya-release

# Empreinte SHA-256 du FICHIER lui-même — sert à prouver qu'une copie
# (coffre, remise) est bit-à-bit identique à l'original. NE PAS confondre
# avec l'empreinte du certificat (§1.5), qui est une donnée différente.
sha256sum sanaya-release.jks
```

### 1.4 Sauvegarde — hors du dépôt, dans un coffre

- Le fichier `.jks` et ses deux mots de passe (store = key, en PKCS12) sont déposés dans le
  coffre de mots de passe de l'équipe (gestionnaire partagé type Bitwarden/1Password — pas un
  fichier texte sur un poste, pas un message Slack qui reste en clair dans l'historique).
- **Aucune de ces trois valeurs n'entre jamais dans le dépôt git**, ni en clair, ni dans une
  branche temporaire, ni dans un exemple avec des « valeurs à remplacer » qui ressemblent à de
  vraies valeurs.
- Avant de considérer la sauvegarde faite, vérifier que le SHA-256 du fichier déposé dans le
  coffre correspond à celui relevé en §1.3 — un dépôt corrompu ou tronqué découvert plus tard,
  après suppression de toutes les autres copies, n'est pas récupérable.
- **Rotation** : ce keystore ne se fait tourner **jamais** en usage normal — le faire romprait la
  chaîne de signature de toute mise à jour future. La seule circonstance de rotation est une
  compromission avérée (fuite du fichier ou des mots de passe), qui impose de traiter la
  situation comme un incident de sécurité (§7.1 de `POLITIQUE-PROJET.md`) avant toute décision
  technique.

### 1.5 Empreinte du certificat — non secrète, à consigner

L'empreinte SHA-256 **du certificat** (différente du SHA-256 du fichier, §1.3) permet de prouver
qu'un APK donné a bien été signé par la clé de production, sans jamais exposer le keystore
lui-même — c'est une donnée publique, comparable à une clé publique.

```bash
keytool -list -v -keystore sanaya-release.jks -alias sanaya-release \
  | grep -A1 "SHA256:"
```

Cette empreinte est stockée dans une **variable** de dépôt GitHub (pas un secret — voir §1.7),
`MOBILE_APK_CERT_SHA256`, et sert de contrôle automatique dans
`Code/tooling/scripts/apk-secret-scan.sh` (FM-14c) : un APK signé avec la mauvaise clé (par
exemple un repli silencieux sur la clé de debug) échoue ce contrôle avant même d'atteindre un
beta-testeur.

> Empreinte relevée le <à compléter à la génération> : `<à compléter>`

### 1.6 Signature du build Gradle — variables attendues

`Code/apps/mobile/android/app/build.gradle.kts` (FM-14b) résout la configuration de signature du
build release à partir de **variables d'environnement**, avec repli sur un fichier local
`android/key.properties` (gitignoré, jamais commité — voir `android/key.properties.example`
pour le format attendu) si les variables d'environnement ne sont pas définies. Les variables
d'environnement sont toujours prioritaires : un `key.properties` local périmé ne peut jamais
primer sur une CI correctement configurée.

| Variable d'environnement | Clé `key.properties` équivalente | Contenu |
|---|---|---|
| `SANAYA_ANDROID_KEYSTORE_FILE` | `storeFile` | Chemin **absolu** vers le fichier `.jks` |
| `SANAYA_ANDROID_KEYSTORE_PASSWORD` | `storePassword` | Mot de passe du magasin |
| `SANAYA_ANDROID_KEY_ALIAS` | `keyAlias` | `sanaya-release` |
| `SANAYA_ANDROID_KEY_PASSWORD` | `keyPassword` | Identique au mot de passe du magasin (PKCS12) |

Si aucune des deux sources n'est complète et qu'une tâche de build release est demandée
(`assembleRelease`/`bundleRelease`), le build **échoue explicitement** en listant les variables
manquantes — jamais de repli silencieux sur la clé de debug (voir `build.gradle.kts` pour le
détail ; c'est précisément le mode de défaillance que ce runbook existe pour éviter).

### 1.7 Secrets GitHub Actions à créer (action manuelle, droits admin du dépôt requis)

Le workflow `.github/workflows/mobile-release.yml` (FM-14d) attend ces secrets, à créer dans
**Settings → Secrets and variables → Actions** du dépôt GitHub. Ils ne peuvent pas être créés
depuis une session Claude (pas d'accès aux paramètres du dépôt) :

| Nom | Type | Valeur |
|---|---|---|
| `ANDROID_KEYSTORE_BASE64` | Secret | Le fichier `.jks` encodé en base64, **sans retour à la ligne** |
| `ANDROID_KEYSTORE_PASSWORD` | Secret | Mot de passe du magasin (§1.4) |
| `ANDROID_KEY_ALIAS` | Secret | `sanaya-release` |
| `ANDROID_KEY_PASSWORD` | Secret | Identique au mot de passe du magasin |
| `MOBILE_APK_CERT_SHA256` | **Variable** (pas un secret — une empreinte n'est pas sensible) | Empreinte relevée en §1.5 |

Encodage base64 du fichier `.jks` :

```bash
# Linux / macOS / Git Bash
base64 -w0 sanaya-release.jks
```

```powershell
# PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("sanaya-release.jks"))
```

### 1.8 En cas de perte

1. Vérifier en premier que le coffre de l'équipe n'a pas simplement une entrée mal nommée ou mal
   classée — une perte réelle est rare, une perte apparente ne l'est pas.
2. Si la perte est confirmée : aucune mise à jour de l'application existante n'est plus possible.
   La seule voie est une nouvelle fiche store avec un nouvel `applicationId`, à traiter comme un
   arbitrage de périmètre avec Oussama (§10 de `POLITIQUE-PROJET.md`), pas comme un correctif
   technique.
3. Documenter l'incident (cause, période d'exposition si compromission) avant toute action de
   remédiation, conformément à `POLITIQUE-PROJET.md` §7.1.
