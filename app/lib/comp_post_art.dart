import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'config.dart' as config;
import 'dart:html' as html;
import 'package:k07me.netbox/netbox.dart';
import 'inputimgage/dialog.dart';
import 'dart:convert' as conv;

//
@Component(
    selector: "post-article-component",
    directives: const [InputImageDialog],
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
      <button (click)='onUpdateIcon(myDialoga)'>add image</button>
      <button #btn (click)='onPost(btn)'>Post</button>

      <div *ngFor='let src of imageSrcs'>
        <img src='{{src}}'>
      </div>
    <inputimage-dialog [param]="param" #myDialoga>
    </inputimage-dialog>
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
  final RouteParams _routeParams;

  String id = "";
  String title = "";
  String message = "";

  @Input()
  ArtNBox artNBox = null;

  @Input()
  String accessToken;

  InputImageDialogParam param = new InputImageDialogParam();

  PostArticleComponent(this._routeParams){
    id = _routeParams.get("id");
  }

  config.AppConfig rootConfig = config.AppConfig.inst;

  List<String> imageSrcs = [];

  ngOnInit() {
  }

  onPost(html.Element v) async {
    NewArtProp newArtProp = await artNBox.newArt(accessToken, title: title, cont: message);

    //String articleId, String dir, String name, typed.Uint8List data
    if(imageSrcs.length > 0) {
      var v = conv.BASE64.decode(imageSrcs[0].replaceFirst(new RegExp(".*,"), ''));
      await artNBox.updateFile(accessToken, newArtProp.articleId, "","icon", v);
    }
  }


  onUpdateIcon(InputImageDialog dd) async {
    param.onFileFunc = (InputImageDialog dd) async {
      var i = conv.BASE64.decode(dd.currentImage.src.replaceFirst(new RegExp(".*,"), ''));
      imageSrcs.add(dd.currentImage.src);
     };
    dd.open();
  }
}
