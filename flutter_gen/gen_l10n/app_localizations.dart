import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
    Locale('az'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Agranova'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farmer Community'**
  String get appSubtitle;

  /// No description provided for @tabAnaSehife.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get tabAnaSehife;

  /// No description provided for @tabSohbetler.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get tabSohbetler;

  /// No description provided for @tabQruplar.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get tabQruplar;

  /// No description provided for @tabHava.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get tabHava;

  /// No description provided for @tabDastek.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get tabDastek;

  /// No description provided for @buttonLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get buttonLogin;

  /// No description provided for @buttonRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get buttonRegister;

  /// No description provided for @buttonLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get buttonLogout;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get buttonNext;

  /// No description provided for @buttonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get buttonBack;

  /// No description provided for @buttonSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get buttonSend;

  /// No description provided for @buttonLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get buttonLike;

  /// No description provided for @buttonComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get buttonComment;

  /// No description provided for @buttonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get buttonShare;

  /// No description provided for @buttonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get buttonSearch;

  /// No description provided for @buttonAddPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get buttonAddPost;

  /// No description provided for @buttonStartChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get buttonStartChat;

  /// No description provided for @buttonCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get buttonCreateGroup;

  /// No description provided for @buttonEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get buttonEditProfile;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPassword;

  /// No description provided for @labelConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get labelConfirmPassword;

  /// No description provided for @labelPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get labelPhoneNumber;

  /// No description provided for @labelFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get labelFullName;

  /// No description provided for @labelFarmName.
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get labelFarmName;

  /// No description provided for @labelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get labelLocation;

  /// No description provided for @labelBio.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get labelBio;

  /// No description provided for @labelProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get labelProfilePhoto;

  /// No description provided for @labelFarmType.
  ///
  /// In en, this message translates to:
  /// **'Farm Type'**
  String get labelFarmType;

  /// No description provided for @labelAgriculturalProducts.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Products'**
  String get labelAgriculturalProducts;

  /// No description provided for @hintEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get hintEnterEmail;

  /// No description provided for @hintEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get hintEnterPassword;

  /// No description provided for @hintEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get hintEnterFullName;

  /// No description provided for @hintEnterFarmName.
  ///
  /// In en, this message translates to:
  /// **'Enter your farm name'**
  String get hintEnterFarmName;

  /// No description provided for @hintSearchPosts.
  ///
  /// In en, this message translates to:
  /// **'Search posts...'**
  String get hintSearchPosts;

  /// No description provided for @hintSearchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get hintSearchUsers;

  /// No description provided for @hintWriteMessage.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get hintWriteMessage;

  /// No description provided for @hintWriteComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get hintWriteComment;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get validationInvalidEmail;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordLength;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMatch;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @errorLoadingPosts.
  ///
  /// In en, this message translates to:
  /// **'Error loading posts'**
  String get errorLoadingPosts;

  /// No description provided for @errorLoadingChats.
  ///
  /// In en, this message translates to:
  /// **'Error loading chats'**
  String get errorLoadingChats;

  /// No description provided for @errorCreatingPost.
  ///
  /// In en, this message translates to:
  /// **'Error creating post'**
  String get errorCreatingPost;

  /// No description provided for @errorSendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Error sending message'**
  String get errorSendingMessage;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get errorLoginFailed;

  /// No description provided for @errorRegisterFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get errorRegisterFailed;

  /// No description provided for @errorProfileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorProfileUpdateFailed;

  /// No description provided for @errorNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get errorNetworkError;

  /// No description provided for @successPostCreated.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully'**
  String get successPostCreated;

  /// No description provided for @successProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get successProfileUpdated;

  /// No description provided for @successMessageSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get successMessageSent;

  /// No description provided for @successRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully'**
  String get successRegistered;

  /// No description provided for @emptyPostsFeed.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get emptyPostsFeed;

  /// No description provided for @emptyChats.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get emptyChats;

  /// No description provided for @emptyGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get emptyGroups;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumBadge;

  /// No description provided for @premiumOnlyFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Only'**
  String get premiumOnlyFeature;

  /// No description provided for @specialistCall.
  ///
  /// In en, this message translates to:
  /// **'Expert Video Call'**
  String get specialistCall;

  /// No description provided for @agroBot.
  ///
  /// In en, this message translates to:
  /// **'AGRO-BOT'**
  String get agroBot;

  /// No description provided for @agroBotQuestion.
  ///
  /// In en, this message translates to:
  /// **'Q&A'**
  String get agroBotQuestion;

  /// No description provided for @expertSupport.
  ///
  /// In en, this message translates to:
  /// **'Expert Support'**
  String get expertSupport;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @weatherToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Weather'**
  String get weatherToday;

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

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @rainfall.
  ///
  /// In en, this message translates to:
  /// **'Rainfall'**
  String get rainfall;

  /// No description provided for @feedTitle.
  ///
  /// In en, this message translates to:
  /// **'Farmer Feed'**
  String get feedTitle;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsTitle;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherTitle;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support & AI'**
  String get supportTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Agranova!'**
  String get welcomeMessage;

  /// No description provided for @loadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingText;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last Seen'**
  String get lastSeen;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get groupMembers;

  /// No description provided for @groupDescription.
  ///
  /// In en, this message translates to:
  /// **'Group Description'**
  String get groupDescription;

  /// No description provided for @joinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join Group'**
  String get joinGroup;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get leaveGroup;

  /// No description provided for @groupSettings.
  ///
  /// In en, this message translates to:
  /// **'Group Settings'**
  String get groupSettings;
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
      <String>['az', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
