import 'package:cookie/cookie.dart' as cookie;
import 'cookie.dart';

class AppConfig {
  static AppConfig inst = new AppConfig();
  MyCookie _cookie= new MyCookie();
  MyCookie get cookie=> _cookie;

  String get clientAddr => "http://localhost:8081";

  String get baseAddr => "http://localhost:8080";

  String makeUrl(path) => baseAddr + path;

  String get twitterLoginUrl =>
      makeUrl("""/api/v1/twitter/tokenurl/redirect?cb=${Uri.encodeFull(
          clientAddr + "/")}""");
}
