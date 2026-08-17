// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build

export const typography = {
  "family": {
    "latin": "Manrope",
    "arabic": "Noto Kufi Arabic",
    "mono": "JetBrains Mono"
  },
  "weight": {
    "regular": 400,
    "medium": 500,
    "semibold": 600,
    "bold": 700,
    "extrabold": 800
  },
  "scale": {
    "display": {
      "size": "36px",
      "lineHeight": "42px",
      "weight": 800,
      "tracking": "-0.02em"
    },
    "h1": {
      "size": "28px",
      "lineHeight": "34px",
      "weight": 800,
      "tracking": "-0.02em"
    },
    "h2": {
      "size": "22px",
      "lineHeight": "28px",
      "weight": 700,
      "tracking": "-0.01em"
    },
    "h3": {
      "size": "18px",
      "lineHeight": "24px",
      "weight": 700,
      "tracking": "0"
    },
    "body": {
      "size": "15px",
      "lineHeight": "22px",
      "weight": 400,
      "tracking": "0"
    },
    "bodyStrong": {
      "size": "15px",
      "lineHeight": "22px",
      "weight": 600,
      "tracking": "0"
    },
    "small": {
      "size": "13px",
      "lineHeight": "18px",
      "weight": 400,
      "tracking": "0"
    },
    "caption": {
      "size": "11px",
      "lineHeight": "14px",
      "weight": 600,
      "tracking": "0.04em"
    }
  }
} as const;
export const motion = {
  "duration": {
    "fast": "120ms",
    "base": "200ms",
    "slow": "320ms"
  },
  "easing": {
    "standard": "cubic-bezier(0.2, 0, 0, 1)",
    "decelerate": "cubic-bezier(0, 0, 0, 1)"
  }
} as const;
