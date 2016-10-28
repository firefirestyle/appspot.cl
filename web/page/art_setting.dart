part of firestylesite;

class ArtSettingPage extends loc.Page {
  String rootID;
  bool isExclusive;

  ArtSettingPage({this.rootID: "fire-artsettingpage", this.isExclusive: true}) {}

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hashPath == "#/ArtSetting") {
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
    ArtInfoProp prop = await GetArtNBox().getArtFromArticleId(//
      location.getValueAsString("articleId", ""),
      location.getValueAsString("sign", "")
    );
    var artParts = new ArticleParts(prop);
    artParts.appendUserInfoTo(rootElm, Cookie.instance);
  }
}
