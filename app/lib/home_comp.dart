// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;


@Component(
    selector: "myhome",
    template:  """
    <div class="mybody">
    <h1>Home</h1>
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
    if(_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}
