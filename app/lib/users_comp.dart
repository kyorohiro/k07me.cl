import 'package:angular2/core.dart';
import 'user_comp.dart';
import 'package:k07me.netbox/netbox.dart';

@Component(
  selector: "user-components",
  directives: const [UsersComponent],
  template: """
  <ul><li></li></ul>
  """
)
class UsersComponent {
  @Input()
  List<UserInfoProp> userInfos = [];

}