import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Mausam Saathi'**
  String get appName;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search village / city'**
  String get searchLocation;

  /// No description provided for @currentWeather.
  ///
  /// In en, this message translates to:
  /// **'Current Weather'**
  String get currentWeather;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @rainChance.
  ///
  /// In en, this message translates to:
  /// **'Rain Chance'**
  String get rainChance;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @cloudCover.
  ///
  /// In en, this message translates to:
  /// **'Cloud Cover'**
  String get cloudCover;

  /// No description provided for @currentSeason.
  ///
  /// In en, this message translates to:
  /// **'Current Season'**
  String get currentSeason;

  /// No description provided for @commonCrops.
  ///
  /// In en, this message translates to:
  /// **'Common Crops in this Region'**
  String get commonCrops;

  /// No description provided for @selectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select a crop for advisory'**
  String get selectCrop;

  /// No description provided for @cropAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Crop Advisory'**
  String get cropAdvisory;

  /// No description provided for @sevenDayForecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Forecast'**
  String get sevenDayForecast;

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter village, city or district name'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No locations found. Try another name.'**
  String get noResults;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error;

  /// No description provided for @riskHigh.
  ///
  /// In en, this message translates to:
  /// **'⚠️ High Risk'**
  String get riskHigh;

  /// No description provided for @riskMedium.
  ///
  /// In en, this message translates to:
  /// **'⚡ Medium Risk'**
  String get riskMedium;

  /// No description provided for @riskLow.
  ///
  /// In en, this message translates to:
  /// **'✅ Low Risk'**
  String get riskLow;

  /// No description provided for @kharif.
  ///
  /// In en, this message translates to:
  /// **'Kharif'**
  String get kharif;

  /// No description provided for @rabi.
  ///
  /// In en, this message translates to:
  /// **'Rabi'**
  String get rabi;

  /// No description provided for @zaid.
  ///
  /// In en, this message translates to:
  /// **'Zaid'**
  String get zaid;

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @precipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get precipitation;

  /// No description provided for @todayAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Advisory'**
  String get todayAdvisory;

  /// No description provided for @tapForAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Tap a crop to get advisory'**
  String get tapForAdvisory;

  /// No description provided for @noCropsFound.
  ///
  /// In en, this message translates to:
  /// **'No crops found for this region and season.'**
  String get noCropsFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @crops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// No description provided for @advisory.
  ///
  /// In en, this message translates to:
  /// **'Advisory'**
  String get advisory;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
