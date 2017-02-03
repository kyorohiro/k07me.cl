
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
        <art-component [artNBox]='artNBox' [artInfo]='artInfo' [isUpdatable]='userName==artInfo.userName'></art-component>
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
  ArticlesComponent(this._routeParams);

  @Input()
  bool isUpdatable = false;

  @Input()
  String userName = "";

  @Input()
  ArtNBox artNBox;

  List<ArtInfoProp> artInfos = [];

  ngOnInit() {
    updateConfig();
    update();
  }

  update() async {
    ArtKeyListProp list = await artNBox.findArticle("");
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