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
	@override late final Translations$search$ar search = Translations$search$ar._(_root);
}

// Path: common
class Translations$common$ar extends Translations$common$fr {
	Translations$common$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get appName => 'Sanaya';
	@override late final Translations$common$home$ar home = Translations$common$home$ar._(_root);
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
			'search.searchPlaceholder' => 'ابحث عن خدمة…',
			'search.locationPlaceholder' => 'اختر ولاية',
			'search.categoriesTitle' => 'الفئات',
			'search.categoriesEmpty' => 'لا توجد فئات متاحة حاليًا.',
			'search.categoriesError' => 'تعذّر تحميل الفئات.',
			'search.locationError' => 'تعذّر تحميل الولايات.',
			'search.retry' => 'إعادة المحاولة',
			_ => null,
		};
	}
}
