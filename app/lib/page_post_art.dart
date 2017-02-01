// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:cl/config.dart' as config;
import 'comp_post_art.dart';

@Component(
    selector: "my-users",
    directives: const [PostArticleComponent],
    template:  """
    <div class="mybody">
    <post-article-component [artNBox]='rootConfig.appNBox.artNBox' [accessToken]='rootConfig.cookie.accessToken' [id]='id'></post-article-component>
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
class PostArticlePage implements OnInit {
  final RouteParams _routeParams;
  String id = "";
  PostArticlePage(this._routeParams){
    id = _routeParams.get("id");
  }
  config.AppConfig rootConfig = config.AppConfig.inst;

  ngOnInit() {

  }
}