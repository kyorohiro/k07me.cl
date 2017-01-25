// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

//import 'package:cl/app_component.dart';
import 'package:cl/config.dart' as config;
import 'package:cl/me_comp.dart';
import 'dart:async';
import 'login_dialog.dart';
import 'logout_dialog.dart';
import 'home_comp.dart';
import 'user_comp.dart';

@Component(
  selector: "my-app",
  directives: const [LoginDialog, UserComponent, LogoutDialog,ROUTER_DIRECTIVES],
  providers: const [ROUTER_PROVIDERS],
  template: """
  <header>
  <nav class='myul'>

  <div *ngIf='useHome==true'>
  <a class='myli' [routerLink]="['Home']">Home</a>
  </div>

  <div *ngIf='rootConfig.cookie.accessToken == ""'>
  <a class='myli' [routerLink]="['Me']">Me</a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='myli' [routerLink]="['User',{name:rootConfig.cookie.userName}]">Me</a>
  </div>

  <div *ngIf='rootConfig.cookie.accessToken == ""'>
  <a class='mylr' (click)='onLogin(myDialoga)'>Login</a>
  </div>
  <div *ngIf='rootConfig.cookie.accessToken != ""'>
  <a class='mylr' (click)='onLogout(myLogoutDialoga)'>Logout</a>
  </div>
  </nav>
  </header>
  <main style='clear:both;'>main</main>
  <br>
  <router-outlet></router-outlet>
  <hooter>hooter</hooter>

  <my-login-dialog [name]="'as'" #myDialoga>
  </my-login-dialog>
   <my-logout-dialog [name]="'as'" #myLogoutDialoga>
  </my-logout-dialog>
  """,
  styles: const ["""
  .myul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    width: 600px;
    height: 34px;
    background-color: #f1f1f1;
 #   border: 1px solid #555;
  }
  .myli {
    display: block;
    float: left;
    font-size: 16px;
    color: #000000;
    text-decoration: none;
    padding: 8px 16px;
    margine: 1px;
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
  .mylr {
    display: block;
    float: right;
    font-size: 16px;
    color: #000000;
    text-decoration: none;
    padding: 8px 16px;
    margine: 1px;
    text-align: center;
    border: 1px solid #555;
  }
  """],
)
@RouteConfig( const[
  const Route(
      path: "/",
      name: "Home",
      component: HomeComponent,
      useAsDefault: true),
  const Route(
      path: "/me",
      name: "Me",
      component: MeComponent,
      data: const {"page":"me"},
      useAsDefault: false),
  const Route(
      path: "/user",
      name: "User",
      component: UserComponent,
      useAsDefault: false),
]
)
class AppComponent {
  bool useHome = true;
  bool useMe = true;
  config.AppConfig rootConfig = config.AppConfig.inst;
  onLogin(LoginDialog d) {
    d.open();
  }
  onLogout(LogoutDialog d) {
    d.open();
  }
}