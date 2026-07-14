// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProgressController)
final progressControllerProvider = ProgressControllerProvider._();

final class ProgressControllerProvider
    extends $AsyncNotifierProvider<ProgressController, ConversionState> {
  ProgressControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'progressControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$progressControllerHash();

  @$internal
  @override
  ProgressController create() => ProgressController();
}

String _$progressControllerHash() =>
    r'57bc45d51ba639491f6b893a3bb368554c261eaf';

abstract class _$ProgressController extends $AsyncNotifier<ConversionState> {
  FutureOr<ConversionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ConversionState>, ConversionState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ConversionState>, ConversionState>,
        AsyncValue<ConversionState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
