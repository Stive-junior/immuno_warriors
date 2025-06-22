// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaderboardEntity _$LeaderboardEntityFromJson(Map<String, dynamic> json) {
  return _LeaderboardEntity.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntity {
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntityCopyWith<LeaderboardEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntityCopyWith<$Res> {
  factory $LeaderboardEntityCopyWith(
          LeaderboardEntity value, $Res Function(LeaderboardEntity) then) =
      _$LeaderboardEntityCopyWithImpl<$Res, LeaderboardEntity>;
  @useResult
  $Res call(
      {String userId,
      String username,
      int score,
      int rank,
      DateTime? lastUpdated});
}

/// @nodoc
class _$LeaderboardEntityCopyWithImpl<$Res, $Val extends LeaderboardEntity>
    implements $LeaderboardEntityCopyWith<$Res> {
  _$LeaderboardEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? score = null,
    Object? rank = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaderboardEntityImplCopyWith<$Res>
    implements $LeaderboardEntityCopyWith<$Res> {
  factory _$$LeaderboardEntityImplCopyWith(_$LeaderboardEntityImpl value,
          $Res Function(_$LeaderboardEntityImpl) then) =
      __$$LeaderboardEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String username,
      int score,
      int rank,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$LeaderboardEntityImplCopyWithImpl<$Res>
    extends _$LeaderboardEntityCopyWithImpl<$Res, _$LeaderboardEntityImpl>
    implements _$$LeaderboardEntityImplCopyWith<$Res> {
  __$$LeaderboardEntityImplCopyWithImpl(_$LeaderboardEntityImpl _value,
      $Res Function(_$LeaderboardEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeaderboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? score = null,
    Object? rank = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$LeaderboardEntityImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardEntityImpl extends _LeaderboardEntity {
  const _$LeaderboardEntityImpl(
      {required this.userId,
      required this.username,
      required this.score,
      required this.rank,
      this.lastUpdated})
      : super._();

  factory _$LeaderboardEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntityImplFromJson(json);

  @override
  final String userId;
  @override
  final String username;
  @override
  final int score;
  @override
  final int rank;
  @override
  final DateTime? lastUpdated;

  /// Create a copy of LeaderboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntityImplCopyWith<_$LeaderboardEntityImpl> get copyWith =>
      __$$LeaderboardEntityImplCopyWithImpl<_$LeaderboardEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntityImplToJson(
      this,
    );
  }
}

abstract class _LeaderboardEntity extends LeaderboardEntity {
  const factory _LeaderboardEntity(
      {required final String userId,
      required final String username,
      required final int score,
      required final int rank,
      final DateTime? lastUpdated}) = _$LeaderboardEntityImpl;
  const _LeaderboardEntity._() : super._();

  factory _LeaderboardEntity.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntityImpl.fromJson;

  @override
  String get userId;
  @override
  String get username;
  @override
  int get score;
  @override
  int get rank;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of LeaderboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntityImplCopyWith<_$LeaderboardEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
