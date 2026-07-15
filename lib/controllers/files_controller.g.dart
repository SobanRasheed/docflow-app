// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilesController)
final filesControllerProvider = FilesControllerProvider._();

final class FilesControllerProvider extends $AsyncNotifierProvider<
    FilesController, List<ConversionHistoryItem>> {
  FilesControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filesControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filesControllerHash();

  @$internal
  @override
  FilesController create() => FilesController();
}

String _$filesControllerHash() => r'858b3d08e70e412fbd6f4ece31c903699b1b9313';

abstract class _$FilesController
    extends $AsyncNotifier<List<ConversionHistoryItem>> {
  FutureOr<List<ConversionHistoryItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<ConversionHistoryItem>>,
        List<ConversionHistoryItem>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ConversionHistoryItem>>,
            List<ConversionHistoryItem>>,
        AsyncValue<List<ConversionHistoryItem>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
