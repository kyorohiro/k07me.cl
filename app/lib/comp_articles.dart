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
class ArticlesComponent implements OnInit {
  final Router _router;
  final RouteParams _routeParams;
  ArticleComponentInfo info;

  ArticlesComponent(this._router, this._routeParams) {
    info = new MyArticleComponentInfo(parent: this);
  }

  @Input()
  String userName = "";

  @Input()
  ArtNBox artNBox;

  @Input()
  String accessToken = "";

  @Input()
  Map<String,Object> params= {};

  List<ArtInfoProp> artInfos = [];

  ngOnInit() {
    updateConfig();
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

    ArtKeyListProp list = await artNBox.findArticle("", props: {"s": "p"},tags: getTags(),userName: getUserName());
    for (String key in list.keys) {
      ArtInfoProp artInfo = await artNBox.getArtFromStringId(key);
      artInfos.add(artInfo);
    }
  }

  updateConfig() {
    print(_routeParams.params.toString());
    if (_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}


class MyArticleComponentInfo extends ArticleComponentInfo {
  final ArticlesComponent parent;

  MyArticleComponentInfo({this.parent: null}) : super() {
  }

  String get accessToken => (parent == null ? "" : parent.accessToken);

  ArtNBox get artNBox => (parent == null ? "" : parent.artNBox);

  bool isUpdatable(String userName) => (parent == null ? false : parent.userName == userName);

  onRemove(ArtInfoProp art) {
    if (parent != null && parent.artInfos.contains(art)) {
      parent.artInfos.remove(art);
    }
  }

  onClickTag(String t) {
    parent._router.navigate(["Arts",{"tag":t}]);
  }
}