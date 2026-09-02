// ⚠️ FICHIER GÉNÉRÉ — NE PAS ÉDITER À LA MAIN.
// Source : packages/design-tokens/tokens.json
// Régénérer : pnpm tokens:build

export const palette = {
  "brand": {
    "50": "#EEF3FD",
    "100": "#DFECFF",
    "200": "#C2D6F8",
    "300": "#95B4F0",
    "400": "#6690E8",
    "500": "#3B6FE0",
    "600": "#2A57C4",
    "700": "#1F449C",
    "800": "#1559B5",
    "900": "#132F6B"
  },
  "neutral": {
    "0": "#FFFFFF",
    "25": "#FCFCFA",
    "50": "#F3F2ED",
    "100": "#ECEEF0",
    "200": "#E9ECF0",
    "300": "#D3D7DE",
    "400": "#A8B0BD",
    "500": "#78818F",
    "600": "#525C6B",
    "700": "#343D4B",
    "800": "#1F2733",
    "900": "#141A24",
    "950": "#11161F",
    "1000": "#0A0D12"
  },
  "success": {
    "50": "#E8F6EE",
    "100": "#C6E9D6",
    "500": "#1E7F4C",
    "600": "#17603A",
    "700": "#0F4527"
  },
  "warning": {
    "50": "#FEF5E6",
    "100": "#FBE6BF",
    "500": "#A9640A",
    "600": "#8A5605",
    "700": "#6B4204"
  },
  "danger": {
    "50": "#FDECEC",
    "100": "#F8CFCF",
    "500": "#D93B3B",
    "600": "#B32C2C",
    "700": "#8C2020"
  },
  "info": {
    "50": "#E9F2FE",
    "500": "#2C7BE5"
  }
} as const;

export const semantic = {
  "light": {
    "background": "#FCFCFA",
    "surface": "#FFFFFF",
    "surface-raised": "#FFFFFF",
    "surface-sunken": "#F3F2ED",
    "border": "#E9ECF0",
    "border-strong": "#D3D7DE",
    "text-primary": "#141A24",
    "text-secondary": "#525C6B",
    "text-muted": "#78818F",
    "text-inverse": "#FFFFFF",
    "accent": "#3B6FE0",
    "accent-hover": "#2A57C4",
    "accent-subtle": "#EEF3FD",
    "on-accent": "#FFFFFF",
    "verified": "#1E7F4C",
    "verified-subtle": "#E8F6EE",
    "pending": "#A9640A",
    "pending-subtle": "#FEF5E6",
    "destructive": "#D93B3B",
    "destructive-subtle": "#FDECEC",
    "rating": "#C77800",
    "sponsored": "#A9640A",
    "whatsapp": "#128C7E",
    "on-whatsapp": "#FFFFFF",
    "amber": "#C77800",
    "on-amber": "#FFFFFF",
    "scrim": "#2B2F36",
    "on-scrim": "#FFFFFF",
    "thumbnail": "#F3F2ED",
    "thumbnail-border": "#E9ECF0",
    "chart-bar": "#95B4F0",
    "chart-bar-highlight": "#3B6FE0",
    "nav-active": "#3B6FE0",
    "nav-inactive": "#78818F",
    "nav-background": "#FFFFFF"
  },
  "dark": {
    "background": "#0A0D12",
    "surface": "#141A24",
    "surface-raised": "#1F2733",
    "surface-sunken": "#11161F",
    "border": "#1F2733",
    "border-strong": "#343D4B",
    "text-primary": "#FCFCFA",
    "text-secondary": "#A8B0BD",
    "text-muted": "#78818F",
    "text-inverse": "#141A24",
    "accent": "#6690E8",
    "accent-hover": "#95B4F0",
    "accent-subtle": "#1A2440",
    "on-accent": "#0A0D12",
    "verified": "#3FBF7F",
    "verified-subtle": "#0F2A1C",
    "pending": "#E8A72B",
    "pending-subtle": "#2E2210",
    "destructive": "#F26D6D",
    "destructive-subtle": "#2E1414",
    "rating": "#F5A623",
    "sponsored": "#E8A72B",
    "whatsapp": "#25D366",
    "on-whatsapp": "#FFFFFF",
    "amber": "#F5A623",
    "on-amber": "#141A24",
    "scrim": "#05070A",
    "on-scrim": "#FFFFFF",
    "thumbnail": "#232C39",
    "thumbnail-border": "#343D4B",
    "chart-bar": "#2A57C4",
    "chart-bar-highlight": "#6690E8",
    "nav-active": "#6690E8",
    "nav-inactive": "#A8B0BD",
    "nav-background": "#141A24"
  }
} as const;

export type ColorScheme = keyof typeof semantic;
export type SemanticColor = keyof typeof semantic.light;
