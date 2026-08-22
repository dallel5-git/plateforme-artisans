export interface BuildWhatsAppMessageInput {
  locale: 'fr' | 'ar';
  providerName: string;
  categoryName: string;
}

export function buildWhatsAppMessage(input: BuildWhatsAppMessageInput): string {
  if (input.locale === 'ar') {
    return `مرحبًا ${input.providerName}، أتواصل معكم عبر تطبيق Sanaya بخصوص خدمة ${input.categoryName}.`;
  }
  return `Bonjour ${input.providerName}, je vous contacte via Sanaya au sujet de : ${input.categoryName}.`;
}
