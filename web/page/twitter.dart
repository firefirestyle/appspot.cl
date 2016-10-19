part of firestylesite;

class TwitterPage extends loc.Page {
  bool updateLocation(loc.PageManager manager, loc.Location location) {
    if (location.hash.startsWith("#/Twitter")) {
      print(".......>Twitter ${location.values}");
      if (location.getValueAsString("error", "") != "" || location.getValueAsString("errcode", "") != "") {
        // Failed to oauth
        PageManager.instance.jumpToErrorPage("Failed to login", location.getValueAsString("error", "")+":"+location.getValueAsString("errcode", ""), location.baseAddr);
      } else {
        Cookie.instance.accessToken = location.getValueAsString("token", "");
        Cookie.instance.userName = location.getValueAsString("userName", "");
        Cookie.instance.isMaster = location.getValueAsInt("isMaster", 0);
        manager.assignLocation(location.baseAddr);
      }
    }
    return true;
  }
}
