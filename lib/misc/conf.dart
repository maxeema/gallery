
import 'package:flutter/material.dart';

///
/// Conf & Const
///

const apiBaseUrl = 'api.unsplash.com';
const apiPhotosPerPage = 30; // now 30 is api restricted max photos per page
const apiTokens = {
  '201bce8c9c3ea17aa7cb4884c062835f7c8c23406ad89b4e1d34ff2c1aef988c'
};

const appColor = Colors.indigo;
const appAccentColor = Colors.pinkAccent;
const appLegalese = "© Maxeem Shemetov, 2020";
const appGitHubPage = 'https://github.com/maxeema/gallery';

// Tunings
const minUniquePhotosPerUiOperation = apiPhotosPerPage * .8;
