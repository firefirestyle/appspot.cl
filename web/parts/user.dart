part of firestylesite;

class UserParts {
  UserInfoProp userProp;
  UserParts(this.userProp) {
    ;
  }
  appendUser(html.Element containerElm, Cookie cookie) {
    String src = userImgSrc(userProp.userName, (userProp.iconUr == "" ? false : true), userProp.iconUr);
    String bgcolor = userImgBgColor(userProp.userName, (userProp.iconUr == "" ? false : true), userProp.iconUr);
    var builder = new tbuil.TextBuilder();
    //var ticket =
    builder.child(builder.getRootTicket(), [
      """<div id="${userProp.userName.replaceAll("=", "")}"class="user-pin">""", //
      """  <img id="user-pin-userimage-icon" class="user-pin-userimage" src="${src}" style="background-color:${bgcolor};">""", //
      """  <div class="user-pin-name">${userProp.displayName}</div>""", //
      """  <div class="user-pin-point">POINT : ${userProp.point}</div>""", //
    ], [
      """</div>""", //
    ]);
    containerElm.appendHtml(builder.toText("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
    if (cookie.isLogin == true && cookie.userName == userProp.userName) {
      var userPin = containerElm.querySelector("#${userProp.userName.replaceAll("=", "")}");
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
        
      });
    }
  }

  userImgSrc(String userName, bool haveIcon, String iconUrl) {
    return "/imgs/egg.png";
  }

  userImgBgColor(String userName, bool haveIcon, String iconUrl) {
    String bgcolor = "black";
    try {
      List<int> by = crypto.sha1.convert(conv.UTF8.encode(userName)).bytes;
      bgcolor = """rgb(${by[0]},${by[1]},${by[2]})"""; //${bytes[0]},${bytes[1]},${bytes[2]}
    } catch (e) {}
    return bgcolor;
  }
}
