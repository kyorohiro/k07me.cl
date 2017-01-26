import 'package:angular2/core.dart';
import 'config.dart' as config;
import 'package:angular2_components/angular2_components.dart';
import 'dart:html' as html;

@Component(
  selector: 'my-user-icon-dialog',
  template: """
<modal #wrappingModal>
  <material-dialog style='width:80%'>
    <h3 header>
        File
    </h3>
    <p>
    ...{{ga}}
    </p>
    <div footer>
      <input #in type="file" id="upload" (change)='onInput(in)'>

      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)">
        Cancel
      </material-button>
      <material-button autoFocus clear-size (click)="onFile(wrappingModal)">
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

  onInput(html.InputElement i){
    print("----->SSS ${i.value}");
    ga = "xxx";
  }
}
