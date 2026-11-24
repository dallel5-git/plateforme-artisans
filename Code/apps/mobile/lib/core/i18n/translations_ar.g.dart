///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsAr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$ar auth = Translations$auth$ar._(_root);
	@override late final Translations$billing$ar billing = Translations$billing$ar._(_root);
	@override late final Translations$boosts$ar boosts = Translations$boosts$ar._(_root);
	@override late final Translations$common$ar common = Translations$common$ar._(_root);
	@override late final Translations$contact$ar contact = Translations$contact$ar._(_root);
	@override late final Translations$dashboard$ar dashboard = Translations$dashboard$ar._(_root);
	@override late final Translations$errors$ar errors = Translations$errors$ar._(_root);
	@override late final Translations$favorites$ar favorites = Translations$favorites$ar._(_root);
	@override late final Translations$history$ar history = Translations$history$ar._(_root);
	@override late final Translations$legal$ar legal = Translations$legal$ar._(_root);
	@override late final Translations$onboarding$ar onboarding = Translations$onboarding$ar._(_root);
	@override late final Translations$proProfile$ar proProfile = Translations$proProfile$ar._(_root);
	@override late final Translations$profile$ar profile = Translations$profile$ar._(_root);
	@override late final Translations$provider$ar provider = Translations$provider$ar._(_root);
	@override late final Translations$reviews$ar reviews = Translations$reviews$ar._(_root);
	@override late final Translations$search$ar search = Translations$search$ar._(_root);
	@override late final Translations$settings$ar settings = Translations$settings$ar._(_root);
	@override late final Translations$verification$ar verification = Translations$verification$ar._(_root);
}

// Path: auth
class Translations$auth$ar extends Translations$auth$fr {
	Translations$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get phoneTitle => 'رقم هاتفك';
	@override String get phoneSubtitle => 'سنرسل لك رمز تحقق عبر رسالة نصية';
	@override String get phoneHint => '22 123 456';
	@override String get legalConsent => 'بمتابعتك، فإنك توافق على شروط الاستخدام وسياسة الخصوصية الخاصة بنا';
	@override String get phoneInvalid => 'رقم هاتف تونسي غير صالح';
	@override String get phoneCta => 'استلام الرمز';
	@override String get otpDigitLabel => 'الرقم {n} من {total}';
	@override String get otpTitle => 'رمز التحقق';
	@override String get otpSubtitle => 'تم إرسال رمز مكوّن من 6 أرقام إلى {phone}';
	@override String get otpCta => 'تأكيد';
	@override String get otpResend => 'إعادة إرسال الرمز';
	@override String get otpResendCountdown => 'إعادة إرسال الرمز ({mmss})';
	@override String get otpAttemptsRemaining => 'رمز غير صحيح، تبقّى {count} محاولة/محاولات';
	@override String get errorOtpInvalid => 'رمز غير صحيح';
	@override String get errorOtpExpired => 'انتهت صلاحية هذا الرمز، اطلب رمزًا جديدًا';
	@override String get errorOtpTooManyAttempts => 'محاولات كثيرة جدًا، اطلب رمزًا جديدًا';
	@override String get errorRateLimitExceeded => 'طلبات كثيرة جدًا، حاول مرة أخرى لاحقًا';
	@override String get errorValidation => 'رقم الهاتف غير صالح';
	@override String get errorGeneric => 'حدث خطأ، حاول مرة أخرى';
}

// Path: billing
class Translations$billing$ar extends Translations$billing$fr {
	Translations$billing$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get creditsBalance => 'رصيد النقاط';
	@override String creditsCount({required Object count}) => '${count} نقاط';
	@override String get buyCredits => 'شراء';
	@override String get boostSectionTitle => 'تفعيل التعزيز';
	@override String get boostSectionSubtitle => 'أبرز ملفك في صدارة نتائج البحث.';
	@override String get boostOption24h => 'تعزيز 24 ساعة';
	@override String get boostOption24hDesc => 'أقصى درجات الظهور لزيادة فورية في النشاط';
	@override String get boostOption7d => 'تعزيز 7 أيام';
	@override String get boostOption7dDesc => 'حضور قوي ومستمر طوال الأسبوع';
	@override String get boostOptionPrice24h => '10 نقاط';
	@override String get boostOptionPrice7d => '50 نقطة';
	@override String get sponsoredTag => 'إعلان ممول';
	@override String get activateBoostCta => 'تفعيل التعزيز';
	@override String get featureUpcomingTitle => 'قريباً';
	@override String get featureUpcomingMessage => 'سيكون نظام شراء النقاط وتفعيل التعزيزات متاحاً في تحديث قادم.';
	@override String get clientSpace => 'حريف';
	@override String get proSpace => 'حرفي';
	@override String get dialogDismiss => 'حسناً';
}

// Path: boosts
class Translations$boosts$ar extends Translations$boosts$fr {
	Translations$boosts$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'التعزيزات';
	@override String get emptyTitle => 'التعزيزات قريباً';
	@override String get emptyMessage => 'أبرز ملفك في نتائج البحث بمجرد أن تصبح هذه الميزة جاهزة.';
}

// Path: common
class Translations$common$ar extends Translations$common$fr {
	Translations$common$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get appName => 'Sanaya';
	@override late final Translations$common$home$ar home = Translations$common$home$ar._(_root);
	@override late final Translations$common$widgets$ar widgets = Translations$common$widgets$ar._(_root);
	@override late final Translations$common$nav$ar nav = Translations$common$nav$ar._(_root);
	@override late final Translations$common$devPreview$ar devPreview = Translations$common$devPreview$ar._(_root);
}

// Path: contact
class Translations$contact$ar extends Translations$contact$fr {
	Translations$contact$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get call => 'اتصال';
	@override String get whatsapp => 'واتساب';
}

// Path: dashboard
class Translations$dashboard$ar extends Translations$dashboard$fr {
	Translations$dashboard$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'لوحة التحكم';
	@override String greeting({required Object name}) => 'مرحباً، ${name}';
	@override String get statViews => 'مشاهدات الملف الشخصي';
	@override String get statUniqueViews => 'زوار فريدون';
	@override String get statContacts => 'جهات الاتصال';
	@override String get statRatio => 'مشاهدة → اتصال';
	@override String get comparisonPreviousPeriod => 'مقارنة بالـ 15 يومًا السابقة';
	@override String get comparisonNew => 'جديد';
	@override String get chartTitle => 'المشاهدات خلال 30 يومًا';
	@override String get chartTitle7d => 'المشاهدات خلال 7 أيام';
	@override String get chartContactsLabel => 'جهات الاتصال';
	@override String get chartViewsLabel => 'المشاهدات';
	@override String get emptyTitle => 'لا مشاهدات حتى الآن';
	@override String get emptyMessage => 'أكمل ملفك الشخصي لتظهر في نتائج البحث.';
	@override String get retry => 'إعادة المحاولة';
	@override String get errorTitle => 'تعذر تحميل لوحة التحكم';
	@override String get errorMessage => 'تحقق من اتصالك وأعد المحاولة.';
	@override String get quickActionsTitle => 'إجراءات سريعة';
	@override String get actionShare => 'مشاركة';
	@override String get actionPublicProfile => 'واجهتي العامة';
	@override String get actionBoost => 'ترقية';
	@override String get actionEditProfile => 'ملفي الشخصي';
	@override String get profileLinkCopied => 'تم نسخ رابط ملفك الشخصي إلى الحافظة';
	@override String get channelsTitle => 'توزيع الاتصالات';
	@override String get channelsSubtitle => 'القنوات التي يستخدمها عملاؤك';
	@override String get channelPhone => 'مكالمات هاتفية';
	@override String get channelWhatsapp => 'رسائل واتساب';
	@override String get recentActivityTitle => 'النشاط الأخير والطلبات';
	@override String get recentActivitySubtitle => 'آخر التفاعلات المستلمة';
	@override String get recentLeadWhatsappTitle => 'طلب واتساب مستلم';
	@override String get recentLeadWhatsappDesc => 'سباكة وصحي • سوسة (خزامة)';
	@override String get recentLeadPhoneTitle => 'مكالمة مباشرة مستلمة';
	@override String get recentLeadPhoneDesc => 'تصليح كهرباء عاجل • المنستير';
	@override String get recentLeadReviewTitle => 'تقييم جديد 5 نجوم';
	@override String get recentLeadReviewDesc => '«دقة في المواعيد وعمل متقن!» • كريم ب.';
	@override String get time2hAgo => 'منذ ساعتين';
	@override String get time5hAgo => 'منذ 5 ساعات';
	@override String get timeYesterday => 'أمس';
	@override String get reputationTitle => 'التقييمات والسمعة';
	@override String reputationRating({required Object rating}) => '${rating} من 5';
	@override String reputationCount({required Object count}) => '${count} تقييم موثق';
	@override String get reputationBadge => 'حرفي موصى به في الساحل';
	@override String get reputationLatestReview => '«عمل ممتاز ودقة في المواعيد واحترافية عالية في تركيب اللوحة الكهربائية.»';
	@override String get reputationAuthor => '— كريم ب.، سوسة';
	@override String get reputationSeeAll => 'عرض جميع التقييمات';
	@override String get boostBannerTitle => 'ضاعف طلباتك 3 مرات';
	@override String get boostBannerSubtitle => 'اظهر في صدارة نتائج البحث في سوسة والمنستير.';
	@override String get boostBannerCta => 'اكتشف الترويجات';
	@override String get proTipsTitle => 'نصائح لتطوير نشاطك';
	@override String get tipResponsivenessTitle => 'سرعة استجابة قصوى';
	@override String get tipResponsivenessDesc => 'الرد على المكالمات والرسائل خلال 15 دقيقة يضاعف فرصك في كسب العمل.';
	@override String get tipPhotosTitle => 'أضف صوراً لأعمالك';
	@override String get tipPhotosDesc => 'الملفات التي تحتوي على صور إنجازات حقيقية تحقق اتصالات أكثر بنسبة تصل إلى 70%.';
}

// Path: errors
class Translations$errors$ar extends Translations$errors$fr {
	Translations$errors$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get routeNotFoundTitle => 'الصفحة غير موجودة';
	@override String get routeNotFoundMessage => 'هذه الصفحة غير موجودة أو لم تعد متاحة.';
	@override String get routeNotFoundAction => 'العودة إلى الصفحة الرئيسية';
	@override String get validationLimit => 'تم بلوغ الحد الأقصى: {limit} كحد أقصى.';
}

// Path: favorites
class Translations$favorites$ar extends Translations$favorites$fr {
	Translations$favorites$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'المفضلات';
	@override String get emptyTitle => 'لا توجد عناصر مفضلة حتى الآن';
	@override String get emptySubtitle => 'احفظ الحرفيين للوصول إليهم بسرعة لاحقاً.';
	@override String get exploreCta => 'البحث عن حرفي';
	@override String get removeTooltip => 'إزالة من المفضلات';
	@override String get addTooltip => 'إضافة إلى المفضلات';
	@override String get removeSuccess => 'تمت إزالة الحرفي من المفضلات';
	@override String get addSuccess => 'تمت إضافة الحرفي إلى المفضلات';
	@override String get removeError => 'تعذر إزالة الحرفي من المفضلات.';
	@override String get addError => 'تعذر إضافة الحرفي إلى المفضلات.';
	@override String get errorTitle => 'تعذّر التحميل';
	@override String get loadError => 'تعذر تحميل قائمة المفضلات.';
	@override String get retry => 'إعادة المحاولة';
	@override String get verifiedBadge => 'موثوق';
	@override String get authRequiredTitle => 'احفظ الحرفيين المفضلين لديك';
	@override String get authRequiredSubtitle => 'سجّل الدخول لحفظ الحرفيين والوصول إليهم بسهولة.';
	@override String get loginCta => 'تسجيل الدخول أو إنشاء حساب';
}

// Path: history
class Translations$history$ar extends Translations$history$fr {
	Translations$history$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'السجل';
	@override String get emptyTitle => 'لم تتصل بأي حرفي بعد';
	@override String get emptyMessage => 'سيظهر هنا الحرفيون الذين تتصل بهم، مع رابط سريع لترك تقييم.';
	@override String get emptyCta => 'بحث';
	@override String get loadError => 'تعذر تحميل سجلك.';
	@override String get retry => 'إعادة المحاولة';
	@override String get reviewCta => 'ترك تقييم';
	@override String get channelPhone => 'اتصال';
	@override String get channelWhatsapp => 'واتساب';
	@override String get authRequiredTitle => 'سجل اتصالاتك';
	@override String get authRequiredSubtitle => 'سجّل الدخول للعثور على الحرفيين الذين تواصلت معهم.';
	@override String get loginCta => 'تسجيل الدخول أو إنشاء حساب';
}

// Path: legal
class Translations$legal$ar extends Translations$legal$fr {
	Translations$legal$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإشعارات القانونية';
	@override String get editorTitle => 'الجهة المشرفة على المنصة';
	@override String get editorContent => 'صنايعية — منصة للربط بين الحرفيين والعملاء في تونس (الساحل: سوسة، المنستير، المهدية).';
	@override String get modelTitle => 'نموذج الخدمة';
	@override String get modelContent => 'صنايعية خدمة لتوفير جهات اتصال موثوقة. المنصة لا تستلم أبدًا مستحقات الخدمات ولا تتدخل في الدفع المباشر للعمل.';
	@override String get inpdpTitle => 'حماية البيانات الشخصية (INPDP)';
	@override String get inpdpContent => 'وفقًا للقانون الأساسي عدد 63 لسنة 2004، تلتزم صنايعية بحماية خصوصية مستخدميها. لا يتم كشف أرقام الهواتف إلا عند طلب التواصل الطوعي والمسجل.';
	@override String get rightsTitle => 'حقوقكم';
	@override String get rightsContent => 'يحق لكم النفاذ إلى بياناتكم الشخصية وتصحيحها أو حذفها في أي وقت.';
}

// Path: onboarding
class Translations$onboarding$ar extends Translations$onboarding$fr {
	Translations$onboarding$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get wizardTitle => 'كن مقدّم خدمة';
	@override String get back => 'رجوع';
	@override String get next => 'التالي';
	@override String get retry => 'إعادة المحاولة';
	@override String get stepProfile => 'الملف الشخصي';
	@override String get stepCategories => 'الفئات';
	@override String get stepZones => 'المناطق';
	@override String get stepPhotos => 'الصور';
	@override String get stepSummary => 'الملخّص';
	@override String get stepIndicator => 'الخطوة {current} من {total}';
	@override String get profileBusinessName => 'اسم النشاط';
	@override String get profileHeadline => 'العنوان (مثال: سبّاك معتمد)';
	@override String get profileBio => 'نبذة (50 حرفًا على الأقل)';
	@override String get profileYearsExperience => 'سنوات الخبرة';
	@override String get profileWhatsapp => 'رقم واتساب';
	@override String get profilePublicPhone => 'رقم هاتف عام';
	@override String get profileGovernorate => 'الولاية الرئيسية';
	@override String get profileGovernorateError => 'تعذّر تحميل الولايات.';
	@override String get profileSaveError => 'تعذّر حفظ الملف الشخصي. أعد المحاولة.';
	@override String get categoriesTitle => 'اختر فئاتك';
	@override String get categoriesPrimaryHint => 'رئيسية';
	@override String get categoriesEmpty => 'اختر فئة واحدة على الأقل.';
	@override String get categoriesError => 'تعذّر تحميل الفئات.';
	@override String get categoriesErrorMessage => 'تحقّق من اتصالك وأعد المحاولة.';
	@override String get categoriesSaveError => 'تعذّر حفظ الفئات. أعد المحاولة.';
	@override String get categoriesCapHint => '3 فئات كحد أقصى في العرض المجاني';
	@override String get zonesTitle => 'اختر مناطق تدخّلك';
	@override String get zonesCapHint => 'ولاية واحدة كحد أقصى في العرض المجاني';
	@override String get zonesEmpty => 'اختر ولاية واحدة على الأقل.';
	@override String get zonesError => 'تعذّر تحميل الولايات.';
	@override String get zonesErrorMessage => 'تحقّق من اتصالك وأعد المحاولة.';
	@override String get zonesSaveError => 'تعذّر حفظ المناطق. أعد المحاولة.';
	@override String get photosTitle => 'أضف صورًا لأعمالك';
	@override String get photosCapHint => '5 صور كحد أقصى في العرض المجاني';
	@override String get photosCapReached => 'تم بلوغ الحد الأقصى (5 صور) في العرض المجاني.';
	@override String get photosAdd => 'إضافة صورة';
	@override String get photosDelete => 'حذف هذه الصورة';
	@override String get photosUploadFailed => 'فشل الإرسال';
	@override String get summaryTitle => 'الملخّص';
	@override String get summaryCompletionLabel => 'الملف مكتمل بنسبة {score} %';
	@override String get summaryMissingTitle => 'لا يزال ناقصًا:';
	@override String get summaryPublish => 'نشر ملفي';
	@override String get summaryPublishError => 'تعذّر النشر. أعد المحاولة.';
	@override String get summaryPublished => 'تم نشر الملف!';
	@override String get missingBio => 'إضافة نبذة تعريفية (50 حرفًا على الأقل)';
	@override String get missingHeadline => 'إضافة عنوان مهني';
	@override String get missingYearsExperience => 'تحديد سنوات الخبرة';
	@override String get missingContactPhone => 'إضافة رقم واتساب أو رقم هاتف عام';
	@override String get missingCategories => 'اختيار فئة واحدة على الأقل';
	@override String get missingCoverageAreas => 'اختيار ولاية واحدة على الأقل';
	@override String get missingPhotos => 'إضافة صور لأعمالك';
	@override String get missingActionHint => 'تعديل في خطوة {step}';
	@override String get summaryScoreCritical => 'الملف غير مكتمل — يتعذر النشر (أقل من 40%)';
	@override String get summaryScoreWarning => 'مزيد من الجهد للوصول إلى حد النشر (60%)';
	@override String get summaryScoreSuccess => 'تم بلوغ الحد الأدنى للنشر (60% فأكثر)';
	@override String get clientWelcomeTitle => 'مرحباً بك في صنايعية';
	@override String get clientWelcomeSubtitle => 'اعثر على أفضل الحرفيين في الساحل التونسي بكل ثقة وسهولة.';
	@override String get clientStep1Title => 'اعثر على الحرفي المناسب';
	@override String get clientStep1Desc => 'سباكون، كهربائيون، دهانون، فنيو تكييف... محترفون مؤهلون ومتوفرون بالقرب منك.';
	@override String get clientStep2Title => 'ثقة وتقييمات موثقة';
	@override String get clientStep2Desc => 'حرفيون موثقون ببطاقة التعريف الوطنية، وتقييمات حقيقية يكتبها حُرفاء اتصلوا فعلياً بالحرفي.';
	@override String get clientStep3Title => 'اتصال مباشر ومجاني 100%';
	@override String get clientStep3Desc => 'اتصال أو واتساب مباشر دون عمولة وبلا وسيط. اتفق على تفاصيل العمل مباشرة مع الحرفي.';
	@override String get clientChooseGovernorate => 'ولايتك المفضلة للبحث :';
	@override String get clientStartExploring => 'ابدأ البحث الآن';
	@override String get clientSkip => 'تخطي المقدمة';
	@override String get celebrationTitle => 'مبروك! ملفك المهني أصبح متوفراً الآن';
	@override String get celebrationSubtitle => 'ملفك أصبح مرئياً لجميع الحرفاء في مناطق تدخلك. يمكنك الآن استقبال طلبات التواصل.';
	@override String get celebrationKycCardTitle => 'ضاعف فرص تواصل الحرفاء معك 3 مرات بالحصول على الشارة الموثقة';
	@override String get celebrationKycCardDescription => 'الحرفيون الذين تم تأكيد هويتهم ببطاقة التعريف الوطنية يحظون بثقة أكبر ويظهرون في المراتب الأولى لنتائج البحث. العملية مجانية تماماً وتستغرق أقل من دقيقتين.';
	@override String get celebrationKycBenefitBadge => 'شارة رسمية «حرفي موثق» على ملفك المهني';
	@override String get celebrationKycBenefitRank => 'أولوية الظهور في صدارة نتائج البحث';
	@override String get celebrationKycBenefitFast => 'تأكيد ومراجعة سريعة خلال 24 ساعة عمل';
	@override String get celebrationCtaVerify => 'توثيق هويتي الآن';
	@override String get celebrationCtaDashboard => 'الانتقال إلى لوحة التحكم';
}

// Path: proProfile
class Translations$proProfile$ar extends Translations$proProfile$fr {
	Translations$proProfile$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الملف الشخصي';
	@override String get emptyTitle => 'الملف غير موجود';
	@override String get emptyMessage => 'لا يوجد ملف حرفي مرتبط بهذا الحساب.';
	@override String get switchToClientSpace => 'العودة إلى مساحة العميل';
	@override String get errorTitle => 'تعذّر تحميل ملفك الشخصي';
	@override String get errorMessage => 'تحقق من اتصالك وأعد المحاولة.';
	@override String get retry => 'إعادة المحاولة';
	@override String get availabilitySection => 'التوفر';
	@override String get acceptsEmergencyLabel => 'يقبل الحالات المستعجلة';
	@override String get acceptsEmergencyDescription => 'يُظهر شارة "مستعجل" في نتائج البحث';
	@override String get editSection => 'تعديل ملفي الشخصي';
	@override String get save => 'حفظ';
	@override String get saveSuccess => 'تم تحديث الملف الشخصي';
	@override String get viewMyListing => 'شاهد ملفي كما يراه العميل';
	@override String get completionTitle => 'اكتمال الملف الشخصي';
	@override String get completionLabel => 'الملف مكتمل بنسبة {score} %';
	@override String get completionTip => 'الملف المكتمل يحصل على 3 أضعاف طلبات الاتصال في المتوسط.';
	@override String get relaunchOnboarding => 'تعديل عبر معالج التسجيل الكامل';
	@override String get yearsExperience => '{years} سنوات خبرة';
	@override String get verifiedBadge => 'حرفي موثّق';
	@override String get unverifiedBadge => 'في انتظار التوثيق';
	@override String get statsViews => 'مشاهدات الملف';
	@override String get statsContacts => 'اتصالات واردة';
	@override String get statsRating => 'متوسط التقييم';
	@override String get publicPreviewTitle => 'الواجهة العامة';
	@override String get publicPreviewSubtitle => 'اطلع على بطاقتك كما تظهر للحرفاء والباحثين عن خدمات';
	@override String get portfolioSection => 'معرض الأعمال والإنجازات';
	@override String get portfolioDesc => 'صور لمشاريعك وتدخلاتك السابقة';
	@override String get categoriesAndZones => 'المهن ومناطق التدخل';
	@override String get categoriesSection => 'مهنتي وتخصصاتي';
	@override String get categoriesDesc => 'إدارة المهن التي تمارسها والمهنة الرئيسية';
	@override String get categoriesUpdated => 'تم تحديث المهن بنجاح';
	@override String get categoriesEmpty => 'لم يتم تحديد أي مهنة';
	@override String get zonesSection => 'مناطق التدخل';
	@override String get zonesDesc => 'الولايات التي تغطيها خدماتك';
	@override String get zonesUpdated => 'تم تحديث مناطق التدخل بنجاح';
	@override String get zonesEmpty => 'لم يتم تحديد أي ولاية';
	@override String get editCategories => 'تعديل المهن';
	@override String get editZones => 'تعديل المناطق';
	@override String get availabilityUpdated => 'تم تحديث الحالة بنجاح';
	@override String get testOnboardingPro => 'تجربة تسجيل الحرفي';
	@override String get testOnboardingClient => 'تجربة تسجيل الحريف';
}

// Path: profile
class Translations$profile$ar extends Translations$profile$fr {
	Translations$profile$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الملف الشخصي';
	@override String get accountFallback => 'حسابي';
	@override String get switchToProSpace => 'التبديل إلى مساحة المحترفين';
	@override String get guestName => 'زائر';
	@override String get guestSubtitle => 'غير متصل';
	@override String get loginCta => 'تسجيل الدخول أو إنشاء حساب';
	@override String get becomeProTitle => 'انضم كحرفي على صنايعية';
	@override String get becomeProSubtitle => 'هل أنت حرفي أو مهني؟ قدم خدماتك واستقبل طلبات الحرفاء مباشرة.';
	@override String get becomeProButton => 'إنشاء حساب حرفي';
}

// Path: provider
class Translations$provider$ar extends Translations$provider$fr {
	Translations$provider$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final Translations$provider$profile$ar profile = Translations$provider$profile$ar._(_root);
}

// Path: reviews
class Translations$reviews$ar extends Translations$reviews$fr {
	Translations$reviews$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'التقييمات';
	@override String get emptyTitle => 'لا توجد تقييمات حتى الآن';
	@override String get emptyMessage => 'ستظهر هنا التقييمات التي يتركها عملاؤك.';
	@override String get loadError => 'تعذر تحميل التقييمات.';
	@override String get errorMessage => 'حدث خطأ أثناء تحميل التقييمات الخاصة بك.';
	@override String get retry => 'إعادة المحاولة';
	@override String get loadMore => 'تحميل المزيد من التقييمات';
	@override String reviewsCount({required Object count}) => '${count} تقييم';
	@override String get ratingSummary => 'متوسط التقييم';
	@override String get replyAction => 'الرد';
	@override String get replyComingSoon => 'الرد على التقييمات سيكون متاحاً قريباً';
}

// Path: search
class Translations$search$ar extends Translations$search$fr {
	Translations$search$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get searchPlaceholder => 'ابحث عن خدمة…';
	@override String get locationPlaceholder => 'اختر ولاية';
	@override String get serviceLabel => 'الخدمة';
	@override String get governorateLabel => 'الولاية';
	@override String get categoriesTitle => 'الفئات';
	@override String get categoriesEmptyTitle => 'لا توجد فئات';
	@override String get categoriesEmpty => 'لا توجد فئات متاحة حاليًا.';
	@override String get categoriesErrorTitle => 'تعذّر التحميل';
	@override String get categoriesError => 'تعذّر تحميل الفئات.';
	@override String get locationError => 'تعذّر تحميل الولايات.';
	@override String get retry => 'إعادة المحاولة';
	@override String get filterRatingMin => 'تقييم 4+';
	@override String get filterUrgent => 'عاجل';
	@override String get resultsTitle => 'النتائج';
	@override String get filterVerified => 'موثّق';
	@override String get emptyTitle => 'لم يتم العثور على أي حرفي';
	@override String get emptySubtitle => 'جرّب تعديل معايير البحث أو اختيار ولاية أخرى.';
	@override String get resetFilters => 'إعادة تعيين الفلاتر';
	@override String get loadErrorTitle => 'خطأ في التحميل';
	@override String get loadError => 'تعذّر تحميل النتائج.';
	@override String get offlineNotice => 'النتائج بدون اتصال';
}

// Path: settings
class Translations$settings$ar extends Translations$settings$fr {
	Translations$settings$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override String get languageSection => 'اللغة';
	@override String get french => 'Français';
	@override String get arabic => 'العربية (تونس)';
	@override String get themeSection => 'المظهر';
	@override String get themeSystem => 'النظام';
	@override String get themeLight => 'فاتح';
	@override String get themeDark => 'داكن';
	@override String get legalSection => 'المعلومات والشروط القانونية';
	@override String get legalNotices => 'الإشعارات القانونية';
	@override String get privacyPolicy => 'حماية البيانات الشخصية (INPDP)';
	@override String get accountSection => 'الحساب';
	@override String get login => 'تسجيل الدخول أو إنشاء حساب';
	@override String get logout => 'تسجيل الخروج';
	@override String get logoutConfirmTitle => 'تسجيل الخروج';
	@override String get logoutConfirmMessage => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';
	@override String get cancel => 'إلغاء';
	@override String get confirm => 'تأكيد';
	@override String get version => 'الإصدار';
	@override String get demoSection => 'الوضع التجريبي (بيانات تجريبية)';
	@override String get demoMode => 'تفعيل الوضع التجريبي';
	@override String get demoModeSubtitle => 'محاكاة الحرفيين والتقييمات والسجل دون اتصال بخادم';
	@override String get demoRoleGuest => 'زائر (غير متصل)';
	@override String get demoRoleClient => 'وضع الحريف';
	@override String get demoRolePro => 'وضع الحرفي';
	@override String get demoBanner => 'الوضع التجريبي نشط';
	@override String get testToolsSection => 'أدوات تجربة مسار التسجيل';
	@override String get testOnboardingPro => 'تجربة تسجيل الحرفي';
	@override String get testOnboardingProDesc => 'بدء معالج التسجيل بـ 5 مراحل (الملف، المهن، المناطق، الصور، الملخص)';
	@override String get testOnboardingClient => 'تجربة ترحيب الحريف';
	@override String get testOnboardingClientDesc => 'بدء مسار الاكتشاف التفاعلي المخصص للحرفاء';
}

// Path: verification
class Translations$verification$ar extends Translations$verification$fr {
	Translations$verification$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get screenTitle => 'التحقق من الهوية';
	@override String get headerTitle => 'احصل على شارة الحرفي المعتمد';
	@override String get headerSubtitle => 'عزز ثقة حرفائك من خلال توثيق حسابك ببطاقة التعريف الوطنية التونسية.';
	@override String get badgeAdvantage1 => 'شارة رسمية تظهر في ملفك الشخصي ونتائج البحث';
	@override String get badgeAdvantage2 => 'أولوية الظهور والترتيب في نتائج البحث';
	@override String get identitySectionTitle => 'معلومات الهوية';
	@override String get fullNameLabel => 'الاسم واللقب (كما في بطاقة التعريف)';
	@override String get fullNameHint => 'مثال: أحمد بن صالح';
	@override String get fullNameError => 'الرجاء إدخال الاسم واللقب (3 أحرف على الأقل)';
	@override String get cinNumberLabel => 'رقم بطاقة التعريف الوطنية (CIN)';
	@override String get cinNumberHint => '8 أرقام (مثال: 08123456)';
	@override String get cinNumberError => 'يجب أن يتكون رقم بطاقة التعريف من 8 أرقام بالضبط';
	@override String get cinFrontTitle => 'الوجه الأمامي (Recto)';
	@override String get cinFrontSubtitle => 'صورة واضحة للوجه الأمامي لبطاقة التعريف';
	@override String get cinBackTitle => 'الوجه الخلفي (Verso)';
	@override String get cinBackSubtitle => 'صورة واضحة للوجه الخلفي لبطاقة التعريف';
	@override String get takePhoto => 'التقاط صورة';
	@override String get chooseFromGallery => 'اختيار من المعرض';
	@override String get changePhoto => 'تغيير';
	@override String get deletePhoto => 'حذف';
	@override String get uploading => 'جارٍ التحميل ({progress}%)...';
	@override String get uploadError => 'فشل في تحميل الصورة. انقر للمحاولة مرة أخرى.';
	@override String get inpdpConsentLabel => 'أوافق على معالجة وثيقة هويتي طبقاً للقانون عدد 63 لسنة 2004 المتعلق بحماية المعطيات الشخصية.';
	@override String get inpdpConsentLink => 'مزيد من المعلومات حول حماية معطياتك الشخصية';
	@override String get inpdpDialogTitle => 'حماية معطياتك الشخصية';
	@override String get inpdpDialogBody => 'يتم تخزين وثائق هويتك في خزانة رقمية مشفرة وعالية الأمان (AES-256-GCM). لا يتم نشرها أو مشاركتها علناً أبداً، وتُستخدم حصرياً للتحقق من حسابك من قبل فريق الإشراف.';
	@override String get inpdpDialogClose => 'فهمت';
	@override String get submitButton => 'إرسال للتحقق';
	@override String get submitting => 'جارٍ إرسال الطلب...';
	@override String get submitSuccessTitle => 'تم إرسال الطلب بنجاح !';
	@override String get submitSuccessMessage => 'يقوم فريقنا بمراجعة وثيقتك خلال 24 ساعة عمل. سيتم إشعارك فور الاعتماد.';
	@override String get backToDashboard => 'العودة إلى لوحة القيادة';
	@override String get statusPending => 'التحقق قيد المراجعة';
	@override String get statusApproved => 'حرفي معتمد';
	@override String get statusRejected => 'تم رفض التحقق';
	@override String get statusMoreInfo => 'مطلوب معلومات إضافية';
	@override String get statusNotSubmitted => 'غير موثق';
	@override String get alreadyPending => 'لديك طلب تحقق قيد المراجعة حالياً.';
	@override String get alreadyVerified => 'ملفك الشخصي معتمد بالفعل.';
	@override String get missingDocuments => 'الرجاء توفير الوجهين الأمامي والخلفي لبطاقة التعريف.';
	@override String get consentRequired => 'الرجاء الموافقة على شروط معالجة المعطيات.';
	@override String get generalError => 'حدث خطأ أثناء الإرسال. الرجاء المحاولة مرة أخرى.';
	@override String get bannerNotSubmittedTitle => 'وثّق حسابك المهني';
	@override String get bannerNotSubmittedBody => 'احصل على شارة الحرفي المعتمد لتعزيز ثقة الحرفاء والأولوية في نتائج البحث.';
	@override String get bannerNotSubmittedCta => 'توثيق حسابي الآن';
	@override String get bannerPendingTitle => 'التحقق قيد المراجعة';
	@override String get bannerPendingBody => 'وثيقة هويتك قيد المراجعة من قبل فريقنا خلال 24 ساعة عمل. سيتم إشعارك فور الاعتماد.';
	@override String get bannerApprovedTitle => 'حساب موثق ومعتمد';
	@override String get bannerApprovedBody => 'تم التحقق من هويتك بنجاح. شارتك الرسمية ظاهرة الآن في ملفك الشخصي والبحث.';
	@override String get bannerRejectedTitle => 'لم يتم قبول التحقق';
	@override String get bannerRejectedBody => 'تعذر قبول طلب التحقق. السبب: {reason}';
	@override String get bannerRejectedDefaultReason => 'الوثيقة غير واضحة أو غير مطابقة.';
	@override String get bannerRejectedCta => 'إعادة إرسال الوثائق';
	@override String get bannerMoreInfoTitle => 'مطلوب معلومات إضافية';
	@override String get bannerMoreInfoBody => 'يلزم تقديم معلومات إضافية لاستكمال التحقق من حسابك: {reason}';
	@override String get bannerMoreInfoCta => 'تحديث الملف';
	@override String get profileTileTitle => 'التحقق من الهوية';
}

// Path: common.home
class Translations$common$home$ar extends Translations$common$home$fr {
	Translations$common$home$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get navAuth => 'مساحة المصادقة — قريبًا (FM-05)';
	@override String get navClient => 'مساحة العميل';
	@override String get navPro => 'مساحة المحترف';
	@override String get navProDashboard => 'مساحة المحترف — لوحة التحكم';
	@override String get toggleTheme => 'تبديل المظهر الفاتح/الداكن';
	@override String get toggleLocale => 'تبديل الفرنسية/العربية';
	@override String get designSystemPreview => 'معرض نظام التصميم';
}

// Path: common.widgets
class Translations$common$widgets$ar extends Translations$common$widgets$fr {
	Translations$common$widgets$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get verifiedBadge => 'موثّق';
	@override late final Translations$common$widgets$offlineBanner$ar offlineBanner = Translations$common$widgets$offlineBanner$ar._(_root);
}

// Path: common.nav
class Translations$common$nav$ar extends Translations$common$nav$fr {
	Translations$common$nav$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get searchTab => 'بحث';
	@override String get favoritesTab => 'المفضلة';
	@override String get historyTab => 'السجل';
	@override String get profileTab => 'الملف الشخصي';
	@override String get dashboardTab => 'لوحة التحكم';
	@override String get boostsTab => 'التعزيزات';
	@override String get reviewsTab => 'التقييمات';
	@override String get switchToClient => 'التبديل إلى وضع العميل';
	@override String get switchToPro => 'التبديل إلى وضع المحترف';
	@override String get exitConfirmation => 'اضغط مرة أخرى للخروج';
}

// Path: common.devPreview
class Translations$common$devPreview$ar extends Translations$common$devPreview$fr {
	Translations$common$devPreview$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get sectionAppButton => 'AppButton';
	@override String get sectionAppCard => 'AppCard';
	@override String get sectionAppTextField => 'AppTextField';
	@override String get sectionRatingStars => 'RatingStars';
	@override String get sectionVerifiedBadge => 'VerifiedBadge';
	@override String get sectionProviderCard => 'ProviderCard';
	@override String get sectionAppSkeleton => 'AppSkeleton';
	@override String get sectionEmptyState => 'EmptyState';
	@override String get sectionErrorState => 'ErrorState';
	@override String get sectionOfflineBanner => 'OfflineBanner';
	@override String get sectionAppBottomNav => 'AppBottomNav';
	@override String get buttonPrimary => 'أساسي';
	@override String get buttonDisabled => 'معطّل';
	@override String get buttonSecondary => 'ثانوي';
	@override String get buttonGhost => 'شفاف';
	@override String get buttonWhatsapp => 'واتساب';
	@override String get buttonOutlineWhatsapp => 'واتساب (محدد)';
	@override String get buttonDanger => 'خطر';
	@override String get phoneLabel => 'رقم الهاتف';
	@override String get phoneHint => '+216 22 123 456';
	@override String get otpLabel => 'رمز التحقق';
	@override String get otpError => 'رمز غير صحيح — تبقى لك محاولتان';
	@override String get sampleProvider1Name => 'كريم بن صالح';
	@override String get sampleProvider1Category => 'سباكة';
	@override String get sampleProvider1Location => 'سوسة، خزامة · 2,4 كم';
	@override String get sampleProvider1Price => 'ابتداءً من 40 د.ت';
	@override String get sampleProvider2Name => 'الهادي الفرجاني';
	@override String get sampleProvider2Category => 'دهان';
	@override String get sampleProvider2Location => 'المنستير';
	@override String get sampleProvider2Price => 'ابتداءً من 25 د.ت';
	@override String get emptyTitle => 'لم يتم العثور على أي حرفي';
	@override String get emptyMessage => 'لا يوجد سبّاك متاح في المهدية لهذه المرشحات.';
	@override String get emptyAction => 'توسيع البحث إلى الولاية';
	@override String get errorTitle => 'انقطع الاتصال';
	@override String get errorMessage => 'تعذّر تحميل النتائج. تحقق من اتصالك.';
	@override String get errorAction => 'إعادة المحاولة';
	@override String get sectionColorRoles => 'أدوار الألوان';
	@override String get swatchLight => 'فاتح';
	@override String get swatchDark => 'داكن';
	@override String get sectionTypography => 'الطباعة';
	@override String get sectionAvailabilityChip => 'AvailabilityChip';
	@override String get sectionReviewTile => 'ReviewTile';
	@override String get sectionOfferingCard => 'OfferingCard';
	@override String get sectionProviderGallery => 'ProviderGallery';
	@override String get sectionDashboardStatCard => 'DashboardStatCard';
	@override String get sectionDashboardTrendChart => 'DashboardTrendChart';
	@override String get sectionDashboardComparisonChip => 'DashboardComparisonChip';
	@override String get sectionRatingStarsInput => 'RatingStarsInput';
	@override String get sectionOtpCodeField => 'OtpCodeField';
	@override String get sectionCoverageAreaChip => 'CoverageAreaChip';
	@override String get sectionCategoryGrid => 'CategoryGrid';
	@override String get sectionCategoryGridSkeleton => 'CategoryGridSkeleton';
	@override String get sectionFavoriteCardSkeleton => 'FavoriteCardSkeleton';
	@override String get statViewsLabel => 'زيارات الملف الشخصي';
	@override String get statNewLabel => 'جديد';
}

// Path: provider.profile
class Translations$provider$profile$ar extends Translations$provider$profile$fr {
	Translations$provider$profile$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get callButton => 'اتصال';
	@override String get whatsappButton => 'واتساب';
	@override String get reviewsTitle => 'التقييمات';
	@override String get loadMoreReviews => 'عرض المزيد من التقييمات';
	@override String get noReviews => 'لا توجد تقييمات حتى الآن.';
	@override String get reviewsErrorTitle => 'تعذّر التحميل';
	@override String get reviewsError => 'تعذّر تحميل التقييمات.';
	@override String get offeringsTitle => 'الخدمات';
	@override String get coverageTitle => 'مناطق التدخل';
	@override String get yearsExperience => '{n} سنة خبرة';
	@override String get availableNow => 'متوفر';
	@override String get busy => 'مشغول';
	@override String get onHoliday => 'في عطلة';
	@override String get verifiedContact => 'اتصال موثّق';
	@override String get errorLoadTitle => 'تعذّر التحميل';
	@override String get errorLoad => 'تعذّر تحميل بطاقة الحرفي.';
	@override String get retry => 'إعادة المحاولة';
	@override String get writeReview => 'كتابة تقييم';
	@override String get reviewTitle => 'رأيك في هذا الحرفي';
	@override String get ratingLabel => 'تقييمك';
	@override String get ratingStarSemanticLabel => '{n} نجمة/نجوم';
	@override String get ratingRequired => 'يرجى اختيار تقييم من 1 إلى 5 نجوم';
	@override String get commentLabel => 'تعليقك (اختياري)';
	@override String get commentHint => 'شارك تجربتك مع هذا الحرفي...';
	@override String get submitReview => 'نشر التقييم';
	@override String get submittingReview => 'جاري النشر...';
	@override String get reviewSuccess => 'شكراً! تم نشر تقييمك.';
	@override String get reviewRequiresContact => 'يجب أن تكون قد تواصلت مع هذا الحرفي لتتمكن من تقييمه.';
	@override String get reviewSelfForbidden => 'لا يمكنك تقييم حسابك الخاص.';
	@override String get reviewGenericError => 'تعذّر نشر تقييمك. يرجى المحاولة مرة أخرى.';
	@override String get reviewLoginRequired => 'يجب عليك تسجيل الدخول لترك تقييم.';
	@override String get reviewPromptTitle => 'هل تعاملت مع هذا الحرفي؟';
	@override String get reviewPromptSubtitle => 'شارك رأيك لمساعدة المجتمع.';
	@override String get reviewPromptCta => 'ترك تقييم';
	@override String get authRequiredTitle => 'تسجيل الدخول مطلوب';
	@override String get authRequiredSubtitle => 'سجّل الدخول لتتمكن من تقييم هذا الحرفي.';
	@override String get loginCta => 'تسجيل الدخول أو إنشاء حساب';
}

// Path: common.widgets.offlineBanner
class Translations$common$widgets$offlineBanner$ar extends Translations$common$widgets$offlineBanner$fr {
	Translations$common$widgets$offlineBanner$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get message => 'أنت تتصفح نتائج محفوظة. سيتم تحديثها عند عودة الاتصال بالشبكة.';
	@override String get dismiss => 'فهمت';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.phoneTitle' => 'رقم هاتفك',
			'auth.phoneSubtitle' => 'سنرسل لك رمز تحقق عبر رسالة نصية',
			'auth.phoneHint' => '22 123 456',
			'auth.legalConsent' => 'بمتابعتك، فإنك توافق على شروط الاستخدام وسياسة الخصوصية الخاصة بنا',
			'auth.phoneInvalid' => 'رقم هاتف تونسي غير صالح',
			'auth.phoneCta' => 'استلام الرمز',
			'auth.otpDigitLabel' => 'الرقم {n} من {total}',
			'auth.otpTitle' => 'رمز التحقق',
			'auth.otpSubtitle' => 'تم إرسال رمز مكوّن من 6 أرقام إلى {phone}',
			'auth.otpCta' => 'تأكيد',
			'auth.otpResend' => 'إعادة إرسال الرمز',
			'auth.otpResendCountdown' => 'إعادة إرسال الرمز ({mmss})',
			'auth.otpAttemptsRemaining' => 'رمز غير صحيح، تبقّى {count} محاولة/محاولات',
			'auth.errorOtpInvalid' => 'رمز غير صحيح',
			'auth.errorOtpExpired' => 'انتهت صلاحية هذا الرمز، اطلب رمزًا جديدًا',
			'auth.errorOtpTooManyAttempts' => 'محاولات كثيرة جدًا، اطلب رمزًا جديدًا',
			'auth.errorRateLimitExceeded' => 'طلبات كثيرة جدًا، حاول مرة أخرى لاحقًا',
			'auth.errorValidation' => 'رقم الهاتف غير صالح',
			'auth.errorGeneric' => 'حدث خطأ، حاول مرة أخرى',
			'billing.creditsBalance' => 'رصيد النقاط',
			'billing.creditsCount' => ({required Object count}) => '${count} نقاط',
			'billing.buyCredits' => 'شراء',
			'billing.boostSectionTitle' => 'تفعيل التعزيز',
			'billing.boostSectionSubtitle' => 'أبرز ملفك في صدارة نتائج البحث.',
			'billing.boostOption24h' => 'تعزيز 24 ساعة',
			'billing.boostOption24hDesc' => 'أقصى درجات الظهور لزيادة فورية في النشاط',
			'billing.boostOption7d' => 'تعزيز 7 أيام',
			'billing.boostOption7dDesc' => 'حضور قوي ومستمر طوال الأسبوع',
			'billing.boostOptionPrice24h' => '10 نقاط',
			'billing.boostOptionPrice7d' => '50 نقطة',
			'billing.sponsoredTag' => 'إعلان ممول',
			'billing.activateBoostCta' => 'تفعيل التعزيز',
			'billing.featureUpcomingTitle' => 'قريباً',
			'billing.featureUpcomingMessage' => 'سيكون نظام شراء النقاط وتفعيل التعزيزات متاحاً في تحديث قادم.',
			'billing.clientSpace' => 'حريف',
			'billing.proSpace' => 'حرفي',
			'billing.dialogDismiss' => 'حسناً',
			'boosts.title' => 'التعزيزات',
			'boosts.emptyTitle' => 'التعزيزات قريباً',
			'boosts.emptyMessage' => 'أبرز ملفك في نتائج البحث بمجرد أن تصبح هذه الميزة جاهزة.',
			'common.appName' => 'Sanaya',
			'common.home.navAuth' => 'مساحة المصادقة — قريبًا (FM-05)',
			'common.home.navClient' => 'مساحة العميل',
			'common.home.navPro' => 'مساحة المحترف',
			'common.home.navProDashboard' => 'مساحة المحترف — لوحة التحكم',
			'common.home.toggleTheme' => 'تبديل المظهر الفاتح/الداكن',
			'common.home.toggleLocale' => 'تبديل الفرنسية/العربية',
			'common.home.designSystemPreview' => 'معرض نظام التصميم',
			'common.widgets.verifiedBadge' => 'موثّق',
			'common.widgets.offlineBanner.message' => 'أنت تتصفح نتائج محفوظة. سيتم تحديثها عند عودة الاتصال بالشبكة.',
			'common.widgets.offlineBanner.dismiss' => 'فهمت',
			'common.nav.searchTab' => 'بحث',
			'common.nav.favoritesTab' => 'المفضلة',
			'common.nav.historyTab' => 'السجل',
			'common.nav.profileTab' => 'الملف الشخصي',
			'common.nav.dashboardTab' => 'لوحة التحكم',
			'common.nav.boostsTab' => 'التعزيزات',
			'common.nav.reviewsTab' => 'التقييمات',
			'common.nav.switchToClient' => 'التبديل إلى وضع العميل',
			'common.nav.switchToPro' => 'التبديل إلى وضع المحترف',
			'common.nav.exitConfirmation' => 'اضغط مرة أخرى للخروج',
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
			'common.devPreview.buttonPrimary' => 'أساسي',
			'common.devPreview.buttonDisabled' => 'معطّل',
			'common.devPreview.buttonSecondary' => 'ثانوي',
			'common.devPreview.buttonGhost' => 'شفاف',
			'common.devPreview.buttonWhatsapp' => 'واتساب',
			'common.devPreview.buttonOutlineWhatsapp' => 'واتساب (محدد)',
			'common.devPreview.buttonDanger' => 'خطر',
			'common.devPreview.phoneLabel' => 'رقم الهاتف',
			'common.devPreview.phoneHint' => '+216 22 123 456',
			'common.devPreview.otpLabel' => 'رمز التحقق',
			'common.devPreview.otpError' => 'رمز غير صحيح — تبقى لك محاولتان',
			'common.devPreview.sampleProvider1Name' => 'كريم بن صالح',
			'common.devPreview.sampleProvider1Category' => 'سباكة',
			'common.devPreview.sampleProvider1Location' => 'سوسة، خزامة · 2,4 كم',
			'common.devPreview.sampleProvider1Price' => 'ابتداءً من 40 د.ت',
			'common.devPreview.sampleProvider2Name' => 'الهادي الفرجاني',
			'common.devPreview.sampleProvider2Category' => 'دهان',
			'common.devPreview.sampleProvider2Location' => 'المنستير',
			'common.devPreview.sampleProvider2Price' => 'ابتداءً من 25 د.ت',
			'common.devPreview.emptyTitle' => 'لم يتم العثور على أي حرفي',
			'common.devPreview.emptyMessage' => 'لا يوجد سبّاك متاح في المهدية لهذه المرشحات.',
			'common.devPreview.emptyAction' => 'توسيع البحث إلى الولاية',
			'common.devPreview.errorTitle' => 'انقطع الاتصال',
			'common.devPreview.errorMessage' => 'تعذّر تحميل النتائج. تحقق من اتصالك.',
			'common.devPreview.errorAction' => 'إعادة المحاولة',
			'common.devPreview.sectionColorRoles' => 'أدوار الألوان',
			'common.devPreview.swatchLight' => 'فاتح',
			'common.devPreview.swatchDark' => 'داكن',
			'common.devPreview.sectionTypography' => 'الطباعة',
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
			'common.devPreview.statViewsLabel' => 'زيارات الملف الشخصي',
			'common.devPreview.statNewLabel' => 'جديد',
			'contact.call' => 'اتصال',
			'contact.whatsapp' => 'واتساب',
			'dashboard.title' => 'لوحة التحكم',
			'dashboard.greeting' => ({required Object name}) => 'مرحباً، ${name}',
			'dashboard.statViews' => 'مشاهدات الملف الشخصي',
			'dashboard.statUniqueViews' => 'زوار فريدون',
			'dashboard.statContacts' => 'جهات الاتصال',
			'dashboard.statRatio' => 'مشاهدة → اتصال',
			'dashboard.comparisonPreviousPeriod' => 'مقارنة بالـ 15 يومًا السابقة',
			'dashboard.comparisonNew' => 'جديد',
			'dashboard.chartTitle' => 'المشاهدات خلال 30 يومًا',
			'dashboard.chartTitle7d' => 'المشاهدات خلال 7 أيام',
			'dashboard.chartContactsLabel' => 'جهات الاتصال',
			'dashboard.chartViewsLabel' => 'المشاهدات',
			'dashboard.emptyTitle' => 'لا مشاهدات حتى الآن',
			'dashboard.emptyMessage' => 'أكمل ملفك الشخصي لتظهر في نتائج البحث.',
			'dashboard.retry' => 'إعادة المحاولة',
			'dashboard.errorTitle' => 'تعذر تحميل لوحة التحكم',
			'dashboard.errorMessage' => 'تحقق من اتصالك وأعد المحاولة.',
			'dashboard.quickActionsTitle' => 'إجراءات سريعة',
			'dashboard.actionShare' => 'مشاركة',
			'dashboard.actionPublicProfile' => 'واجهتي العامة',
			'dashboard.actionBoost' => 'ترقية',
			'dashboard.actionEditProfile' => 'ملفي الشخصي',
			'dashboard.profileLinkCopied' => 'تم نسخ رابط ملفك الشخصي إلى الحافظة',
			'dashboard.channelsTitle' => 'توزيع الاتصالات',
			'dashboard.channelsSubtitle' => 'القنوات التي يستخدمها عملاؤك',
			'dashboard.channelPhone' => 'مكالمات هاتفية',
			'dashboard.channelWhatsapp' => 'رسائل واتساب',
			'dashboard.recentActivityTitle' => 'النشاط الأخير والطلبات',
			'dashboard.recentActivitySubtitle' => 'آخر التفاعلات المستلمة',
			'dashboard.recentLeadWhatsappTitle' => 'طلب واتساب مستلم',
			'dashboard.recentLeadWhatsappDesc' => 'سباكة وصحي • سوسة (خزامة)',
			'dashboard.recentLeadPhoneTitle' => 'مكالمة مباشرة مستلمة',
			'dashboard.recentLeadPhoneDesc' => 'تصليح كهرباء عاجل • المنستير',
			'dashboard.recentLeadReviewTitle' => 'تقييم جديد 5 نجوم',
			'dashboard.recentLeadReviewDesc' => '«دقة في المواعيد وعمل متقن!» • كريم ب.',
			'dashboard.time2hAgo' => 'منذ ساعتين',
			'dashboard.time5hAgo' => 'منذ 5 ساعات',
			'dashboard.timeYesterday' => 'أمس',
			'dashboard.reputationTitle' => 'التقييمات والسمعة',
			'dashboard.reputationRating' => ({required Object rating}) => '${rating} من 5',
			'dashboard.reputationCount' => ({required Object count}) => '${count} تقييم موثق',
			'dashboard.reputationBadge' => 'حرفي موصى به في الساحل',
			'dashboard.reputationLatestReview' => '«عمل ممتاز ودقة في المواعيد واحترافية عالية في تركيب اللوحة الكهربائية.»',
			'dashboard.reputationAuthor' => '— كريم ب.، سوسة',
			'dashboard.reputationSeeAll' => 'عرض جميع التقييمات',
			'dashboard.boostBannerTitle' => 'ضاعف طلباتك 3 مرات',
			'dashboard.boostBannerSubtitle' => 'اظهر في صدارة نتائج البحث في سوسة والمنستير.',
			'dashboard.boostBannerCta' => 'اكتشف الترويجات',
			'dashboard.proTipsTitle' => 'نصائح لتطوير نشاطك',
			'dashboard.tipResponsivenessTitle' => 'سرعة استجابة قصوى',
			'dashboard.tipResponsivenessDesc' => 'الرد على المكالمات والرسائل خلال 15 دقيقة يضاعف فرصك في كسب العمل.',
			'dashboard.tipPhotosTitle' => 'أضف صوراً لأعمالك',
			'dashboard.tipPhotosDesc' => 'الملفات التي تحتوي على صور إنجازات حقيقية تحقق اتصالات أكثر بنسبة تصل إلى 70%.',
			'errors.routeNotFoundTitle' => 'الصفحة غير موجودة',
			'errors.routeNotFoundMessage' => 'هذه الصفحة غير موجودة أو لم تعد متاحة.',
			'errors.routeNotFoundAction' => 'العودة إلى الصفحة الرئيسية',
			'errors.validationLimit' => 'تم بلوغ الحد الأقصى: {limit} كحد أقصى.',
			'favorites.title' => 'المفضلات',
			'favorites.emptyTitle' => 'لا توجد عناصر مفضلة حتى الآن',
			'favorites.emptySubtitle' => 'احفظ الحرفيين للوصول إليهم بسرعة لاحقاً.',
			'favorites.exploreCta' => 'البحث عن حرفي',
			'favorites.removeTooltip' => 'إزالة من المفضلات',
			'favorites.addTooltip' => 'إضافة إلى المفضلات',
			'favorites.removeSuccess' => 'تمت إزالة الحرفي من المفضلات',
			'favorites.addSuccess' => 'تمت إضافة الحرفي إلى المفضلات',
			'favorites.removeError' => 'تعذر إزالة الحرفي من المفضلات.',
			'favorites.addError' => 'تعذر إضافة الحرفي إلى المفضلات.',
			'favorites.errorTitle' => 'تعذّر التحميل',
			'favorites.loadError' => 'تعذر تحميل قائمة المفضلات.',
			'favorites.retry' => 'إعادة المحاولة',
			'favorites.verifiedBadge' => 'موثوق',
			'favorites.authRequiredTitle' => 'احفظ الحرفيين المفضلين لديك',
			'favorites.authRequiredSubtitle' => 'سجّل الدخول لحفظ الحرفيين والوصول إليهم بسهولة.',
			'favorites.loginCta' => 'تسجيل الدخول أو إنشاء حساب',
			'history.title' => 'السجل',
			'history.emptyTitle' => 'لم تتصل بأي حرفي بعد',
			'history.emptyMessage' => 'سيظهر هنا الحرفيون الذين تتصل بهم، مع رابط سريع لترك تقييم.',
			'history.emptyCta' => 'بحث',
			'history.loadError' => 'تعذر تحميل سجلك.',
			'history.retry' => 'إعادة المحاولة',
			'history.reviewCta' => 'ترك تقييم',
			'history.channelPhone' => 'اتصال',
			'history.channelWhatsapp' => 'واتساب',
			'history.authRequiredTitle' => 'سجل اتصالاتك',
			'history.authRequiredSubtitle' => 'سجّل الدخول للعثور على الحرفيين الذين تواصلت معهم.',
			'history.loginCta' => 'تسجيل الدخول أو إنشاء حساب',
			'legal.title' => 'الإشعارات القانونية',
			'legal.editorTitle' => 'الجهة المشرفة على المنصة',
			'legal.editorContent' => 'صنايعية — منصة للربط بين الحرفيين والعملاء في تونس (الساحل: سوسة، المنستير، المهدية).',
			'legal.modelTitle' => 'نموذج الخدمة',
			'legal.modelContent' => 'صنايعية خدمة لتوفير جهات اتصال موثوقة. المنصة لا تستلم أبدًا مستحقات الخدمات ولا تتدخل في الدفع المباشر للعمل.',
			'legal.inpdpTitle' => 'حماية البيانات الشخصية (INPDP)',
			'legal.inpdpContent' => 'وفقًا للقانون الأساسي عدد 63 لسنة 2004، تلتزم صنايعية بحماية خصوصية مستخدميها. لا يتم كشف أرقام الهواتف إلا عند طلب التواصل الطوعي والمسجل.',
			'legal.rightsTitle' => 'حقوقكم',
			'legal.rightsContent' => 'يحق لكم النفاذ إلى بياناتكم الشخصية وتصحيحها أو حذفها في أي وقت.',
			'onboarding.wizardTitle' => 'كن مقدّم خدمة',
			'onboarding.back' => 'رجوع',
			'onboarding.next' => 'التالي',
			'onboarding.retry' => 'إعادة المحاولة',
			'onboarding.stepProfile' => 'الملف الشخصي',
			'onboarding.stepCategories' => 'الفئات',
			'onboarding.stepZones' => 'المناطق',
			'onboarding.stepPhotos' => 'الصور',
			'onboarding.stepSummary' => 'الملخّص',
			'onboarding.stepIndicator' => 'الخطوة {current} من {total}',
			'onboarding.profileBusinessName' => 'اسم النشاط',
			'onboarding.profileHeadline' => 'العنوان (مثال: سبّاك معتمد)',
			'onboarding.profileBio' => 'نبذة (50 حرفًا على الأقل)',
			'onboarding.profileYearsExperience' => 'سنوات الخبرة',
			'onboarding.profileWhatsapp' => 'رقم واتساب',
			'onboarding.profilePublicPhone' => 'رقم هاتف عام',
			'onboarding.profileGovernorate' => 'الولاية الرئيسية',
			'onboarding.profileGovernorateError' => 'تعذّر تحميل الولايات.',
			'onboarding.profileSaveError' => 'تعذّر حفظ الملف الشخصي. أعد المحاولة.',
			'onboarding.categoriesTitle' => 'اختر فئاتك',
			'onboarding.categoriesPrimaryHint' => 'رئيسية',
			'onboarding.categoriesEmpty' => 'اختر فئة واحدة على الأقل.',
			'onboarding.categoriesError' => 'تعذّر تحميل الفئات.',
			'onboarding.categoriesErrorMessage' => 'تحقّق من اتصالك وأعد المحاولة.',
			'onboarding.categoriesSaveError' => 'تعذّر حفظ الفئات. أعد المحاولة.',
			'onboarding.categoriesCapHint' => '3 فئات كحد أقصى في العرض المجاني',
			'onboarding.zonesTitle' => 'اختر مناطق تدخّلك',
			'onboarding.zonesCapHint' => 'ولاية واحدة كحد أقصى في العرض المجاني',
			'onboarding.zonesEmpty' => 'اختر ولاية واحدة على الأقل.',
			'onboarding.zonesError' => 'تعذّر تحميل الولايات.',
			'onboarding.zonesErrorMessage' => 'تحقّق من اتصالك وأعد المحاولة.',
			'onboarding.zonesSaveError' => 'تعذّر حفظ المناطق. أعد المحاولة.',
			'onboarding.photosTitle' => 'أضف صورًا لأعمالك',
			'onboarding.photosCapHint' => '5 صور كحد أقصى في العرض المجاني',
			'onboarding.photosCapReached' => 'تم بلوغ الحد الأقصى (5 صور) في العرض المجاني.',
			'onboarding.photosAdd' => 'إضافة صورة',
			'onboarding.photosDelete' => 'حذف هذه الصورة',
			'onboarding.photosUploadFailed' => 'فشل الإرسال',
			'onboarding.summaryTitle' => 'الملخّص',
			'onboarding.summaryCompletionLabel' => 'الملف مكتمل بنسبة {score} %',
			'onboarding.summaryMissingTitle' => 'لا يزال ناقصًا:',
			'onboarding.summaryPublish' => 'نشر ملفي',
			'onboarding.summaryPublishError' => 'تعذّر النشر. أعد المحاولة.',
			'onboarding.summaryPublished' => 'تم نشر الملف!',
			'onboarding.missingBio' => 'إضافة نبذة تعريفية (50 حرفًا على الأقل)',
			'onboarding.missingHeadline' => 'إضافة عنوان مهني',
			'onboarding.missingYearsExperience' => 'تحديد سنوات الخبرة',
			'onboarding.missingContactPhone' => 'إضافة رقم واتساب أو رقم هاتف عام',
			'onboarding.missingCategories' => 'اختيار فئة واحدة على الأقل',
			'onboarding.missingCoverageAreas' => 'اختيار ولاية واحدة على الأقل',
			'onboarding.missingPhotos' => 'إضافة صور لأعمالك',
			'onboarding.missingActionHint' => 'تعديل في خطوة {step}',
			'onboarding.summaryScoreCritical' => 'الملف غير مكتمل — يتعذر النشر (أقل من 40%)',
			'onboarding.summaryScoreWarning' => 'مزيد من الجهد للوصول إلى حد النشر (60%)',
			'onboarding.summaryScoreSuccess' => 'تم بلوغ الحد الأدنى للنشر (60% فأكثر)',
			'onboarding.clientWelcomeTitle' => 'مرحباً بك في صنايعية',
			'onboarding.clientWelcomeSubtitle' => 'اعثر على أفضل الحرفيين في الساحل التونسي بكل ثقة وسهولة.',
			'onboarding.clientStep1Title' => 'اعثر على الحرفي المناسب',
			'onboarding.clientStep1Desc' => 'سباكون، كهربائيون، دهانون، فنيو تكييف... محترفون مؤهلون ومتوفرون بالقرب منك.',
			'onboarding.clientStep2Title' => 'ثقة وتقييمات موثقة',
			'onboarding.clientStep2Desc' => 'حرفيون موثقون ببطاقة التعريف الوطنية، وتقييمات حقيقية يكتبها حُرفاء اتصلوا فعلياً بالحرفي.',
			'onboarding.clientStep3Title' => 'اتصال مباشر ومجاني 100%',
			'onboarding.clientStep3Desc' => 'اتصال أو واتساب مباشر دون عمولة وبلا وسيط. اتفق على تفاصيل العمل مباشرة مع الحرفي.',
			'onboarding.clientChooseGovernorate' => 'ولايتك المفضلة للبحث :',
			'onboarding.clientStartExploring' => 'ابدأ البحث الآن',
			'onboarding.clientSkip' => 'تخطي المقدمة',
			'onboarding.celebrationTitle' => 'مبروك! ملفك المهني أصبح متوفراً الآن',
			'onboarding.celebrationSubtitle' => 'ملفك أصبح مرئياً لجميع الحرفاء في مناطق تدخلك. يمكنك الآن استقبال طلبات التواصل.',
			'onboarding.celebrationKycCardTitle' => 'ضاعف فرص تواصل الحرفاء معك 3 مرات بالحصول على الشارة الموثقة',
			'onboarding.celebrationKycCardDescription' => 'الحرفيون الذين تم تأكيد هويتهم ببطاقة التعريف الوطنية يحظون بثقة أكبر ويظهرون في المراتب الأولى لنتائج البحث. العملية مجانية تماماً وتستغرق أقل من دقيقتين.',
			'onboarding.celebrationKycBenefitBadge' => 'شارة رسمية «حرفي موثق» على ملفك المهني',
			'onboarding.celebrationKycBenefitRank' => 'أولوية الظهور في صدارة نتائج البحث',
			'onboarding.celebrationKycBenefitFast' => 'تأكيد ومراجعة سريعة خلال 24 ساعة عمل',
			'onboarding.celebrationCtaVerify' => 'توثيق هويتي الآن',
			'onboarding.celebrationCtaDashboard' => 'الانتقال إلى لوحة التحكم',
			'proProfile.title' => 'الملف الشخصي',
			'proProfile.emptyTitle' => 'الملف غير موجود',
			'proProfile.emptyMessage' => 'لا يوجد ملف حرفي مرتبط بهذا الحساب.',
			'proProfile.switchToClientSpace' => 'العودة إلى مساحة العميل',
			'proProfile.errorTitle' => 'تعذّر تحميل ملفك الشخصي',
			'proProfile.errorMessage' => 'تحقق من اتصالك وأعد المحاولة.',
			'proProfile.retry' => 'إعادة المحاولة',
			'proProfile.availabilitySection' => 'التوفر',
			'proProfile.acceptsEmergencyLabel' => 'يقبل الحالات المستعجلة',
			'proProfile.acceptsEmergencyDescription' => 'يُظهر شارة "مستعجل" في نتائج البحث',
			'proProfile.editSection' => 'تعديل ملفي الشخصي',
			'proProfile.save' => 'حفظ',
			'proProfile.saveSuccess' => 'تم تحديث الملف الشخصي',
			'proProfile.viewMyListing' => 'شاهد ملفي كما يراه العميل',
			'proProfile.completionTitle' => 'اكتمال الملف الشخصي',
			'proProfile.completionLabel' => 'الملف مكتمل بنسبة {score} %',
			'proProfile.completionTip' => 'الملف المكتمل يحصل على 3 أضعاف طلبات الاتصال في المتوسط.',
			'proProfile.relaunchOnboarding' => 'تعديل عبر معالج التسجيل الكامل',
			'proProfile.yearsExperience' => '{years} سنوات خبرة',
			'proProfile.verifiedBadge' => 'حرفي موثّق',
			'proProfile.unverifiedBadge' => 'في انتظار التوثيق',
			'proProfile.statsViews' => 'مشاهدات الملف',
			'proProfile.statsContacts' => 'اتصالات واردة',
			'proProfile.statsRating' => 'متوسط التقييم',
			'proProfile.publicPreviewTitle' => 'الواجهة العامة',
			'proProfile.publicPreviewSubtitle' => 'اطلع على بطاقتك كما تظهر للحرفاء والباحثين عن خدمات',
			'proProfile.portfolioSection' => 'معرض الأعمال والإنجازات',
			'proProfile.portfolioDesc' => 'صور لمشاريعك وتدخلاتك السابقة',
			'proProfile.categoriesAndZones' => 'المهن ومناطق التدخل',
			'proProfile.categoriesSection' => 'مهنتي وتخصصاتي',
			'proProfile.categoriesDesc' => 'إدارة المهن التي تمارسها والمهنة الرئيسية',
			'proProfile.categoriesUpdated' => 'تم تحديث المهن بنجاح',
			'proProfile.categoriesEmpty' => 'لم يتم تحديد أي مهنة',
			'proProfile.zonesSection' => 'مناطق التدخل',
			'proProfile.zonesDesc' => 'الولايات التي تغطيها خدماتك',
			'proProfile.zonesUpdated' => 'تم تحديث مناطق التدخل بنجاح',
			'proProfile.zonesEmpty' => 'لم يتم تحديد أي ولاية',
			'proProfile.editCategories' => 'تعديل المهن',
			'proProfile.editZones' => 'تعديل المناطق',
			'proProfile.availabilityUpdated' => 'تم تحديث الحالة بنجاح',
			'proProfile.testOnboardingPro' => 'تجربة تسجيل الحرفي',
			'proProfile.testOnboardingClient' => 'تجربة تسجيل الحريف',
			'profile.title' => 'الملف الشخصي',
			'profile.accountFallback' => 'حسابي',
			'profile.switchToProSpace' => 'التبديل إلى مساحة المحترفين',
			'profile.guestName' => 'زائر',
			'profile.guestSubtitle' => 'غير متصل',
			'profile.loginCta' => 'تسجيل الدخول أو إنشاء حساب',
			'profile.becomeProTitle' => 'انضم كحرفي على صنايعية',
			'profile.becomeProSubtitle' => 'هل أنت حرفي أو مهني؟ قدم خدماتك واستقبل طلبات الحرفاء مباشرة.',
			'profile.becomeProButton' => 'إنشاء حساب حرفي',
			'provider.profile.callButton' => 'اتصال',
			'provider.profile.whatsappButton' => 'واتساب',
			'provider.profile.reviewsTitle' => 'التقييمات',
			'provider.profile.loadMoreReviews' => 'عرض المزيد من التقييمات',
			'provider.profile.noReviews' => 'لا توجد تقييمات حتى الآن.',
			'provider.profile.reviewsErrorTitle' => 'تعذّر التحميل',
			'provider.profile.reviewsError' => 'تعذّر تحميل التقييمات.',
			'provider.profile.offeringsTitle' => 'الخدمات',
			'provider.profile.coverageTitle' => 'مناطق التدخل',
			'provider.profile.yearsExperience' => '{n} سنة خبرة',
			'provider.profile.availableNow' => 'متوفر',
			'provider.profile.busy' => 'مشغول',
			'provider.profile.onHoliday' => 'في عطلة',
			'provider.profile.verifiedContact' => 'اتصال موثّق',
			'provider.profile.errorLoadTitle' => 'تعذّر التحميل',
			'provider.profile.errorLoad' => 'تعذّر تحميل بطاقة الحرفي.',
			'provider.profile.retry' => 'إعادة المحاولة',
			'provider.profile.writeReview' => 'كتابة تقييم',
			'provider.profile.reviewTitle' => 'رأيك في هذا الحرفي',
			'provider.profile.ratingLabel' => 'تقييمك',
			'provider.profile.ratingStarSemanticLabel' => '{n} نجمة/نجوم',
			'provider.profile.ratingRequired' => 'يرجى اختيار تقييم من 1 إلى 5 نجوم',
			'provider.profile.commentLabel' => 'تعليقك (اختياري)',
			'provider.profile.commentHint' => 'شارك تجربتك مع هذا الحرفي...',
			'provider.profile.submitReview' => 'نشر التقييم',
			'provider.profile.submittingReview' => 'جاري النشر...',
			'provider.profile.reviewSuccess' => 'شكراً! تم نشر تقييمك.',
			'provider.profile.reviewRequiresContact' => 'يجب أن تكون قد تواصلت مع هذا الحرفي لتتمكن من تقييمه.',
			'provider.profile.reviewSelfForbidden' => 'لا يمكنك تقييم حسابك الخاص.',
			'provider.profile.reviewGenericError' => 'تعذّر نشر تقييمك. يرجى المحاولة مرة أخرى.',
			'provider.profile.reviewLoginRequired' => 'يجب عليك تسجيل الدخول لترك تقييم.',
			'provider.profile.reviewPromptTitle' => 'هل تعاملت مع هذا الحرفي؟',
			'provider.profile.reviewPromptSubtitle' => 'شارك رأيك لمساعدة المجتمع.',
			'provider.profile.reviewPromptCta' => 'ترك تقييم',
			'provider.profile.authRequiredTitle' => 'تسجيل الدخول مطلوب',
			'provider.profile.authRequiredSubtitle' => 'سجّل الدخول لتتمكن من تقييم هذا الحرفي.',
			'provider.profile.loginCta' => 'تسجيل الدخول أو إنشاء حساب',
			'reviews.title' => 'التقييمات',
			'reviews.emptyTitle' => 'لا توجد تقييمات حتى الآن',
			'reviews.emptyMessage' => 'ستظهر هنا التقييمات التي يتركها عملاؤك.',
			'reviews.loadError' => 'تعذر تحميل التقييمات.',
			'reviews.errorMessage' => 'حدث خطأ أثناء تحميل التقييمات الخاصة بك.',
			'reviews.retry' => 'إعادة المحاولة',
			'reviews.loadMore' => 'تحميل المزيد من التقييمات',
			'reviews.reviewsCount' => ({required Object count}) => '${count} تقييم',
			'reviews.ratingSummary' => 'متوسط التقييم',
			'reviews.replyAction' => 'الرد',
			'reviews.replyComingSoon' => 'الرد على التقييمات سيكون متاحاً قريباً',
			'search.searchPlaceholder' => 'ابحث عن خدمة…',
			'search.locationPlaceholder' => 'اختر ولاية',
			'search.serviceLabel' => 'الخدمة',
			'search.governorateLabel' => 'الولاية',
			'search.categoriesTitle' => 'الفئات',
			'search.categoriesEmptyTitle' => 'لا توجد فئات',
			'search.categoriesEmpty' => 'لا توجد فئات متاحة حاليًا.',
			'search.categoriesErrorTitle' => 'تعذّر التحميل',
			'search.categoriesError' => 'تعذّر تحميل الفئات.',
			'search.locationError' => 'تعذّر تحميل الولايات.',
			'search.retry' => 'إعادة المحاولة',
			'search.filterRatingMin' => 'تقييم 4+',
			'search.filterUrgent' => 'عاجل',
			'search.resultsTitle' => 'النتائج',
			'search.filterVerified' => 'موثّق',
			'search.emptyTitle' => 'لم يتم العثور على أي حرفي',
			'search.emptySubtitle' => 'جرّب تعديل معايير البحث أو اختيار ولاية أخرى.',
			'search.resetFilters' => 'إعادة تعيين الفلاتر',
			'search.loadErrorTitle' => 'خطأ في التحميل',
			'search.loadError' => 'تعذّر تحميل النتائج.',
			'search.offlineNotice' => 'النتائج بدون اتصال',
			'settings.title' => 'الإعدادات',
			'settings.languageSection' => 'اللغة',
			'settings.french' => 'Français',
			'settings.arabic' => 'العربية (تونس)',
			'settings.themeSection' => 'المظهر',
			'settings.themeSystem' => 'النظام',
			'settings.themeLight' => 'فاتح',
			'settings.themeDark' => 'داكن',
			'settings.legalSection' => 'المعلومات والشروط القانونية',
			'settings.legalNotices' => 'الإشعارات القانونية',
			'settings.privacyPolicy' => 'حماية البيانات الشخصية (INPDP)',
			'settings.accountSection' => 'الحساب',
			'settings.login' => 'تسجيل الدخول أو إنشاء حساب',
			'settings.logout' => 'تسجيل الخروج',
			'settings.logoutConfirmTitle' => 'تسجيل الخروج',
			'settings.logoutConfirmMessage' => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
			'settings.cancel' => 'إلغاء',
			'settings.confirm' => 'تأكيد',
			'settings.version' => 'الإصدار',
			'settings.demoSection' => 'الوضع التجريبي (بيانات تجريبية)',
			'settings.demoMode' => 'تفعيل الوضع التجريبي',
			'settings.demoModeSubtitle' => 'محاكاة الحرفيين والتقييمات والسجل دون اتصال بخادم',
			'settings.demoRoleGuest' => 'زائر (غير متصل)',
			'settings.demoRoleClient' => 'وضع الحريف',
			'settings.demoRolePro' => 'وضع الحرفي',
			'settings.demoBanner' => 'الوضع التجريبي نشط',
			'settings.testToolsSection' => 'أدوات تجربة مسار التسجيل',
			'settings.testOnboardingPro' => 'تجربة تسجيل الحرفي',
			'settings.testOnboardingProDesc' => 'بدء معالج التسجيل بـ 5 مراحل (الملف، المهن، المناطق، الصور، الملخص)',
			'settings.testOnboardingClient' => 'تجربة ترحيب الحريف',
			'settings.testOnboardingClientDesc' => 'بدء مسار الاكتشاف التفاعلي المخصص للحرفاء',
			'verification.screenTitle' => 'التحقق من الهوية',
			'verification.headerTitle' => 'احصل على شارة الحرفي المعتمد',
			'verification.headerSubtitle' => 'عزز ثقة حرفائك من خلال توثيق حسابك ببطاقة التعريف الوطنية التونسية.',
			'verification.badgeAdvantage1' => 'شارة رسمية تظهر في ملفك الشخصي ونتائج البحث',
			'verification.badgeAdvantage2' => 'أولوية الظهور والترتيب في نتائج البحث',
			'verification.identitySectionTitle' => 'معلومات الهوية',
			'verification.fullNameLabel' => 'الاسم واللقب (كما في بطاقة التعريف)',
			'verification.fullNameHint' => 'مثال: أحمد بن صالح',
			'verification.fullNameError' => 'الرجاء إدخال الاسم واللقب (3 أحرف على الأقل)',
			'verification.cinNumberLabel' => 'رقم بطاقة التعريف الوطنية (CIN)',
			'verification.cinNumberHint' => '8 أرقام (مثال: 08123456)',
			'verification.cinNumberError' => 'يجب أن يتكون رقم بطاقة التعريف من 8 أرقام بالضبط',
			'verification.cinFrontTitle' => 'الوجه الأمامي (Recto)',
			'verification.cinFrontSubtitle' => 'صورة واضحة للوجه الأمامي لبطاقة التعريف',
			'verification.cinBackTitle' => 'الوجه الخلفي (Verso)',
			'verification.cinBackSubtitle' => 'صورة واضحة للوجه الخلفي لبطاقة التعريف',
			'verification.takePhoto' => 'التقاط صورة',
			'verification.chooseFromGallery' => 'اختيار من المعرض',
			'verification.changePhoto' => 'تغيير',
			'verification.deletePhoto' => 'حذف',
			'verification.uploading' => 'جارٍ التحميل ({progress}%)...',
			'verification.uploadError' => 'فشل في تحميل الصورة. انقر للمحاولة مرة أخرى.',
			'verification.inpdpConsentLabel' => 'أوافق على معالجة وثيقة هويتي طبقاً للقانون عدد 63 لسنة 2004 المتعلق بحماية المعطيات الشخصية.',
			'verification.inpdpConsentLink' => 'مزيد من المعلومات حول حماية معطياتك الشخصية',
			'verification.inpdpDialogTitle' => 'حماية معطياتك الشخصية',
			'verification.inpdpDialogBody' => 'يتم تخزين وثائق هويتك في خزانة رقمية مشفرة وعالية الأمان (AES-256-GCM). لا يتم نشرها أو مشاركتها علناً أبداً، وتُستخدم حصرياً للتحقق من حسابك من قبل فريق الإشراف.',
			'verification.inpdpDialogClose' => 'فهمت',
			'verification.submitButton' => 'إرسال للتحقق',
			'verification.submitting' => 'جارٍ إرسال الطلب...',
			'verification.submitSuccessTitle' => 'تم إرسال الطلب بنجاح !',
			'verification.submitSuccessMessage' => 'يقوم فريقنا بمراجعة وثيقتك خلال 24 ساعة عمل. سيتم إشعارك فور الاعتماد.',
			'verification.backToDashboard' => 'العودة إلى لوحة القيادة',
			'verification.statusPending' => 'التحقق قيد المراجعة',
			'verification.statusApproved' => 'حرفي معتمد',
			'verification.statusRejected' => 'تم رفض التحقق',
			'verification.statusMoreInfo' => 'مطلوب معلومات إضافية',
			'verification.statusNotSubmitted' => 'غير موثق',
			'verification.alreadyPending' => 'لديك طلب تحقق قيد المراجعة حالياً.',
			'verification.alreadyVerified' => 'ملفك الشخصي معتمد بالفعل.',
			'verification.missingDocuments' => 'الرجاء توفير الوجهين الأمامي والخلفي لبطاقة التعريف.',
			'verification.consentRequired' => 'الرجاء الموافقة على شروط معالجة المعطيات.',
			'verification.generalError' => 'حدث خطأ أثناء الإرسال. الرجاء المحاولة مرة أخرى.',
			'verification.bannerNotSubmittedTitle' => 'وثّق حسابك المهني',
			'verification.bannerNotSubmittedBody' => 'احصل على شارة الحرفي المعتمد لتعزيز ثقة الحرفاء والأولوية في نتائج البحث.',
			'verification.bannerNotSubmittedCta' => 'توثيق حسابي الآن',
			'verification.bannerPendingTitle' => 'التحقق قيد المراجعة',
			'verification.bannerPendingBody' => 'وثيقة هويتك قيد المراجعة من قبل فريقنا خلال 24 ساعة عمل. سيتم إشعارك فور الاعتماد.',
			'verification.bannerApprovedTitle' => 'حساب موثق ومعتمد',
			'verification.bannerApprovedBody' => 'تم التحقق من هويتك بنجاح. شارتك الرسمية ظاهرة الآن في ملفك الشخصي والبحث.',
			'verification.bannerRejectedTitle' => 'لم يتم قبول التحقق',
			'verification.bannerRejectedBody' => 'تعذر قبول طلب التحقق. السبب: {reason}',
			'verification.bannerRejectedDefaultReason' => 'الوثيقة غير واضحة أو غير مطابقة.',
			'verification.bannerRejectedCta' => 'إعادة إرسال الوثائق',
			'verification.bannerMoreInfoTitle' => 'مطلوب معلومات إضافية',
			'verification.bannerMoreInfoBody' => 'يلزم تقديم معلومات إضافية لاستكمال التحقق من حسابك: {reason}',
			'verification.bannerMoreInfoCta' => 'تحديث الملف',
			'verification.profileTileTitle' => 'التحقق من الهوية',
			_ => null,
		};
	}
}
