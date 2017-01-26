import 'package:angular2/core.dart';
import 'config.dart' as config;
import 'package:angular2_components/angular2_components.dart';
import 'dart:html' as html;
import 'imageutil.dart' as imgutil;
import 'dart:async';

@Component(
  selector: 'my-user-icon-dialog',
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <h3 header>
        File
    </h3>
    <p>{{ga}}</p>
    <material-spinner *ngIf='isloading'></material-spinner>
    <!--img *ngIf='useImg' src='src'-->
    <div #imgc></div>
    <div footer>
      <input #in type="file" id="upload" (change)='onInput(in,imgc)'>

      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)">
        Cancel
      </material-button>
      <material-button *ngIf='currentImage!=null' autoFocus clear-size (click)="onFile(wrappingModal)">
        File
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class UserIconDialog {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;
  bool isloading = false;
  bool useImg = false;
  String src = "";
  html.ImageElement currentImage = null;

  void open() {
    wrappingModal.open();
  }

  onCancel(ModalComponent comp) {
    wrappingModal.close();
  }
  onFile(ModalComponent comp) {
    wrappingModal.close();
  }
  String ga = "";

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
      useImg = true;
      print("${src}");
    } catch(e){
      ga = "Failed";
      useImg = false;
    } finally{
      isloading = false;
    }
  }
}
