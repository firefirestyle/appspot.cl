import 'dart:html' as html;
//import 'package:firefirestyle.textbuilder/textbuilder.dart' as util;

class Dialog {
  String name;
  String width;
  html.DivElement dialogElement;
  html.Element content;

  Dialog(this.name, {this.width: "90%"}) {}

  init({List<String> optStyle: null}) {
    html.Element elm = html.document.body;

    dialogElement = new html.Element.html(
        [
          """<div id="${name}" class=".fire-dialog">""", //
          """</div>""", //
        ].join(),
        treeSanitizer: html.NodeTreeSanitizer.trusted);
    elm.children.insert(0, dialogElement);
  }

  html.Element show(String cont, int zIndex, //
      {String dialogWidth: "100%",
      String dialogHeight: "100%", //
      String dialogContWidth: "99%",
      String dialogContHeight: "99%"}) {
    init();
    this.dialogElement.children.clear();
    content = new html.Element.html("""<div style="display:block"></div>""");
    this.dialogElement.children.add(content);

    content.appendHtml(cont, treeSanitizer: html.NodeTreeSanitizer.trusted);
    this.dialogElement.style.position = "fixed"; ////"absolute";
    this.dialogElement.style.zIndex = "${zIndex}";
    this.dialogElement.style.margin = "0 auto";
    this.dialogElement.style.width = "${dialogWidth}";
    this.dialogElement.style.height = "${dialogHeight}";
    this.dialogElement.style.backgroundColor = "rgba(55,55,55,0.8)";
    this.dialogElement.style.display = "block";
    this.dialogElement.style.right = "0";

    //
    content.style.display = "block";
    content.style.width = "${dialogContWidth}";
    content.style.height = "${dialogContHeight}";
    content.style.margin = "0 auto";
    content.style.verticalAlign = "middle";
    content.style.backgroundColor = "rgba(255,255,255,1)";
    return this.dialogElement;
  }

  close() {
//    this.dialogElement.children.clear();
//    this.dialogElement.style.width = "0%";
//    this.dialogElement.style.height = "0%";
    var parentElm = dialogElement.parent;
    parentElm.children.remove(parentElm);
//    return this.dialogElement;
  }
}
