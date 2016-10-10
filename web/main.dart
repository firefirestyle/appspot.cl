import 'dart:html' as html;

void main() {
  print("hello client");
  ContentBuilder c = new ContentBuilder();
  c.bake(html.document.body);
}

class ContentBuilder {
  String navigatorId = "fire-navigation";
  String navigatorRightId = "fire-navigation-right";
  String navigatorLeftId = "fire-navigation-left";
  String contentId = "fire-content";
  String footerId = "fire-footer";

  List<String> tab = ["xxx","yyy"];
  bake(html.Element rootElm) {
    rootElm.appendHtml([
      """<div id=${navigatorId} class="${navigatorId}"> </div>""",
      """<div id=${contentId} class="${contentId}"> </div>""",
      """<div id=${footerId} class="${footerId}"> </div>""",
    ].join("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
    //
    var navigator = rootElm.querySelector("#${navigatorId}");
    navigator.appendHtml([
      """<div id=${navigatorRightId} class="${navigatorRightId}"> </div>""",
      """<div id=${navigatorLeftId} class="${navigatorLeftId}"> </div>""",
    ], treeSanitizer: html.NodeTreeSanitizer.trusted);
    //
    var navigatorRight = rootElm.querySelector("#${navigatorRightId}");
    for(String item in tab) {
      navigatorRight.appendHtml("<div> ${item} </div>");
    }
  }
}
