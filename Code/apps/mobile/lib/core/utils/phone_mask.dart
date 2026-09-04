/// Masque un numéro de téléphone tunisien pour l'affichage (FM-32) :
/// garde l'indicatif `+216` et les 2 derniers chiffres, remplace le reste
/// par `•`. Un numéro trop court pour être masqué de façon utile (≤ 2
/// chiffres) est renvoyé tel quel.
String maskPhone(String phone) {
  const prefix = '+216';
  final hasPrefix = phone.startsWith(prefix);
  final digits = hasPrefix ? phone.substring(prefix.length) : phone;

  if (digits.length <= 2) return phone;

  final visibleEnd = digits.substring(digits.length - 2);
  final masked = '•' * (digits.length - 2);
  final body = '$masked $visibleEnd';

  return hasPrefix ? '$prefix $body' : body;
}
