// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryItemEntity _$InventoryItemEntityFromJson(Map<String, dynamic> json) {
  return _InventoryItemEntity.fromJson(json);
}

/// @nodoc
mixin _$InventoryItemEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ItemType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this InventoryItemEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryItemEntityCopyWith<InventoryItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryItemEntityCopyWith<$Res> {
  factory $InventoryItemEntityCopyWith(
          InventoryItemEntity value, $Res Function(InventoryItemEntity) then) =
      _$InventoryItemEntityCopyWithImpl<$Res, InventoryItemEntity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      ItemType type,
      String name,
      int quantity,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$InventoryItemEntityCopyWithImpl<$Res, $Val extends InventoryItemEntity>
    implements $InventoryItemEntityCopyWith<$Res> {
  _$InventoryItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? quantity = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ItemType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryItemEntityImplCopyWith<$Res>
    implements $InventoryItemEntityCopyWith<$Res> {
  factory _$$InventoryItemEntityImplCopyWith(_$InventoryItemEntityImpl value,
          $Res Function(_$InventoryItemEntityImpl) then) =
      __$$InventoryItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      ItemType type,
      String name,
      int quantity,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$InventoryItemEntityImplCopyWithImpl<$Res>
    extends _$InventoryItemEntityCopyWithImpl<$Res, _$InventoryItemEntityImpl>
    implements _$$InventoryItemEntityImplCopyWith<$Res> {
  __$$InventoryItemEntityImplCopyWithImpl(_$InventoryItemEntityImpl _value,
      $Res Function(_$InventoryItemEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? quantity = null,
    Object? metadata = freezed,
  }) {
    return _then(_$InventoryItemEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ItemType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryItemEntityImpl extends _InventoryItemEntity {
  const _$InventoryItemEntityImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.name,
      required this.quantity,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata,
        super._();

  factory _$InventoryItemEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryItemEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final ItemType type;
  @override
  final String name;
  @override
  final int quantity;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryItemEntityImplCopyWith<_$InventoryItemEntityImpl> get copyWith =>
      __$$InventoryItemEntityImplCopyWithImpl<_$InventoryItemEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryItemEntityImplToJson(
      this,
    );
  }
}

abstract class _InventoryItemEntity extends InventoryItemEntity {
  const factory _InventoryItemEntity(
      {required final String id,
      required final String userId,
      required final ItemType type,
      required final String name,
      required final int quantity,
      final Map<String, dynamic>? metadata}) = _$InventoryItemEntityImpl;
  const _InventoryItemEntity._() : super._();

  factory _InventoryItemEntity.fromJson(Map<String, dynamic> json) =
      _$InventoryItemEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  ItemType get type;
  @override
  String get name;
  @override
  int get quantity;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of InventoryItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryItemEntityImplCopyWith<_$InventoryItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
