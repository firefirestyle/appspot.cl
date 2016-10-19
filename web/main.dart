library firestylesite;
import 'dart:html' as html;
import 'dart:async';
import 'package:dart.html.location/location.dart' as loc;
import 'config.dart';
//
part 'page/twitter.dart';
part 'page/user.dart';
part 'page/error.dart';
part 'page/me.dart';
part 'page/toolbar.dart';
//import 'package:dart.httprequest/request.dart' as req;
//import 'package:dart.httprequest/request_ver_html.dart' as req;

//String configBackendAddr = "";

LoginNBox GetLoginNBox() {
  return new LoginNBox();
}

class PageManager {
  static String title = "title";
  static String message = "message";
  static String backurl = "backurl";
  static String userNameId = "userName";
  static PageManager instance = new PageManager();

  void jumpToUserPage(String userName) {
    loc.Location l = new loc.Location();
    html.window.location.assign(l.baseAddr+"/#/User?${userNameId}=${Uri.encodeComponent(userName)}");
  }

  void jumpToErrorPage(String title, String message, String backurl) {
    loc.Location l = new loc.Location();
    html.window.location.assign(l.baseAddr+"/#/Error?title=${Uri.encodeComponent(title)}&message=${Uri.encodeComponent(message)}&backurl=${Uri.encodeComponent(backurl)}");
  }

  List<String> getErrorPageRequest(loc.Location location){
    return [location.getValueAsString(title, ""),location.getValueAsString(message, ""),location.getValueAsString(backurl, "")];
  }

  List<String> getUserNamePageRequest(loc.Location location){
    return [location.getValueAsString(userNameId, "")];
  }

}

void main() {
  print("hello client");
  ContentBuilder c = new ContentBuilder()..addItem("ME", "#/Me")..addItem("Home", "#/Home");
  c.bake(html.document.body);
  //
  //
  loc.PageManager pageManager = new loc.PageManager();
  pageManager.pages.add(new MePage());
  pageManager.pages.add(new TwitterPage());
  pageManager.pages.add(new ErrorPage());
  pageManager.doLocation();

  var l = new loc.Location();
  print(">>>>> ${l.hash} : ${l.scheme} : ${l.baseAddr} : ${l.values} : ${l.baseAddr}");
}

class Config {}

class LoginNBox {
  String callbackopt = "cb";
  String makeLoginTwitterUrl() {
    var l = new loc.Location();
    return """${GetBackAddr()}/api/v1/twitter/tokenurl/redirect?${callbackopt}=${Uri.encodeComponent(l.baseAddr+"/#/Twitter")}""";
  }
}
