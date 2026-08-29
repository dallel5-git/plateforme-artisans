# Règles ProGuard/R8 du build release (FM-14b). Le moteur Flutter et le
# canal de plateforme gèrent déjà leurs propres règles de conservation via
# `flutter.jar` (fusionnées automatiquement par le plugin Gradle Flutter) —
# ce fichier ne couvre que ce qui est spécifique à ce dépôt.
#
# Rien à ajouter pour l'instant : aucune dépendance de ce projet n'utilise de
# réflexion, sérialisation par nom de champ, ou JNI nécessitant une règle
# `-keep` dédiée (built_value génère du code statique, pas de réflexion).
# Si un crash release (et lui seul, jamais en debug) pointe vers une classe
# manquante après minification, c'est ici que la règle `-keep` correspondante
# doit être ajoutée — jamais en désactivant `isMinifyEnabled`.
