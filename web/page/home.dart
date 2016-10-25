part of firestylesite;

class Home extends loc.Page {
  String rootID;
  bool isExclusive;
  Home({this.rootID: "fire-homepage", this.isExclusive: true}) {}

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Home")) {
      //
      var listView = new dynablock.DynaHtmlView();
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "block";
      rootElm.appendHtml("""<div id="fire-listcontainer" style="width:100%;height:auto;min-height:100px;"></div>""", treeSanitizer: html.NodeTreeSanitizer.trusted);
      GetUserNBox().findUser("").then((UserKeyListProp prop) async {
        for(String key in prop.keys) {
          UserInfoProp userInfo = await GetUserNBox().getUserInfoFromKey(key);
          var el = new html.Element.html(
              [
                //"""<div style="color:black;width:${w}px;height:${h}px;border: 5px; border-style: dashed double;border-color: red;">x${i}""",
                """<div style="color:black;border: 5px; border-style: dashed double;border-color: red;width:100px;height:auto;">""",
                """  <img id="user-pin-userimage-icon" class="user-pin-userimage" src="imgs/egg.png"  style="color:black;width:100px;">""", //
                """  <div>${userInfo.displayName}</div>""",
                """  <div>${userInfo.publicInfo}</div>""",
                """</div>"""
              ].join(),
              treeSanitizer: html.NodeTreeSanitizer.trusted);
              await listView.add(el);
        }
        /*
        var rand = new math.Random(1000);
        for (int i = 0; i < 12; i++) {

          int h = 100 + rand.nextInt(100);
          var el = new html.Element.html(
              [
                //"""<div style="color:black;width:${w}px;height:${h}px;border: 5px; border-style: dashed double;border-color: red;">x${i}""",
                """<div style="color:black;border: 5px; border-style: dashed double;border-color: red;width:100px;height:auto;">x${i}""",
                """  <img id="user-pin-userimage-icon" class="user-pin-userimage" src="imgs/egg.png" height=${h} style="color:black;width:100px;height:${h}px;">""", //
                """ <div>asdfasdfasf</div>""",
                """</div>"""
              ].join(),
              treeSanitizer: html.NodeTreeSanitizer.trusted);
              await listView.add(el);
        }*/
      });
    } else {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "none";
    }
    return true;
  }
}
