library firestylesite;

import 'dart:html' as html;
import 'dart:async';
import 'package:dart.html.location/location.dart' as loc;
import 'config.dart';
import 'package:dart.httprequest/request.dart' as req;
import 'package:dart.httprequest/request_ver_html.dart' as req;
//
import 'dart:convert' as conv;
//
part 'page/twitter.dart';
part 'page/user.dart';
part 'page/error.dart';
part 'page/me.dart';
part 'page/toolbar.dart';

//String configBackendAddr = "";

LoginNBox GetLoginNBox() {
  return new LoginNBox();
}

class UserParts {
  appendUser(html.Element containerElm) {
    ;
  }
}

class PageManager {
  static String title = "title";
  static String message = "message";
  static String backurl = "backurl";
  static String userNameId = "userName";
  static PageManager instance = new PageManager();

  void jumpToUserPage(String userName) {
    loc.Location l = new loc.Location();
    html.window.location.assign(l.baseAddr + "/#/User?${userNameId}=${Uri.encodeComponent(userName)}");
  }

  void jumpToErrorPage(String title, String message, String backurl) {
    loc.Location l = new loc.Location();
    html.window.location.assign(l.baseAddr + "/#/Error?title=${Uri.encodeComponent(title)}&message=${Uri.encodeComponent(message)}&backurl=${Uri.encodeComponent(backurl)}");
  }

  List<String> getErrorPageRequest(loc.Location location) {
    return [location.getValueAsString(title, ""), location.getValueAsString(message, ""), location.getValueAsString(backurl, "")];
  }

  List<String> getUserNamePageRequest(loc.Location location) {
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

class UserBBox {
  Future<String> requestUserInfo(String userName) async {
    var builder = new req.Html5NetBuilder();
    var requester = await builder.createRequester();
    var url = "${GetBackAddr()}/api/v1/user/get?userName=${Uri.encodeComponent(userName)}";
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }

    var obj = conv.JSON.decode(conv.UTF8.decode(response.response.asUint8List(), allowMalformed: true));
    var displayName = obj["DisplayName"];
    var userNameP = obj["UserName"];
    var created = obj["Created"];
    var logined = obj["Logined"];
    var state = obj["State"];
    var point = obj["Point"];
    var iconUr = obj["IconUrl"];
    var publicInfo = obj["PublicInfo"];
    var privateInfo = obj["PrivateInfo"];
  }
}
