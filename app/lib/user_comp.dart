import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'config.dart' as config;
import 'dart:async';
import 'dart:convert' as conv;

//
//import 'package:cl/hello_dialog/hello_dialog.dart';
//
import 'logout_dialog.dart';
//import 'user_icon_dialog.dart';
import 'inputimgage/dialog.dart';
import 'updateuser/dialog.dart';

//
@Component(
    selector: "my-user",
    directives: const[InputImageDialog,UpdateUserDialog],
    template: """
    <div class="mybody">
    <img *ngIf='iconUrl==""' src='/assets/egg.png'>
    <img *ngIf='iconUrl!=""' src='{{iconUrl}}'>

    <div style='font-size:24px;'>{{displayName}}</div>
    <div style='fomt-size:8px;'>({{userName}})</div>

    <p>cont:{{content}}</p>

    <div *ngIf='isMe'>
      <button (click)='onUpdateIcon(myDialoga)'> updateIcon</button>
      <button (click)='onUpdateInfo(myDialogb)'> updateIcon</button>
    </div>

    <inputimage-dialog [param]="param" #myDialoga>
    </inputimage-dialog>
    <updateuser-dialog [param]="parama" #myDialogb>
    </updateuser-dialog>
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
  String iconUrl = "";
  String content = "";
  bool get isMe => (rootConfig.cookie.userName==userName);

  //
  InputImageDialogParam param = new InputImageDialogParam();
  UpdateUserDialogParam parama = new UpdateUserDialogParam();

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
      iconUrl = await userNBox.createBlobUrlFromKey(infoProp.iconUrl);
      print("===> ${iconUrl}");
      content = infoProp.content;
    } catch(e){

    }
  }

  onUpdateIcon(InputImageDialog d) {
    param = new InputImageDialogParam();
    param.onFileFunc = (InputImageDialog dd) async {
      MeNBox meNBox = config.AppConfig.inst.appNBox.meNBox;
      UserNBox userNBox = config.AppConfig.inst.appNBox.userNBox;
      var i = conv.BASE64.decode(dd.currentImage.src.replaceFirst(new RegExp(".*,"), ''));
      UploadFileProp prop = await meNBox.updateFile(rootConfig.cookie.accessToken,"/","icon.png", i,userName: userName);
      iconUrl = await userNBox.createBlobUrlFromKey(prop.blobKey);
    };
    d.open();
  }

  onUpdateInfo(UpdateUserDialog d) {
    d.open();
  }
}
