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
	@override late final Translations$common$ar common = Translations$common$ar._(_root);
	@override late final Translations$contact$ar contact = Translations$contact$ar._(_root);
	@override late final Translations$favorites$ar favorites = Translations$favorites$ar._(_root);
	@override late final Translations$legal$ar legal = Translations$legal$ar._(_root);
	@override late final Translations$search$ar search = Translations$search$ar._(_root);
	@override late final Translations$settings$ar settings = Translations$settings$ar._(_root);
}

// Path: common
class Translations$common$ar extends Translations$common$fr {
	Translations$common$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get appName => 'Sanaya';
	@override late final Translations$common$home$ar home = Translations$common$home$ar._(_root);
}

// Path: contact
class Translations$contact$ar extends Translations$contact$fr {
	Translations$contact$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get call => 'اتصال';
	@override String get whatsapp => 'واتساب';
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
	@override String get loadError => 'تعذر تحميل قائمة المفضلات.';
	@override String get retry => 'إعادة المحاولة';
	@override String get verifiedBadge => 'موثوق';
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

// Path: search
class Translations$search$ar extends Translations$search$fr {
	Translations$search$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get searchPlaceholder => 'ابحث عن خدمة…';
	@override String get locationPlaceholder => 'اختر ولاية';
	@override String get categoriesTitle => 'الفئات';
	@override String get categoriesEmpty => 'لا توجد فئات متاحة حاليًا.';
	@override String get categoriesError => 'تعذّر تحميل الفئات.';
	@override String get locationError => 'تعذّر تحميل الولايات.';
	@override String get retry => 'إعادة المحاولة';
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
	@override String get logout => 'تسجيل الخروج';
	@override String get logoutConfirmTitle => 'تسجيل الخروج';
	@override String get logoutConfirmMessage => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';
	@override String get cancel => 'إلغاء';
	@override String get confirm => 'تأكيد';
	@override String get version => 'الإصدار';
}

// Path: common.home
class Translations$common$home$ar extends Translations$common$home$fr {
	Translations$common$home$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get navAuth => 'مساحة المصادقة — قريبًا (FM-05)';
	@override String get navClient => 'مساحة العميل';
	@override String get navPro => 'مساحة المحترف — قريبًا (FM-08)';
	@override String get toggleTheme => 'تبديل المظهر الفاتح/الداكن';
	@override String get toggleLocale => 'تبديل الفرنسية/العربية';
	@override String get designSystemPreview => 'معرض نظام التصميم';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'Sanaya',
			'common.home.navAuth' => 'مساحة المصادقة — قريبًا (FM-05)',
			'common.home.navClient' => 'مساحة العميل',
			'common.home.navPro' => 'مساحة المحترف — قريبًا (FM-08)',
			'common.home.toggleTheme' => 'تبديل المظهر الفاتح/الداكن',
			'common.home.toggleLocale' => 'تبديل الفرنسية/العربية',
			'common.home.designSystemPreview' => 'معرض نظام التصميم',
			'contact.call' => 'اتصال',
			'contact.whatsapp' => 'واتساب',
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
			'favorites.loadError' => 'تعذر تحميل قائمة المفضلات.',
			'favorites.retry' => 'إعادة المحاولة',
			'favorites.verifiedBadge' => 'موثوق',
			'legal.title' => 'الإشعارات القانونية',
			'legal.editorTitle' => 'الجهة المشرفة على المنصة',
			'legal.editorContent' => 'صنايعية — منصة للربط بين الحرفيين والعملاء في تونس (الساحل: سوسة، المنستير، المهدية).',
			'legal.modelTitle' => 'نموذج الخدمة',
			'legal.modelContent' => 'صنايعية خدمة لتوفير جهات اتصال موثوقة. المنصة لا تستلم أبدًا مستحقات الخدمات ولا تتدخل في الدفع المباشر للعمل.',
			'legal.inpdpTitle' => 'حماية البيانات الشخصية (INPDP)',
			'legal.inpdpContent' => 'وفقًا للقانون الأساسي عدد 63 لسنة 2004، تلتزم صنايعية بحماية خصوصية مستخدميها. لا يتم كشف أرقام الهواتف إلا عند طلب التواصل الطوعي والمسجل.',
			'legal.rightsTitle' => 'حقوقكم',
			'legal.rightsContent' => 'يحق لكم النفاذ إلى بياناتكم الشخصية وتصحيحها أو حذفها في أي وقت.',
			'search.searchPlaceholder' => 'ابحث عن خدمة…',
			'search.locationPlaceholder' => 'اختر ولاية',
			'search.categoriesTitle' => 'الفئات',
			'search.categoriesEmpty' => 'لا توجد فئات متاحة حاليًا.',
			'search.categoriesError' => 'تعذّر تحميل الفئات.',
			'search.locationError' => 'تعذّر تحميل الولايات.',
			'search.retry' => 'إعادة المحاولة',
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
			'settings.logout' => 'تسجيل الخروج',
			'settings.logoutConfirmTitle' => 'تسجيل الخروج',
			'settings.logoutConfirmMessage' => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
			'settings.cancel' => 'إلغاء',
			'settings.confirm' => 'تأكيد',
			'settings.version' => 'الإصدار',
			_ => null,
		};
	}
}
