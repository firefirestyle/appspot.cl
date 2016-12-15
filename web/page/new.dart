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
    rootElm.appendHtml(
        [
          """<input id="new-title" type="text" style="width:100%;" placeholder="Title"><br>""", //
          """<textarea id="new-cont" style="width:100%;" rows="5" placeholder="Cont"></textarea>""", //
          """<button id="new-button" disabled>MAKE</button>""",
        ].join(),
        treeSanitizer: html.NodeTreeSanitizer.trusted);

    //ArtNBox
    html.InputElement newTitleElm = rootElm.querySelector("#new-title");
    html.TextAreaElement newContElm = rootElm.querySelector("#new-cont");
    html.ButtonElement newButtonElm = rootElm.querySelector("#new-button");

    newTitleElm.onInput.listen((e) {
      print("====> A");
      if (newTitleElm.value.length > 0 && newContElm.value.length > 0) {
        newButtonElm.disabled = false;
      } else {
        newButtonElm.disabled = true;
      }
    });
    newContElm.onInput.listen((e) {
      print("====> B");
      if (newTitleElm.value.length > 0 && newContElm.value.length > 0) {
        newButtonElm.disabled = false;
      } else {
        newButtonElm.disabled = true;
      }
    });
    newButtonElm.onClick.listen((ev) {
      try {
        GetArtNBox().newArt(Cookie.instance.accessToken, title: newTitleElm.value, cont: newContElm.value);
      } catch (e) {
        String message = "";
        if (e is ErrorProp) {
          message = """errCode:${e.errorCode};errMessage:${e.errorMessage}""";
        }
        PageManager.instance.jumpToErrorPage("Failed to new article", message, html.window.location.href);
      }
    });
  }
}
