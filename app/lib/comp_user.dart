import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:convert' as conv;
import 'package:k07me.prop/prop.dart';
import 'dart:html' as html;

import 'inputimgage/dialog.dart';
import 'updateuser/dialog.dart';
import 'dart:async';
import 'config.dart' as config;

//
@Component(
  selector: "user-component",
  directives: const[InputImageDialog, UpdateUserDialog],
  template: """
    <div>
    <img #image1 *ngIf='iconUrl==""' src='/assets/egg.png'>
    <img #image *ngIf='iconUrl!=""' src='{{iconUrl}}'>
    <div style='font-size:24px;'>{{userInfo.displayName}}</div>
    <div style='font-size:8px;'>({{userInfo.userName}})</div>

    <div #userinfocont></div>

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
)
class UserComponent implements OnInit {
  final RouteParams _routeParams;
  String iconUrl = "";

  @Input()
  int imageWidth = 200;

  @Input()
  int contentWidth = 200;

  @ViewChild('image')
  set image(ElementRef elementRef) {
    if (elementRef == null || elementRef.nativeElement == null) {
      return;
    }
    (elementRef.nativeElement as html.ImageElement).style.width = "${imageWidth}px";
  }


  @Input()
  UserInfoProp userInfo = new UserInfoProp(null);

  bool get isUpdatable => config.AppConfig.inst.cookie.userName == userInfo.userName;

  MeNBox get meNBox => config.AppConfig.inst.appNBox.meNBox;


  html.Element _userInfoElement;

  @ViewChild('userinfocont')
  set main(ElementRef elementRef) {
    _userInfoElement = elementRef.nativeElement;
    _userInfoElement.style.width = "${contentWidth}px";
  }

  //
  InputImageDialogParam param = new InputImageDialogParam();
  UpdateUserDialogParam parama = new UpdateUserDialogParam();

  UserComponent(this._routeParams) {
  }


  ngOnInit() {
    if (userInfo == null) {
      userInfo = new UserInfoProp(new MiniProp());
      updateInfo();
    }
  }

  updateInfo() async {
    if (meNBox != null && userInfo != null) {
      try {
        iconUrl = await meNBox.createBlobUrlFromKey(userInfo.iconUrl);
        updateContent(userInfo.content);
      } catch (e) {
        print("--e-- ${e}");
      }
    }
  }

  updateContent(String cont) {
    _userInfoElement.children.clear();
    _userInfoElement.children.add( //
        new html.Element.html("""<div> ${cont.replaceAll("\n", "<br>")}</div>""", //
            treeSanitizer: html.NodeTreeSanitizer.trusted));
  }

  onUpdateIcon(InputImageDialog d) {
    param = new InputImageDialogParam();
    param.onFileFunc = (InputImageDialog dd) async {
      if (userInfo == null) {
        return;
      }
      var i = conv.BASE64.decode(dd.currentImage.src.replaceFirst(new RegExp(".*,"), ''));
      UploadFileProp prop = await meNBox.updateFile(
          config.AppConfig.inst.cookie.accessToken, "/", "icon.png", //
          i, userName: config.AppConfig.inst.cookie.userName);
      iconUrl = await meNBox.createBlobUrlFromKey(prop.blobKey);
    };
    d.open();
  }

  onUpdateInfo(UpdateUserDialog d) {
    parama = new UpdateUserDialogParam();
    parama.userInfo = userInfo;
    parama.onUpdateFunc = (UpdateUserDialog dd) async {
      userInfo = await meNBox.updateUserInfo(
          config.AppConfig.inst.cookie.accessToken, //
          config.AppConfig.inst.cookie.userName,
          displayName: dd.displayName,
          cont: dd.content
      );
    };
    d.open();
  }
}
