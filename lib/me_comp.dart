import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'config.dart' as config;
import 'dart:async';

//
//import 'package:cl/hello_dialog/hello_dialog.dart';
//
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:angular2_components/src/components/material_dialog/material_dialog.dart';

//
@Component(
    selector: "mybody",
    directives: const [HelloDialog],
    template: """
    <div class="mybody">
    <h1>Login</h1>
    <div *ngIf='rootConfig.cookie.accessToken == ""'>
    <a href='{{twitterLoginUrl}}'>use Twitter</a>
    </div>
    <div *ngIf='rootConfig.cookie.accessToken != ""'>
    <buttomn (click)='onLogout(myDialoga)'>Logout</buttomn>
    </div>

    <hello-dialog #myDialoga
             [name]="'as'">
    </hello-dialog>

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
class MeComponent implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;

  MeComponent(this._routeParams);

  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {
    twitterLoginUrl = config.AppConfig.inst.twitterLoginUrl;
  }

  onLogout(HelloDialog _dialog) async {
    _dialog.open();
  }
}


@Component(
  selector: 'hello-dialog',
  template: """
<modal #wrappingModal>
  <material-dialog>
    <h3 header>
        Logout?
    </h3>
    <p>
    ...
    </p>
    <div footer>
      <material-button autoFocus clear-size (click)="onCancel(wrappingModal)">
        Cancel
      </material-button>
      <material-button autoFocus clear-size (click)="onLogout(wrappingModal)">
        Logout
      </material-button>
    </div>
  </material-dialog>
</modal>
  """,
  directives: const [materialDirectives],
  providers: const [materialProviders],
)
class HelloDialog {
  @ViewChild('wrappingModal')
  ModalComponent wrappingModal;

  void open() {
    wrappingModal.open();
  }

  onCancel(ModalComponent comp) {
    wrappingModal.close();
  }
  onLogout(ModalComponent comp) {
    config.AppConfig.inst.cookie.setIsMaster("");
    config.AppConfig.inst.cookie.accessToken = "";
    config.AppConfig.inst.cookie.userName = "";
    wrappingModal.close();
  }
}
