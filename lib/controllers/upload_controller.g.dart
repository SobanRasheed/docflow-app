// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UploadController)
final uploadControllerProvider = UploadControllerProvider._();

final class UploadControllerProvider
    extends $AsyncNotifierProvider<UploadController, UploadState> {
  UploadControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'uploadControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$uploadControllerHash();

  @$internal
  @override
  UploadController create() => UploadController();
}

String _$uploadControllerHash() => r'b5dca84106934d3a81f2d5a4fb41eb74a2494426';

abstract class _$UploadController extends $AsyncNotifier<UploadState> {
  FutureOr<UploadState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UploadState>, UploadState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UploadState>, UploadState>,
        AsyncValue<UploadState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
