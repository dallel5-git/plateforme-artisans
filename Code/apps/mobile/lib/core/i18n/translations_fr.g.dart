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
	late final Translations$provider$fr provider = Translations$provider$fr.internal(_root);
	late final Translations$search$fr search = Translations$search$fr.internal(_root);
}

// Path: common
class Translations$common$fr {
	Translations$common$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sanaya'
	String get appName => 'Sanaya';

	late final Translations$common$home$fr home = Translations$common$home$fr.internal(_root);
	late final Translations$common$widgets$fr widgets = Translations$common$widgets$fr.internal(_root);
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

// Path: provider
class Translations$provider$fr {
	Translations$provider$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$provider$profile$fr profile = Translations$provider$profile$fr.internal(_root);
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

// Path: common.widgets
class Translations$common$widgets$fr {
	Translations$common$widgets$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Vérifié'
	String get verifiedBadge => 'Vérifié';
}

// Path: provider.profile
class Translations$provider$profile$fr {
	Translations$provider$profile$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Appeler'
	String get callButton => 'Appeler';

	/// fr: 'WhatsApp'
	String get whatsappButton => 'WhatsApp';

	/// fr: 'Avis'
	String get reviewsTitle => 'Avis';

	/// fr: 'Charger plus d'avis'
	String get loadMoreReviews => 'Charger plus d\'avis';

	/// fr: 'Aucun avis pour le moment.'
	String get noReviews => 'Aucun avis pour le moment.';

	/// fr: 'Prestations'
	String get offeringsTitle => 'Prestations';

	/// fr: 'Zones d'intervention'
	String get coverageTitle => 'Zones d\'intervention';

	/// fr: '{n} an(s) d'expérience'
	String get yearsExperience => '{n} an(s) d\'expérience';

	/// fr: 'Disponible'
	String get availableNow => 'Disponible';

	/// fr: 'Occupé'
	String get busy => 'Occupé';

	/// fr: 'En congé'
	String get onHoliday => 'En congé';

	/// fr: 'Contact vérifié'
	String get verifiedContact => 'Contact vérifié';

	/// fr: 'Impossible de charger la fiche.'
	String get errorLoad => 'Impossible de charger la fiche.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';
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
			'common.widgets.verifiedBadge' => 'Vérifié',
			'contact.call' => 'Appeler',
			'contact.whatsapp' => 'WhatsApp',
			'provider.profile.callButton' => 'Appeler',
			'provider.profile.whatsappButton' => 'WhatsApp',
			'provider.profile.reviewsTitle' => 'Avis',
			'provider.profile.loadMoreReviews' => 'Charger plus d\'avis',
			'provider.profile.noReviews' => 'Aucun avis pour le moment.',
			'provider.profile.offeringsTitle' => 'Prestations',
			'provider.profile.coverageTitle' => 'Zones d\'intervention',
			'provider.profile.yearsExperience' => '{n} an(s) d\'expérience',
			'provider.profile.availableNow' => 'Disponible',
			'provider.profile.busy' => 'Occupé',
			'provider.profile.onHoliday' => 'En congé',
			'provider.profile.verifiedContact' => 'Contact vérifié',
			'provider.profile.errorLoad' => 'Impossible de charger la fiche.',
			'provider.profile.retry' => 'Réessayer',
			'search.searchPlaceholder' => 'Rechercher un service…',
			'search.locationPlaceholder' => 'Choisir un gouvernorat',
			'search.categoriesTitle' => 'Catégories',
			'search.categoriesEmpty' => 'Aucune catégorie disponible pour le moment.',
			'search.categoriesError' => 'Impossible de charger les catégories.',
			'search.locationError' => 'Impossible de charger les gouvernorats.',
			'search.retry' => 'Réessayer',
			_ => null,
		};
	}
}
