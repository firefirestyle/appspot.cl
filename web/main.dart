import 'dart:html' as html;
import 'dart:async';
import 'package:dart.html.location/location.dart' as loc;
import 'config.dart';
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

class TwitterPage extends loc.Page {
  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Twitter")) {
      print(".......>Twitter ${location.values}");
      if (location.getValueAsString("error", "") != "" || location.getValueAsString("errcode", "") != "") {
        // Failed to oauth
        PageManager.instance.jumpToErrorPage("Failed to login", location.getValueAsString("error", "")+":"+location.getValueAsString("errcode", ""), location.baseAddr);
      } else {
        Cookie.instance.accessToken = location.getValueAsString("token", "");
        Cookie.instance.userName = location.getValueAsString("userName", "");
        Cookie.instance.isMaster = location.getValueAsInt("isMaster", 0);
        manager.assignLocation(location.baseAddr);
      }
    }
    return true;
  }
}

class UserPage extends loc.Page {
  String rootID;
  bool isExclusive;

  UserPage({this.rootID: "fire-userpage", this.isExclusive: true}) {
  }
  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/User")) {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "block";
      rootElm.children.clear();
      rootElm.appendHtml([
        """<div style="color:#000000;">User</div>""",//
    ].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
    } else {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "none";
    }
    return true;
  }
}

class ErrorPage extends loc.Page {
  String rootID;
  bool isExclusive;

  ErrorPage({this.rootID: "fire-errorpage", this.isExclusive: true}) {}
  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Error")) {
      var requestProp = PageManager.instance.getErrorPageRequest(location);
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "block";
      rootElm.children.clear();
      rootElm.appendHtml([
        """<div style="color:#000000;">${requestProp[0]}</div>""",//
        """<div style="color:#000000;">${requestProp[1]}</div>""",//
        """<a style="color:#000000;" href="${requestProp[2]}">back</a>""",//
    ].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
    } else {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "none";
    }
    return true;
  }
}

class MePage extends loc.Page {
  String rootID;
  bool isExclusive;

  MePage({this.rootID: "fire-mepage", this.isExclusive: true}) {}

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Me")) {
      if(Cookie.instance.isLogin) {
        PageManager.instance.jumpToUserPage(Cookie.instance.userName);
      } else {
      manager.doEvent(loc.PageManagerEvent.startLoading);
      drawHtml()
          .then((v) {
            manager.doEvent(loc.PageManagerEvent.stopLoading);
          })
          .catchError((e) {})
          .whenComplete(() {
            manager.doEvent(loc.PageManagerEvent.stopLoading);
          });
        }
    } else {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "none";
    }
    return true;
  }

  bool updateEvent(loc.PageManager manager, loc.PageManagerEvent event) {
    return true;
  }

  Future drawHtml() async {
    var rootElm = html.document.body.querySelector("#${rootID}");
    rootElm.style.display = "block";
    rootElm.children.clear();
    rootElm.appendHtml([
      """<a class="fire-mepage-login-item" href="${GetLoginNBox().makeLoginTwitterUrl()}"> twitter login </a>""",].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
}

class ContentBuilder extends loc.Page {
  String navigatorId = "fire-navigation";
  String navigatorRightId = "fire-navigation-right";
  String navigatorLeftId = "fire-navigation-left";
  String contentId = "fire-content";
  String footerId = "fire-footer";
  String navigatorItemId = "fire-naviitem";

  List<String> tabList = [];
  List<String> urlList = [];
  Map<String, html.Element> elms = {};

  ContentBuilder() {
    html.window.onHashChange.listen((html.Event ev) {
      onHashChange();
    });
  }

  void addItem(String label, String url) {
    tabList.add(label);
    urlList.add(url);
  }

  bool updateEvent(loc.PageManager manager, loc.PageManagerEvent event) {
    if (event == loc.PageManagerEvent.startLoading) {
      for (var key in elms.keys) {
        elms[key].style.display = "none";
      }
    } else if (event == loc.PageManagerEvent.stopLoading) {
      for (var key in elms.keys) {
        elms[key].style.display = "block";
      }
    }
    return true;
  }

  void onHashChange() {
    //::selectio
    //  var e = elm[html.window.location.hash];
  }

  bake(html.Element rootElm, {needMakeRoot: false}) {
    if (needMakeRoot) {
      rootElm.appendHtml(["""<div id=${navigatorId} class="${navigatorId}"> </div>""", //
      """<div id=${contentId} class="${contentId}"> </div>""", //
      """<div id=${footerId} class="${footerId}"> </div>""",].join("\r\n"), //
      treeSanitizer: html.NodeTreeSanitizer.trusted);
    }
    //
    var navigator = rootElm.querySelector("#${navigatorId}");
    navigator.appendHtml(
        [
          """<div id=${navigatorLeftId} class="${navigatorLeftId}"> </div>""",
          """<div id=${navigatorRightId} class="${navigatorRightId}"> </div>""", //
        ].join("\r\n"),
        treeSanitizer: html.NodeTreeSanitizer.trusted);
    //
    //
    var navigatorRight = rootElm.querySelector("#${navigatorRightId}");
    navigatorRight.appendHtml("""<div style="right:100;" class="${navigatorItemId}">(- -)</div>""", treeSanitizer: html.NodeTreeSanitizer.trusted);

    //
    var navigatorLeft = rootElm.querySelector("#${navigatorLeftId}");
    elms.clear();
    for (int i = 0; i < tabList.length; i++) {
      var item = new html.Element.html(
        """<a href="${urlList[i]}" id="${navigatorItemId}" class="${navigatorItemId}"> ${tabList[i]} </a>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
      navigatorLeft.children.add(item);
      elms[urlList[i]] = item;
      item.onClick.listen((e) {
        for (var ee in elms.values) {
          ee.classes.clear();
          if (item != ee) {
            ee.classes.add("${navigatorItemId}");
          } else {
            ee.classes.add("${navigatorItemId}-checked");
          }
        }
      });
    }
  }
}
