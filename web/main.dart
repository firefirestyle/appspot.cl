import 'dart:html' as html;

void main() {
  print("hello client");
  ContentBuilder c = new ContentBuilder();
  c.bake(html.document.body);
}

class ContentBuilder {
  String navigatorId = "fire-navigation";
  String contentId = "fire-content";
  String footerId = "fire-footer";

  bake(html.Element rootElm) {
    rootElm.appendHtml([
      """<div id=${navigatorId} class="${navigatorId}"> </div>""",
      """<div id=${contentId} class="${contentId}"> </div>""",
      """<div id=${footerId} class="${footerId}"> </div>""",
    ].join("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
    //

  }
}
