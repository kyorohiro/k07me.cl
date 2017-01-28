import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
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
  final RouteParams _routeParams;
  String iconUrl = "";

  @Input()
  bool isUpdatable;

  @Input()
  UserInfoProp userInfo;

  @Input()
  MeNBox meNBox;

  @Input()
  String accessToken;

  @Input()
  String userName;

  html.Element _mainElement;
  @ViewChild('userinfocont')
  set main(ElementRef elementRef) {
    _mainElement = elementRef.nativeElement;
  }

  //
  InputImageDialogParam param = new InputImageDialogParam();
  UpdateUserDialogParam parama = new UpdateUserDialogParam();

  UserComponent(this._routeParams);


  ngOnInit() {
    if (userInfo == null){
      userInfo = new UserInfoProp(new MiniProp());
    }
    if (isUpdatable == null) {
      isUpdatable = false;
    }
    _init();
  }

  _init() async {
    try {
      iconUrl = await meNBox.createBlobUrlFromKey(userInfo.iconUrl);
      updateContent(userInfo.content);
    } catch(e){
      print("--e--");
    }
  }

  updateContent(String cont) {
    _mainElement.children.clear();
    _mainElement.children.add(//
        new html.Element.html("""<div> ${cont.replaceAll("\n","<br>")}</div>""",//
            treeSanitizer: html.NodeTreeSanitizer.trusted));
  }

  onUpdateIcon(InputImageDialog d) {
    param = new InputImageDialogParam();
    param.onFileFunc = (InputImageDialog dd) async {
      if(userInfo == null) {
        return;
      }
      var i = conv.BASE64.decode(dd.currentImage.src.replaceFirst(new RegExp(".*,"), ''));
      UploadFileProp prop = await meNBox.updateFile(accessToken,"/","icon.png", i,userName: userName);
      iconUrl = await meNBox.createBlobUrlFromKey(prop.blobKey);
    };
    d.open();
  }

  onUpdateInfo(UpdateUserDialog d) {
    parama = new UpdateUserDialogParam();
    parama.userInfo = userInfo;
    parama.onUpdateFunc = (UpdateUserDialog dd) async {
      userInfo = await meNBox.updateUserInfo(
          accessToken, //
          userName,
          displayName: dd.displayName,
          cont: dd.content
      );
      updateContent(dd.content);
    };
    d.open();
  }
}
