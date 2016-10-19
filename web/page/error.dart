part of firestylesite;

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
