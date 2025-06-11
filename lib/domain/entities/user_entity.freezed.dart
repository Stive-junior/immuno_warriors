// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return _UserEntity.fromJson(json);
}

/// @nodoc
mixin _$UserEntity {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatarUrl')
  String? get avatar => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  Map<String, dynamic>? get resources => throw _privateConstructorUsedError;
  Map<String, dynamic>? get progression => throw _privateConstructorUsedError;
  Map<String, bool>? get achievements => throw _privateConstructorUsedError;
  List<dynamic>? get inventory => throw _privateConstructorUsedError;

  /// Serializes this UserEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
          UserEntity value, $Res Function(UserEntity) then) =
      _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? username,
      @JsonKey(name: 'avatarUrl') String? avatar,
      DateTime? createdAt,
      DateTime? lastLogin,
      Map<String, dynamic>? resources,
      Map<String, dynamic>? progression,
      Map<String, bool>? achievements,
      List<dynamic>? inventory});
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = freezed,
    Object? avatar = freezed,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? resources = freezed,
    Object? progression = freezed,
    Object? achievements = freezed,
    Object? inventory = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resources: freezed == resources
          ? _value.resources
          : resources // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      progression: freezed == progression
          ? _value.progression
          : progression // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      achievements: freezed == achievements
          ? _value.achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>?,
      inventory: freezed == inventory
          ? _value.inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserEntityImplCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$UserEntityImplCopyWith(
          _$UserEntityImpl value, $Res Function(_$UserEntityImpl) then) =
      __$$UserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? username,
      @JsonKey(name: 'avatarUrl') String? avatar,
      DateTime? createdAt,
      DateTime? lastLogin,
      Map<String, dynamic>? resources,
      Map<String, dynamic>? progression,
      Map<String, bool>? achievements,
      List<dynamic>? inventory});
}

/// @nodoc
class __$$UserEntityImplCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$UserEntityImpl>
    implements _$$UserEntityImplCopyWith<$Res> {
  __$$UserEntityImplCopyWithImpl(
      _$UserEntityImpl _value, $Res Function(_$UserEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = freezed,
    Object? avatar = freezed,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? resources = freezed,
    Object? progression = freezed,
    Object? achievements = freezed,
    Object? inventory = freezed,
  }) {
    return _then(_$UserEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resources: freezed == resources
          ? _value._resources
          : resources // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      progression: freezed == progression
          ? _value._progression
          : progression // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      achievements: freezed == achievements
          ? _value._achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>?,
      inventory: freezed == inventory
          ? _value._inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserEntityImpl extends _UserEntity {
  const _$UserEntityImpl(
      {required this.id,
      required this.email,
      this.username,
      @JsonKey(name: 'avatarUrl') this.avatar,
      this.createdAt,
      this.lastLogin,
      final Map<String, dynamic>? resources,
      final Map<String, dynamic>? progression,
      final Map<String, bool>? achievements,
      final List<dynamic>? inventory})
      : _resources = resources,
        _progression = progression,
        _achievements = achievements,
        _inventory = inventory,
        super._();

  factory _$UserEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? username;
  @override
  @JsonKey(name: 'avatarUrl')
  final String? avatar;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastLogin;
  final Map<String, dynamic>? _resources;
  @override
  Map<String, dynamic>? get resources {
    final value = _resources;
    if (value == null) return null;
    if (_resources is EqualUnmodifiableMapView) return _resources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _progression;
  @override
  Map<String, dynamic>? get progression {
    final value = _progression;
    if (value == null) return null;
    if (_progression is EqualUnmodifiableMapView) return _progression;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, bool>? _achievements;
  @override
  Map<String, bool>? get achievements {
    final value = _achievements;
    if (value == null) return null;
    if (_achievements is EqualUnmodifiableMapView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<dynamic>? _inventory;
  @override
  List<dynamic>? get inventory {
    final value = _inventory;
    if (value == null) return null;
    if (_inventory is EqualUnmodifiableListView) return _inventory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      __$$UserEntityImplCopyWithImpl<_$UserEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserEntityImplToJson(
      this,
    );
  }
}

abstract class _UserEntity extends UserEntity {
  const factory _UserEntity(
      {required final String id,
      required final String email,
      final String? username,
      @JsonKey(name: 'avatarUrl') final String? avatar,
      final DateTime? createdAt,
      final DateTime? lastLogin,
      final Map<String, dynamic>? resources,
      final Map<String, dynamic>? progression,
      final Map<String, bool>? achievements,
      final List<dynamic>? inventory}) = _$UserEntityImpl;
  const _UserEntity._() : super._();

  factory _UserEntity.fromJson(Map<String, dynamic> json) =
      _$UserEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get username;
  @override
  @JsonKey(name: 'avatarUrl')
  String? get avatar;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastLogin;
  @override
  Map<String, dynamic>? get resources;
  @override
  Map<String, dynamic>? get progression;
  @override
  Map<String, bool>? get achievements;
  @override
  List<dynamic>? get inventory;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
