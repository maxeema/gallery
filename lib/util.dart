
import 'package:url_launcher/url_launcher.dart' as launcher;

bool isEmpty(String s) => s?.trim()?.isEmpty ?? true;
bool isNotEmpty(String s) => !isEmpty(s);

assetsSvgIcon(String name) => "assets/icons/${name.replaceAll(' ', '_').toLowerCase()}.svg";

launchTwitter(String user)   => launcher.launch('https://twitter/$user');
launchInstagram(String user) => launcher.launch('https://www.instagram.com/$user');
