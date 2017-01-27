import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'dart:html' as html;
import 'imageutil.dart' as imgutil;
import 'dart:async';


@Component(
  selector: 'inputimage-dialog',
  styles: const [
    """
    .inputimage-dialog-title {
    }
    .inputimage-dialog-message {
    }
    .inputimage-dialog-errormessage {
    }
    .inputimage-dialog-cancelbutton{
    }
    .inputimage-dialog-okbutton{
    }
    """,
  ],
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <div *ngIf='errorMessage!=""' class='inputimage-dialog-errormessage'>{{errorMessage}}</div>
    <h3 class='inputimage-dialog-title' header>{{param.title}}</h3>
    <p class='inputimage-dialog-message'>{{param.message}}</p>
    <material-spinner *ngIf='isloading'></material-spinner>
    <div #imgc></div>
    <div footer>
      <input #in type="file" id="upload" (change)='onInput(in,imgc)'>

      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)" class='inputimage-dialog-cancelbutton'>
        {{param.cancel}}
      </material-button>
      <material-button *ngIf='currentImage!=null' autoFocus clear-size (click)="onFile(wrappingModal)" class='inputimage-dialog-okbutton'>
        {{param.ok}}
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class InputImageDialog implements OnInit {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  @Input()
  InputImageDialogParam param;

  bool isloading = false;
  html.ImageElement currentImage = null;
  String errorMessage = "";

  ngOnInit(){
  }

  void open() {
    wrappingModal.open();
  }

  onCancel(ModalComponent comp) {
    wrappingModal.close();
  }

  onFile(ModalComponent comp) async {
    isloading = true;
    try {
      var ret = await param.onFile(this);
      if (ret != "" && ret != null) {
        errorMessage = ret;
      } else {
        errorMessage = "";
        wrappingModal.close();
      }
    } catch (e) {
      errorMessage = "failed to (${e})";
    } finally {
      isloading = false;
    }
  }

  onInput(html.InputElement i,html.DivElement c) async {
    isloading = true;
    try {
      if(i.value.length <= 0) {
        return;
      }
      var img = await imgutil.ImageUtil.loadImage(i.files.first);
      var img1 = await imgutil.ImageUtil.resizeImage(img);
      c.children.add(img1);
      currentImage = img1;
    } catch(e){
      errorMessage = "failed to (${e})";
    } finally{
      isloading = false;
    }
  }
}

class InputImageDialogParam {
  final String title;
  final String message;
  String ok;
  String cancel;
  int get imgWidth => 300;
  int get imgHeight => -1;


  InputImageDialogParam({this.title:"File",this.message:"select file!!",this.ok:"OK",this.cancel:"Cancel"}){
  }

  /**
   * if failed to do onFind func, then return error message.
   */
  Future<String> onFile(InputImageDialog d){}
}

