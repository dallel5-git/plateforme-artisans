import type { PriceUnit } from '@repo/db';

// BE-17 : ServiceOffering.priceMin/priceMax est un Decimal(10,3) TND (pas un entier en millimes
// — écart hérité de BE-02/05, hors périmètre ici). `displayPrice` est une chaîne FR calculée
// serveur, pas un contenu stocké : P7 (bilingue dès le jour 1) régit `titleFr`/`titleAr` etc.,
// pas une chaîne de confort calculée à la volée. Les champs bruts (priceMin/priceMax/priceUnit/
// isNegotiable) restent dans la réponse à côté de `displayPrice` pour un futur formatter AR sans
// migration de schéma.
const UNIT_SUFFIX_FR: Record<PriceUnit, string> = {
  FIXED: '',
  HOUR: '/heure',
  DAY: '/jour',
  SQUARE_METER: '/m²',
  LINEAR_METER: '/ml',
  ON_QUOTE: '',
};

export interface OfferingPriceInput {
  priceMin: number | null;
  priceMax: number | null;
  priceUnit: PriceUnit;
}

function formatTnd(value: number): string {
  return Number(value.toFixed(3)).toString().replace('.', ',');
}

export function formatDisplayPrice(input: OfferingPriceInput): string {
  const { priceMin, priceMax, priceUnit } = input;
  if (priceUnit === 'ON_QUOTE' || (priceMin === null && priceMax === null)) {
    return 'Sur devis';
  }

  const min = priceMin ?? priceMax!;
  const max = priceMax ?? priceMin!;
  const amount = min === max ? formatTnd(min) : `${formatTnd(min)} - ${formatTnd(max)}`;
  return `${amount} DT${UNIT_SUFFIX_FR[priceUnit]}`;
}
