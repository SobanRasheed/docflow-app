// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilesController)
final filesControllerProvider = FilesControllerProvider._();

final class FilesControllerProvider
    extends
        $AsyncNotifierProvider<FilesController, List<ConversionHistoryItem>> {
  FilesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filesControllerHash();

  @$internal
  @override
  FilesController create() => FilesController();
}

String _$filesControllerHash() => r'6a1f59fc18da739b3e89a01022708484bdbdd904';

abstract class _$FilesController
    extends $AsyncNotifier<List<ConversionHistoryItem>> {
  FutureOr<List<ConversionHistoryItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ConversionHistoryItem>>,
              List<ConversionHistoryItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ConversionHistoryItem>>,
                List<ConversionHistoryItem>
              >,
              AsyncValue<List<ConversionHistoryItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
