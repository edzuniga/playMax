import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'active_page_provider.g.dart';

@Riverpod(keepAlive: true)
class ActivePage extends _$ActivePage {
  @override
  int build() {
    return 0;
  }

  //set page index
  void setPageIndex(int i) {
    state = i;
  }
}
