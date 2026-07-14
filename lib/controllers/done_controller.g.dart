// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'done_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DoneController)
final doneControllerProvider = DoneControllerProvider._();

final class DoneControllerProvider
    extends $AsyncNotifierProvider<DoneController, DoneState> {
  DoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doneControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doneControllerHash();

  @$internal
  @override
  DoneController create() => DoneController();
}

String _$doneControllerHash() => r'5fb1964c29d44bc53f06eaf46e063b0a363c5a23';

abstract class _$DoneController extends $AsyncNotifier<DoneState> {
  FutureOr<DoneState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DoneState>, DoneState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DoneState>, DoneState>,
              AsyncValue<DoneState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
