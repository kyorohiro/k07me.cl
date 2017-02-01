import 'package:angular2/core.dart';
import 'comp_user.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:async';
import 'comp_user.dart';
import 'config.dart' as config;

@Component(
  selector: "user-components",
  directives: const [UserComponent],
  template: """
  <div>
  <div *ngFor='let ui of userInfos'><user-component [userInfo]='ui' [meNBox]='rootConfig.appNBox.meNBox'></user-component></div>
  </div>
  """
)
class UsersComponent implements OnInit {

  config.AppConfig rootConfig = config.AppConfig.inst;

  @Input()
  List<UserInfoProp> userInfos = [];

  List<String> userNames = [];

  @Input()
  UserNBox userNBox = null;

  @Input()
  String cursor = "";



  ngOnInit() {
    _init();
    for(UserInfoProp user in userInfos) {
      userNames.add(user.userName);
    }
  }

  _init() async {
    try {
      UserKeyListProp userKeys = await userNBox.findUser(cursor);
      for(String key in userKeys.keys) {
        UserInfoProp infoProp = await userNBox.getUserInfoFromKey(key);
         if(!userNames.contains(infoProp.userName)) {
            print("--> ${infoProp.userName} ${infoProp.iconUrl}");
            userInfos.add(infoProp);
         }
      }
    } catch(e){
    }
  }

}