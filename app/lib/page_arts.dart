// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_users.dart';
import 'comp_post_art.dart';

@Component(
    selector: "my-arts",
    directives: const [UsersComponent],
    template:  """
    <div class="mybody">
    <h1>Users</h1>
    <user-components [userNBox]='rootConfig.appNBox.userNBox'></user-components>
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
class ArtsPage implements OnInit {
  String twitterLoginUrl = "";
  final RouteParams _routeParams;
  ArtsPage(this._routeParams);
  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {

    twitterLoginUrl =  config.AppConfig.inst.twitterLoginUrl;
    print(_routeParams.params.toString());
    if(_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}
