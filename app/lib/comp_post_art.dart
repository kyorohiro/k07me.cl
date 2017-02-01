import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'config.dart' as config;

//
@Component(
    selector: "post-article-component",
    directives: const [],
    template: """
    <div class="mybody">
    <h1>Post Article</h1>
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
class PostArticleComponent implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;

  PostArticleComponent(this._routeParams);

  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
  }

}
