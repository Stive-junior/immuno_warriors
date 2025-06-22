// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progression_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProgressionEntity _$ProgressionEntityFromJson(Map<String, dynamic> json) {
  return _ProgressionEntity.fromJson(json);
}

/// @nodoc
mixin _$ProgressionEntity {
  String get userId => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  String? get rank => throw _privateConstructorUsedError;
  List<MissionEntity> get missions => throw _privateConstructorUsedError;

  /// Serializes this ProgressionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgressionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressionEntityCopyWith<ProgressionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressionEntityCopyWith<$Res> {
  factory $ProgressionEntityCopyWith(
          ProgressionEntity value, $Res Function(ProgressionEntity) then) =
      _$ProgressionEntityCopyWithImpl<$Res, ProgressionEntity>;
  @useResult
  $Res call(
      {String userId,
      int level,
      int xp,
      String? rank,
      List<MissionEntity> missions});
}

/// @nodoc
class _$ProgressionEntityCopyWithImpl<$Res, $Val extends ProgressionEntity>
    implements $ProgressionEntityCopyWith<$Res> {
  _$ProgressionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? level = null,
    Object? xp = null,
    Object? rank = freezed,
    Object? missions = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String?,
      missions: null == missions
          ? _value.missions
          : missions // ignore: cast_nullable_to_non_nullable
              as List<MissionEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressionEntityImplCopyWith<$Res>
    implements $ProgressionEntityCopyWith<$Res> {
  factory _$$ProgressionEntityImplCopyWith(_$ProgressionEntityImpl value,
          $Res Function(_$ProgressionEntityImpl) then) =
      __$$ProgressionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int level,
      int xp,
      String? rank,
      List<MissionEntity> missions});
}

/// @nodoc
class __$$ProgressionEntityImplCopyWithImpl<$Res>
    extends _$ProgressionEntityCopyWithImpl<$Res, _$ProgressionEntityImpl>
    implements _$$ProgressionEntityImplCopyWith<$Res> {
  __$$ProgressionEntityImplCopyWithImpl(_$ProgressionEntityImpl _value,
      $Res Function(_$ProgressionEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProgressionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? level = null,
    Object? xp = null,
    Object? rank = freezed,
    Object? missions = null,
  }) {
    return _then(_$ProgressionEntityImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String?,
      missions: null == missions
          ? _value._missions
          : missions // ignore: cast_nullable_to_non_nullable
              as List<MissionEntity>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressionEntityImpl extends _ProgressionEntity {
  const _$ProgressionEntityImpl(
      {required this.userId,
      required this.level,
      required this.xp,
      this.rank,
      required final List<MissionEntity> missions})
      : _missions = missions,
        super._();

  factory _$ProgressionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressionEntityImplFromJson(json);

  @override
  final String userId;
  @override
  final int level;
  @override
  final int xp;
  @override
  final String? rank;
  final List<MissionEntity> _missions;
  @override
  List<MissionEntity> get missions {
    if (_missions is EqualUnmodifiableListView) return _missions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missions);
  }

  /// Create a copy of ProgressionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressionEntityImplCopyWith<_$ProgressionEntityImpl> get copyWith =>
      __$$ProgressionEntityImplCopyWithImpl<_$ProgressionEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressionEntityImplToJson(
      this,
    );
  }
}

abstract class _ProgressionEntity extends ProgressionEntity {
  const factory _ProgressionEntity(
      {required final String userId,
      required final int level,
      required final int xp,
      final String? rank,
      required final List<MissionEntity> missions}) = _$ProgressionEntityImpl;
  const _ProgressionEntity._() : super._();

  factory _ProgressionEntity.fromJson(Map<String, dynamic> json) =
      _$ProgressionEntityImpl.fromJson;

  @override
  String get userId;
  @override
  int get level;
  @override
  int get xp;
  @override
  String? get rank;
  @override
  List<MissionEntity> get missions;

  /// Create a copy of ProgressionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressionEntityImplCopyWith<_$ProgressionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissionEntity _$MissionEntityFromJson(Map<String, dynamic> json) {
  return _MissionEntity.fromJson(json);
}

/// @nodoc
mixin _$MissionEntity {
  String get id => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;

  /// Serializes this MissionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MissionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionEntityCopyWith<MissionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionEntityCopyWith<$Res> {
  factory $MissionEntityCopyWith(
          MissionEntity value, $Res Function(MissionEntity) then) =
      _$MissionEntityCopyWithImpl<$Res, MissionEntity>;
  @useResult
  $Res call({String id, bool completed});
}

/// @nodoc
class _$MissionEntityCopyWithImpl<$Res, $Val extends MissionEntity>
    implements $MissionEntityCopyWith<$Res> {
  _$MissionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MissionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? completed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionEntityImplCopyWith<$Res>
    implements $MissionEntityCopyWith<$Res> {
  factory _$$MissionEntityImplCopyWith(
          _$MissionEntityImpl value, $Res Function(_$MissionEntityImpl) then) =
      __$$MissionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, bool completed});
}

/// @nodoc
class __$$MissionEntityImplCopyWithImpl<$Res>
    extends _$MissionEntityCopyWithImpl<$Res, _$MissionEntityImpl>
    implements _$$MissionEntityImplCopyWith<$Res> {
  __$$MissionEntityImplCopyWithImpl(
      _$MissionEntityImpl _value, $Res Function(_$MissionEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of MissionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? completed = null,
  }) {
    return _then(_$MissionEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionEntityImpl extends _MissionEntity {
  const _$MissionEntityImpl({required this.id, required this.completed})
      : super._();

  factory _$MissionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionEntityImplFromJson(json);

  @override
  final String id;
  @override
  final bool completed;

  /// Create a copy of MissionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionEntityImplCopyWith<_$MissionEntityImpl> get copyWith =>
      __$$MissionEntityImplCopyWithImpl<_$MissionEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionEntityImplToJson(
      this,
    );
  }
}

abstract class _MissionEntity extends MissionEntity {
  const factory _MissionEntity(
      {required final String id,
      required final bool completed}) = _$MissionEntityImpl;
  const _MissionEntity._() : super._();

  factory _MissionEntity.fromJson(Map<String, dynamic> json) =
      _$MissionEntityImpl.fromJson;

  @override
  String get id;
  @override
  bool get completed;

  /// Create a copy of MissionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionEntityImplCopyWith<_$MissionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
