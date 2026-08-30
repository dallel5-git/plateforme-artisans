import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Signature du build release (FM-14b, Code/docs/05-runbook.md §1.6). Variables
// d'environnement toujours prioritaires sur `android/key.properties` (fichier
// local gitignoré, jamais commité — voir key.properties.example) : une CI
// correctement configurée ne doit jamais être court-circuitée par un fichier
// local périmé oublié dans le répertoire de travail.
val keystoreProperties = Properties()
val keystorePropertiesFile = file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

fun resolveSigningValue(envVar: String, propertyKey: String): String? {
    val fromEnv = System.getenv(envVar)
    if (!fromEnv.isNullOrBlank()) return fromEnv
    return keystoreProperties.getProperty(propertyKey)?.takeIf { it.isNotBlank() }
}

val releaseStoreFile = resolveSigningValue("SANAYA_ANDROID_KEYSTORE_FILE", "storeFile")
val releaseStorePassword = resolveSigningValue("SANAYA_ANDROID_KEYSTORE_PASSWORD", "storePassword")
val releaseKeyAlias = resolveSigningValue("SANAYA_ANDROID_KEY_ALIAS", "keyAlias")
val releaseKeyPassword = resolveSigningValue("SANAYA_ANDROID_KEY_PASSWORD", "keyPassword")

val hasCompleteReleaseSigningConfig =
    releaseStoreFile != null &&
        releaseStorePassword != null &&
        releaseKeyAlias != null &&
        releaseKeyPassword != null

android {
    namespace = "tn.sanaya.sanaya"
    // Fixé à 37 (pas `flutter.compileSdkVersion`, qui reste sur 36) : requis
    // par `flutter_secure_storage` 11.0.0 depuis AGP 9.3.2 (bump FM-14b —
    // AGP 9.0.1 plafonnait à 36, cf. commit history de ce fichier).
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "tn.sanaya.sanaya"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasCompleteReleaseSigningConfig) {
            create("release") {
                storeFile = file(releaseStoreFile!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
            // Jamais de repli sur la clé de debug (runbook §1.6) : en
            // l'absence de configuration complète, `null` laisse l'APK non
            // signé plutôt que signé silencieusement avec une clé qui ne
            // pourra jamais publier de mise à jour sur les appareils des
            // beta-testeurs. `checkReleaseSigningConfig` ci-dessous
            // transforme cette absence en échec explicite du build.
            signingConfig = if (hasCompleteReleaseSigningConfig) {
                signingConfigs.getByName("release")
            } else {
                null
            }
        }
    }
}

// `signingConfig = null` ne fait pas échouer `assembleRelease`/`bundleRelease`
// eux-mêmes (l'APK/AAB résultant est simplement non signé, donc non
// installable) — sans ce garde-fou explicite, l'échec se manifesterait
// tardivement et de façon peu claire (ex. en CI, à l'étape d'upload). Ne
// s'applique qu'aux tâches de build release : `assembleDebug`/`flutter test`
// continuent de fonctionner sans keystore sur n'importe quel poste de dev.
tasks.matching { it.name == "assembleRelease" || it.name == "bundleRelease" }
    .configureEach {
        doFirst {
            if (!hasCompleteReleaseSigningConfig) {
                val missing = listOfNotNull(
                    "SANAYA_ANDROID_KEYSTORE_FILE (ou storeFile)".takeIf { releaseStoreFile == null },
                    "SANAYA_ANDROID_KEYSTORE_PASSWORD (ou storePassword)".takeIf {
                        releaseStorePassword == null
                    },
                    "SANAYA_ANDROID_KEY_ALIAS (ou keyAlias)".takeIf { releaseKeyAlias == null },
                    "SANAYA_ANDROID_KEY_PASSWORD (ou keyPassword)".takeIf {
                        releaseKeyPassword == null
                    },
                )
                throw GradleException(
                    "Configuration de signature release incomplète — valeurs manquantes : " +
                        "${missing.joinToString(", ")}. Voir Code/docs/05-runbook.md §1.6.",
                )
            }
        }
    }

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
