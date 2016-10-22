library firestylesite;

import 'dart:html' as html;
import 'dart:async';
import 'config.dart';

import 'package:firefirestyle.html.location/location.dart' as loc;
import 'package:firefirestyle.httprequest/request.dart' as req;
import 'package:firefirestyle.httprequest/request_ver_html.dart' as req;
import 'package:firefirestyle.miniprop/miniprop.dart' as prop;
import 'package:firefirestyle.textbuilder/textbuilder.dart' as tbuil;
import 'package:firefirestyle.cl.netbox/netbox.dart';
//
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert' as conv;
import 'dart:typed_data' as typed;
//
//
import 'package:firefirestyle.dialog/dialog.dart' as dialog;

//
//
part 'page/twitter.dart';
part 'page/user.dart';
part 'page/error.dart';
part 'page/me.dart';
part 'page/toolbar.dart';
part 'parts/user.dart';
//String configBackendAddr = "";



class PageManager {
  static String title = "title";
  static String message = "message";
  static String backurl = "backurl";
  static String userNameId = "userName";
  static PageManager instance = new PageManager();
  void jumpToMePage() {
    loc.Location l = new loc.Location();
    html.window.location.assign(l.baseAddr + "/#/Me");
  }

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
  pageManager.pages.add(new UserPage());
  pageManager.doLocation();

  var l = new loc.Location();
  print(">>>>> ${l.hash} : ${l.scheme} : ${l.baseAddr} : ${l.values} : ${l.baseAddr}");
}

class Config {}
//
//
//
//

MeNBox GetLoginNBox() {
  return new MeNBox(new req.Html5NetBuilder(), GetBackAddr());
}

UserNBox GetUserNBox() {
  return new UserNBox(GetBackAddr());
}

FileNBox GetFileNBox() {
  return new FileNBox(new req.Html5NetBuilder(), GetBackAddr());
}

/*
class LogoutProp {
  prop.MiniProp prop;
  LogoutProp(this.prop) {}
}

class UploadFileProp {
  prop.MiniProp prop;
  UploadFileProp(this.prop) {}

  String get blobKey => prop.getString("blobkey", "");
}

class MeNBox {
  req.NetBuilder builder;
  String callbackopt = "cb";
  MeNBox(this.builder) {}
  String makeLoginTwitterUrl() {
    var l = new loc.Location();
    return """${GetBackAddr()}/api/v1/twitter/tokenurl/redirect?${callbackopt}=${Uri.encodeComponent(l.baseAddr+"/#/Twitter")}""";
  }

  Future<LogoutProp> logout(String token) async {
    var requester = await builder.createRequester();
    var url = "${GetBackAddr()}/api/v1/me/logout";
    var pro = new prop.MiniProp();
    pro.setString("token", token);

    req.Response response = await requester.request(req.Requester.TYPE_GET, url, data: pro.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw new Exception("");
    }
    return new LogoutProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }

  Future<UploadFileProp> updateIcon(String src) async {
    String url = [
      GetBackAddr(), //
      """/api/v1/blob/requesturl""", //
      """?dir=${Uri.encodeComponent("/user/"+Cookie.instance.userName)}&file=meicon"""
    ].join("");

    var uelPropObj = new prop.MiniProp();
    uelPropObj.setString("token", Cookie.instance.accessToken);
    req.Response response = await (await builder.createRequester()).request(req.Requester.TYPE_POST, url, data: uelPropObj.toJson(errorIsThrow: false));
    if (response.status != 200) {
      throw "failed to get request token";
    }
    var responsePropObj = new prop.MiniProp.fromByte(response.response.asUint8List());
    var tokenUrl = responsePropObj.getString("token", "");
    //new prop.MiniProp.fromByte(response.response.asUint8List());
    print(""" TokenUrl = ${tokenUrl} """);
    req.Multipart multipartObj = new req.Multipart();
    var responseFromUploaded = await multipartObj.post(await builder.createRequester(), tokenUrl, [
      new req.MultipartItem.fromBase64("file", "blob", "image/png", src.replaceFirst(new RegExp(".*,"), '')) //
    ]);
    if (responseFromUploaded.status != 200) {
      throw "failed to uploaded";
    }

    return new UploadFileProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}

class UserInfoProp {
  prop.MiniProp prop;
  UserInfoProp(this.prop) {}

  String get displayName => prop.getString("DisplayName", "");
  String get userName => prop.getString("UserName", "");
  int get created => prop.getNum("Created", 0);
  int get logined => prop.getNum("Logined", 0);
  String get state => prop.getString("State", "");
  int get point => prop.getNum("Point", 0);
  String get iconUr => prop.getString("IconUrl", "");
  String get publicInfo => prop.getString("PublicInfo", "");
  String get privateInfo => prop.getString("PrivateInfo", "");
}

class UserNBox {
  //
  Future<UserInfoProp> requestUserInfo(String userName) async {
    var builder = new req.Html5NetBuilder();
    var requester = await builder.createRequester();
    var url = "${GetBackAddr()}/api/v1/user/get?userName=${Uri.encodeComponent(userName)}";
    req.Response response = await requester.request(req.Requester.TYPE_GET, url);
    if (response.status != 200) {
      throw new Exception("");
    }
    return new UserInfoProp(new prop.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}*/
