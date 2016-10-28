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
    print("==>d loc :" + location.hash);
    var rootElm = html.document.body.querySelector("#${rootID}");
    rootElm.style.display = "block";
    rootElm.children.clear();
    ArtInfoProp prop = await GetArtNBox().getArtFromArticleId(
        //
        location.getValueAsString("articleId", ""),
        location.getValueAsString("sign", ""),
        mode: ArtNBox.ModeQuery);
    rootElm.appendHtml([
      """<div style="color:black;">Title</div>""",
      """<input value="${prop.title}" style="width:100%;">""", //
      """<div style="color:black;">Info</div>""",
      """<textarea value="${prop.cont}" style="width:100%;height:250px;"></textarea>""", //
      """<div style="color:black;">Tag</div>""",
      """<input value="${prop.tag}" style="width:100%;">""", //
      """<button>Update</button>""", //      
      """"""
    ].join("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
}
