import 'dart:html' as html;

void main() {
  print("hello client");
  ContentBuilder c = new ContentBuilder()..addItem("ME", "#/Me")..addItem("Home", "#/Home");
  c.bake(html.document.body);
}

class ContentBuilder {
  String navigatorId = "fire-navigation";
  String navigatorRightId = "fire-navigation-right";
  String navigatorLeftId = "fire-navigation-left";
  String contentId = "fire-content";
  String footerId = "fire-footer";
  String navigatorItemId = "fire-naviitem";

  List<String> tabList = [];
  List<String> urlList = [];
  Map<String, html.Element> elm = {};

  ContentBuilder() {
    html.window.onHashChange.listen((html.Event ev) {
      onHashChange();
    });
  }

  void addItem(String label, String url) {
    tabList.add(label);
    urlList.add(url);
  }

  void onHashChange() {
    //::selectio
    //  var e = elm[html.window.location.hash];
  }

  bake(html.Element rootElm) {
    rootElm.appendHtml(["""<div id=${navigatorId} class="${navigatorId}"> </div>""", """<div id=${contentId} class="${contentId}"> </div>""", """<div id=${footerId} class="${footerId}"> </div>""",].join("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
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
    elm.clear();
    for (int i = 0; i < tabList.length; i++) {
      var item = new html.Element.html("""<a href="${urlList[i]}" id="${navigatorItemId}" class="${navigatorItemId}"> ${tabList[i]} </a>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
      navigatorLeft.children.add(item);
      elm[urlList[i]] = item;
      item.onClick.listen((e) {
        for (var ee in elm.values) {
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
