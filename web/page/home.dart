part of firestylesite;

class Home extends loc.Page {
  String rootID;
  bool isExclusive;
  Home({this.rootID: "fire-homepage", this.isExclusive: true}) {
  }

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Home")) {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "block";
      GetUserNBox().findUser("").then((UserKeyListProp prop){
        rootElm.appendText("${prop.prop.toJson()}");
      });
    } else {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "none";
    }
    return true;
  }
}
