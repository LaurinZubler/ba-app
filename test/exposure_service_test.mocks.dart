// Mocks generated by Mockito 5.4.4 from annotations
// in ba_app/test/exposure_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:ba_app/domain/exposure/exposure_model.dart' as _i4;
import 'package:ba_app/infrastructure/exposure_repository.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ExposureRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockExposureRepository extends _i1.Mock
    implements _i2.ExposureRepository {
  MockExposureRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Exposure>> getAll() => (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Exposure>>.value(<_i4.Exposure>[]),
      ) as _i3.Future<List<_i4.Exposure>>);

  @override
  _i3.Future<void> save(_i4.Exposure? exposure) => (super.noSuchMethod(
        Invocation.method(
          #save,
          [exposure],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
