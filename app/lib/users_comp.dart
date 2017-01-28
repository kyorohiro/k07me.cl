import 'package:angular2/core.dart';
import 'user_page.dart';

@Component(
  directives: const [UserPage],
  template: """
  <ul>
  <li *ngFor='lot user in users'></li>
  </ul>
  """,
)
class UsersComponent implements OnInit {
  ngOnInit() {
    ;
  }
}