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

  String _id = "";
  @Input()
  void set id(String v){
    _id = v;

  }
  String get id => _id;
  String title = "";
  String message = "";

  @Input()
  ArtNBox artNBox = null;

  @Input()
  String accessToken;

  @Input()
  String userName;

  InputImageDialogParam param = new InputImageDialogParam();

  PostArticleComponent(this._routeParams){
   // id = _routeParams.get("id");
  }

  config.AppConfig rootConfig = config.AppConfig.inst;

  List<String> imageSrcs = [];

  ngOnInit(){
    updateA();
  }

  updateA() async {
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
      newArtProp = await artNBox.newArt(accessToken, userName,title: title, cont: message);
    } else {
      newArtProp = await artNBox.updateArt(accessToken, id, userName:userName, title: title, cont: message);
    }
    if (imageSrcs.length > 0 && false == imageSrcs[0].startsWith("http")) {
      var v = conv.BASE64.decode(imageSrcs[0].replaceFirst(new RegExp(".*,"), ''));
      await artNBox.updateFile(accessToken, newArtProp.articleId, "", "icon", v);
    }
  }


  onUpdateIcon(InputImageDialog dd) async {
    param.onFileFunc = (InputImageDialog dd) async {
      var currentImage = dd.currentImage;
//      var i = conv.BASE64.decode(currentImage.src.replaceFirst(new RegExp(".*,"), ''));
      updateIcon(currentImage.src);

     };
    dd.open();
  }

  updateIcon(String src) async {
    imageSrcs.add(src);
  }
}
