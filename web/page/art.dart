part of firestylesite;

class ArtPage extends loc.Page {
  String rootID;
  bool isExclusive;

  ArtPage({this.rootID: "fire-artpage", this.isExclusive: true}) {}

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Art")) {
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
