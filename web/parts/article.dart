part of firestylesite;

class ArticleParts {
  ArtInfoProp artProp;
  ArticleParts(this.artProp) {}


  Future<html.Element> createShortArtInfoTo() async {
    String src = await artImgSrc(artProp.articleId, "");
    String bgcolor = await artImgBgColor(artProp.articleId, "");

    var builder = new tbuil.TextBuilder();
    PageManager page = new PageManager();
    var url = page.getUrlArtPage(artProp.articleId, artProp.sign);
    builder.add(builder.getRootTicket(), [
      """<div class="hunter-pin">""",
      """  <a class="hunter-anchor" href="${url}">""",
      """    <img class="hunter-pin-image" src="${src}" style="background-color:${bgcolor};">""", //
      """    <div class="target-pin-title" style="border:${bgcolor} solid 2px;"> ${artProp.title} </div>""",
      """    <div class="target-pin-info" style="word-wrap: break-word">userName: ${artProp.userName}  </div>""",
      """  </a>""",
      """</div>"""
    ]);
    return new html.Element.html(builder.toText("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
  }
  //
  //
  appendUserInfoTo(html.Element containerElm, Cookie cookie) async {
    String src = await artImgSrc(artProp.articleId, "");
    String bgcolor = await artImgBgColor(artProp.articleId, "");
    var userName = "id" + artProp.userName;
    var builder = new tbuil.TextBuilder();
    //var ticket =
    builder.child(builder.getRootTicket(), [
      """<div id="${userName}"class="user-pin">""", //
      """  <img id="user-pin-userimage-icon" class="user-pin-userimage" src="${src}" style="background-color:${bgcolor};">""", //
      """  <div class="user-pin-name">${artProp.title}</div>""", //
      """  <div class="user-pin-point">Name : ${artProp.userName}</div>""", //
    ], [
      """</div>""", //
    ]);
    containerElm.appendHtml(builder.toText("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
    //
    //
    //
    print("LOGIN CHECLK ${cookie.userName} == ${artProp.userName}");
    if (cookie.isLogin == true && cookie.userName == artProp.userName.replaceFirst(new RegExp("::sign::.*"), "")) {
      print("LOGIN OK");
      var userPin = containerElm.querySelector("#${userName}");
      var image = new html.Element.html("""  <button class="user-pin-hunt-me"> Me<br>DImg</button> """, treeSanitizer: html.NodeTreeSanitizer.trusted);
      var setting = new html.Element.html("""  <button class="user-pin-hunt-me"> Setting</button> """, treeSanitizer: html.NodeTreeSanitizer.trusted);

      userPin.children.add(setting);
      userPin.children.add(image);
      setting.onClick.listen((e) {
        new PageManager().jumpToArtSettingPage(artProp.articleId);
      });
      image.onClick.listen((e) async {
        var imgDialog = new dialog.ImgageDialog();
        var imgSrc = await imgDialog.show();
        if (imgSrc == "") {
          return;
        }
        /*
        var res = await GetLoginNBox().updateIcon(
            Cookie.instance.accessToken, //
            Cookie.instance.userName,
            conv.BASE64.decode(imgSrc.replaceFirst(new RegExp(".*,"), '')));
        //
        //
        updateUserImage(containerElm, await artImgSrc(artProp.userName, res.blobKey));
        */
      });
    }
  }

  updateUserImage(html.Element containerElm, String src) async {
    html.ImageElement v = containerElm.querySelector("#user-pin-userimage-icon");
    v.src = src;
  }

  Future<String> artImgSrc(String userName, String iconUrl) async {
//    if (artProp.iconUr == "") {
      return "/imgs/heart.png";
//    } else {
//      return await GetFileNBox().getFromKey(iconUrl.replaceAll("key://", ""));
//    }
  }

  Future<String> artImgBgColor(String userName, String iconUrl) async {
    String bgcolor = "black";
    try {
      List<int> by = crypto.sha1.convert(conv.UTF8.encode(userName)).bytes;
      bgcolor = """rgb(${by[0]},${by[1]},${by[2]})"""; //${bytes[0]},${bytes[1]},${bytes[2]}
    } catch (e) {}
    return bgcolor;
  }
}
