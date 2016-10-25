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
          for(int i=0;i<3;i++) {
          UserInfoProp userInfo = await GetUserNBox().getUserInfoFromKey(key);
          print(">>>>>>>>>>>>>>>> ${userInfo.userName}");
          UserParts userParts = new UserParts(userInfo);
          var elc = await userParts.createShortUserInfoTo(Cookie.instance);
          var el = new html.Element.html(
              [
//                """<div style="color:black;border: 5px; border-style: dashed double;border-color: red;width:100px;height:auto;">""",
                """<div style="width:100px;height:auto;" class="target-pin">""",
                """</div>"""
              ].join(),
              treeSanitizer: html.NodeTreeSanitizer.trusted);
              rootElm.children.add(elc);
          el.children.add(elc);
          await listView.add(el);
        }
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
