export const REVIEW_MIN_CONTACT_AGE_HOURS = 12;
export const REVIEW_MAX_CONTACT_AGE_DAYS = 60;

export interface ReviewEligibilityWindow {
  earliestEligible: Date;
  latestEligible: Date;
}

// US-C-06 : « datant de plus de 12h et de moins de 60j » — les deux bornes sont strictes.
export function buildReviewEligibilityWindow(now: Date = new Date()): ReviewEligibilityWindow {
  return {
    earliestEligible: new Date(now.getTime() - REVIEW_MAX_CONTACT_AGE_DAYS * 24 * 60 * 60 * 1000),
    latestEligible: new Date(now.getTime() - REVIEW_MIN_CONTACT_AGE_HOURS * 60 * 60 * 1000),
  };
}

export function isContactEventEligibleForReview(
  contactCreatedAt: Date,
  now: Date = new Date(),
): boolean {
  const { earliestEligible, latestEligible } = buildReviewEligibilityWindow(now);
  return (
    contactCreatedAt.getTime() > earliestEligible.getTime() &&
    contactCreatedAt.getTime() < latestEligible.getTime()
  );
}
