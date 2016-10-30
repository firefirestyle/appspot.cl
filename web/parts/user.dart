part of firestylesite;

class UserParts {
  UserInfoProp userProp;
  UserParts(this.userProp) {}

  //
  //
  Future<html.Element> createShortUserInfoTo( Cookie cookie) async {
    String src = await userImgSrc(userProp.userName, userProp.iconUrl);
    String bgcolor = await userImgBgColor(userProp.userName, userProp.iconUrl);

    var userName = userProp.userName;
    var builder = new tbuil.TextBuilder();
    PageManager page = new PageManager();
    print("""========  ${userName} ========""");
    var url = page.getUrlUserPage(userName);
    builder.add(builder.getRootTicket(), [
      """<div class="hunter-pin">""",
      """  <a class="hunter-anchor" href="${url}">""",
      """    <img class="hunter-pin-image" src="${src}" style="background-color:${bgcolor};">""", //
      """    <div class="target-pin-title" style="border:${bgcolor} solid 2px;"> ${userProp.displayName} </div>""",
      """    <div class="target-pin-info">point: ${userProp.point}  </div>""",
      """  </a>""",
      """</div>"""
    ]);
    return new html.Element.html(builder.toText("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
  }

  //
  //
  appendUserInfoTo(html.Element containerElm, Cookie cookie) async {
    String src = await userImgSrc(userProp.userName, userProp.iconUrl);
    String bgcolor = await userImgBgColor(userProp.userName, userProp.iconUrl);
    var userName = "id" + userProp.userName;
    var builder = new tbuil.TextBuilder();
    //var ticket =
    builder.child(builder.getRootTicket(), [
      """<div id="${userName}"class="user-pin">""", //
      """  <img id="user-pin-userimage-icon" class="user-pin-userimage" src="${src}" style="background-color:${bgcolor};">""", //
      """  <div class="user-pin-name">${userProp.displayName}</div>""", //
      """  <div class="user-pin-point">POINT : ${userProp.point}</div>""", //
    ], [
      """</div>""", //
    ]);
    containerElm.appendHtml(builder.toText("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
    //
    //
    //
    print("LOGIN CHECLK ${cookie.userName} == ${userProp.userName}");
    if (cookie.isLogin == true && cookie.userName == userProp.userName.replaceFirst(new RegExp("::sign::.*"), "")) {
      print("LOGIN OK");
      var userPin = containerElm.querySelector("#${userName}");
      var logout = new html.Element.html("""  <button class="user-pin-hunt-me"> Me<br>Logout</button> """, treeSanitizer: html.NodeTreeSanitizer.trusted);
      var image = new html.Element.html("""  <button class="user-pin-hunt-me"> Me<br>DImg</button> """, treeSanitizer: html.NodeTreeSanitizer.trusted);

      userPin.children.add(logout);
      userPin.children.add(image);
      logout.onClick.listen((e) {
        html.window.location.assign("#/Me?act=logout");
      });
      image.onClick.listen((e) async {
        var imgDialog = new dialog.ImgageDialog();
        var imgSrc = await imgDialog.show();
        if (imgSrc == "") {
          return;
        }
        var res = await GetLoginNBox().updateIcon(
            Cookie.instance.accessToken, //
            Cookie.instance.userName,
            conv.BASE64.decode(imgSrc.replaceFirst(new RegExp(".*,"), '')));
        //
        //
        updateUserImage(containerElm, await userImgSrc(userProp.userName, res.blobKey));
      });
    }
  }

  updateUserImage(html.Element containerElm, String src) async {
    html.ImageElement v = containerElm.querySelector("#user-pin-userimage-icon");
    v.src = src;
  }

  Future<String> userImgSrc(String userName, String iconUrl) async {
    if (userProp.iconUrl == "") {
      return "/imgs/egg.png";
    } else {
      return await GetFileNBox().getFromKey(iconUrl.replaceAll("key://", ""));
    }
  }

  Future<String> userImgBgColor(String userName, String iconUrl) async {
    String bgcolor = "black";
    try {
      List<int> by = crypto.sha1.convert(conv.UTF8.encode(userName)).bytes;
      bgcolor = """rgb(${by[0]},${by[1]},${by[2]})"""; //${bytes[0]},${bytes[1]},${bytes[2]}
    } catch (e) {}
    return bgcolor;
  }
}
