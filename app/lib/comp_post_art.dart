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

  @Input()
  String id = "";

  @Input()
  ArtNBox artNBox = null;

  @Input()
  String accessToken;

  @Input()
  String userName;

  //
  //
  String title = "";
  String message = "";
  InputImageDialogParam param = new InputImageDialogParam();
  config.AppConfig rootConfig = config.AppConfig.inst;
  List<String> imageSrcs = [];

  PostArticleComponent(this._routeParams){
  }

  ngOnInit(){
    updateInfo();
  }

  updateInfo() async {
    if(id != null && id !="new" && id!="") {
      var v = await artNBox.getArtFromArticleId(id,"");
      title = v.title;
      message = v.cont;
      if(v.iconUrl != "" && v.iconUrl != null) {
        updateIcon(await artNBox.createBlobUrlFromKey(v.iconUrl));
      }
    }
  }

  onPost(html.Element v) async {
    NewArtProp newArtProp = null;
    if(id == "" || id == "new" || id == null) {
      newArtProp = await artNBox.newArt(accessToken, userName,title: title, cont: message, props: {"s":"p"});
    } else {
      newArtProp = await artNBox.updateArt(accessToken, id, userName:userName, title: title, cont: message, props: {"s":"p"});
    }
    if (imageSrcs.length > 0 && false == imageSrcs[0].startsWith("http")) {
      var v = conv.BASE64.decode(imageSrcs[0].replaceFirst(new RegExp(".*,"), ''));
      await artNBox.updateFile(accessToken, newArtProp.articleId, "", "icon", v);
    }
  }

  //      var i = conv.BASE64.decode(currentImage.src.replaceFirst(new RegExp(".*,"), ''));
  onUpdateIcon(InputImageDialog dd) async {
    param.onFileFunc = (InputImageDialog dd) async {
      var currentImage = dd.currentImage;
      updateIcon(currentImage.src);

     };
    dd.open();
  }

  updateIcon(String src) async {
    imageSrcs.add(src);
  }
}
