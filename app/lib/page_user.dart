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
import 'comp_user.dart';
import 'comp_post_art.dart';

//
@Component(
    selector: "my-user",
    directives: const[UserComponent,PostArticleComponent],
    template: """
    <div class="mybody">
    <user-component  [userInfo]='userInfo' [accessToken]='rootConfig.cookie.accessToken' [userName]='rootConfig.cookie.userName' [meNBox]='rootConfig.appNBox.meNBox' [isUpdatable]='isUpdatable'></user-component>
    <br>
    <div *ngIf='isMe'>
    <button (click)='onClick()'> New Article</button>
    </div>
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
  final Router _router;
  final RouteParams _routeParams;
  UserInfoProp userInfo = new UserInfoProp(new MiniProp());

  InputImageDialogParam param = new InputImageDialogParam();
  UpdateUserDialogParam parama = new UpdateUserDialogParam();

  UserPage(this._router,this._routeParams);
  config.AppConfig rootConfig = config.AppConfig.inst;
  bool get isUpdatable => rootConfig.cookie.userName == userInfo.userName;
  bool get isMe => rootConfig.cookie.userName == userInfo.userName;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
    _init();
  }

  onClick() {
    _router.navigate(["Post",{"id":"new"}]);
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
