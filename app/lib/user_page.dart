import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'config.dart' as config;
import 'dart:async';
import 'dart:convert' as conv;
import 'package:k07me.netbox/netbox.dart';
import 'package:k07me.prop/prop.dart';
import 'dart:html' as html;

import 'inputimgage/dialog.dart';
import 'updateuser/dialog.dart';
import 'user_comp.dart';

//
@Component(
    selector: "my-user",
    directives: const[InputImageDialog,UpdateUserDialog,UserComponent],
    template: """
    <div class="mybody">
    <user-component  [userInfo]='userInfo' [accessToken]='rootConfig.cookie.accessToken' [userName]='rootConfig.cookie.userName' [meNBox]='rootConfig.appNBox.meNBox' [isUpdatable]='isUpdatable'></user-component>
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
class UserPage implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;
  UserInfoProp userInfo = new UserInfoProp(new MiniProp());

  InputImageDialogParam param = new InputImageDialogParam();
  UpdateUserDialogParam parama = new UpdateUserDialogParam();

  UserPage(this._routeParams);
  config.AppConfig rootConfig = config.AppConfig.inst;
  bool get isUpdatable => rootConfig.cookie.userName == userInfo.userName;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
    _init();
  }

  _init() async {
    UserNBox userNBox = config.AppConfig.inst.appNBox.userNBox;
    try {
      userInfo  = await userNBox.getUserInfo(
          config.AppConfig.inst.cookie.userName);
    } catch (e) {

    }
  }
}
