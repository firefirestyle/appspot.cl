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
    rootElm.appendHtml(
        [
          """<div style="color:black;">Title</div>""",
          """<input id="title" value="${prop.title}" style="width:100%;">""", //
          """<div style="color:black;">Info</div>""",
          """<textarea id="cont" value="${prop.cont}" style="width:100%;height:250px;">${prop.cont}</textarea>""", //
          """<div style="color:black;">Tag</div>""",
          """<div id="tagCont" style="width:100%;"></div>""", //
          """<button id="btn">Update</button>""", //
          """"""
        ].join("\r\n"),
        treeSanitizer: html.NodeTreeSanitizer.trusted);
    html.InputElement titleElm = rootElm.querySelector("#title");
    html.TextAreaElement contElm = rootElm.querySelector("#cont");
    html.ButtonElement updateElm = rootElm.querySelector("#btn");

      html.DivElement tagContElm = rootElm.querySelector("#tagCont");
      TagElement tagElm = new TagElement(prop.tags);
      tagContElm.children.add(tagElm.contElm);

    updateElm.onClick.listen((e) {
      GetArtNBox().updateArt(Cookie.instance.accessToken,location.getValueAsString("articleId", ""), //
      title: titleElm.value, //
      cont: contElm.value,//
      tags: tagElm.tagList);
    });
  }
}
