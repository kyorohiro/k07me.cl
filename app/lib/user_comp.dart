import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'config.dart' as config;
import 'dart:convert' as conv;
import 'package:k07me.prop/prop.dart';
import 'dart:html' as html;

import 'inputimgage/dialog.dart';
import 'updateuser/dialog.dart';

//
@Component(
    selector: "user-component",
    directives: const[InputImageDialog,UpdateUserDialog],
    template: """
    <div class="mybody">
    <img *ngIf='iconUrl==""' src='/assets/egg.png'>
    <img *ngIf='iconUrl!=""' src='{{iconUrl}}'>

    <div style='font-size:24px;'>{{userInfo.displayName}}</div>
    <div style='fomt-size:8px;'>({{userInfo.userName}})</div>

    <div #userinfocont></div>
    <p>cont:{{userInfo.content}}</p>

    <div *ngIf='isUpdatable'>
      <button (click)='onUpdateIcon(myDialoga)'> updateIcon</button>
      <button (click)='onUpdateInfo(myDialogb)'> updateInfo</button>
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
  String iconUrl = "";

  @Input()
  bool isUpdatable;

  @Input()
  UserInfoProp userInfo;

  html.Element _mainElement;
  @ViewChild('userinfocont')
  set main(ElementRef elementRef) {
    _mainElement = elementRef.nativeElement;
  }

  //
  InputImageDialogParam param = new InputImageDialogParam();
  UpdateUserDialogParam parama = new UpdateUserDialogParam();

  UserComponent(this._routeParams);

  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
    if (userInfo == null){
      userInfo = new UserInfoProp(new MiniProp());
    }
    if (isUpdatable == null) {
      isUpdatable = false;
    }
    _init();
  }

  _init() async {

    UserNBox userNBox = config.AppConfig.inst.appNBox.userNBox;
    try {
      iconUrl = await userNBox.createBlobUrlFromKey(userInfo.iconUrl);
      print("===> ${iconUrl}");
      _mainElement.children.add(//
          new html.Element.html("""<div> ${userInfo.content.replaceAll("\n","<br>")}</div>""",//
              treeSanitizer: html.NodeTreeSanitizer.trusted));
    } catch(e){
      print("--e--");
    }
  }

  onUpdateIcon(InputImageDialog d) {
    param = new InputImageDialogParam();
    param.onFileFunc = (InputImageDialog dd) async {
      if(userInfo == null) {
        return;
      }
      MeNBox meNBox = config.AppConfig.inst.appNBox.meNBox;
      UserNBox userNBox = config.AppConfig.inst.appNBox.userNBox;
      var i = conv.BASE64.decode(dd.currentImage.src.replaceFirst(new RegExp(".*,"), ''));
      UploadFileProp prop = await meNBox.updateFile(rootConfig.cookie.accessToken,"/","icon.png", i,userName: userInfo.userName);
      iconUrl = await userNBox.createBlobUrlFromKey(prop.blobKey);
    };
    d.open();
  }

  onUpdateInfo(UpdateUserDialog d) {
    parama = new UpdateUserDialogParam();
    parama.userInfo = userInfo;
    parama.onUpdateFunc = (UpdateUserDialog dd) async {
      MeNBox meNBox = config.AppConfig.inst.appNBox.meNBox;
      UserNBox userNBox = config.AppConfig.inst.appNBox.userNBox;
      userInfo = await meNBox.updateUserInfo(
          config.AppConfig.inst.cookie.accessToken, //
          config.AppConfig.inst.cookie.userName,
          displayName: dd.displayName,
          cont: dd.content
      );
      print("${dd.displayName} ${dd.content}");
    };
    d.open();
  }
}
