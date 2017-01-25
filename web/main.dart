// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

//import 'package:cl/app_component.dart';
import 'config.dart' as config;

class Param {
 static Param instance = new Param();
}

class Item {
  String id;
  String path;
  String label;
  String name;
  Item(this.id,this.path, this.name, this.label);
}

main() {
  bootstrap(AppComponent);
}

@Component(
  selector: "my-app",
  directives: const [ROUTER_DIRECTIVES],
  providers: const [ROUTER_PROVIDERS],
  template: """
  <header>
  <ul class='myul'>
  <li *ngFor='let item of items'><a class='myli' [routerLink]="[item.name]">{{item.label}}</a></li></ul>
  </header>
  <main style='clear:both;'>main</main>
  <br>
  <router-outlet></router-outlet>
  <hooter>hooter</hooter>
  """,
  styles: const ["""
  .myul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    width: 200px;
    background-color: #f1f1f1;
    border: 1px solid #555;
  }
  .myli {
    display: block;
    float: left;
    color: #000000;
    text-decoration: none;
    padding: 8px 16px;
    text-align: center;
        border: 1px solid #555;
  }
  .myli .selected {
    background-color: #4CAF50;
    color: white;
  }
  .myli:hover {
    background-color: #555;
    color: white;
  }
  """],
)
@RouteConfig( const[
  const Route(
  path: "/",
  name: "Home",
  component: HomeComponent,
  useAsDefault: true)]
)
class AppComponent {
  List<Item> items = [
    new Item("0","/home","Home","Home"),
    new Item("0","/me","Home","Me"),
  ];


}

@Component(
  selector: "mybody",
  template:  """
    <div class="mybody">
    <h1>Login</h1>
    <div *ngIf='rootConfig.cookie.accessToken != ""'>
    <a href='{{twitterLoginUrl}}'>use Twitter</a>
    </div>
    <div *ngIf='rootConfig.cookie.accessToken == ""'>
    <span>Logined</span>
    </div>
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
class HomeComponent implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;
  HomeComponent(this._routeParams);
  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {
   twitterLoginUrl =  config.AppConfig.inst.twitterLoginUrl;
   print(_routeParams.params.toString());
   if(_routeParams.params["isMaster"] != "") {
     config.AppConfig.inst.cookie.accessToken = _routeParams.params["token"];
     config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
     config.AppConfig.inst.cookie.userName = _routeParams.params["userName"];
   }
  }
}
