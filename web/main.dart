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
part 'pagemanager.dart';
part 'page/twitter.dart';
part 'page/user.dart';
part 'page/error.dart';
part 'page/me.dart';
part 'page/toolbar.dart';
part 'page/home.dart';
part 'page/new.dart';

part 'parts/user.dart';

Toolbar toolBarObj = new Toolbar(null);

void main() {
  print("hello client");
  toolBarObj = new Toolbar(null)..addLeftItem(new ToolbarItem("ME", "#/Me)"))..addLeftItem(new ToolbarItem("Home", "#/Home"));
  if (Cookie.instance.isLogin) {
    toolBarObj.addRightItem(new ToolbarItem("NEW", "#/New"));
  } else {
    toolBarObj.addRightItem(new ToolbarItem("(-_-)", ""));
  }

  toolBarObj.bake();
  toolBarObj.bake();
  toolBarObj.bake();
  //
  //
  loc.PageManager pageManager = new loc.PageManager();
  pageManager.pages.add(new MePage());
  pageManager.pages.add(new TwitterPage());
  pageManager.pages.add(new ErrorPage());
  pageManager.pages.add(new UserPage());
  pageManager.pages.add(new Home());
  pageManager.pages.add(new NewPage());
  pageManager.doLocation();

  var l = new loc.Location();
  print(">>>>> ${l.hash} : ${l.scheme} : ${l.baseAddr} : ${l.values} : ${l.baseAddr}");
}

Toolbar GetToolbar() {
  return toolBarObj;
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

ArtNBox GetArtNBox() {
  return new ArtNBox(new req.Html5NetBuilder(), GetBackAddr());
}
