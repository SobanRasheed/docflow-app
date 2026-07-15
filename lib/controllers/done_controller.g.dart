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
    extends $NotifierProvider<DoneController, DoneState> {
  DoneControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'doneControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$doneControllerHash();

  @$internal
  @override
  DoneController create() => DoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DoneState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DoneState>(value),
    );
  }
}

String _$doneControllerHash() => r'9e0acafead4525eb4c4199c4bc1c519d9f0737cf';

abstract class _$DoneController extends $Notifier<DoneState> {
  DoneState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DoneState, DoneState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DoneState, DoneState>, DoneState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
