part of firestylesite;

class UserPage extends loc.Page {
  String rootID;
  bool isExclusive;

  UserPage({this.rootID: "fire-userpage", this.isExclusive: true}) {}

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/User")) {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "block";
      update(location);
    } else {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "none";
    }
    return true;
  }

  update(loc.Location location) async {
    print("==> loc :"+location.hash);
    var rootElm = html.document.body.querySelector("#${rootID}");
    rootElm.style.display = "block";
    rootElm.children.clear();
    UserInfoProp prop = await GetUserNBox().requestUserInfo(location.getValueAsString("userName", "none"));
    UserParts userParts = new UserParts(prop);
    userParts.appendUser(rootElm, Cookie.instance);
/*    rootElm.appendHtml(
        [
          """<div style="color:#000000;">${prop.displayName}</div>""", //
          """<div style="color:#000000;">${new DateTime.fromMicrosecondsSinceEpoch(prop.created~/1000)}</div>""", //
          """<div style="color:#000000;">${prop.created}</div>""", //
          """<div style="color:#000000;">${prop.userName}</div>""", //
        ].join(),
        treeSanitizer: html.NodeTreeSanitizer.trusted);*/
  }
}
