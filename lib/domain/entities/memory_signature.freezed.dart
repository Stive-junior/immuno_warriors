// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_signature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MemorySignature _$MemorySignatureFromJson(Map<String, dynamic> json) {
  return _MemorySignature.fromJson(json);
}

/// @nodoc
mixin _$MemorySignature {
  String get pathogenType => throw _privateConstructorUsedError;
  int get attackBonus => throw _privateConstructorUsedError;
  int get defenseBonus => throw _privateConstructorUsedError;
  String get expiryDate => throw _privateConstructorUsedError;

  /// Serializes this MemorySignature to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemorySignature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemorySignatureCopyWith<MemorySignature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemorySignatureCopyWith<$Res> {
  factory $MemorySignatureCopyWith(
          MemorySignature value, $Res Function(MemorySignature) then) =
      _$MemorySignatureCopyWithImpl<$Res, MemorySignature>;
  @useResult
  $Res call(
      {String pathogenType,
      int attackBonus,
      int defenseBonus,
      String expiryDate});
}

/// @nodoc
class _$MemorySignatureCopyWithImpl<$Res, $Val extends MemorySignature>
    implements $MemorySignatureCopyWith<$Res> {
  _$MemorySignatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemorySignature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathogenType = null,
    Object? attackBonus = null,
    Object? defenseBonus = null,
    Object? expiryDate = null,
  }) {
    return _then(_value.copyWith(
      pathogenType: null == pathogenType
          ? _value.pathogenType
          : pathogenType // ignore: cast_nullable_to_non_nullable
              as String,
      attackBonus: null == attackBonus
          ? _value.attackBonus
          : attackBonus // ignore: cast_nullable_to_non_nullable
              as int,
      defenseBonus: null == defenseBonus
          ? _value.defenseBonus
          : defenseBonus // ignore: cast_nullable_to_non_nullable
              as int,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemorySignatureImplCopyWith<$Res>
    implements $MemorySignatureCopyWith<$Res> {
  factory _$$MemorySignatureImplCopyWith(_$MemorySignatureImpl value,
          $Res Function(_$MemorySignatureImpl) then) =
      __$$MemorySignatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String pathogenType,
      int attackBonus,
      int defenseBonus,
      String expiryDate});
}

/// @nodoc
class __$$MemorySignatureImplCopyWithImpl<$Res>
    extends _$MemorySignatureCopyWithImpl<$Res, _$MemorySignatureImpl>
    implements _$$MemorySignatureImplCopyWith<$Res> {
  __$$MemorySignatureImplCopyWithImpl(
      _$MemorySignatureImpl _value, $Res Function(_$MemorySignatureImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemorySignature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathogenType = null,
    Object? attackBonus = null,
    Object? defenseBonus = null,
    Object? expiryDate = null,
  }) {
    return _then(_$MemorySignatureImpl(
      pathogenType: null == pathogenType
          ? _value.pathogenType
          : pathogenType // ignore: cast_nullable_to_non_nullable
              as String,
      attackBonus: null == attackBonus
          ? _value.attackBonus
          : attackBonus // ignore: cast_nullable_to_non_nullable
              as int,
      defenseBonus: null == defenseBonus
          ? _value.defenseBonus
          : defenseBonus // ignore: cast_nullable_to_non_nullable
              as int,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemorySignatureImpl extends _MemorySignature {
  const _$MemorySignatureImpl(
      {required this.pathogenType,
      required this.attackBonus,
      required this.defenseBonus,
      required this.expiryDate})
      : super._();

  factory _$MemorySignatureImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemorySignatureImplFromJson(json);

  @override
  final String pathogenType;
  @override
  final int attackBonus;
  @override
  final int defenseBonus;
  @override
  final String expiryDate;

  /// Create a copy of MemorySignature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemorySignatureImplCopyWith<_$MemorySignatureImpl> get copyWith =>
      __$$MemorySignatureImplCopyWithImpl<_$MemorySignatureImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemorySignatureImplToJson(
      this,
    );
  }
}

abstract class _MemorySignature extends MemorySignature {
  const factory _MemorySignature(
      {required final String pathogenType,
      required final int attackBonus,
      required final int defenseBonus,
      required final String expiryDate}) = _$MemorySignatureImpl;
  const _MemorySignature._() : super._();

  factory _MemorySignature.fromJson(Map<String, dynamic> json) =
      _$MemorySignatureImpl.fromJson;

  @override
  String get pathogenType;
  @override
  int get attackBonus;
  @override
  int get defenseBonus;
  @override
  String get expiryDate;

  /// Create a copy of MemorySignature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemorySignatureImplCopyWith<_$MemorySignatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
