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
	late final Translations$auth$fr auth = Translations$auth$fr.internal(_root);
	late final Translations$billing$fr billing = Translations$billing$fr.internal(_root);
	late final Translations$boosts$fr boosts = Translations$boosts$fr.internal(_root);
	late final Translations$common$fr common = Translations$common$fr.internal(_root);
	late final Translations$contact$fr contact = Translations$contact$fr.internal(_root);
	late final Translations$dashboard$fr dashboard = Translations$dashboard$fr.internal(_root);
	late final Translations$errors$fr errors = Translations$errors$fr.internal(_root);
	late final Translations$favorites$fr favorites = Translations$favorites$fr.internal(_root);
	late final Translations$history$fr history = Translations$history$fr.internal(_root);
	late final Translations$legal$fr legal = Translations$legal$fr.internal(_root);
	late final Translations$onboarding$fr onboarding = Translations$onboarding$fr.internal(_root);
	late final Translations$proProfile$fr proProfile = Translations$proProfile$fr.internal(_root);
	late final Translations$profile$fr profile = Translations$profile$fr.internal(_root);
	late final Translations$provider$fr provider = Translations$provider$fr.internal(_root);
	late final Translations$reviews$fr reviews = Translations$reviews$fr.internal(_root);
	late final Translations$search$fr search = Translations$search$fr.internal(_root);
	late final Translations$settings$fr settings = Translations$settings$fr.internal(_root);
	late final Translations$verification$fr verification = Translations$verification$fr.internal(_root);
}

// Path: auth
class Translations$auth$fr {
	Translations$auth$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Votre numéro de téléphone'
	String get phoneTitle => 'Votre numéro de téléphone';

	/// fr: 'Nous vous enverrons un code de vérification par SMS'
	String get phoneSubtitle => 'Nous vous enverrons un code de vérification par SMS';

	/// fr: '22 123 456'
	String get phoneHint => '22 123 456';

	/// fr: 'En continuant, vous acceptez nos conditions d'utilisation et notre politique de confidentialité'
	String get legalConsent => 'En continuant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité';

	/// fr: 'Numéro de téléphone tunisien invalide'
	String get phoneInvalid => 'Numéro de téléphone tunisien invalide';

	/// fr: 'Recevoir le code'
	String get phoneCta => 'Recevoir le code';

	/// fr: 'Chiffre {n} sur {total}'
	String get otpDigitLabel => 'Chiffre {n} sur {total}';

	/// fr: 'Code de vérification'
	String get otpTitle => 'Code de vérification';

	/// fr: 'Un code à 6 chiffres a été envoyé au {phone}'
	String get otpSubtitle => 'Un code à 6 chiffres a été envoyé au {phone}';

	/// fr: 'Confirmer'
	String get otpCta => 'Confirmer';

	/// fr: 'Renvoyer le code'
	String get otpResend => 'Renvoyer le code';

	/// fr: 'Renvoyer le code ({mmss})'
	String get otpResendCountdown => 'Renvoyer le code ({mmss})';

	/// fr: 'Code invalide, {count} tentative(s) restante(s)'
	String get otpAttemptsRemaining => 'Code invalide, {count} tentative(s) restante(s)';

	/// fr: 'Code invalide'
	String get errorOtpInvalid => 'Code invalide';

	/// fr: 'Ce code a expiré, demandez-en un nouveau'
	String get errorOtpExpired => 'Ce code a expiré, demandez-en un nouveau';

	/// fr: 'Trop de tentatives, demandez un nouveau code'
	String get errorOtpTooManyAttempts => 'Trop de tentatives, demandez un nouveau code';

	/// fr: 'Trop de demandes, réessayez plus tard'
	String get errorRateLimitExceeded => 'Trop de demandes, réessayez plus tard';

	/// fr: 'Numéro de téléphone invalide'
	String get errorValidation => 'Numéro de téléphone invalide';

	/// fr: 'Une erreur est survenue, réessayez'
	String get errorGeneric => 'Une erreur est survenue, réessayez';
}

// Path: billing
class Translations$billing$fr {
	Translations$billing$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Solde de crédits'
	String get creditsBalance => 'Solde de crédits';

	/// fr: '$count crédits'
	String creditsCount({required Object count}) => '${count} crédits';

	/// fr: 'Acheter'
	String get buyCredits => 'Acheter';

	/// fr: 'Activer un boost'
	String get boostSectionTitle => 'Activer un boost';

	/// fr: 'Mettez en avant votre profil en tête des résultats de recherche.'
	String get boostSectionSubtitle => 'Mettez en avant votre profil en tête des résultats de recherche.';

	/// fr: 'Boost 24 heures'
	String get boostOption24h => 'Boost 24 heures';

	/// fr: 'Visibilité maximale pour un pic d'activité immédiat'
	String get boostOption24hDesc => 'Visibilité maximale pour un pic d\'activité immédiat';

	/// fr: 'Boost 7 jours'
	String get boostOption7d => 'Boost 7 jours';

	/// fr: 'Présence renforcée et continue toute la semaine'
	String get boostOption7dDesc => 'Présence renforcée et continue toute la semaine';

	/// fr: '10 crédits'
	String get boostOptionPrice24h => '10 crédits';

	/// fr: '50 crédits'
	String get boostOptionPrice7d => '50 crédits';

	/// fr: 'Sponsorisé'
	String get sponsoredTag => 'Sponsorisé';

	/// fr: 'Activer le boost'
	String get activateBoostCta => 'Activer le boost';

	/// fr: 'Bientôt disponible'
	String get featureUpcomingTitle => 'Bientôt disponible';

	/// fr: 'Le système d'achat de crédits et d'activation de boosts sera disponible dans une prochaine mise à jour.'
	String get featureUpcomingMessage => 'Le système d\'achat de crédits et d\'activation de boosts sera disponible dans une prochaine mise à jour.';

	/// fr: 'Client'
	String get clientSpace => 'Client';

	/// fr: 'Pro'
	String get proSpace => 'Pro';

	/// fr: 'Compris'
	String get dialogDismiss => 'Compris';
}

// Path: boosts
class Translations$boosts$fr {
	Translations$boosts$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Boosts'
	String get title => 'Boosts';

	/// fr: 'Boosts bientôt disponibles'
	String get emptyTitle => 'Boosts bientôt disponibles';

	/// fr: 'Mettez en avant votre profil dans les résultats de recherche dès que cette fonctionnalité sera prête.'
	String get emptyMessage => 'Mettez en avant votre profil dans les résultats de recherche dès que cette fonctionnalité sera prête.';
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
	late final Translations$common$nav$fr nav = Translations$common$nav$fr.internal(_root);
	late final Translations$common$devPreview$fr devPreview = Translations$common$devPreview$fr.internal(_root);
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

// Path: dashboard
class Translations$dashboard$fr {
	Translations$dashboard$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tableau de bord'
	String get title => 'Tableau de bord';

	/// fr: 'Bonjour, $name'
	String greeting({required Object name}) => 'Bonjour, ${name}';

	/// fr: 'Vues du profil'
	String get statViews => 'Vues du profil';

	/// fr: 'Visiteurs uniques'
	String get statUniqueViews => 'Visiteurs uniques';

	/// fr: 'Contacts'
	String get statContacts => 'Contacts';

	/// fr: 'Vue → contact'
	String get statRatio => 'Vue → contact';

	/// fr: 'vs. 15 jours précédents'
	String get comparisonPreviousPeriod => 'vs. 15 jours précédents';

	/// fr: 'Nouveau'
	String get comparisonNew => 'Nouveau';

	/// fr: 'Vues sur 30 jours'
	String get chartTitle => 'Vues sur 30 jours';

	/// fr: 'Vues sur 7 jours'
	String get chartTitle7d => 'Vues sur 7 jours';

	/// fr: 'Contacts'
	String get chartContactsLabel => 'Contacts';

	/// fr: 'Vues'
	String get chartViewsLabel => 'Vues';

	/// fr: 'Aucune vue pour l'instant'
	String get emptyTitle => 'Aucune vue pour l\'instant';

	/// fr: 'Complétez votre profil pour apparaître dans les résultats de recherche.'
	String get emptyMessage => 'Complétez votre profil pour apparaître dans les résultats de recherche.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Impossible de charger le tableau de bord'
	String get errorTitle => 'Impossible de charger le tableau de bord';

	/// fr: 'Vérifiez votre connexion et réessayez.'
	String get errorMessage => 'Vérifiez votre connexion et réessayez.';

	/// fr: 'Actions rapides'
	String get quickActionsTitle => 'Actions rapides';

	/// fr: 'Partager'
	String get actionShare => 'Partager';

	/// fr: 'Ma vitrine'
	String get actionPublicProfile => 'Ma vitrine';

	/// fr: 'Booster'
	String get actionBoost => 'Booster';

	/// fr: 'Mon profil'
	String get actionEditProfile => 'Mon profil';

	/// fr: 'Lien de votre profil copié dans le presse-papier'
	String get profileLinkCopied => 'Lien de votre profil copié dans le presse-papier';

	/// fr: 'Répartition des contacts'
	String get channelsTitle => 'Répartition des contacts';

	/// fr: 'Canaux utilisés par vos clients'
	String get channelsSubtitle => 'Canaux utilisés par vos clients';

	/// fr: 'Appels directs'
	String get channelPhone => 'Appels directs';

	/// fr: 'Messages WhatsApp'
	String get channelWhatsapp => 'Messages WhatsApp';

	/// fr: 'Activité récente & demandes'
	String get recentActivityTitle => 'Activité récente & demandes';

	/// fr: 'Dernières interactions reçues'
	String get recentActivitySubtitle => 'Dernières interactions reçues';

	/// fr: 'Demande WhatsApp reçue'
	String get recentLeadWhatsappTitle => 'Demande WhatsApp reçue';

	/// fr: 'Plomberie & sanitaires • Sousse (Khzema)'
	String get recentLeadWhatsappDesc => 'Plomberie & sanitaires • Sousse (Khzema)';

	/// fr: 'Appel direct reçu'
	String get recentLeadPhoneTitle => 'Appel direct reçu';

	/// fr: 'Dépannage électrique urgent • Monastir'
	String get recentLeadPhoneDesc => 'Dépannage électrique urgent • Monastir';

	/// fr: 'Nouvel avis 5 étoiles'
	String get recentLeadReviewTitle => 'Nouvel avis 5 étoiles';

	/// fr: '« Ponctuel et travail propre ! » • Karim B.'
	String get recentLeadReviewDesc => '« Ponctuel et travail propre ! » • Karim B.';

	/// fr: 'Il y a 2h'
	String get time2hAgo => 'Il y a 2h';

	/// fr: 'Il y a 5h'
	String get time5hAgo => 'Il y a 5h';

	/// fr: 'Hier'
	String get timeYesterday => 'Hier';

	/// fr: 'Avis & Réputation'
	String get reputationTitle => 'Avis & Réputation';

	/// fr: '$rating sur 5'
	String reputationRating({required Object rating}) => '${rating} sur 5';

	/// fr: '$count avis vérifiés'
	String reputationCount({required Object count}) => '${count} avis vérifiés';

	/// fr: 'Artisan Recommandé au Sahel'
	String get reputationBadge => 'Artisan Recommandé au Sahel';

	/// fr: '« Excellent travail, ponctuel et très professionnel pour l'installation du tableau électrique. »'
	String get reputationLatestReview => '« Excellent travail, ponctuel et très professionnel pour l\'installation du tableau électrique. »';

	/// fr: '— Karim B., Sousse'
	String get reputationAuthor => '— Karim B., Sousse';

	/// fr: 'Consulter tous les avis'
	String get reputationSeeAll => 'Consulter tous les avis';

	/// fr: 'Multipliez vos demandes par 3'
	String get boostBannerTitle => 'Multipliez vos demandes par 3';

	/// fr: 'Apparaissez en tête des résultats de recherche à Sousse et Monastir.'
	String get boostBannerSubtitle => 'Apparaissez en tête des résultats de recherche à Sousse et Monastir.';

	/// fr: 'Découvrir les Boosts'
	String get boostBannerCta => 'Découvrir les Boosts';

	/// fr: 'Conseils pour votre activité'
	String get proTipsTitle => 'Conseils pour votre activité';

	/// fr: 'Réactivité maximale'
	String get tipResponsivenessTitle => 'Réactivité maximale';

	/// fr: 'Répondre aux appels et messages dans les 15 minutes double le taux de confirmation de chantier.'
	String get tipResponsivenessDesc => 'Répondre aux appels et messages dans les 15 minutes double le taux de confirmation de chantier.';

	/// fr: 'Ajoutez des photos de chantiers'
	String get tipPhotosTitle => 'Ajoutez des photos de chantiers';

	/// fr: 'Les fiches avec des photos de réalisations génèrent jusqu'à 70% de contacts en plus.'
	String get tipPhotosDesc => 'Les fiches avec des photos de réalisations génèrent jusqu\'à 70% de contacts en plus.';
}

// Path: errors
class Translations$errors$fr {
	Translations$errors$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Page introuvable'
	String get routeNotFoundTitle => 'Page introuvable';

	/// fr: 'Cette page n'existe pas ou n'est plus disponible.'
	String get routeNotFoundMessage => 'Cette page n\'existe pas ou n\'est plus disponible.';

	/// fr: 'Retour à l'accueil'
	String get routeNotFoundAction => 'Retour à l\'accueil';

	/// fr: 'Limite atteinte : maximum {limit}.'
	String get validationLimit => 'Limite atteinte : maximum {limit}.';
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

	/// fr: 'Chargement impossible'
	String get errorTitle => 'Chargement impossible';

	/// fr: 'Impossible de charger vos favoris.'
	String get loadError => 'Impossible de charger vos favoris.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Vérifié'
	String get verifiedBadge => 'Vérifié';

	/// fr: 'Retrouvez vos artisans favoris'
	String get authRequiredTitle => 'Retrouvez vos artisans favoris';

	/// fr: 'Connectez-vous pour enregistrer des artisans et les retrouver facilement.'
	String get authRequiredSubtitle => 'Connectez-vous pour enregistrer des artisans et les retrouver facilement.';

	/// fr: 'Se connecter ou s'inscrire'
	String get loginCta => 'Se connecter ou s\'inscrire';
}

// Path: history
class Translations$history$fr {
	Translations$history$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Historique'
	String get title => 'Historique';

	/// fr: 'Aucun artisan contacté'
	String get emptyTitle => 'Aucun artisan contacté';

	/// fr: 'Les artisans que vous contactez apparaîtront ici, avec un raccourci pour laisser un avis.'
	String get emptyMessage => 'Les artisans que vous contactez apparaîtront ici, avec un raccourci pour laisser un avis.';

	/// fr: 'Rechercher'
	String get emptyCta => 'Rechercher';

	/// fr: 'Impossible de charger votre historique.'
	String get loadError => 'Impossible de charger votre historique.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Laisser un avis'
	String get reviewCta => 'Laisser un avis';

	/// fr: 'Appel'
	String get channelPhone => 'Appel';

	/// fr: 'WhatsApp'
	String get channelWhatsapp => 'WhatsApp';

	/// fr: 'Consultez votre historique'
	String get authRequiredTitle => 'Consultez votre historique';

	/// fr: 'Connectez-vous pour retrouver tous les artisans que vous avez contactés.'
	String get authRequiredSubtitle => 'Connectez-vous pour retrouver tous les artisans que vous avez contactés.';

	/// fr: 'Se connecter ou s'inscrire'
	String get loginCta => 'Se connecter ou s\'inscrire';
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

// Path: onboarding
class Translations$onboarding$fr {
	Translations$onboarding$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Devenir prestataire'
	String get wizardTitle => 'Devenir prestataire';

	/// fr: 'Retour'
	String get back => 'Retour';

	/// fr: 'Suivant'
	String get next => 'Suivant';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Profil'
	String get stepProfile => 'Profil';

	/// fr: 'Catégories'
	String get stepCategories => 'Catégories';

	/// fr: 'Zones'
	String get stepZones => 'Zones';

	/// fr: 'Photos'
	String get stepPhotos => 'Photos';

	/// fr: 'Récapitulatif'
	String get stepSummary => 'Récapitulatif';

	/// fr: 'Étape {current} sur {total}'
	String get stepIndicator => 'Étape {current} sur {total}';

	/// fr: 'Nom de l'activité'
	String get profileBusinessName => 'Nom de l\'activité';

	/// fr: 'Titre (ex. Plombier certifié)'
	String get profileHeadline => 'Titre (ex. Plombier certifié)';

	/// fr: 'Présentation (au moins 50 caractères)'
	String get profileBio => 'Présentation (au moins 50 caractères)';

	/// fr: 'Années d'expérience'
	String get profileYearsExperience => 'Années d\'expérience';

	/// fr: 'Téléphone WhatsApp'
	String get profileWhatsapp => 'Téléphone WhatsApp';

	/// fr: 'Téléphone public'
	String get profilePublicPhone => 'Téléphone public';

	/// fr: 'Gouvernorat de rattachement'
	String get profileGovernorate => 'Gouvernorat de rattachement';

	/// fr: 'Impossible de charger les gouvernorats.'
	String get profileGovernorateError => 'Impossible de charger les gouvernorats.';

	/// fr: 'Impossible d'enregistrer le profil. Réessayez.'
	String get profileSaveError => 'Impossible d\'enregistrer le profil. Réessayez.';

	/// fr: 'Choisissez vos catégories'
	String get categoriesTitle => 'Choisissez vos catégories';

	/// fr: 'Principale'
	String get categoriesPrimaryHint => 'Principale';

	/// fr: 'Sélectionnez au moins une catégorie.'
	String get categoriesEmpty => 'Sélectionnez au moins une catégorie.';

	/// fr: 'Impossible de charger les catégories.'
	String get categoriesError => 'Impossible de charger les catégories.';

	/// fr: 'Vérifiez votre connexion et réessayez.'
	String get categoriesErrorMessage => 'Vérifiez votre connexion et réessayez.';

	/// fr: 'Impossible d'enregistrer les catégories. Réessayez.'
	String get categoriesSaveError => 'Impossible d\'enregistrer les catégories. Réessayez.';

	/// fr: '3 catégories maximum en offre gratuite'
	String get categoriesCapHint => '3 catégories maximum en offre gratuite';

	/// fr: 'Choisissez vos zones d'intervention'
	String get zonesTitle => 'Choisissez vos zones d\'intervention';

	/// fr: '1 gouvernorat maximum en offre gratuite'
	String get zonesCapHint => '1 gouvernorat maximum en offre gratuite';

	/// fr: 'Sélectionnez au moins un gouvernorat.'
	String get zonesEmpty => 'Sélectionnez au moins un gouvernorat.';

	/// fr: 'Impossible de charger les gouvernorats.'
	String get zonesError => 'Impossible de charger les gouvernorats.';

	/// fr: 'Vérifiez votre connexion et réessayez.'
	String get zonesErrorMessage => 'Vérifiez votre connexion et réessayez.';

	/// fr: 'Impossible d'enregistrer les zones. Réessayez.'
	String get zonesSaveError => 'Impossible d\'enregistrer les zones. Réessayez.';

	/// fr: 'Ajoutez des photos de vos réalisations'
	String get photosTitle => 'Ajoutez des photos de vos réalisations';

	/// fr: '5 photos maximum en offre gratuite'
	String get photosCapHint => '5 photos maximum en offre gratuite';

	/// fr: 'Plafond de 5 photos atteint (offre gratuite).'
	String get photosCapReached => 'Plafond de 5 photos atteint (offre gratuite).';

	/// fr: 'Ajouter une photo'
	String get photosAdd => 'Ajouter une photo';

	/// fr: 'Supprimer cette photo'
	String get photosDelete => 'Supprimer cette photo';

	/// fr: 'Échec de l'envoi'
	String get photosUploadFailed => 'Échec de l\'envoi';

	/// fr: 'Récapitulatif'
	String get summaryTitle => 'Récapitulatif';

	/// fr: 'Profil complet à {score} %'
	String get summaryCompletionLabel => 'Profil complet à {score} %';

	/// fr: 'Il manque encore :'
	String get summaryMissingTitle => 'Il manque encore :';

	/// fr: 'Publier mon profil'
	String get summaryPublish => 'Publier mon profil';

	/// fr: 'Publication impossible. Réessayez.'
	String get summaryPublishError => 'Publication impossible. Réessayez.';

	/// fr: 'Profil publié !'
	String get summaryPublished => 'Profil publié !';

	/// fr: 'Ajouter une description de 50 caractères min'
	String get missingBio => 'Ajouter une description de 50 caractères min';

	/// fr: 'Ajouter un titre professionnel'
	String get missingHeadline => 'Ajouter un titre professionnel';

	/// fr: 'Indiquer vos années d'expérience'
	String get missingYearsExperience => 'Indiquer vos années d\'expérience';

	/// fr: 'Ajouter un numéro WhatsApp ou public'
	String get missingContactPhone => 'Ajouter un numéro WhatsApp ou public';

	/// fr: 'Sélectionner au moins une catégorie'
	String get missingCategories => 'Sélectionner au moins une catégorie';

	/// fr: 'Sélectionner au moins un gouvernorat'
	String get missingCoverageAreas => 'Sélectionner au moins un gouvernorat';

	/// fr: 'Ajouter des photos de vos réalisations'
	String get missingPhotos => 'Ajouter des photos de vos réalisations';

	/// fr: 'Modifier dans l'étape {step}'
	String get missingActionHint => 'Modifier dans l\'étape {step}';

	/// fr: 'Profil incomplet — publication impossible (< 40 %)'
	String get summaryScoreCritical => 'Profil incomplet — publication impossible (< 40 %)';

	/// fr: 'Encore un effort pour atteindre le seuil de publication (60 %)'
	String get summaryScoreWarning => 'Encore un effort pour atteindre le seuil de publication (60 %)';

	/// fr: 'Seuil de publication atteint (≥ 60 %)'
	String get summaryScoreSuccess => 'Seuil de publication atteint (≥ 60 %)';

	/// fr: 'Bienvenue sur Sanaya'
	String get clientWelcomeTitle => 'Bienvenue sur Sanaya';

	/// fr: 'Trouvez les meilleurs artisans au Sahel tunisien en toute confiance.'
	String get clientWelcomeSubtitle => 'Trouvez les meilleurs artisans au Sahel tunisien en toute confiance.';

	/// fr: 'Trouvez l'artisan idéal'
	String get clientStep1Title => 'Trouvez l\'artisan idéal';

	/// fr: 'Plombiers, électriciens, peintres, climatiseurs... Des professionnels qualifiés et disponibles près de chez vous.'
	String get clientStep1Desc => 'Plombiers, électriciens, peintres, climatiseurs... Des professionnels qualifiés et disponibles près de chez vous.';

	/// fr: 'Confiance & Avis vérifiés'
	String get clientStep2Title => 'Confiance & Avis vérifiés';

	/// fr: 'Artisans vérifiés par pièce d'identité (CIN) et avis authentiques déposés uniquement après contact réel.'
	String get clientStep2Desc => 'Artisans vérifiés par pièce d\'identité (CIN) et avis authentiques déposés uniquement après contact réel.';

	/// fr: 'Contact direct & 100% gratuit'
	String get clientStep3Title => 'Contact direct & 100% gratuit';

	/// fr: 'Appel ou WhatsApp direct sans commission ni intermédiaire. Vous convenez du chantier directement avec l'artisan.'
	String get clientStep3Desc => 'Appel ou WhatsApp direct sans commission ni intermédiaire. Vous convenez du chantier directement avec l\'artisan.';

	/// fr: 'Votre gouvernorat de recherche :'
	String get clientChooseGovernorate => 'Votre gouvernorat de recherche :';

	/// fr: 'Commencer à chercher'
	String get clientStartExploring => 'Commencer à chercher';

	/// fr: 'Passer l'introduction'
	String get clientSkip => 'Passer l\'introduction';

	/// fr: 'Mabrouk ! Votre profil est en ligne'
	String get celebrationTitle => 'Mabrouk ! Votre profil est en ligne';

	/// fr: 'Votre profil est désormais visible par tous les clients de votre région de couverture. Vous pouvez commencer à recevoir des demandes de contact.'
	String get celebrationSubtitle => 'Votre profil est désormais visible par tous les clients de votre région de couverture. Vous pouvez commencer à recevoir des demandes de contact.';

	/// fr: 'Multipliez par 3 vos contacts grâce au Badge Vérifié'
	String get celebrationKycCardTitle => 'Multipliez par 3 vos contacts grâce au Badge Vérifié';

	/// fr: 'Les artisans dont l'identité est confirmée par leur carte d'identité (CIN) inspirent davantage confiance et apparaissent en tête des résultats de recherche. La démarche est 100 % gratuite et prend moins de 2 minutes.'
	String get celebrationKycCardDescription => 'Les artisans dont l\'identité est confirmée par leur carte d\'identité (CIN) inspirent davantage confiance et apparaissent en tête des résultats de recherche. La démarche est 100 % gratuite et prend moins de 2 minutes.';

	/// fr: 'Badge officiel « Artisan Vérifié » sur votre profil'
	String get celebrationKycBenefitBadge => 'Badge officiel « Artisan Vérifié » sur votre profil';

	/// fr: 'Priorité d'affichage dans les résultats de recherche'
	String get celebrationKycBenefitRank => 'Priorité d\'affichage dans les résultats de recherche';

	/// fr: 'Validation sous 24 h ouvrées'
	String get celebrationKycBenefitFast => 'Validation sous 24 h ouvrées';

	/// fr: 'Faire vérifier mon identité maintenant'
	String get celebrationCtaVerify => 'Faire vérifier mon identité maintenant';

	/// fr: 'Accéder à mon tableau de bord'
	String get celebrationCtaDashboard => 'Accéder à mon tableau de bord';
}

// Path: proProfile
class Translations$proProfile$fr {
	Translations$proProfile$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Profil'
	String get title => 'Profil';

	/// fr: 'Profil introuvable'
	String get emptyTitle => 'Profil introuvable';

	/// fr: 'Aucun profil artisan n'est associé à ce compte.'
	String get emptyMessage => 'Aucun profil artisan n\'est associé à ce compte.';

	/// fr: 'Retour à l'espace Client'
	String get switchToClientSpace => 'Retour à l\'espace Client';

	/// fr: 'Impossible de charger votre profil'
	String get errorTitle => 'Impossible de charger votre profil';

	/// fr: 'Vérifiez votre connexion et réessayez.'
	String get errorMessage => 'Vérifiez votre connexion et réessayez.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Disponibilité'
	String get availabilitySection => 'Disponibilité';

	/// fr: 'Accepte les urgences'
	String get acceptsEmergencyLabel => 'Accepte les urgences';

	/// fr: 'Affiche le badge Urgence dans les résultats de recherche'
	String get acceptsEmergencyDescription => 'Affiche le badge Urgence dans les résultats de recherche';

	/// fr: 'Modifier mon profil'
	String get editSection => 'Modifier mon profil';

	/// fr: 'Enregistrer'
	String get save => 'Enregistrer';

	/// fr: 'Profil mis à jour'
	String get saveSuccess => 'Profil mis à jour';

	/// fr: 'Voir ma fiche telle que la voit un client'
	String get viewMyListing => 'Voir ma fiche telle que la voit un client';

	/// fr: 'Complétude du profil'
	String get completionTitle => 'Complétude du profil';

	/// fr: 'Profil complété à {score} %'
	String get completionLabel => 'Profil complété à {score} %';

	/// fr: 'Un profil complet reçoit en moyenne 3 fois plus de contacts.'
	String get completionTip => 'Un profil complet reçoit en moyenne 3 fois plus de contacts.';

	/// fr: 'Modifier via l'assistant complet'
	String get relaunchOnboarding => 'Modifier via l\'assistant complet';

	/// fr: '{years} ans d'expérience'
	String get yearsExperience => '{years} ans d\'expérience';

	/// fr: 'Artisan Vérifié'
	String get verifiedBadge => 'Artisan Vérifié';

	/// fr: 'Vérification en attente'
	String get unverifiedBadge => 'Vérification en attente';

	/// fr: 'Vues de profil'
	String get statsViews => 'Vues de profil';

	/// fr: 'Contacts reçus'
	String get statsContacts => 'Contacts reçus';

	/// fr: 'Note moyenne'
	String get statsRating => 'Note moyenne';

	/// fr: 'Vitrine publique'
	String get publicPreviewTitle => 'Vitrine publique';

	/// fr: 'Consultez votre fiche telle qu'elle apparaît pour vos futurs clients'
	String get publicPreviewSubtitle => 'Consultez votre fiche telle qu\'elle apparaît pour vos futurs clients';

	/// fr: 'Galerie & Réalisations'
	String get portfolioSection => 'Galerie & Réalisations';

	/// fr: 'Photos de vos réalisations et chantiers'
	String get portfolioDesc => 'Photos de vos réalisations et chantiers';

	/// fr: 'Métiers & Zones d'intervention'
	String get categoriesAndZones => 'Métiers & Zones d\'intervention';

	/// fr: 'Mes Métiers & Spécialités'
	String get categoriesSection => 'Mes Métiers & Spécialités';

	/// fr: 'Gérez vos corps de métier et votre spécialité principale'
	String get categoriesDesc => 'Gérez vos corps de métier et votre spécialité principale';

	/// fr: 'Métiers mis à jour avec succès'
	String get categoriesUpdated => 'Métiers mis à jour avec succès';

	/// fr: 'Aucun métier configuré'
	String get categoriesEmpty => 'Aucun métier configuré';

	/// fr: 'Zones d'intervention'
	String get zonesSection => 'Zones d\'intervention';

	/// fr: 'Gouvernorats couverts par vos déplacements'
	String get zonesDesc => 'Gouvernorats couverts par vos déplacements';

	/// fr: 'Zones d'intervention mises à jour avec succès'
	String get zonesUpdated => 'Zones d\'intervention mises à jour avec succès';

	/// fr: 'Aucune zone configurée'
	String get zonesEmpty => 'Aucune zone configurée';

	/// fr: 'Modifier mes métiers'
	String get editCategories => 'Modifier mes métiers';

	/// fr: 'Modifier mes zones'
	String get editZones => 'Modifier mes zones';

	/// fr: 'Disponibilité mise à jour'
	String get availabilityUpdated => 'Disponibilité mise à jour';

	/// fr: 'Tester l'onboarding Pro'
	String get testOnboardingPro => 'Tester l\'onboarding Pro';

	/// fr: 'Tester l'onboarding Particulier'
	String get testOnboardingClient => 'Tester l\'onboarding Particulier';

	/// fr: '{count} / {max} photos'
	String get portfolioQuota => '{count} / {max} photos';

	/// fr: 'Ajouter une réalisation'
	String get portfolioAddPhoto => 'Ajouter une réalisation';

	/// fr: 'Aucune photo de réalisation pour le moment'
	String get portfolioEmpty => 'Aucune photo de réalisation pour le moment';

	/// fr: 'Supprimer cette réalisation ?'
	String get portfolioDeleteTitle => 'Supprimer cette réalisation ?';

	/// fr: 'Cette photo sera retirée définitivement de votre vitrine publique.'
	String get portfolioDeleteMessage => 'Cette photo sera retirée définitivement de votre vitrine publique.';

	/// fr: 'Supprimer'
	String get portfolioDeleteConfirm => 'Supprimer';

	/// fr: 'Annuler'
	String get portfolioCancel => 'Annuler';

	/// fr: 'Photo retirée du portfolio'
	String get portfolioDeleted => 'Photo retirée du portfolio';

	/// fr: 'Photo ajoutée à vos réalisations'
	String get portfolioAdded => 'Photo ajoutée à vos réalisations';

	/// fr: 'Échec du téléversement de la photo'
	String get portfolioUploadError => 'Échec du téléversement de la photo';

	/// fr: 'Légende (optionnel)'
	String get portfolioCaptionLabel => 'Légende (optionnel)';

	/// fr: 'Métier associé (optionnel)'
	String get portfolioCategoryLabel => 'Métier associé (optionnel)';

	/// fr: 'Limite de {max} photos atteinte (offre gratuite)'
	String get portfolioMaxReached => 'Limite de {max} photos atteinte (offre gratuite)';

	/// fr: 'Mes Prestations & Tarifs indicatifs'
	String get offeringsSection => 'Mes Prestations & Tarifs indicatifs';

	/// fr: 'Présentez vos forfaits types pour donner des repères à vos futurs clients'
	String get offeringsDesc => 'Présentez vos forfaits types pour donner des repères à vos futurs clients';

	/// fr: 'Ajouter une prestation'
	String get offeringsAdd => 'Ajouter une prestation';

	/// fr: 'Aucune prestation renseignée. Ajoutez vos tarifs types !'
	String get offeringsEmpty => 'Aucune prestation renseignée. Ajoutez vos tarifs types !';

	/// fr: 'Négociable'
	String get offeringsNegotiable => 'Négociable';

	/// fr: 'Modifier'
	String get offeringsEdit => 'Modifier';

	/// fr: 'Supprimer'
	String get offeringsDelete => 'Supprimer';

	/// fr: 'Supprimer cette prestation ?'
	String get offeringsDeleteTitle => 'Supprimer cette prestation ?';

	/// fr: 'Cette offre ne sera plus visible sur votre fiche artisan.'
	String get offeringsDeleteMessage => 'Cette offre ne sera plus visible sur votre fiche artisan.';

	/// fr: 'Supprimer'
	String get offeringsDeleteConfirm => 'Supprimer';

	/// fr: 'Prestation supprimée'
	String get offeringsDeleted => 'Prestation supprimée';

	/// fr: 'Prestation enregistrée avec succès'
	String get offeringsSaved => 'Prestation enregistrée avec succès';

	/// fr: 'Titre de la prestation (Français)'
	String get offeringTitleFr => 'Titre de la prestation (Français)';

	/// fr: 'Titre en Arabe (optionnel)'
	String get offeringTitleAr => 'Titre en Arabe (optionnel)';

	/// fr: 'Description détaillée (optionnel)'
	String get offeringDescription => 'Description détaillée (optionnel)';

	/// fr: 'Corps de métier'
	String get offeringCategory => 'Corps de métier';

	/// fr: 'Prix minimum (DT)'
	String get offeringPriceMin => 'Prix minimum (DT)';

	/// fr: 'Prix maximum (DT)'
	String get offeringPriceMax => 'Prix maximum (DT)';

	/// fr: 'Unité de tarification'
	String get offeringPriceUnit => 'Unité de tarification';

	/// fr: 'Au forfait'
	String get unitFixed => 'Au forfait';

	/// fr: 'Par heure'
	String get unitHour => 'Par heure';

	/// fr: 'Par jour'
	String get unitDay => 'Par jour';

	/// fr: 'Par m²'
	String get unitSquareMeter => 'Par m²';

	/// fr: 'Sur devis uniquement'
	String get unitOnQuote => 'Sur devis uniquement';

	/// fr: 'Tarif négociable selon le chantier'
	String get offeringNegotiableSwitch => 'Tarif négociable selon le chantier';
}

// Path: profile
class Translations$profile$fr {
	Translations$profile$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Profil'
	String get title => 'Profil';

	/// fr: 'Mon compte'
	String get accountFallback => 'Mon compte';

	/// fr: 'Passer en espace Pro'
	String get switchToProSpace => 'Passer en espace Pro';

	/// fr: 'Invité'
	String get guestName => 'Invité';

	/// fr: 'Non connecté'
	String get guestSubtitle => 'Non connecté';

	/// fr: 'Se connecter ou s'inscrire'
	String get loginCta => 'Se connecter ou s\'inscrire';

	/// fr: 'Devenir artisan sur Sanaya'
	String get becomeProTitle => 'Devenir artisan sur Sanaya';

	/// fr: 'Vous êtes artisan ou professionnel du bâtiment ? Proposez vos services et trouvez de nouveaux clients.'
	String get becomeProSubtitle => 'Vous êtes artisan ou professionnel du bâtiment ? Proposez vos services et trouvez de nouveaux clients.';

	/// fr: 'Créer mon profil artisan'
	String get becomeProButton => 'Créer mon profil artisan';
}

// Path: provider
class Translations$provider$fr {
	Translations$provider$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$provider$profile$fr profile = Translations$provider$profile$fr.internal(_root);
}

// Path: reviews
class Translations$reviews$fr {
	Translations$reviews$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Avis'
	String get title => 'Avis';

	/// fr: 'Aucun avis reçu pour l'instant'
	String get emptyTitle => 'Aucun avis reçu pour l\'instant';

	/// fr: 'Les avis laissés par vos clients apparaîtront ici.'
	String get emptyMessage => 'Les avis laissés par vos clients apparaîtront ici.';

	/// fr: 'Impossible de charger vos avis.'
	String get loadError => 'Impossible de charger vos avis.';

	/// fr: 'Une erreur est survenue lors de la récupération de vos avis.'
	String get errorMessage => 'Une erreur est survenue lors de la récupération de vos avis.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Charger plus d'avis'
	String get loadMore => 'Charger plus d\'avis';

	/// fr: '$count avis'
	String reviewsCount({required Object count}) => '${count} avis';

	/// fr: 'Note moyenne'
	String get ratingSummary => 'Note moyenne';

	/// fr: 'Répondre'
	String get replyAction => 'Répondre';

	/// fr: 'La réponse aux avis sera bientôt disponible'
	String get replyComingSoon => 'La réponse aux avis sera bientôt disponible';
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

	/// fr: 'Service'
	String get serviceLabel => 'Service';

	/// fr: 'Gouvernorat'
	String get governorateLabel => 'Gouvernorat';

	/// fr: 'Catégories'
	String get categoriesTitle => 'Catégories';

	/// fr: 'Aucune catégorie'
	String get categoriesEmptyTitle => 'Aucune catégorie';

	/// fr: 'Aucune catégorie disponible pour le moment.'
	String get categoriesEmpty => 'Aucune catégorie disponible pour le moment.';

	/// fr: 'Chargement impossible'
	String get categoriesErrorTitle => 'Chargement impossible';

	/// fr: 'Impossible de charger les catégories.'
	String get categoriesError => 'Impossible de charger les catégories.';

	/// fr: 'Impossible de charger les gouvernorats.'
	String get locationError => 'Impossible de charger les gouvernorats.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Note 4+'
	String get filterRatingMin => 'Note 4+';

	/// fr: 'Urgence'
	String get filterUrgent => 'Urgence';

	/// fr: 'Résultats'
	String get resultsTitle => 'Résultats';

	/// fr: 'Vérifié'
	String get filterVerified => 'Vérifié';

	/// fr: 'Aucun artisan trouvé'
	String get emptyTitle => 'Aucun artisan trouvé';

	/// fr: 'Essayez de modifier vos filtres ou de chercher dans un autre gouvernorat.'
	String get emptySubtitle => 'Essayez de modifier vos filtres ou de chercher dans un autre gouvernorat.';

	/// fr: 'Réinitialiser les filtres'
	String get resetFilters => 'Réinitialiser les filtres';

	/// fr: 'Erreur de chargement'
	String get loadErrorTitle => 'Erreur de chargement';

	/// fr: 'Impossible de charger les résultats.'
	String get loadError => 'Impossible de charger les résultats.';

	/// fr: 'Résultats hors ligne'
	String get offlineNotice => 'Résultats hors ligne';
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

	/// fr: 'Se connecter ou s'inscrire'
	String get login => 'Se connecter ou s\'inscrire';

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

	/// fr: 'Mode Démo (Données de test)'
	String get demoSection => 'Mode Démo (Données de test)';

	/// fr: 'Activer le mode démo'
	String get demoMode => 'Activer le mode démo';

	/// fr: 'Simuler artisans, avis et historique sans serveur distant'
	String get demoModeSubtitle => 'Simuler artisans, avis et historique sans serveur distant';

	/// fr: 'Visiteur (non connecté)'
	String get demoRoleGuest => 'Visiteur (non connecté)';

	/// fr: 'Mode Client'
	String get demoRoleClient => 'Mode Client';

	/// fr: 'Mode Artisan Pro'
	String get demoRolePro => 'Mode Artisan Pro';

	/// fr: 'Mode Démo actif'
	String get demoBanner => 'Mode Démo actif';

	/// fr: 'Outils de Test Onboarding'
	String get testToolsSection => 'Outils de Test Onboarding';

	/// fr: 'Tester l'onboarding Pro'
	String get testOnboardingPro => 'Tester l\'onboarding Pro';

	/// fr: 'Lancer l'assistant 5 étapes (profil, métiers, zones, photos, récap)'
	String get testOnboardingProDesc => 'Lancer l\'assistant 5 étapes (profil, métiers, zones, photos, récap)';

	/// fr: 'Tester l'onboarding Particulier'
	String get testOnboardingClient => 'Tester l\'onboarding Particulier';

	/// fr: 'Lancer le parcours interactif de découverte pour les clients'
	String get testOnboardingClientDesc => 'Lancer le parcours interactif de découverte pour les clients';
}

// Path: verification
class Translations$verification$fr {
	Translations$verification$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Vérification d'identité'
	String get screenTitle => 'Vérification d\'identité';

	/// fr: 'Obtenez le badge Artisan Vérifié'
	String get headerTitle => 'Obtenez le badge Artisan Vérifié';

	/// fr: 'Renforcez la confiance de vos clients en faisant certifier votre compte par votre Carte d'Identité Nationale (CIN).'
	String get headerSubtitle => 'Renforcez la confiance de vos clients en faisant certifier votre compte par votre Carte d\'Identité Nationale (CIN).';

	/// fr: 'Badge officiel affiché sur votre profil et dans la recherche'
	String get badgeAdvantage1 => 'Badge officiel affiché sur votre profil et dans la recherche';

	/// fr: 'Priorité dans les résultats de recherche'
	String get badgeAdvantage2 => 'Priorité dans les résultats de recherche';

	/// fr: 'Informations d'identité'
	String get identitySectionTitle => 'Informations d\'identité';

	/// fr: 'Nom et prénom (sur la CIN)'
	String get fullNameLabel => 'Nom et prénom (sur la CIN)';

	/// fr: 'ex. Ahmed Ben Salah'
	String get fullNameHint => 'ex. Ahmed Ben Salah';

	/// fr: 'Veuillez saisir votre nom et prénom (au moins 3 caractères)'
	String get fullNameError => 'Veuillez saisir votre nom et prénom (au moins 3 caractères)';

	/// fr: 'Numéro de carte d'identité (CIN)'
	String get cinNumberLabel => 'Numéro de carte d\'identité (CIN)';

	/// fr: '8 chiffres (ex. 08123456)'
	String get cinNumberHint => '8 chiffres (ex. 08123456)';

	/// fr: 'Le numéro de CIN doit comporter exactement 8 chiffres'
	String get cinNumberError => 'Le numéro de CIN doit comporter exactement 8 chiffres';

	/// fr: 'Face avant (Recto)'
	String get cinFrontTitle => 'Face avant (Recto)';

	/// fr: 'Photo nette de la face avant de votre CIN'
	String get cinFrontSubtitle => 'Photo nette de la face avant de votre CIN';

	/// fr: 'Face arrière (Verso)'
	String get cinBackTitle => 'Face arrière (Verso)';

	/// fr: 'Photo nette de la face arrière de votre CIN'
	String get cinBackSubtitle => 'Photo nette de la face arrière de votre CIN';

	/// fr: 'Prendre une photo'
	String get takePhoto => 'Prendre une photo';

	/// fr: 'Choisir depuis la galerie'
	String get chooseFromGallery => 'Choisir depuis la galerie';

	/// fr: 'Changer'
	String get changePhoto => 'Changer';

	/// fr: 'Supprimer'
	String get deletePhoto => 'Supprimer';

	/// fr: 'Envoi en cours ({progress}%)...'
	String get uploading => 'Envoi en cours ({progress}%)...';

	/// fr: 'Échec de l'envoi de l'image. Touchez pour réessayer.'
	String get uploadError => 'Échec de l\'envoi de l\'image. Touchez pour réessayer.';

	/// fr: 'Je consens au traitement de ma pièce d'identité conformément à la loi n° 2004-63 relative à la protection des données personnelles.'
	String get inpdpConsentLabel => 'Je consens au traitement de ma pièce d\'identité conformément à la loi n° 2004-63 relative à la protection des données personnelles.';

	/// fr: 'En savoir plus sur la protection de vos données'
	String get inpdpConsentLink => 'En savoir plus sur la protection de vos données';

	/// fr: 'Protection de vos données personnelles'
	String get inpdpDialogTitle => 'Protection de vos données personnelles';

	/// fr: 'Vos documents d'identité sont stockés dans un coffre-fort numérique hautement sécurisé, chiffrés au repos (AES-256-GCM) et protégés par chiffrement serveur. Ils ne sont jamais partagés publiquement et servent exclusivement à l'authentification de votre profil par notre équipe de modération.'
	String get inpdpDialogBody => 'Vos documents d\'identité sont stockés dans un coffre-fort numérique hautement sécurisé, chiffrés au repos (AES-256-GCM) et protégés par chiffrement serveur. Ils ne sont jamais partagés publiquement et servent exclusivement à l\'authentification de votre profil par notre équipe de modération.';

	/// fr: 'Compris'
	String get inpdpDialogClose => 'Compris';

	/// fr: 'Envoyer pour vérification'
	String get submitButton => 'Envoyer pour vérification';

	/// fr: 'Envoi de la demande...'
	String get submitting => 'Envoi de la demande...';

	/// fr: 'Demande envoyée avec succès !'
	String get submitSuccessTitle => 'Demande envoyée avec succès !';

	/// fr: 'Notre équipe examine votre pièce d'identité sous 24 heures ouvrées. Vous serez notifié dès validation.'
	String get submitSuccessMessage => 'Notre équipe examine votre pièce d\'identité sous 24 heures ouvrées. Vous serez notifié dès validation.';

	/// fr: 'Retour au tableau de bord'
	String get backToDashboard => 'Retour au tableau de bord';

	/// fr: 'Vérification en cours'
	String get statusPending => 'Vérification en cours';

	/// fr: 'Artisan Vérifié'
	String get statusApproved => 'Artisan Vérifié';

	/// fr: 'Vérification refusée'
	String get statusRejected => 'Vérification refusée';

	/// fr: 'Complément d'information requis'
	String get statusMoreInfo => 'Complément d\'information requis';

	/// fr: 'Non vérifié'
	String get statusNotSubmitted => 'Non vérifié';

	/// fr: 'Une demande de vérification est déjà en cours de traitement.'
	String get alreadyPending => 'Une demande de vérification est déjà en cours de traitement.';

	/// fr: 'Votre profil est déjà vérifié.'
	String get alreadyVerified => 'Votre profil est déjà vérifié.';

	/// fr: 'Veuillez fournir les deux faces de votre CIN.'
	String get missingDocuments => 'Veuillez fournir les deux faces de votre CIN.';

	/// fr: 'Veuillez accepter les conditions de traitement des données.'
	String get consentRequired => 'Veuillez accepter les conditions de traitement des données.';

	/// fr: 'Une erreur est survenue lors de la soumission. Veuillez réessayer.'
	String get generalError => 'Une erreur est survenue lors de la soumission. Veuillez réessayer.';

	/// fr: 'Faites vérifier votre profil'
	String get bannerNotSubmittedTitle => 'Faites vérifier votre profil';

	/// fr: 'Obtenez le badge officiel Artisan Vérifié pour renforcer la confiance et être prioritaire dans la recherche.'
	String get bannerNotSubmittedBody => 'Obtenez le badge officiel Artisan Vérifié pour renforcer la confiance et être prioritaire dans la recherche.';

	/// fr: 'Faire vérifier mon compte'
	String get bannerNotSubmittedCta => 'Faire vérifier mon compte';

	/// fr: 'Vérification en cours'
	String get bannerPendingTitle => 'Vérification en cours';

	/// fr: 'Votre pièce d'identité est en cours d'examen sous 24h ouvrées. Vous recevrez une notification dès validation.'
	String get bannerPendingBody => 'Votre pièce d\'identité est en cours d\'examen sous 24h ouvrées. Vous recevrez une notification dès validation.';

	/// fr: 'Profil Vérifié'
	String get bannerApprovedTitle => 'Profil Vérifié';

	/// fr: 'Votre identité a été certifiée. Votre badge officiel est visible sur votre vitrine et dans la recherche.'
	String get bannerApprovedBody => 'Votre identité a été certifiée. Votre badge officiel est visible sur votre vitrine et dans la recherche.';

	/// fr: 'Vérification non validée'
	String get bannerRejectedTitle => 'Vérification non validée';

	/// fr: 'Votre demande n'a pas pu être validée. Motif : {reason}'
	String get bannerRejectedBody => 'Votre demande n\'a pas pu être validée. Motif : {reason}';

	/// fr: 'Document illisible ou non conforme.'
	String get bannerRejectedDefaultReason => 'Document illisible ou non conforme.';

	/// fr: 'Soumettre à nouveau'
	String get bannerRejectedCta => 'Soumettre à nouveau';

	/// fr: 'Complément requis'
	String get bannerMoreInfoTitle => 'Complément requis';

	/// fr: 'Un complément d'information est nécessaire pour finaliser votre vérification : {reason}'
	String get bannerMoreInfoBody => 'Un complément d\'information est nécessaire pour finaliser votre vérification : {reason}';

	/// fr: 'Mettre à jour le dossier'
	String get bannerMoreInfoCta => 'Mettre à jour le dossier';

	/// fr: 'Vérification d'identité'
	String get profileTileTitle => 'Vérification d\'identité';
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

	/// fr: 'Espace pro'
	String get navPro => 'Espace pro';

	/// fr: 'Espace pro — Tableau de bord'
	String get navProDashboard => 'Espace pro — Tableau de bord';

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

	late final Translations$common$widgets$offlineBanner$fr offlineBanner = Translations$common$widgets$offlineBanner$fr.internal(_root);
}

// Path: common.nav
class Translations$common$nav$fr {
	Translations$common$nav$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Rechercher'
	String get searchTab => 'Rechercher';

	/// fr: 'Favoris'
	String get favoritesTab => 'Favoris';

	/// fr: 'Historique'
	String get historyTab => 'Historique';

	/// fr: 'Profil'
	String get profileTab => 'Profil';

	/// fr: 'Tableau de bord'
	String get dashboardTab => 'Tableau de bord';

	/// fr: 'Boosts'
	String get boostsTab => 'Boosts';

	/// fr: 'Avis'
	String get reviewsTab => 'Avis';

	/// fr: 'Passer en mode client'
	String get switchToClient => 'Passer en mode client';

	/// fr: 'Passer en mode pro'
	String get switchToPro => 'Passer en mode pro';

	/// fr: 'Appuyez à nouveau pour quitter'
	String get exitConfirmation => 'Appuyez à nouveau pour quitter';
}

// Path: common.devPreview
class Translations$common$devPreview$fr {
	Translations$common$devPreview$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'AppButton'
	String get sectionAppButton => 'AppButton';

	/// fr: 'AppCard'
	String get sectionAppCard => 'AppCard';

	/// fr: 'AppTextField'
	String get sectionAppTextField => 'AppTextField';

	/// fr: 'RatingStars'
	String get sectionRatingStars => 'RatingStars';

	/// fr: 'VerifiedBadge'
	String get sectionVerifiedBadge => 'VerifiedBadge';

	/// fr: 'ProviderCard'
	String get sectionProviderCard => 'ProviderCard';

	/// fr: 'AppSkeleton'
	String get sectionAppSkeleton => 'AppSkeleton';

	/// fr: 'EmptyState'
	String get sectionEmptyState => 'EmptyState';

	/// fr: 'ErrorState'
	String get sectionErrorState => 'ErrorState';

	/// fr: 'OfflineBanner'
	String get sectionOfflineBanner => 'OfflineBanner';

	/// fr: 'AppBottomNav'
	String get sectionAppBottomNav => 'AppBottomNav';

	/// fr: 'Primary'
	String get buttonPrimary => 'Primary';

	/// fr: 'Disabled'
	String get buttonDisabled => 'Disabled';

	/// fr: 'Secondary'
	String get buttonSecondary => 'Secondary';

	/// fr: 'Ghost'
	String get buttonGhost => 'Ghost';

	/// fr: 'WhatsApp'
	String get buttonWhatsapp => 'WhatsApp';

	/// fr: 'WhatsApp (contour)'
	String get buttonOutlineWhatsapp => 'WhatsApp (contour)';

	/// fr: 'Danger'
	String get buttonDanger => 'Danger';

	/// fr: 'Numéro de téléphone'
	String get phoneLabel => 'Numéro de téléphone';

	/// fr: '+216 22 123 456'
	String get phoneHint => '+216 22 123 456';

	/// fr: 'Code de vérification'
	String get otpLabel => 'Code de vérification';

	/// fr: 'Code incorrect — il vous reste 2 tentatives'
	String get otpError => 'Code incorrect — il vous reste 2 tentatives';

	/// fr: 'Karim Ben Salah'
	String get sampleProvider1Name => 'Karim Ben Salah';

	/// fr: 'Plomberie'
	String get sampleProvider1Category => 'Plomberie';

	/// fr: 'Sousse, Khezama · 2,4 km'
	String get sampleProvider1Location => 'Sousse, Khezama · 2,4 km';

	/// fr: 'à partir de 40 TND'
	String get sampleProvider1Price => 'à partir de 40 TND';

	/// fr: 'Hédi Ferjani'
	String get sampleProvider2Name => 'Hédi Ferjani';

	/// fr: 'Peinture'
	String get sampleProvider2Category => 'Peinture';

	/// fr: 'Monastir'
	String get sampleProvider2Location => 'Monastir';

	/// fr: 'à partir de 25 TND'
	String get sampleProvider2Price => 'à partir de 25 TND';

	/// fr: 'Aucun artisan trouvé'
	String get emptyTitle => 'Aucun artisan trouvé';

	/// fr: 'Aucun plombier disponible à Mahdia pour ces filtres.'
	String get emptyMessage => 'Aucun plombier disponible à Mahdia pour ces filtres.';

	/// fr: 'Élargir au gouvernorat'
	String get emptyAction => 'Élargir au gouvernorat';

	/// fr: 'Connexion perdue'
	String get errorTitle => 'Connexion perdue';

	/// fr: 'Impossible de charger les résultats. Vérifie ta connexion.'
	String get errorMessage => 'Impossible de charger les résultats. Vérifie ta connexion.';

	/// fr: 'Réessayer'
	String get errorAction => 'Réessayer';

	/// fr: 'Rôles de couleur'
	String get sectionColorRoles => 'Rôles de couleur';

	/// fr: 'Clair'
	String get swatchLight => 'Clair';

	/// fr: 'Sombre'
	String get swatchDark => 'Sombre';

	/// fr: 'Typographie'
	String get sectionTypography => 'Typographie';

	/// fr: 'AvailabilityChip'
	String get sectionAvailabilityChip => 'AvailabilityChip';

	/// fr: 'ReviewTile'
	String get sectionReviewTile => 'ReviewTile';

	/// fr: 'OfferingCard'
	String get sectionOfferingCard => 'OfferingCard';

	/// fr: 'ProviderGallery'
	String get sectionProviderGallery => 'ProviderGallery';

	/// fr: 'DashboardStatCard'
	String get sectionDashboardStatCard => 'DashboardStatCard';

	/// fr: 'DashboardTrendChart'
	String get sectionDashboardTrendChart => 'DashboardTrendChart';

	/// fr: 'DashboardComparisonChip'
	String get sectionDashboardComparisonChip => 'DashboardComparisonChip';

	/// fr: 'RatingStarsInput'
	String get sectionRatingStarsInput => 'RatingStarsInput';

	/// fr: 'OtpCodeField'
	String get sectionOtpCodeField => 'OtpCodeField';

	/// fr: 'CoverageAreaChip'
	String get sectionCoverageAreaChip => 'CoverageAreaChip';

	/// fr: 'CategoryGrid'
	String get sectionCategoryGrid => 'CategoryGrid';

	/// fr: 'CategoryGridSkeleton'
	String get sectionCategoryGridSkeleton => 'CategoryGridSkeleton';

	/// fr: 'FavoriteCardSkeleton'
	String get sectionFavoriteCardSkeleton => 'FavoriteCardSkeleton';

	/// fr: 'Vues du profil'
	String get statViewsLabel => 'Vues du profil';

	/// fr: 'Nouveau'
	String get statNewLabel => 'Nouveau';
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

	/// fr: 'Chargement impossible'
	String get reviewsErrorTitle => 'Chargement impossible';

	/// fr: 'Impossible de charger les avis.'
	String get reviewsError => 'Impossible de charger les avis.';

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

	/// fr: 'Chargement impossible'
	String get errorLoadTitle => 'Chargement impossible';

	/// fr: 'Impossible de charger la fiche.'
	String get errorLoad => 'Impossible de charger la fiche.';

	/// fr: 'Réessayer'
	String get retry => 'Réessayer';

	/// fr: 'Donner mon avis'
	String get writeReview => 'Donner mon avis';

	/// fr: 'Votre avis sur cet artisan'
	String get reviewTitle => 'Votre avis sur cet artisan';

	/// fr: 'Votre note'
	String get ratingLabel => 'Votre note';

	/// fr: '{n} étoile(s)'
	String get ratingStarSemanticLabel => '{n} étoile(s)';

	/// fr: 'Veuillez sélectionner une note de 1 à 5 étoiles'
	String get ratingRequired => 'Veuillez sélectionner une note de 1 à 5 étoiles';

	/// fr: 'Votre commentaire (optionnel)'
	String get commentLabel => 'Votre commentaire (optionnel)';

	/// fr: 'Partagez votre expérience avec cet artisan...'
	String get commentHint => 'Partagez votre expérience avec cet artisan...';

	/// fr: 'Publier l'avis'
	String get submitReview => 'Publier l\'avis';

	/// fr: 'Publication en cours...'
	String get submittingReview => 'Publication en cours...';

	/// fr: 'Merci ! Votre avis a été publié.'
	String get reviewSuccess => 'Merci ! Votre avis a été publié.';

	/// fr: 'Vous devez avoir contacté cet artisan pour pouvoir laisser un avis.'
	String get reviewRequiresContact => 'Vous devez avoir contacté cet artisan pour pouvoir laisser un avis.';

	/// fr: 'Vous ne pouvez pas évaluer votre propre profil.'
	String get reviewSelfForbidden => 'Vous ne pouvez pas évaluer votre propre profil.';

	/// fr: 'Impossible de publier votre avis. Veuillez réessayer.'
	String get reviewGenericError => 'Impossible de publier votre avis. Veuillez réessayer.';

	/// fr: 'Vous devez être connecté pour laisser un avis.'
	String get reviewLoginRequired => 'Vous devez être connecté pour laisser un avis.';

	/// fr: 'Avez-vous fait appel à cet artisan ?'
	String get reviewPromptTitle => 'Avez-vous fait appel à cet artisan ?';

	/// fr: 'Partagez votre avis pour aider la communauté.'
	String get reviewPromptSubtitle => 'Partagez votre avis pour aider la communauté.';

	/// fr: 'Laisser un avis'
	String get reviewPromptCta => 'Laisser un avis';

	/// fr: 'Connexion requise'
	String get authRequiredTitle => 'Connexion requise';

	/// fr: 'Connectez-vous pour donner votre avis sur cet artisan.'
	String get authRequiredSubtitle => 'Connectez-vous pour donner votre avis sur cet artisan.';

	/// fr: 'Se connecter ou s'inscrire'
	String get loginCta => 'Se connecter ou s\'inscrire';
}

// Path: common.widgets.offlineBanner
class Translations$common$widgets$offlineBanner$fr {
	Translations$common$widgets$offlineBanner$fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tu consultes des résultats enregistrés. Ils seront actualisés au retour du réseau.'
	String get message => 'Tu consultes des résultats enregistrés. Ils seront actualisés au retour du réseau.';

	/// fr: 'Compris'
	String get dismiss => 'Compris';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.phoneTitle' => 'Votre numéro de téléphone',
			'auth.phoneSubtitle' => 'Nous vous enverrons un code de vérification par SMS',
			'auth.phoneHint' => '22 123 456',
			'auth.legalConsent' => 'En continuant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité',
			'auth.phoneInvalid' => 'Numéro de téléphone tunisien invalide',
			'auth.phoneCta' => 'Recevoir le code',
			'auth.otpDigitLabel' => 'Chiffre {n} sur {total}',
			'auth.otpTitle' => 'Code de vérification',
			'auth.otpSubtitle' => 'Un code à 6 chiffres a été envoyé au {phone}',
			'auth.otpCta' => 'Confirmer',
			'auth.otpResend' => 'Renvoyer le code',
			'auth.otpResendCountdown' => 'Renvoyer le code ({mmss})',
			'auth.otpAttemptsRemaining' => 'Code invalide, {count} tentative(s) restante(s)',
			'auth.errorOtpInvalid' => 'Code invalide',
			'auth.errorOtpExpired' => 'Ce code a expiré, demandez-en un nouveau',
			'auth.errorOtpTooManyAttempts' => 'Trop de tentatives, demandez un nouveau code',
			'auth.errorRateLimitExceeded' => 'Trop de demandes, réessayez plus tard',
			'auth.errorValidation' => 'Numéro de téléphone invalide',
			'auth.errorGeneric' => 'Une erreur est survenue, réessayez',
			'billing.creditsBalance' => 'Solde de crédits',
			'billing.creditsCount' => ({required Object count}) => '${count} crédits',
			'billing.buyCredits' => 'Acheter',
			'billing.boostSectionTitle' => 'Activer un boost',
			'billing.boostSectionSubtitle' => 'Mettez en avant votre profil en tête des résultats de recherche.',
			'billing.boostOption24h' => 'Boost 24 heures',
			'billing.boostOption24hDesc' => 'Visibilité maximale pour un pic d\'activité immédiat',
			'billing.boostOption7d' => 'Boost 7 jours',
			'billing.boostOption7dDesc' => 'Présence renforcée et continue toute la semaine',
			'billing.boostOptionPrice24h' => '10 crédits',
			'billing.boostOptionPrice7d' => '50 crédits',
			'billing.sponsoredTag' => 'Sponsorisé',
			'billing.activateBoostCta' => 'Activer le boost',
			'billing.featureUpcomingTitle' => 'Bientôt disponible',
			'billing.featureUpcomingMessage' => 'Le système d\'achat de crédits et d\'activation de boosts sera disponible dans une prochaine mise à jour.',
			'billing.clientSpace' => 'Client',
			'billing.proSpace' => 'Pro',
			'billing.dialogDismiss' => 'Compris',
			'boosts.title' => 'Boosts',
			'boosts.emptyTitle' => 'Boosts bientôt disponibles',
			'boosts.emptyMessage' => 'Mettez en avant votre profil dans les résultats de recherche dès que cette fonctionnalité sera prête.',
			'common.appName' => 'Sanaya',
			'common.home.navAuth' => 'Espace authentification — à venir (FM-05)',
			'common.home.navClient' => 'Espace client',
			'common.home.navPro' => 'Espace pro',
			'common.home.navProDashboard' => 'Espace pro — Tableau de bord',
			'common.home.toggleTheme' => 'Basculer thème clair/sombre',
			'common.home.toggleLocale' => 'Basculer FR/AR',
			'common.home.designSystemPreview' => 'Vitrine design system',
			'common.widgets.verifiedBadge' => 'Vérifié',
			'common.widgets.offlineBanner.message' => 'Tu consultes des résultats enregistrés. Ils seront actualisés au retour du réseau.',
			'common.widgets.offlineBanner.dismiss' => 'Compris',
			'common.nav.searchTab' => 'Rechercher',
			'common.nav.favoritesTab' => 'Favoris',
			'common.nav.historyTab' => 'Historique',
			'common.nav.profileTab' => 'Profil',
			'common.nav.dashboardTab' => 'Tableau de bord',
			'common.nav.boostsTab' => 'Boosts',
			'common.nav.reviewsTab' => 'Avis',
			'common.nav.switchToClient' => 'Passer en mode client',
			'common.nav.switchToPro' => 'Passer en mode pro',
			'common.nav.exitConfirmation' => 'Appuyez à nouveau pour quitter',
			'common.devPreview.sectionAppButton' => 'AppButton',
			'common.devPreview.sectionAppCard' => 'AppCard',
			'common.devPreview.sectionAppTextField' => 'AppTextField',
			'common.devPreview.sectionRatingStars' => 'RatingStars',
			'common.devPreview.sectionVerifiedBadge' => 'VerifiedBadge',
			'common.devPreview.sectionProviderCard' => 'ProviderCard',
			'common.devPreview.sectionAppSkeleton' => 'AppSkeleton',
			'common.devPreview.sectionEmptyState' => 'EmptyState',
			'common.devPreview.sectionErrorState' => 'ErrorState',
			'common.devPreview.sectionOfflineBanner' => 'OfflineBanner',
			'common.devPreview.sectionAppBottomNav' => 'AppBottomNav',
			'common.devPreview.buttonPrimary' => 'Primary',
			'common.devPreview.buttonDisabled' => 'Disabled',
			'common.devPreview.buttonSecondary' => 'Secondary',
			'common.devPreview.buttonGhost' => 'Ghost',
			'common.devPreview.buttonWhatsapp' => 'WhatsApp',
			'common.devPreview.buttonOutlineWhatsapp' => 'WhatsApp (contour)',
			'common.devPreview.buttonDanger' => 'Danger',
			'common.devPreview.phoneLabel' => 'Numéro de téléphone',
			'common.devPreview.phoneHint' => '+216 22 123 456',
			'common.devPreview.otpLabel' => 'Code de vérification',
			'common.devPreview.otpError' => 'Code incorrect — il vous reste 2 tentatives',
			'common.devPreview.sampleProvider1Name' => 'Karim Ben Salah',
			'common.devPreview.sampleProvider1Category' => 'Plomberie',
			'common.devPreview.sampleProvider1Location' => 'Sousse, Khezama · 2,4 km',
			'common.devPreview.sampleProvider1Price' => 'à partir de 40 TND',
			'common.devPreview.sampleProvider2Name' => 'Hédi Ferjani',
			'common.devPreview.sampleProvider2Category' => 'Peinture',
			'common.devPreview.sampleProvider2Location' => 'Monastir',
			'common.devPreview.sampleProvider2Price' => 'à partir de 25 TND',
			'common.devPreview.emptyTitle' => 'Aucun artisan trouvé',
			'common.devPreview.emptyMessage' => 'Aucun plombier disponible à Mahdia pour ces filtres.',
			'common.devPreview.emptyAction' => 'Élargir au gouvernorat',
			'common.devPreview.errorTitle' => 'Connexion perdue',
			'common.devPreview.errorMessage' => 'Impossible de charger les résultats. Vérifie ta connexion.',
			'common.devPreview.errorAction' => 'Réessayer',
			'common.devPreview.sectionColorRoles' => 'Rôles de couleur',
			'common.devPreview.swatchLight' => 'Clair',
			'common.devPreview.swatchDark' => 'Sombre',
			'common.devPreview.sectionTypography' => 'Typographie',
			'common.devPreview.sectionAvailabilityChip' => 'AvailabilityChip',
			'common.devPreview.sectionReviewTile' => 'ReviewTile',
			'common.devPreview.sectionOfferingCard' => 'OfferingCard',
			'common.devPreview.sectionProviderGallery' => 'ProviderGallery',
			'common.devPreview.sectionDashboardStatCard' => 'DashboardStatCard',
			'common.devPreview.sectionDashboardTrendChart' => 'DashboardTrendChart',
			'common.devPreview.sectionDashboardComparisonChip' => 'DashboardComparisonChip',
			'common.devPreview.sectionRatingStarsInput' => 'RatingStarsInput',
			'common.devPreview.sectionOtpCodeField' => 'OtpCodeField',
			'common.devPreview.sectionCoverageAreaChip' => 'CoverageAreaChip',
			'common.devPreview.sectionCategoryGrid' => 'CategoryGrid',
			'common.devPreview.sectionCategoryGridSkeleton' => 'CategoryGridSkeleton',
			'common.devPreview.sectionFavoriteCardSkeleton' => 'FavoriteCardSkeleton',
			'common.devPreview.statViewsLabel' => 'Vues du profil',
			'common.devPreview.statNewLabel' => 'Nouveau',
			'contact.call' => 'Appeler',
			'contact.whatsapp' => 'WhatsApp',
			'dashboard.title' => 'Tableau de bord',
			'dashboard.greeting' => ({required Object name}) => 'Bonjour, ${name}',
			'dashboard.statViews' => 'Vues du profil',
			'dashboard.statUniqueViews' => 'Visiteurs uniques',
			'dashboard.statContacts' => 'Contacts',
			'dashboard.statRatio' => 'Vue → contact',
			'dashboard.comparisonPreviousPeriod' => 'vs. 15 jours précédents',
			'dashboard.comparisonNew' => 'Nouveau',
			'dashboard.chartTitle' => 'Vues sur 30 jours',
			'dashboard.chartTitle7d' => 'Vues sur 7 jours',
			'dashboard.chartContactsLabel' => 'Contacts',
			'dashboard.chartViewsLabel' => 'Vues',
			'dashboard.emptyTitle' => 'Aucune vue pour l\'instant',
			'dashboard.emptyMessage' => 'Complétez votre profil pour apparaître dans les résultats de recherche.',
			'dashboard.retry' => 'Réessayer',
			'dashboard.errorTitle' => 'Impossible de charger le tableau de bord',
			'dashboard.errorMessage' => 'Vérifiez votre connexion et réessayez.',
			'dashboard.quickActionsTitle' => 'Actions rapides',
			'dashboard.actionShare' => 'Partager',
			'dashboard.actionPublicProfile' => 'Ma vitrine',
			'dashboard.actionBoost' => 'Booster',
			'dashboard.actionEditProfile' => 'Mon profil',
			'dashboard.profileLinkCopied' => 'Lien de votre profil copié dans le presse-papier',
			'dashboard.channelsTitle' => 'Répartition des contacts',
			'dashboard.channelsSubtitle' => 'Canaux utilisés par vos clients',
			'dashboard.channelPhone' => 'Appels directs',
			'dashboard.channelWhatsapp' => 'Messages WhatsApp',
			'dashboard.recentActivityTitle' => 'Activité récente & demandes',
			'dashboard.recentActivitySubtitle' => 'Dernières interactions reçues',
			'dashboard.recentLeadWhatsappTitle' => 'Demande WhatsApp reçue',
			'dashboard.recentLeadWhatsappDesc' => 'Plomberie & sanitaires • Sousse (Khzema)',
			'dashboard.recentLeadPhoneTitle' => 'Appel direct reçu',
			'dashboard.recentLeadPhoneDesc' => 'Dépannage électrique urgent • Monastir',
			'dashboard.recentLeadReviewTitle' => 'Nouvel avis 5 étoiles',
			'dashboard.recentLeadReviewDesc' => '« Ponctuel et travail propre ! » • Karim B.',
			'dashboard.time2hAgo' => 'Il y a 2h',
			'dashboard.time5hAgo' => 'Il y a 5h',
			'dashboard.timeYesterday' => 'Hier',
			'dashboard.reputationTitle' => 'Avis & Réputation',
			'dashboard.reputationRating' => ({required Object rating}) => '${rating} sur 5',
			'dashboard.reputationCount' => ({required Object count}) => '${count} avis vérifiés',
			'dashboard.reputationBadge' => 'Artisan Recommandé au Sahel',
			'dashboard.reputationLatestReview' => '« Excellent travail, ponctuel et très professionnel pour l\'installation du tableau électrique. »',
			'dashboard.reputationAuthor' => '— Karim B., Sousse',
			'dashboard.reputationSeeAll' => 'Consulter tous les avis',
			'dashboard.boostBannerTitle' => 'Multipliez vos demandes par 3',
			'dashboard.boostBannerSubtitle' => 'Apparaissez en tête des résultats de recherche à Sousse et Monastir.',
			'dashboard.boostBannerCta' => 'Découvrir les Boosts',
			'dashboard.proTipsTitle' => 'Conseils pour votre activité',
			'dashboard.tipResponsivenessTitle' => 'Réactivité maximale',
			'dashboard.tipResponsivenessDesc' => 'Répondre aux appels et messages dans les 15 minutes double le taux de confirmation de chantier.',
			'dashboard.tipPhotosTitle' => 'Ajoutez des photos de chantiers',
			'dashboard.tipPhotosDesc' => 'Les fiches avec des photos de réalisations génèrent jusqu\'à 70% de contacts en plus.',
			'errors.routeNotFoundTitle' => 'Page introuvable',
			'errors.routeNotFoundMessage' => 'Cette page n\'existe pas ou n\'est plus disponible.',
			'errors.routeNotFoundAction' => 'Retour à l\'accueil',
			'errors.validationLimit' => 'Limite atteinte : maximum {limit}.',
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
			'favorites.errorTitle' => 'Chargement impossible',
			'favorites.loadError' => 'Impossible de charger vos favoris.',
			'favorites.retry' => 'Réessayer',
			'favorites.verifiedBadge' => 'Vérifié',
			'favorites.authRequiredTitle' => 'Retrouvez vos artisans favoris',
			'favorites.authRequiredSubtitle' => 'Connectez-vous pour enregistrer des artisans et les retrouver facilement.',
			'favorites.loginCta' => 'Se connecter ou s\'inscrire',
			'history.title' => 'Historique',
			'history.emptyTitle' => 'Aucun artisan contacté',
			'history.emptyMessage' => 'Les artisans que vous contactez apparaîtront ici, avec un raccourci pour laisser un avis.',
			'history.emptyCta' => 'Rechercher',
			'history.loadError' => 'Impossible de charger votre historique.',
			'history.retry' => 'Réessayer',
			'history.reviewCta' => 'Laisser un avis',
			'history.channelPhone' => 'Appel',
			'history.channelWhatsapp' => 'WhatsApp',
			'history.authRequiredTitle' => 'Consultez votre historique',
			'history.authRequiredSubtitle' => 'Connectez-vous pour retrouver tous les artisans que vous avez contactés.',
			'history.loginCta' => 'Se connecter ou s\'inscrire',
			'legal.title' => 'Mentions légales',
			'legal.editorTitle' => 'Éditeur de la plateforme',
			'legal.editorContent' => 'Sanaya — Plateforme de mise en relation entre particuliers et artisans tunisiens (Sahel : Sousse, Monastir, Mahdia).',
			'legal.modelTitle' => 'Modèle de service',
			'legal.modelContent' => 'Sanaya est un service de génération de contacts qualifiés. La plateforme n\'encaisse jamais le montant des prestations et n\'intervient pas dans le paiement direct du chantier.',
			'legal.inpdpTitle' => 'Protection des données personnelles (INPDP)',
			'legal.inpdpContent' => 'Conformément à la loi organique n° 2004-63, Sanaya s\'engage à protéger la vie privée de ses utilisateurs. Les numéros de téléphone ne sont révélés que lors d\'une mise en relation volontaire et tracée.',
			'legal.rightsTitle' => 'Vos droits',
			'legal.rightsContent' => 'Vous disposez d\'un droit d\'accès, de rectification et de suppression de vos données personnelles à tout moment.',
			'onboarding.wizardTitle' => 'Devenir prestataire',
			'onboarding.back' => 'Retour',
			'onboarding.next' => 'Suivant',
			'onboarding.retry' => 'Réessayer',
			'onboarding.stepProfile' => 'Profil',
			'onboarding.stepCategories' => 'Catégories',
			'onboarding.stepZones' => 'Zones',
			'onboarding.stepPhotos' => 'Photos',
			'onboarding.stepSummary' => 'Récapitulatif',
			'onboarding.stepIndicator' => 'Étape {current} sur {total}',
			'onboarding.profileBusinessName' => 'Nom de l\'activité',
			'onboarding.profileHeadline' => 'Titre (ex. Plombier certifié)',
			'onboarding.profileBio' => 'Présentation (au moins 50 caractères)',
			'onboarding.profileYearsExperience' => 'Années d\'expérience',
			'onboarding.profileWhatsapp' => 'Téléphone WhatsApp',
			'onboarding.profilePublicPhone' => 'Téléphone public',
			'onboarding.profileGovernorate' => 'Gouvernorat de rattachement',
			'onboarding.profileGovernorateError' => 'Impossible de charger les gouvernorats.',
			'onboarding.profileSaveError' => 'Impossible d\'enregistrer le profil. Réessayez.',
			'onboarding.categoriesTitle' => 'Choisissez vos catégories',
			'onboarding.categoriesPrimaryHint' => 'Principale',
			'onboarding.categoriesEmpty' => 'Sélectionnez au moins une catégorie.',
			'onboarding.categoriesError' => 'Impossible de charger les catégories.',
			'onboarding.categoriesErrorMessage' => 'Vérifiez votre connexion et réessayez.',
			'onboarding.categoriesSaveError' => 'Impossible d\'enregistrer les catégories. Réessayez.',
			'onboarding.categoriesCapHint' => '3 catégories maximum en offre gratuite',
			'onboarding.zonesTitle' => 'Choisissez vos zones d\'intervention',
			'onboarding.zonesCapHint' => '1 gouvernorat maximum en offre gratuite',
			'onboarding.zonesEmpty' => 'Sélectionnez au moins un gouvernorat.',
			'onboarding.zonesError' => 'Impossible de charger les gouvernorats.',
			'onboarding.zonesErrorMessage' => 'Vérifiez votre connexion et réessayez.',
			'onboarding.zonesSaveError' => 'Impossible d\'enregistrer les zones. Réessayez.',
			'onboarding.photosTitle' => 'Ajoutez des photos de vos réalisations',
			'onboarding.photosCapHint' => '5 photos maximum en offre gratuite',
			'onboarding.photosCapReached' => 'Plafond de 5 photos atteint (offre gratuite).',
			'onboarding.photosAdd' => 'Ajouter une photo',
			'onboarding.photosDelete' => 'Supprimer cette photo',
			'onboarding.photosUploadFailed' => 'Échec de l\'envoi',
			'onboarding.summaryTitle' => 'Récapitulatif',
			'onboarding.summaryCompletionLabel' => 'Profil complet à {score} %',
			'onboarding.summaryMissingTitle' => 'Il manque encore :',
			'onboarding.summaryPublish' => 'Publier mon profil',
			'onboarding.summaryPublishError' => 'Publication impossible. Réessayez.',
			'onboarding.summaryPublished' => 'Profil publié !',
			'onboarding.missingBio' => 'Ajouter une description de 50 caractères min',
			'onboarding.missingHeadline' => 'Ajouter un titre professionnel',
			'onboarding.missingYearsExperience' => 'Indiquer vos années d\'expérience',
			'onboarding.missingContactPhone' => 'Ajouter un numéro WhatsApp ou public',
			'onboarding.missingCategories' => 'Sélectionner au moins une catégorie',
			'onboarding.missingCoverageAreas' => 'Sélectionner au moins un gouvernorat',
			'onboarding.missingPhotos' => 'Ajouter des photos de vos réalisations',
			'onboarding.missingActionHint' => 'Modifier dans l\'étape {step}',
			'onboarding.summaryScoreCritical' => 'Profil incomplet — publication impossible (< 40 %)',
			'onboarding.summaryScoreWarning' => 'Encore un effort pour atteindre le seuil de publication (60 %)',
			'onboarding.summaryScoreSuccess' => 'Seuil de publication atteint (≥ 60 %)',
			'onboarding.clientWelcomeTitle' => 'Bienvenue sur Sanaya',
			'onboarding.clientWelcomeSubtitle' => 'Trouvez les meilleurs artisans au Sahel tunisien en toute confiance.',
			'onboarding.clientStep1Title' => 'Trouvez l\'artisan idéal',
			'onboarding.clientStep1Desc' => 'Plombiers, électriciens, peintres, climatiseurs... Des professionnels qualifiés et disponibles près de chez vous.',
			'onboarding.clientStep2Title' => 'Confiance & Avis vérifiés',
			'onboarding.clientStep2Desc' => 'Artisans vérifiés par pièce d\'identité (CIN) et avis authentiques déposés uniquement après contact réel.',
			'onboarding.clientStep3Title' => 'Contact direct & 100% gratuit',
			'onboarding.clientStep3Desc' => 'Appel ou WhatsApp direct sans commission ni intermédiaire. Vous convenez du chantier directement avec l\'artisan.',
			'onboarding.clientChooseGovernorate' => 'Votre gouvernorat de recherche :',
			'onboarding.clientStartExploring' => 'Commencer à chercher',
			'onboarding.clientSkip' => 'Passer l\'introduction',
			'onboarding.celebrationTitle' => 'Mabrouk ! Votre profil est en ligne',
			'onboarding.celebrationSubtitle' => 'Votre profil est désormais visible par tous les clients de votre région de couverture. Vous pouvez commencer à recevoir des demandes de contact.',
			'onboarding.celebrationKycCardTitle' => 'Multipliez par 3 vos contacts grâce au Badge Vérifié',
			'onboarding.celebrationKycCardDescription' => 'Les artisans dont l\'identité est confirmée par leur carte d\'identité (CIN) inspirent davantage confiance et apparaissent en tête des résultats de recherche. La démarche est 100 % gratuite et prend moins de 2 minutes.',
			'onboarding.celebrationKycBenefitBadge' => 'Badge officiel « Artisan Vérifié » sur votre profil',
			'onboarding.celebrationKycBenefitRank' => 'Priorité d\'affichage dans les résultats de recherche',
			'onboarding.celebrationKycBenefitFast' => 'Validation sous 24 h ouvrées',
			'onboarding.celebrationCtaVerify' => 'Faire vérifier mon identité maintenant',
			'onboarding.celebrationCtaDashboard' => 'Accéder à mon tableau de bord',
			'proProfile.title' => 'Profil',
			'proProfile.emptyTitle' => 'Profil introuvable',
			'proProfile.emptyMessage' => 'Aucun profil artisan n\'est associé à ce compte.',
			'proProfile.switchToClientSpace' => 'Retour à l\'espace Client',
			'proProfile.errorTitle' => 'Impossible de charger votre profil',
			'proProfile.errorMessage' => 'Vérifiez votre connexion et réessayez.',
			'proProfile.retry' => 'Réessayer',
			'proProfile.availabilitySection' => 'Disponibilité',
			'proProfile.acceptsEmergencyLabel' => 'Accepte les urgences',
			'proProfile.acceptsEmergencyDescription' => 'Affiche le badge Urgence dans les résultats de recherche',
			'proProfile.editSection' => 'Modifier mon profil',
			'proProfile.save' => 'Enregistrer',
			'proProfile.saveSuccess' => 'Profil mis à jour',
			'proProfile.viewMyListing' => 'Voir ma fiche telle que la voit un client',
			'proProfile.completionTitle' => 'Complétude du profil',
			'proProfile.completionLabel' => 'Profil complété à {score} %',
			'proProfile.completionTip' => 'Un profil complet reçoit en moyenne 3 fois plus de contacts.',
			'proProfile.relaunchOnboarding' => 'Modifier via l\'assistant complet',
			'proProfile.yearsExperience' => '{years} ans d\'expérience',
			'proProfile.verifiedBadge' => 'Artisan Vérifié',
			'proProfile.unverifiedBadge' => 'Vérification en attente',
			'proProfile.statsViews' => 'Vues de profil',
			'proProfile.statsContacts' => 'Contacts reçus',
			'proProfile.statsRating' => 'Note moyenne',
			'proProfile.publicPreviewTitle' => 'Vitrine publique',
			'proProfile.publicPreviewSubtitle' => 'Consultez votre fiche telle qu\'elle apparaît pour vos futurs clients',
			'proProfile.portfolioSection' => 'Galerie & Réalisations',
			'proProfile.portfolioDesc' => 'Photos de vos réalisations et chantiers',
			'proProfile.categoriesAndZones' => 'Métiers & Zones d\'intervention',
			'proProfile.categoriesSection' => 'Mes Métiers & Spécialités',
			'proProfile.categoriesDesc' => 'Gérez vos corps de métier et votre spécialité principale',
			'proProfile.categoriesUpdated' => 'Métiers mis à jour avec succès',
			'proProfile.categoriesEmpty' => 'Aucun métier configuré',
			'proProfile.zonesSection' => 'Zones d\'intervention',
			'proProfile.zonesDesc' => 'Gouvernorats couverts par vos déplacements',
			'proProfile.zonesUpdated' => 'Zones d\'intervention mises à jour avec succès',
			'proProfile.zonesEmpty' => 'Aucune zone configurée',
			'proProfile.editCategories' => 'Modifier mes métiers',
			'proProfile.editZones' => 'Modifier mes zones',
			'proProfile.availabilityUpdated' => 'Disponibilité mise à jour',
			'proProfile.testOnboardingPro' => 'Tester l\'onboarding Pro',
			'proProfile.testOnboardingClient' => 'Tester l\'onboarding Particulier',
			'proProfile.portfolioQuota' => '{count} / {max} photos',
			'proProfile.portfolioAddPhoto' => 'Ajouter une réalisation',
			'proProfile.portfolioEmpty' => 'Aucune photo de réalisation pour le moment',
			'proProfile.portfolioDeleteTitle' => 'Supprimer cette réalisation ?',
			'proProfile.portfolioDeleteMessage' => 'Cette photo sera retirée définitivement de votre vitrine publique.',
			'proProfile.portfolioDeleteConfirm' => 'Supprimer',
			'proProfile.portfolioCancel' => 'Annuler',
			'proProfile.portfolioDeleted' => 'Photo retirée du portfolio',
			'proProfile.portfolioAdded' => 'Photo ajoutée à vos réalisations',
			'proProfile.portfolioUploadError' => 'Échec du téléversement de la photo',
			'proProfile.portfolioCaptionLabel' => 'Légende (optionnel)',
			'proProfile.portfolioCategoryLabel' => 'Métier associé (optionnel)',
			'proProfile.portfolioMaxReached' => 'Limite de {max} photos atteinte (offre gratuite)',
			'proProfile.offeringsSection' => 'Mes Prestations & Tarifs indicatifs',
			'proProfile.offeringsDesc' => 'Présentez vos forfaits types pour donner des repères à vos futurs clients',
			'proProfile.offeringsAdd' => 'Ajouter une prestation',
			'proProfile.offeringsEmpty' => 'Aucune prestation renseignée. Ajoutez vos tarifs types !',
			'proProfile.offeringsNegotiable' => 'Négociable',
			'proProfile.offeringsEdit' => 'Modifier',
			'proProfile.offeringsDelete' => 'Supprimer',
			'proProfile.offeringsDeleteTitle' => 'Supprimer cette prestation ?',
			'proProfile.offeringsDeleteMessage' => 'Cette offre ne sera plus visible sur votre fiche artisan.',
			'proProfile.offeringsDeleteConfirm' => 'Supprimer',
			'proProfile.offeringsDeleted' => 'Prestation supprimée',
			'proProfile.offeringsSaved' => 'Prestation enregistrée avec succès',
			'proProfile.offeringTitleFr' => 'Titre de la prestation (Français)',
			'proProfile.offeringTitleAr' => 'Titre en Arabe (optionnel)',
			'proProfile.offeringDescription' => 'Description détaillée (optionnel)',
			'proProfile.offeringCategory' => 'Corps de métier',
			'proProfile.offeringPriceMin' => 'Prix minimum (DT)',
			'proProfile.offeringPriceMax' => 'Prix maximum (DT)',
			'proProfile.offeringPriceUnit' => 'Unité de tarification',
			'proProfile.unitFixed' => 'Au forfait',
			'proProfile.unitHour' => 'Par heure',
			'proProfile.unitDay' => 'Par jour',
			'proProfile.unitSquareMeter' => 'Par m²',
			'proProfile.unitOnQuote' => 'Sur devis uniquement',
			'proProfile.offeringNegotiableSwitch' => 'Tarif négociable selon le chantier',
			'profile.title' => 'Profil',
			'profile.accountFallback' => 'Mon compte',
			'profile.switchToProSpace' => 'Passer en espace Pro',
			'profile.guestName' => 'Invité',
			'profile.guestSubtitle' => 'Non connecté',
			'profile.loginCta' => 'Se connecter ou s\'inscrire',
			'profile.becomeProTitle' => 'Devenir artisan sur Sanaya',
			'profile.becomeProSubtitle' => 'Vous êtes artisan ou professionnel du bâtiment ? Proposez vos services et trouvez de nouveaux clients.',
			'profile.becomeProButton' => 'Créer mon profil artisan',
			'provider.profile.callButton' => 'Appeler',
			'provider.profile.whatsappButton' => 'WhatsApp',
			'provider.profile.reviewsTitle' => 'Avis',
			'provider.profile.loadMoreReviews' => 'Charger plus d\'avis',
			'provider.profile.noReviews' => 'Aucun avis pour le moment.',
			'provider.profile.reviewsErrorTitle' => 'Chargement impossible',
			'provider.profile.reviewsError' => 'Impossible de charger les avis.',
			'provider.profile.offeringsTitle' => 'Prestations',
			'provider.profile.coverageTitle' => 'Zones d\'intervention',
			'provider.profile.yearsExperience' => '{n} an(s) d\'expérience',
			'provider.profile.availableNow' => 'Disponible',
			'provider.profile.busy' => 'Occupé',
			'provider.profile.onHoliday' => 'En congé',
			'provider.profile.verifiedContact' => 'Contact vérifié',
			'provider.profile.errorLoadTitle' => 'Chargement impossible',
			'provider.profile.errorLoad' => 'Impossible de charger la fiche.',
			'provider.profile.retry' => 'Réessayer',
			'provider.profile.writeReview' => 'Donner mon avis',
			'provider.profile.reviewTitle' => 'Votre avis sur cet artisan',
			'provider.profile.ratingLabel' => 'Votre note',
			'provider.profile.ratingStarSemanticLabel' => '{n} étoile(s)',
			'provider.profile.ratingRequired' => 'Veuillez sélectionner une note de 1 à 5 étoiles',
			'provider.profile.commentLabel' => 'Votre commentaire (optionnel)',
			'provider.profile.commentHint' => 'Partagez votre expérience avec cet artisan...',
			'provider.profile.submitReview' => 'Publier l\'avis',
			'provider.profile.submittingReview' => 'Publication en cours...',
			'provider.profile.reviewSuccess' => 'Merci ! Votre avis a été publié.',
			'provider.profile.reviewRequiresContact' => 'Vous devez avoir contacté cet artisan pour pouvoir laisser un avis.',
			'provider.profile.reviewSelfForbidden' => 'Vous ne pouvez pas évaluer votre propre profil.',
			'provider.profile.reviewGenericError' => 'Impossible de publier votre avis. Veuillez réessayer.',
			'provider.profile.reviewLoginRequired' => 'Vous devez être connecté pour laisser un avis.',
			'provider.profile.reviewPromptTitle' => 'Avez-vous fait appel à cet artisan ?',
			'provider.profile.reviewPromptSubtitle' => 'Partagez votre avis pour aider la communauté.',
			'provider.profile.reviewPromptCta' => 'Laisser un avis',
			'provider.profile.authRequiredTitle' => 'Connexion requise',
			'provider.profile.authRequiredSubtitle' => 'Connectez-vous pour donner votre avis sur cet artisan.',
			'provider.profile.loginCta' => 'Se connecter ou s\'inscrire',
			'reviews.title' => 'Avis',
			'reviews.emptyTitle' => 'Aucun avis reçu pour l\'instant',
			'reviews.emptyMessage' => 'Les avis laissés par vos clients apparaîtront ici.',
			'reviews.loadError' => 'Impossible de charger vos avis.',
			'reviews.errorMessage' => 'Une erreur est survenue lors de la récupération de vos avis.',
			'reviews.retry' => 'Réessayer',
			'reviews.loadMore' => 'Charger plus d\'avis',
			'reviews.reviewsCount' => ({required Object count}) => '${count} avis',
			'reviews.ratingSummary' => 'Note moyenne',
			'reviews.replyAction' => 'Répondre',
			'reviews.replyComingSoon' => 'La réponse aux avis sera bientôt disponible',
			'search.searchPlaceholder' => 'Rechercher un service…',
			'search.locationPlaceholder' => 'Choisir un gouvernorat',
			'search.serviceLabel' => 'Service',
			'search.governorateLabel' => 'Gouvernorat',
			'search.categoriesTitle' => 'Catégories',
			'search.categoriesEmptyTitle' => 'Aucune catégorie',
			'search.categoriesEmpty' => 'Aucune catégorie disponible pour le moment.',
			'search.categoriesErrorTitle' => 'Chargement impossible',
			'search.categoriesError' => 'Impossible de charger les catégories.',
			'search.locationError' => 'Impossible de charger les gouvernorats.',
			'search.retry' => 'Réessayer',
			'search.filterRatingMin' => 'Note 4+',
			'search.filterUrgent' => 'Urgence',
			'search.resultsTitle' => 'Résultats',
			'search.filterVerified' => 'Vérifié',
			'search.emptyTitle' => 'Aucun artisan trouvé',
			'search.emptySubtitle' => 'Essayez de modifier vos filtres ou de chercher dans un autre gouvernorat.',
			'search.resetFilters' => 'Réinitialiser les filtres',
			'search.loadErrorTitle' => 'Erreur de chargement',
			'search.loadError' => 'Impossible de charger les résultats.',
			'search.offlineNotice' => 'Résultats hors ligne',
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
			'settings.login' => 'Se connecter ou s\'inscrire',
			'settings.logout' => 'Se déconnecter',
			'settings.logoutConfirmTitle' => 'Déconnexion',
			'settings.logoutConfirmMessage' => 'Êtes-vous sûr de vouloir vous déconnecter ?',
			'settings.cancel' => 'Annuler',
			'settings.confirm' => 'Confirmer',
			'settings.version' => 'Version',
			'settings.demoSection' => 'Mode Démo (Données de test)',
			'settings.demoMode' => 'Activer le mode démo',
			'settings.demoModeSubtitle' => 'Simuler artisans, avis et historique sans serveur distant',
			'settings.demoRoleGuest' => 'Visiteur (non connecté)',
			'settings.demoRoleClient' => 'Mode Client',
			'settings.demoRolePro' => 'Mode Artisan Pro',
			'settings.demoBanner' => 'Mode Démo actif',
			'settings.testToolsSection' => 'Outils de Test Onboarding',
			'settings.testOnboardingPro' => 'Tester l\'onboarding Pro',
			'settings.testOnboardingProDesc' => 'Lancer l\'assistant 5 étapes (profil, métiers, zones, photos, récap)',
			'settings.testOnboardingClient' => 'Tester l\'onboarding Particulier',
			'settings.testOnboardingClientDesc' => 'Lancer le parcours interactif de découverte pour les clients',
			'verification.screenTitle' => 'Vérification d\'identité',
			'verification.headerTitle' => 'Obtenez le badge Artisan Vérifié',
			'verification.headerSubtitle' => 'Renforcez la confiance de vos clients en faisant certifier votre compte par votre Carte d\'Identité Nationale (CIN).',
			'verification.badgeAdvantage1' => 'Badge officiel affiché sur votre profil et dans la recherche',
			'verification.badgeAdvantage2' => 'Priorité dans les résultats de recherche',
			'verification.identitySectionTitle' => 'Informations d\'identité',
			'verification.fullNameLabel' => 'Nom et prénom (sur la CIN)',
			'verification.fullNameHint' => 'ex. Ahmed Ben Salah',
			'verification.fullNameError' => 'Veuillez saisir votre nom et prénom (au moins 3 caractères)',
			'verification.cinNumberLabel' => 'Numéro de carte d\'identité (CIN)',
			'verification.cinNumberHint' => '8 chiffres (ex. 08123456)',
			'verification.cinNumberError' => 'Le numéro de CIN doit comporter exactement 8 chiffres',
			'verification.cinFrontTitle' => 'Face avant (Recto)',
			'verification.cinFrontSubtitle' => 'Photo nette de la face avant de votre CIN',
			'verification.cinBackTitle' => 'Face arrière (Verso)',
			'verification.cinBackSubtitle' => 'Photo nette de la face arrière de votre CIN',
			'verification.takePhoto' => 'Prendre une photo',
			'verification.chooseFromGallery' => 'Choisir depuis la galerie',
			'verification.changePhoto' => 'Changer',
			'verification.deletePhoto' => 'Supprimer',
			'verification.uploading' => 'Envoi en cours ({progress}%)...',
			'verification.uploadError' => 'Échec de l\'envoi de l\'image. Touchez pour réessayer.',
			'verification.inpdpConsentLabel' => 'Je consens au traitement de ma pièce d\'identité conformément à la loi n° 2004-63 relative à la protection des données personnelles.',
			'verification.inpdpConsentLink' => 'En savoir plus sur la protection de vos données',
			'verification.inpdpDialogTitle' => 'Protection de vos données personnelles',
			'verification.inpdpDialogBody' => 'Vos documents d\'identité sont stockés dans un coffre-fort numérique hautement sécurisé, chiffrés au repos (AES-256-GCM) et protégés par chiffrement serveur. Ils ne sont jamais partagés publiquement et servent exclusivement à l\'authentification de votre profil par notre équipe de modération.',
			'verification.inpdpDialogClose' => 'Compris',
			'verification.submitButton' => 'Envoyer pour vérification',
			'verification.submitting' => 'Envoi de la demande...',
			'verification.submitSuccessTitle' => 'Demande envoyée avec succès !',
			'verification.submitSuccessMessage' => 'Notre équipe examine votre pièce d\'identité sous 24 heures ouvrées. Vous serez notifié dès validation.',
			'verification.backToDashboard' => 'Retour au tableau de bord',
			'verification.statusPending' => 'Vérification en cours',
			'verification.statusApproved' => 'Artisan Vérifié',
			'verification.statusRejected' => 'Vérification refusée',
			_ => null,
		} ?? switch (path) {
			'verification.statusMoreInfo' => 'Complément d\'information requis',
			'verification.statusNotSubmitted' => 'Non vérifié',
			'verification.alreadyPending' => 'Une demande de vérification est déjà en cours de traitement.',
			'verification.alreadyVerified' => 'Votre profil est déjà vérifié.',
			'verification.missingDocuments' => 'Veuillez fournir les deux faces de votre CIN.',
			'verification.consentRequired' => 'Veuillez accepter les conditions de traitement des données.',
			'verification.generalError' => 'Une erreur est survenue lors de la soumission. Veuillez réessayer.',
			'verification.bannerNotSubmittedTitle' => 'Faites vérifier votre profil',
			'verification.bannerNotSubmittedBody' => 'Obtenez le badge officiel Artisan Vérifié pour renforcer la confiance et être prioritaire dans la recherche.',
			'verification.bannerNotSubmittedCta' => 'Faire vérifier mon compte',
			'verification.bannerPendingTitle' => 'Vérification en cours',
			'verification.bannerPendingBody' => 'Votre pièce d\'identité est en cours d\'examen sous 24h ouvrées. Vous recevrez une notification dès validation.',
			'verification.bannerApprovedTitle' => 'Profil Vérifié',
			'verification.bannerApprovedBody' => 'Votre identité a été certifiée. Votre badge officiel est visible sur votre vitrine et dans la recherche.',
			'verification.bannerRejectedTitle' => 'Vérification non validée',
			'verification.bannerRejectedBody' => 'Votre demande n\'a pas pu être validée. Motif : {reason}',
			'verification.bannerRejectedDefaultReason' => 'Document illisible ou non conforme.',
			'verification.bannerRejectedCta' => 'Soumettre à nouveau',
			'verification.bannerMoreInfoTitle' => 'Complément requis',
			'verification.bannerMoreInfoBody' => 'Un complément d\'information est nécessaire pour finaliser votre vérification : {reason}',
			'verification.bannerMoreInfoCta' => 'Mettre à jour le dossier',
			'verification.profileTileTitle' => 'Vérification d\'identité',
			_ => null,
		};
	}
}
