part of firestylesite;

class NewPage extends loc.Page {
  String rootID;
  bool isExclusive;

  NewPage({this.rootID: "fire-newpage", this.isExclusive: true}) {}

  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/New")) {
        manager.doEvent(loc.PageManagerEvent.startLoading);
        drawHtml()
            .then((v) {
              manager.doEvent(loc.PageManagerEvent.stopLoading);
            })
            .catchError((e) {})
            .whenComplete(() {
              manager.doEvent(loc.PageManagerEvent.stopLoading);
            });
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
    rootElm.appendHtml([
      """<input type="text" style="width:100%;" placeholder="Title"><br>""",//
      """<textarea style="width:100%;" rows="5" placeholder="Cont"></textarea>""",//
      """<button>MAKE</button>""",
    ].join(), treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
}
