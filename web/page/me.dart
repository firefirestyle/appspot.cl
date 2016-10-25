part of firestylesite;

class MePage extends loc.Page {
  String rootID;
  bool isExclusive;

  MePage({this.rootID: "fire-mepage", this.isExclusive: true}) {}

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Me")) {
      if (location.getValueAsString("act", "") == "logout") {
        String userName = Cookie.instance.userName;
        GetLoginNBox().logout(Cookie.instance.accessToken);
        Cookie.instance.accessToken = "";
        Cookie.instance.userName = "";
        Cookie.instance.isMaster = 0;
        PageManager.instance.jumpToUserPage(userName);
        if (Cookie.instance.isLogin) {
          toolBarObj.addRightItem(new ToolbarItem("NEW", "#/New"));
        } else {
          toolBarObj.addRightItem(new ToolbarItem("(-_-)", ""));
        }
        toolBarObj.updateRight();
      } else if (Cookie.instance.isLogin) {
        PageManager.instance.jumpToUserPage(Cookie.instance.userName);
      } else {
        manager.doEvent(loc.PageManagerEvent.startLoading);
        drawHtml()
            .then((v) {
              manager.doEvent(loc.PageManagerEvent.stopLoading);
            })
            .catchError((e) {})
            .whenComplete(() {
              manager.doEvent(loc.PageManagerEvent.stopLoading);
            });
      }
    } else {
      var rootElm = html.document.body.querySelector("#${rootID}");
      rootElm.style.display = "none";
    }
    return true;
  }

  bool updateEvent(loc.PageManager manager, loc.PageManagerEvent event) {
    return true;
  }

  Future drawHtml() async {
    var rootElm = html.document.body.querySelector("#${rootID}");
    rootElm.style.display = "block";
    rootElm.children.clear();
    String callbackAddr = GetFrontAddr()+"/#/Twitter";
    rootElm.appendHtml(["""<a class="fire-mepage-login-item" href="${GetLoginNBox().makeLoginTwitterUrl(callbackAddr)}"> twitter login </a>""",].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
}
