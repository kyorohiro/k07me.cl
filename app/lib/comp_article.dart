import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:convert' as conv;
import 'package:k07me.prop/prop.dart';
import 'dart:html' as html;

import 'dart:async';
import 'deleteArticle/dialog.dart';

//
@Component(
    selector: "art-component",
    directives: const[DeleteArticleDialog],
    template: """
    <div>
    <h2>{{artInfo.title}}</h2>
    <img #image *ngIf='iconUrl!=""' src='{{iconUrl}}'>

    <div #userinfocont></div>

    <div *ngIf='isUpdatable'>
      <button (click)='onEdit()'>Edit</button>
      <button (click)='onDelete(myDialoga)'>Delete</button>
    </div>
    <deletearticle-dialog [param]='param' #myDialoga>
    </deletearticle-dialog>
    </div>
  """,
    styles: const[
      """
    """,
    ]
)
class ArticleComponent implements OnInit {
  final RouteParams _routeParams;
  final Router _router;
  String iconUrl = "";



  @Input()
  int imageWidth = 200;

  @Input()
  int contentWidth = 200;

  @ViewChild('image')
  set image(ElementRef elementRef) {
    if(elementRef == null || elementRef.nativeElement == null) {
      return;
    }
    (elementRef.nativeElement as html.ImageElement).style.width = "${imageWidth}px";
  }


  @Input()
  bool isUpdatable;

  ArtInfoProp _artInfo = null;
  @Input()
  void set artInfo(ArtInfoProp v) {
    _artInfo = v;
    updateInfo();
  }

  ArtInfoProp get artInfo => _artInfo;

  ArtNBox _artNBox;
  @Input()
  void set artNBox(ArtNBox v) {
    _artNBox = v;
    updateInfo();
  }

  ArtNBox get artNBox => _artNBox;

  @Input()
  String accessToken;

  @Input()
  String userName;

  html.Element _mainElement;

  @ViewChild('userinfocont')
  set main(ElementRef elementRef) {
    _mainElement = elementRef.nativeElement;
    _mainElement.style.width ="${contentWidth}px";
  }

  ArticleComponent(this._router, this._routeParams){
///    artInfo.title
  }


  ngOnInit() {
    if (artInfo == null){
      artInfo = new ArtInfoProp(new MiniProp());
    }
    if (isUpdatable == null) {
      isUpdatable = false;
    }
    updateInfo();
  }

  updateInfo()async {
    if(artNBox != null && artInfo != null) {
      try {
        if(artInfo.iconUrl == null || artInfo.iconUrl == ""){
          iconUrl = "";
        } else {
          iconUrl = await artNBox.createBlobUrlFromKey(artInfo.iconUrl);
        }
      } catch(e) {
        print("--e-- ${e}");
      }
    }
    updateContent(artInfo.cont);
  }

  updateContent(String cont) {
    print("--->${cont}");
    _mainElement.children.clear();
    _mainElement.children.add(//
        new html.Element.html("""<div> ${cont.replaceAll("\n","<br>")}</div>""",//
            treeSanitizer: html.NodeTreeSanitizer.trusted));
  }

  onEdit(){
    _router.navigate(["Post",{"id":artInfo.articleId}]);
  }

  DeleteArticleDialogParam param = new DeleteArticleDialogParam();
  onDelete(DeleteArticleDialog d) {
    param.onDeleteFunc = (DeleteArticleDialog dd) async {
      await artNBox.deleteArticleWithToken(accessToken, _artInfo.articleId);
    };
    param.title = "delete";
    param.message = "delete article";
    d.open();
  }
}
