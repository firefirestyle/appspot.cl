part of firestylesite;

class ToolbarItem {
  String url;
  String label;
  ToolbarItem(this.label, this.url) {}
}

class Toolbar extends loc.Page {
  String navigatorId = "fire-navigation";
  String navigatorRightId = "fire-navigation-right";
  String navigatorLeftId = "fire-navigation-left";
  String contentId = "fire-content";
  String footerId = "fire-footer";
  String navigatorItemId = "fire-naviitem";

  List<ToolbarItem> leftItems = [];
  ToolbarItem rightItem = new ToolbarItem("(-_-)", "");
  Map<String, html.Element> elms = {};


  Toolbar() {
    html.window.onHashChange.listen((html.Event ev) {
      onHashChange();
    });
  }

  void addLeftItem(ToolbarItem item) {
    leftItems.add(item);
  }

  void addRightItem(ToolbarItem item) {
      rightItem = item;
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

  bakeContainer(html.Element rootElm, {needMakeRoot: false}) {
    if (needMakeRoot) {
      rootElm.children.clear();
      rootElm.appendHtml(
          [
            """<div id=${navigatorId} class="${navigatorId}"> </div>""", //
            """<div id=${contentId} class="${contentId}"> </div>""", //
            """<div id=${footerId} class="${footerId}"> </div>""",
          ].join("\r\n"), //
          treeSanitizer: html.NodeTreeSanitizer.trusted);
    }
    //
    var navigator = rootElm.querySelector("#${navigatorId}");
    navigator.children.clear();
    navigator.appendHtml(
        [
          """<div id=${navigatorLeftId} class="${navigatorLeftId}"> </div>""",
          """<div id=${navigatorRightId} class="${navigatorRightId}"> </div>""", //
        ].join("\r\n"),
        treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  updateRight(html.Element rootElm, {needMakeRoot: false}) {
    var navigatorRight = rootElm.querySelector("#${navigatorRightId}");
    navigatorRight.children.clear();
    navigatorRight.appendHtml("""<a href="${rightItem.url}" style="right:100;" class="${navigatorItemId}">${rightItem.label}</a>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  updateLeft(html.Element rootElm, {needMakeRoot: false}) {
    var navigatorLeft = rootElm.querySelector("#${navigatorLeftId}");
    navigatorLeft.children.clear();
    for (int i = 0; i < leftItems.length; i++) {
      var item = new html.Element.html("""<a href="${leftItems[i].url}" id="${navigatorItemId}" class="${navigatorItemId}"> ${leftItems[i].label} </a>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
      navigatorLeft.children.add(item);
      elms[leftItems[i].url] = item;
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

  bake(html.Element rootElm, {needMakeRoot: false}) {
    bakeContainer(rootElm, needMakeRoot: needMakeRoot);
    //
    updateRight(rootElm, needMakeRoot: needMakeRoot);
    //
    updateLeft(rootElm, needMakeRoot: needMakeRoot);
  }
}
