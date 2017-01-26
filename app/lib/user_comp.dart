import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'config.dart' as config;
import 'dart:async';

//
//import 'package:cl/hello_dialog/hello_dialog.dart';
//
import 'logout_dialog.dart';

//
@Component(
    selector: "my-user",
    directives: const [LogoutDialog],
    template: """
    <div class="mybody">
    <h1>{{userName}}</h1>
    <h1>{{displayName}}</h1>


    <my-logout-dialog #myDialoga
             [name]="'as'">
    </my-logout-dialog>

    </div>
  """,
    styles: const[
      """
    .mybody {
      display: block;
      height: 600px;
    }
    """,
    ]
)
class UserComponent implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;
  String userName = "";
  String displayName = "";

  UserComponent(this._routeParams);

  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
    _init();
  }
  _init() async {
    UserNBox userNBox = config.AppConfig.inst.appNBox.userNBox;
    userName = _routeParams.get("name");
    try {
      UserInfoProp infoProp = await userNBox.getUserInfo(userName);
      displayName = infoProp.displayName;
    } catch(e){

    }
  }

  onLogout(LogoutDialog _dialog) async {
    _dialog.open();
  }
}
