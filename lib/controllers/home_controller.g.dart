// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeController)
final homeControllerProvider = HomeControllerProvider._();

final class HomeControllerProvider
    extends $AsyncNotifierProvider<HomeController, List<ToolType>> {
  HomeControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeControllerHash();

  @$internal
  @override
  HomeController create() => HomeController();
}

String _$homeControllerHash() => r'd6ccaca4885a1e021c410d041927ab3935569316';

abstract class _$HomeController extends $AsyncNotifier<List<ToolType>> {
  FutureOr<List<ToolType>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<ToolType>>, List<ToolType>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ToolType>>, List<ToolType>>,
        AsyncValue<List<ToolType>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
