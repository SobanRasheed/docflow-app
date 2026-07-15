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
          isAutoDispose: false,
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
    r'f0ffb11ae0f2bc6e3ae83ea8aa7823ce2099f2bf';

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
