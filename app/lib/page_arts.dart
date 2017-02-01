// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_users.dart';
import 'package:k07me.netbox/netbox.dart';
import 'comp_article.dart';

@Component(
    selector: "my-arts",
    directives: const [ArticleComponent],
    template:  """
    <div class="mybody">
    <h1>Articles</h1>
    <div *ngFor='let artInfo of artInfos'>
        <art-component [userNBox]='rootConfig.appNBox.userNBox' [artInfo]='artInfo'></art-component>
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
class ArtsPage implements OnInit {
  final RouteParams _routeParams;
  ArtsPage(this._routeParams);
  config.AppConfig rootConfig = config.AppConfig.inst;

  List<ArtInfoProp> artInfos = [];

  ngOnInit() {
    updateConfig();
    update();
  }

  update() async {
    ArtNBox artnBox = rootConfig.appNBox.artNBox;
    ArtKeyListProp list = await artnBox.findArticle("");
    for(String key in list.keys) {
      ArtInfoProp artInfo = await artnBox.getArtFromStringId(key);
      artInfos.add(artInfo);
    }
  }

  updateConfig(){
    print(_routeParams.params.toString());
    if(_routeParams.params.containsKey("token")) {
      config.AppConfig.inst.cookie.accessToken = Uri.decodeFull(_routeParams.params["token"]);
      config.AppConfig.inst.cookie.setIsMaster(_routeParams.params["isMaster"]);
      config.AppConfig.inst.cookie.userName = Uri.decodeFull(_routeParams.params["userName"]);
    }
  }
}
