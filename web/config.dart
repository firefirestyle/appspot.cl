import 'package:cookie/cookie.dart' as cookie;
import 'package:firefirestyle.location/location.dart' as loc;
import 'package:firefirestyle.location/location_html.dart' as loc;

//const String platform = "web";
const String platform = "cordova";

String GetBackAddr() {
  //return (new loc.Location()).baseAddr;
  //return "http://localhost:8080";
  return "https://firefirestyle.appspot.com/";
}

String GetCallback() {
  return "firefirestyle://";
}

String GetFrontAddr() {
  if(platform == "cordova") {
    return "firefirestyle://";
  } else {
    return (new loc.HtmlLocation()).baseAddr;
  }
//  return "http://localhost:8080";
}

class Cookie {
  static final String keyAccessToken = "user-accesstoken";
  static final String keyUserName = "user-name";
  static final String keyIsMaster = "user-isMaster";

  static Cookie _instance = new Cookie();
  static Cookie get instance => _instance;

  Map<String, String> binary = {};

  String get accessToken => getFromKey(keyAccessToken);
  String get userName => getFromKey(keyUserName);

  int get isMaster {
    var v = getFromKey(keyIsMaster);
    try {
      return int.parse(v);
    } catch (e) {
      return 0;
    }
  }

  bool get isLogin => (accessToken != null && accessToken.length != 0);

  void init() {}

  String getFromKey(String key) {
    if (binary.containsKey(key)) {
      return binary[key];
    }
    return cookie.get(key);
  }

  void set userName(String v) {
    if (v == null) {
      v = "";
    }
    binary[keyUserName] = v;
    cookie.set(keyUserName, v);
  }

  void set isMaster(int value) {
    binary[keyIsMaster] = "${value}";
    cookie.set(keyIsMaster, "${value}");
  }

  void set accessToken(String v) {
    if (v == null) {
      v = "";
    }
    binary[keyAccessToken] = v;
    cookie.set(keyAccessToken, v);
  }
}
