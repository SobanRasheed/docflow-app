import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/tool_type.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends AsyncNotifier<List<ToolType>> {
  @override
  Future<List<ToolType>> build() async => ToolType.all;
}