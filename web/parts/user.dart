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
    var ticket = builder.child(builder.getRootTicket(), [
      """<div class="user-pin">""", //
      """  <img id="user-pin-userimage-icon" class="user-pin-userimage" src="${src}" style="background-color:${bgcolor};">""", //
      """  <div class="user-pin-name">${userProp.displayName}</div>""", //
      """  <div class="user-pin-point">POINT : ${userProp.point}</div>""", //
    ], [
      """</div>""", //
    ]);
    if (cookie.isLogin == true && cookie.userName == userProp.userName) {
//    String backUrl = """#/Me?${nbox.NetBox.ReqPropertyName}=${Uri.encodeComponent(status.userName)}""";
      builder.add(ticket, [
        """  <a class="user-pin-hunt-me" href="#/Me?act=logout"> Me<br>Logout</a> """, //
        //    """  <a class="user-pin-hunt-me" href="#/Me?act=updateName&backurl=${Uri.encodeComponent(backUrl)}"> Me<br>DName</a> """, //
        //    """  <a class="user-pin-hunt-me" href="#/Me?act=updateImage&backurl=${Uri.encodeComponent(backUrl)}&icon=${Uri.encodeComponent("#user-pin-userimage-icon")}"> Me<br>DImg</a> """, //
      ]);
    }

    containerElm.appendHtml(builder.toText("\r\n"), treeSanitizer: html.NodeTreeSanitizer.trusted);
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
