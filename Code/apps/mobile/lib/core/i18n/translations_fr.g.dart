///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsFr = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$common$fr common = Translations$common$fr.internal(_root);
	late final Translations$contact$fr contact = Translations$contact$fr.internal(_root);
	late final Translations$favorites$fr favorites = Translations$favorites$fr.internal(_root);
	late final Translations$legal$fr legal = Translations$legal$fr.internal(_root);
	late final Translations$search$fr search = Translations$search$fr.internal(_root);
	late final Translations$settings$fr settings = Translations$settings$fr.internal(_root);
}

// Path: common
class Translations$common$fr {
	Translations$common$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sanaya'
	String get appName => 'Sanaya';

	late final Translations$common$home$fr home = Translations$common$home$fr.internal(_root);
}

// Path: contact
class Translations$contact$fr {
	Translations$contact$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Appeler'
	String get call => 'Appeler';

	/// fr: 'WhatsApp'
	String get whatsapp => 'WhatsApp';
}

// Path: favorites
class Translations$favorites$fr {
	Translations$favorites$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mes favoris'
	String get title => 'Mes favoris';

	/// fr: 'Aucun favori pour le moment'
	String get emptyTitle => 'Aucun favori pour le moment';

	/// fr: 'Enregistrez des artisans pour les retrouver rapidement.'
	String get emptySubtitle => 'Enregistrez des artisans pour les retrouver rapidement.';

	/// fr: 'Trouver un artisan'
	String get exploreCta => 'Trouver un artisan';

	/// fr: 'Retirer des favoris'
	String get removeTooltip => 'Retirer des favoris';

	/// fr: 'Ajouter aux favoris'
	String get addTooltip => 'Ajouter aux favoris';

	/// fr: 'Artisan retiré des favoris'
	String get removeSuccess => 'Artisan retiré des favoris';

	/// fr: 'Artisan ajouté aux favoris'
	String get addSuccess => 'Artisan ajouté aux favoris';

	/// fr: 'Impossible de retirer le favori.'
	String get removeError => 'Impossible de retirer le favori.';

	/// fr: 'Impossible d'ajouter le favori.'
	String get addError => 'Impossible d\'ajouter le favori.';

	/// fr: 'Impossible de charger vos favoris.'
	String get loadError => 'Impossible de charger vos favoris.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Vérifié'
	String get verifiedBadge => 'Vérifié';
}

// Path: legal
class Translations$legal$fr {
	Translations$legal$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mentions légales'
	String get title => 'Mentions légales';

	/// fr: 'Éditeur de la plateforme'
	String get editorTitle => 'Éditeur de la plateforme';

	/// fr: 'Sanaya — Plateforme de mise en relation entre particuliers et artisans tunisiens (Sahel : Sousse, Monastir, Mahdia).'
	String get editorContent => 'Sanaya — Plateforme de mise en relation entre particuliers et artisans tunisiens (Sahel : Sousse, Monastir, Mahdia).';

	/// fr: 'Modèle de service'
	String get modelTitle => 'Modèle de service';

	/// fr: 'Sanaya est un service de génération de contacts qualifiés. La plateforme n'encaisse jamais le montant des prestations et n'intervient pas dans le paiement direct du chantier.'
	String get modelContent => 'Sanaya est un service de génération de contacts qualifiés. La plateforme n\'encaisse jamais le montant des prestations et n\'intervient pas dans le paiement direct du chantier.';

	/// fr: 'Protection des données personnelles (INPDP)'
	String get inpdpTitle => 'Protection des données personnelles (INPDP)';

	/// fr: 'Conformément à la loi organique n° 2004-63, Sanaya s'engage à protéger la vie privée de ses utilisateurs. Les numéros de téléphone ne sont révélés que lors d'une mise en relation volontaire et tracée.'
	String get inpdpContent => 'Conformément à la loi organique n° 2004-63, Sanaya s\'engage à protéger la vie privée de ses utilisateurs. Les numéros de téléphone ne sont révélés que lors d\'une mise en relation volontaire et tracée.';

	/// fr: 'Vos droits'
	String get rightsTitle => 'Vos droits';

	/// fr: 'Vous disposez d'un droit d'accès, de rectification et de suppression de vos données personnelles à tout moment.'
	String get rightsContent => 'Vous disposez d\'un droit d\'accès, de rectification et de suppression de vos données personnelles à tout moment.';
}

// Path: search
class Translations$search$fr {
	Translations$search$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Rechercher un service…'
	String get searchPlaceholder => 'Rechercher un service…';

	/// fr: 'Choisir un gouvernorat'
	String get locationPlaceholder => 'Choisir un gouvernorat';

	/// fr: 'Catégories'
	String get categoriesTitle => 'Catégories';

	/// fr: 'Aucune catégorie disponible pour le moment.'
	String get categoriesEmpty => 'Aucune catégorie disponible pour le moment.';

	/// fr: 'Impossible de charger les catégories.'
	String get categoriesError => 'Impossible de charger les catégories.';

	/// fr: 'Impossible de charger les gouvernorats.'
	String get locationError => 'Impossible de charger les gouvernorats.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';
}

// Path: settings
class Translations$settings$fr {
	Translations$settings$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réglages'
	String get title => 'Réglages';

	/// fr: 'Langue'
	String get languageSection => 'Langue';

	/// fr: 'Français'
	String get french => 'Français';

	/// fr: 'العربية (تونس)'
	String get arabic => 'العربية (تونس)';

	/// fr: 'Apparence'
	String get themeSection => 'Apparence';

	/// fr: 'Système'
	String get themeSystem => 'Système';

	/// fr: 'Clair'
	String get themeLight => 'Clair';

	/// fr: 'Sombre'
	String get themeDark => 'Sombre';

	/// fr: 'Informations & Légal'
	String get legalSection => 'Informations & Légal';

	/// fr: 'Mentions légales'
	String get legalNotices => 'Mentions légales';

	/// fr: 'Protection des données (INPDP)'
	String get privacyPolicy => 'Protection des données (INPDP)';

	/// fr: 'Compte'
	String get accountSection => 'Compte';

	/// fr: 'Se déconnecter'
	String get logout => 'Se déconnecter';

	/// fr: 'Déconnexion'
	String get logoutConfirmTitle => 'Déconnexion';

	/// fr: 'Êtes-vous sûr de vouloir vous déconnecter ?'
	String get logoutConfirmMessage => 'Êtes-vous sûr de vouloir vous déconnecter ?';

	/// fr: 'Annuler'
	String get cancel => 'Annuler';

	/// fr: 'Confirmer'
	String get confirm => 'Confirmer';

	/// fr: 'Version'
	String get version => 'Version';
}

// Path: common.home
class Translations$common$home$fr {
	Translations$common$home$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Espace authentification — à venir (FM-05)'
	String get navAuth => 'Espace authentification — à venir (FM-05)';

	/// fr: 'Espace client'
	String get navClient => 'Espace client';

	/// fr: 'Espace pro — à venir (FM-08)'
	String get navPro => 'Espace pro — à venir (FM-08)';

	/// fr: 'Basculer thème clair/sombre'
	String get toggleTheme => 'Basculer thème clair/sombre';

	/// fr: 'Basculer FR/AR'
	String get toggleLocale => 'Basculer FR/AR';

	/// fr: 'Vitrine design system'
	String get designSystemPreview => 'Vitrine design system';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'Sanaya',
			'common.home.navAuth' => 'Espace authentification — à venir (FM-05)',
			'common.home.navClient' => 'Espace client',
			'common.home.navPro' => 'Espace pro — à venir (FM-08)',
			'common.home.toggleTheme' => 'Basculer thème clair/sombre',
			'common.home.toggleLocale' => 'Basculer FR/AR',
			'common.home.designSystemPreview' => 'Vitrine design system',
			'contact.call' => 'Appeler',
			'contact.whatsapp' => 'WhatsApp',
			'favorites.title' => 'Mes favoris',
			'favorites.emptyTitle' => 'Aucun favori pour le moment',
			'favorites.emptySubtitle' => 'Enregistrez des artisans pour les retrouver rapidement.',
			'favorites.exploreCta' => 'Trouver un artisan',
			'favorites.removeTooltip' => 'Retirer des favoris',
			'favorites.addTooltip' => 'Ajouter aux favoris',
			'favorites.removeSuccess' => 'Artisan retiré des favoris',
			'favorites.addSuccess' => 'Artisan ajouté aux favoris',
			'favorites.removeError' => 'Impossible de retirer le favori.',
			'favorites.addError' => 'Impossible d\'ajouter le favori.',
			'favorites.loadError' => 'Impossible de charger vos favoris.',
			'favorites.retry' => 'Réessayer',
			'favorites.verifiedBadge' => 'Vérifié',
			'legal.title' => 'Mentions légales',
			'legal.editorTitle' => 'Éditeur de la plateforme',
			'legal.editorContent' => 'Sanaya — Plateforme de mise en relation entre particuliers et artisans tunisiens (Sahel : Sousse, Monastir, Mahdia).',
			'legal.modelTitle' => 'Modèle de service',
			'legal.modelContent' => 'Sanaya est un service de génération de contacts qualifiés. La plateforme n\'encaisse jamais le montant des prestations et n\'intervient pas dans le paiement direct du chantier.',
			'legal.inpdpTitle' => 'Protection des données personnelles (INPDP)',
			'legal.inpdpContent' => 'Conformément à la loi organique n° 2004-63, Sanaya s\'engage à protéger la vie privée de ses utilisateurs. Les numéros de téléphone ne sont révélés que lors d\'une mise en relation volontaire et tracée.',
			'legal.rightsTitle' => 'Vos droits',
			'legal.rightsContent' => 'Vous disposez d\'un droit d\'accès, de rectification et de suppression de vos données personnelles à tout moment.',
			'search.searchPlaceholder' => 'Rechercher un service…',
			'search.locationPlaceholder' => 'Choisir un gouvernorat',
			'search.categoriesTitle' => 'Catégories',
			'search.categoriesEmpty' => 'Aucune catégorie disponible pour le moment.',
			'search.categoriesError' => 'Impossible de charger les catégories.',
			'search.locationError' => 'Impossible de charger les gouvernorats.',
			'search.retry' => 'Réessayer',
			'settings.title' => 'Réglages',
			'settings.languageSection' => 'Langue',
			'settings.french' => 'Français',
			'settings.arabic' => 'العربية (تونس)',
			'settings.themeSection' => 'Apparence',
			'settings.themeSystem' => 'Système',
			'settings.themeLight' => 'Clair',
			'settings.themeDark' => 'Sombre',
			'settings.legalSection' => 'Informations & Légal',
			'settings.legalNotices' => 'Mentions légales',
			'settings.privacyPolicy' => 'Protection des données (INPDP)',
			'settings.accountSection' => 'Compte',
			'settings.logout' => 'Se déconnecter',
			'settings.logoutConfirmTitle' => 'Déconnexion',
			'settings.logoutConfirmMessage' => 'Êtes-vous sûr de vouloir vous déconnecter ?',
			'settings.cancel' => 'Annuler',
			'settings.confirm' => 'Confirmer',
			'settings.version' => 'Version',
			_ => null,
		};
	}
}
