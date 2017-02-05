import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_users.dart';
import 'package:k07me.netbox/netbox.dart';
import 'comp_article.dart';

@Component(
    selector: "arts-component",
    directives: const [ArticleComponent],
    template: """
    <div class="mybody">
    <h1>Articles</h1>
    <div *ngFor='let artInfo of artInfos'>
        <art-component [info]='info' [artInfo]='artInfo'  ></art-component>
    </div>
    </div>
  """
)
class ArticlesComponent implements OnInit {
  final Router _router;
  final RouteParams _routeParams;
  ArticleComponentInfo info;

  ArticlesComponent(this._router, this._routeParams) {
    info = new MyArticleComponentInfo(parent: this);
  }

  @Input()
  Map<String,Object> params= {};

  List<ArtInfoProp> artInfos = [];

  ngOnInit() {
    update();
  }

  List<String> getTags() {
    var v = params["tag"];
    if(v == "" || v== null) {
      return [];
    } else {
      return [v];
    }
  }

  String getUserName() {
    var v = params["user"];
    if(v == "" || v== null) {
      return "";
    } else {
      return Uri.decodeComponent(v);
    }
  }

  update() async {
    ArtNBox artNBox = config.AppConfig.inst.appNBox.artNBox;
    ArtKeyListProp list = await artNBox.findArticle("", props: {"s": "p"},tags: getTags(),userName: getUserName());
    for (String key in list.keys) {
      ArtInfoProp artInfo = await artNBox.getArtFromStringId(key);
      artInfos.add(artInfo);
    }
  }

}


class MyArticleComponentInfo extends ArticleComponentInfo {
  final ArticlesComponent parent;

  MyArticleComponentInfo({this.parent: null}) : super() ;

  bool isUpdatable(String userName) => (parent == null ? false : config.AppConfig.inst.cookie.userName == userName);

  onRemove(ArtInfoProp art) {
    if (parent != null && parent.artInfos.contains(art)) {
      parent.artInfos.remove(art);
    }
  }

  onClickTag(String t) {
    parent._router.navigate(["Arts",{"tag":t}]);
  }
}