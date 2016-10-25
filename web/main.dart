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
import 'package:firefirestyle.dynamicblock/dynablock.dart' as dynablock;
import 'package:firefirestyle.dynamicblock/dynablock_html.dart' as dynablock;
//
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert' as conv;
import 'dart:typed_data' as typed;
import 'dart:math' as math;
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
part 'page/home.dart';

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

  String getUrlUserPage(String userName) {
    loc.Location l = new loc.Location();
    return l.baseAddr + "/#/User?${userNameId}=${Uri.encodeComponent(userName)}";
  }
  void jumpToUserPage(String userName) {
    html.window.location.assign(getUrlUserPage(userName));
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
  Toolbar c = new Toolbar()..addLeftItem(new ToolbarItem("ME", "#/Me)"))..addLeftItem(new ToolbarItem("Home", "#/Home"));
  c.bake(html.document.body);
  //
  //
  loc.PageManager pageManager = new loc.PageManager();
  pageManager.pages.add(new MePage());
  pageManager.pages.add(new TwitterPage());
  pageManager.pages.add(new ErrorPage());
  pageManager.pages.add(new UserPage());
  pageManager.pages.add(new Home());
  pageManager.doLocation();

  var l = new loc.Location();
  print(">>>>> ${l.hash} : ${l.scheme} : ${l.baseAddr} : ${l.values} : ${l.baseAddr}");
}

MeNBox GetLoginNBox() {
  return new MeNBox(new req.Html5NetBuilder(), GetBackAddr());
}

UserNBox GetUserNBox() {
  return new UserNBox(new req.Html5NetBuilder(),GetBackAddr());
}

FileNBox GetFileNBox() {
  return new FileNBox(new req.Html5NetBuilder(), GetBackAddr());
}
