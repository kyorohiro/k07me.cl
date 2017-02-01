import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'config.dart' as config;
import 'dart:html' as html;
import 'package:k07me.netbox/netbox.dart';

//
@Component(
    selector: "post-article-component",
    directives: const [],
    template: """
    <div class="mybody">
      <h1>Post Article</h1>
      <div>{{id}}</div>
      <div><label>Title</label><br>
      <input [(ngModel)]='title' class='title'>
      </div>

      <div><label>Message</label><br>
      <textarea [(ngModel)]='message' class='content'></textarea>
      </div>

      <button #btn (click)='onPost(btn)'>Post</button>

    </div>
  """,
    styles: const[
      """
    .mybody {
      display: block;
      height: 600px;
    }
    .title {
      width:80%;
    }
    .content {
      width:80%;
    }
    """,
    ]
)
class PostArticleComponent implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;

  String id = "";
  String title = "";
  String message = "";

  @Input()
  ArtNBox artNBox = null;

  @Input()
  String accessToken;



  PostArticleComponent(this._routeParams){
    id = _routeParams.get("id");
  }

  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
  }

  onPost(html.Element v){
    artNBox.newArt(accessToken, title: title, cont: message);
  }

}
