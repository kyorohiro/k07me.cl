import 'package:angular2/core.dart';
import 'user_comp.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:async';


@Component(
  selector: "user-components",
  directives: const [UsersComponent],
  template: """
  <ul>
  <li *ngFor='let ui of userInfos'><span>{{ui.userName}}</span></li>
  </ul>
  """
)
class UsersComponent implements OnInit {

  @Input()
  List<UserInfoProp> userInfos = [];

  List<String> userNames = [];

  @Input()
  UserNBox userNBox = null;

  @Input()
  String cursor = "";



  ngOnInit() {
    print("---A-1");
    _init();
    for(UserInfoProp user in userInfos) {
      userNames.add(user.userName);
    }
  }

  _init() async {
    try {
      print("---A0");
      UserKeyListProp userKeys = await userNBox.findUser(cursor);
      for(String key in userKeys.keys) {
        print("---A1 ${key}");
        UserInfoProp infoProp = await userNBox.getUserInfoFromKey(key);
         if(!userNames.contains(infoProp.userName)) {
            userInfos.add(infoProp);
         }
      }
    } catch(e){
      print("A2 ${e}");
    }
  }
}