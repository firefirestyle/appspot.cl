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
    UserInfoProp prop = await GetUserNBox().getUserInfo(location.getValueAsString("userName", "none"));
    UserParts userParts = new UserParts(prop);
    userParts.appendUserInfoTo(rootElm, Cookie.instance);
  }
}
