import 'dart:html' as html;
import 'dart:async';
import 'package:dart.html.location/location.dart' as loc;
import 'package:dart.httprequest/request.dart' as req;
import 'package:dart.httprequest/request_ver_html.dart' as req;

//String configBackendAddr = "";
String GetBackAddr() {
  //return (new loc.Location()).baseAddr;
  return "http://localhost:8080";
}

LoginNBox GetLoginNBox() {
  return new LoginNBox();
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
      print(".......>Twitter");
      manager.assignLocation(location.baseAddr);
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
      """<a class="fire-mepage-login-item" href="${GetLoginNBox().makeLoginTwitterUrl()}"> twitter login </a>""",
    ].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
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
    if(event == loc.PageManagerEvent.startLoading) {
      for(var key in elms.keys) {
        elms[key].style.display = "none";
      }
    } else if(event == loc.PageManagerEvent.stopLoading) {
      for(var key in elms.keys) {
        elms[key].style.display = "block";
      }
    }
    return true;
  }

  void onHashChange() {
    //::selectio
    //  var e = elm[html.window.location.hash];
  }

  bake(html.Element rootElm,{needMakeRoot:false}) {
    if(needMakeRoot) {
      rootElm.appendHtml(["""<div id=${navigatorId} class="${navigatorId}"> </div>""", """<div id=${contentId} class="${contentId}"> </div>""", """<div id=${footerId} class="${footerId}"> </div>""",].join("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
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
      var item = new html.Element.html("""<a href="${urlList[i]}" id="${navigatorItemId}" class="${navigatorItemId}"> ${tabList[i]} </a>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
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
