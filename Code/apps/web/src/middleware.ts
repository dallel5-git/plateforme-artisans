import { NextResponse, type NextRequest } from 'next/server';

const SUPPORTED_LOCALES = ['fr', 'ar'];
const DEFAULT_LOCALE = 'fr';

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Ignorer les fichiers statiques, assets, robots et sitemap
  if (
    pathname.startsWith('/_next') ||
    pathname.startsWith('/api') ||
    pathname.startsWith('/static') ||
    pathname.includes('.') ||
    pathname === '/robots.txt' ||
    pathname === '/sitemap.xml'
  ) {
    return NextResponse.next();
  }

  // Vérifier si le chemin a déjà un préfixe de locale valide
  const pathnameHasLocale = SUPPORTED_LOCALES.some(
    (locale) => pathname.startsWith(`/${locale}/`) || pathname === `/${locale}`,
  );

  if (pathnameHasLocale) {
    return NextResponse.next();
  }

  // Redirection vers la locale par défaut
  const locale = DEFAULT_LOCALE;
  const redirectUrl = new URL(`/${locale}${pathname === '/' ? '' : pathname}`, request.url);
  return NextResponse.redirect(redirectUrl);
}

export const config = {
  matcher: ['/((?!_next|api|favicon.ico).*)'],
};
