import 'package:flutter/material.dart';

part 'objects.dart';

class AppLocalizations {

  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title':      'Gallery',
      'drawer_title':   'Gallery',
      //
      'neu':      'New',
      'random':   'Random',
      'travel':   'Travel',
      'girls':    'Girls',
      'fitness':  'Fitness',
      'cars':     'Cars',
      'islands':  'Islands',
      'about':    'About',
      //
      'share':    'Share',
      'refresh':  'Refresh',
      'retry':    'Retry',
      'copied':   'Copied!',
      'the_end':                 'You have reached the end',
      'latest':                  'You see the latest photos',
      'see_on_play':             'See on Google Play',
      'app_git_hub':             'App GitHub page',
      'app_credits':             "Credits to Unsplash and photos' authors",
      'download':                'Download',
      'author_page_copied':      'Author page copied!',
      'instagram_copied':        'Instagram name copied!',
      'twitter_copied':          'Twitter name copied!',
      'get_more':                'Get more',
      //
      LocKeys.noNet:              "Connection problem.\nCheck Internet and retry.",
      LocKeys.notOk:              "Contact server error",
      LocKeys.errInLog:           "An error occured.\nTechnical details in log.",
      LocKeys.unreachable:        "Server is unreachable",
      LocKeys.noMore:             "No more data",
      LocKeys.noData:             "No data was recieved",
      LocKeys.dataUnsupported:    "Data format is not supported",
      LocKeys.unknownResponse:    "Unknown server response",
      LocKeys.remoteError:        "Server error",
      LocKeys.rateLimit:          "Rate Limit Exceeded. Please, try later.\nNow the app works in dev-mode.",
    },
  };

  Map<String, String> get _localized => _localizedValues[locale.languageCode];

  String localized(String key) => _localized[key];

  String get appTitle    => _localized['app_title'];
  String get drawerTitle => _localized['drawer_title'];
  //
  String get neu      => _localized['neu'];
  String get random   => _localized['random'];
  String get travel     => _localized['travel'];
  String get girls    => _localized['girls'];
  String get fitness     => _localized['fitness'];
  String get cars     => _localized['cars'];
  String get islands     => _localized['islands'];
  String get about    => _localized['about'];
  //
  String get share    => _localized['share'];
  String get refresh  => _localized['refresh'];
  String get retry    => _localized['retry'];
  String get copied   => _localized['copied'];
  String get theEnd       => _localized['the_end'];
  String get latest       => _localized['latest'];
  String get seeOnPlay    => _localized['see_on_play'];
  String get appGitHub    => _localized['app_git_hub'];
  String get appCredits   => _localized['app_credits'];
  String get download     => _localized['download'];
  String get authorPageCopied   => _localized['author_page_copied'];
  String get instagramCopied    => _localized['instagram_copied'];
  String get twitterCopied      => _localized['twitter_copied'];
  String get getMore            => _localized['get_more'];
}

abstract class LocKeys {

  static const noNet              = 'no_net';
  static const errInLog           = 'err_in_log';
  static const unreachable        = 'unreachable';
  static const noMore             = 'no_more';
  static const noData             = 'no_data';
  static const dataUnsupported    = 'data_unsupported';
  static const unknownResponse    = 'unknown_response';
  static const notOk              = 'not_ok';
  static const remoteError        = 'remote_error';
  static const rateLimit          = 'rateLimit';

}
