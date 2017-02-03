
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_users.dart';
import 'package:k07me.netbox/netbox.dart';
import 'comp_article.dart';

@Component(
    selector: "arts-component",
    directives: const [ArticleComponent],
    template:  """
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
  final RouteParams _routeParams;
  ArticlesComponentInfo info;

  ArticlesComponent(this._routeParams) {
    info = new ArticlesComponentInfo(parent:this);
  }

  @Input()
  bool isUpdatable = false;

  @Input()
  String userName = "";

  @Input()
  ArtNBox artNBox;

  @Input()
  String accessToken = "";

  List<ArtInfoProp> artInfos = [];

  ngOnInit() {
    updateConfig();
    update();
  }

  update() async {
    ArtKeyListProp list = await artNBox.findArticle("",props: {"s":"p"});
    for(String key in list.keys) {
      ArtInfoProp artInfo = await artNBox.getArtFromStringId(key);
      artInfos.add(artInfo);
    }
  }

  updateConfig(){
    print(_routeParams.params.toString());
    if(_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}

class ArticlesComponentInfo {
  final ArticlesComponent parent;

  ArticlesComponentInfo({this.parent:null}){
  }

  String get accessToken => (parent == null ? "" : parent.accessToken);

  ArtNBox get artNBox => (parent == null ? "" : parent.artNBox);

  bool isUpdatable(String userName) => (parent == null ? false : parent.userName == userName);

  onRemove(ArtInfoProp art) {
    if (parent != null && parent.artInfos.contains(art)) {
      parent.artInfos.remove(art);
    }
  }
}