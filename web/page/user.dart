part of firestylesite;


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
