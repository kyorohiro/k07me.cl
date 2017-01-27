import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'dart:html' as html;
import 'dart:async';


@Component(
  selector: 'updateuser-dialog',
  styles: const [
    """
    .updateuser-dialog-title {
    }
    .updateuser-dialog-message {
    }
    .updateuser-dialog-errormessage {
    }
    .updateuser-dialog-cancelbutton{
    }
    .updateuser-dialog-okbutton{
    }
    """,
  ],
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <div *ngIf='errorMessage!=""' class='updateuser-dialog-errormessage'>{{errorMessage}}</div>
    <h3 class='updateuser-dialog-title' header>{{param.title}}</h3>
    <p class='updateuser-dialog-message'>{{param.message}}</p>
    <material-spinner *ngIf='isloading'></material-spinner>
    <div #imgc></div>
    <div footer>


      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)" class='updateuser-dialog-cancelbutton'>
        {{param.cancel}}
      </material-button>
      <material-button *ngIf='currentImage!=null' autoFocus clear-size (click)="onUpdate(wrappingModal)" class='updateuser-dialog-okbutton'>
        {{param.ok}}
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class UpdateUserDialog implements OnInit {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  @Input()
  UpdateUserDialogParam param;

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

  onUpdate(ModalComponent comp) async {
    isloading = true;
    try {
      var ret = await param.onUpdate(this);
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

}

typedef Future<String> OnUpdateFunc(UpdateUserDialog d);

class UpdateUserDialogParam {
  String title;
  String message;
  String ok;
  String cancel;
  OnUpdateFunc onFileFunc;

  UpdateUserDialogParam({this.title:"UserInfo",this.message:"..",this.ok:"Update",this.cancel:"Cancel",
  onFileFunc: null}){
  }

  /**
   * if failed to do onFind func, then return error message.
   */
  Future<String> onUpdate(UpdateUserDialog d) async {
    if (onFileFunc == null) {
      return "";
    } else {
      return onFileFunc(d);
    }
  }
}