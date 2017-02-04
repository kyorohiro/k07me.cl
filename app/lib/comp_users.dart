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
  <div *ngFor='let ui of userInfos'><user-component  [userInfo]='ui'></user-component></div>
  </div>
  """
)
class UsersComponent implements OnInit {
  List<String> userNames = [];

  @Input()
  List<UserInfoProp> userInfos = [];

  @Input()
  String cursor = "";

  UsersComponent(){
  }

  ngOnInit() {
    _init();
    for(UserInfoProp user in userInfos) {
      userNames.add(user.userName);
    }
  }

  _init() async {

    try {
      UserKeyListProp userKeys = await config.AppConfig.inst.appNBox.userNBox.findUser(cursor);
      for(String key in userKeys.keys) {
        UserInfoProp infoProp = await config.AppConfig.inst.appNBox.userNBox.getUserInfoFromKey(key);
         if(!userNames.contains(infoProp.userName)) {
            userInfos.add(infoProp);
         }
      }
    } catch(e){
    }
  }
}

