import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:k07me.netbox/netbox.dart';
import 'dart:convert' as conv;
import 'package:k07me.prop/prop.dart';
import 'dart:html' as html;

import 'dart:async';
import 'deleteArticle/dialog.dart';

import 'comp_articles.dart';

//
@Component(
    selector: "art-component",
    directives: const[DeleteArticleDialog],
    template: """
    <div>
    <h2>{{artInfo.title}}</h2>
    <img #image *ngIf='iconUrl!=""' src='{{iconUrl}}'>

    <div #userinfocont></div>

    <div *ngIf='info.isUpdatable(artInfo.userName)'>
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
  ArticlesComponentInfo info = new ArticlesComponentInfo();


  ArtInfoProp _artInfo = null;
  @Input()
  void set artInfo(ArtInfoProp v) {
    _artInfo = v;
    updateInfo();
  }

  ArtInfoProp get artInfo => _artInfo;


  @Input()
  String userName;

  html.Element _mainElement;

  @ViewChild('userinfocont')
  set main(ElementRef elementRef) {
    _mainElement = elementRef.nativeElement;
    _mainElement.style.width ="${contentWidth}px";
  }

  ArticleComponent(this._router, this._routeParams){
  }


  ngOnInit() {
    if (artInfo == null){
      artInfo = new ArtInfoProp(new MiniProp());
    }
    updateInfo();
  }

  updateInfo() async {
    if(info.artNBox != null && artInfo != null) {
      try {
        if(artInfo.iconUrl == null || artInfo.iconUrl == ""){
          iconUrl = "";
        } else {
          iconUrl = await info.artNBox.createBlobUrlFromKey(artInfo.iconUrl);
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
      await info.artNBox.deleteArticleWithToken(info.accessToken, _artInfo.articleId);
      info.onRemove(artInfo);
    };
    param.title = "delete";
    param.message = "delete article";
    d.open();
  }
}
