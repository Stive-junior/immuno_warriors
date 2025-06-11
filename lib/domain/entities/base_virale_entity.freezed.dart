// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_virale_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseViraleEntity _$BaseViraleEntityFromJson(Map<String, dynamic> json) {
  return _BaseViraleEntity.fromJson(json);
}

/// @nodoc
mixin _$BaseViraleEntity {
  String get id => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  List<PathogenEntity> get pathogens => throw _privateConstructorUsedError;
  Map<DefenseType, int> get defenses => throw _privateConstructorUsedError;

  /// Serializes this BaseViraleEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseViraleEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseViraleEntityCopyWith<BaseViraleEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseViraleEntityCopyWith<$Res> {
  factory $BaseViraleEntityCopyWith(
          BaseViraleEntity value, $Res Function(BaseViraleEntity) then) =
      _$BaseViraleEntityCopyWithImpl<$Res, BaseViraleEntity>;
  @useResult
  $Res call(
      {String id,
      String playerId,
      String name,
      int level,
      List<PathogenEntity> pathogens,
      Map<DefenseType, int> defenses});
}

/// @nodoc
class _$BaseViraleEntityCopyWithImpl<$Res, $Val extends BaseViraleEntity>
    implements $BaseViraleEntityCopyWith<$Res> {
  _$BaseViraleEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseViraleEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? name = null,
    Object? level = null,
    Object? pathogens = null,
    Object? defenses = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      pathogens: null == pathogens
          ? _value.pathogens
          : pathogens // ignore: cast_nullable_to_non_nullable
              as List<PathogenEntity>,
      defenses: null == defenses
          ? _value.defenses
          : defenses // ignore: cast_nullable_to_non_nullable
              as Map<DefenseType, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseViraleEntityImplCopyWith<$Res>
    implements $BaseViraleEntityCopyWith<$Res> {
  factory _$$BaseViraleEntityImplCopyWith(_$BaseViraleEntityImpl value,
          $Res Function(_$BaseViraleEntityImpl) then) =
      __$$BaseViraleEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String playerId,
      String name,
      int level,
      List<PathogenEntity> pathogens,
      Map<DefenseType, int> defenses});
}

/// @nodoc
class __$$BaseViraleEntityImplCopyWithImpl<$Res>
    extends _$BaseViraleEntityCopyWithImpl<$Res, _$BaseViraleEntityImpl>
    implements _$$BaseViraleEntityImplCopyWith<$Res> {
  __$$BaseViraleEntityImplCopyWithImpl(_$BaseViraleEntityImpl _value,
      $Res Function(_$BaseViraleEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseViraleEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? name = null,
    Object? level = null,
    Object? pathogens = null,
    Object? defenses = null,
  }) {
    return _then(_$BaseViraleEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      pathogens: null == pathogens
          ? _value._pathogens
          : pathogens // ignore: cast_nullable_to_non_nullable
              as List<PathogenEntity>,
      defenses: null == defenses
          ? _value._defenses
          : defenses // ignore: cast_nullable_to_non_nullable
              as Map<DefenseType, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BaseViraleEntityImpl extends _BaseViraleEntity {
  const _$BaseViraleEntityImpl(
      {required this.id,
      required this.playerId,
      required this.name,
      required this.level,
      required final List<PathogenEntity> pathogens,
      required final Map<DefenseType, int> defenses})
      : _pathogens = pathogens,
        _defenses = defenses,
        super._();

  factory _$BaseViraleEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaseViraleEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String playerId;
  @override
  final String name;
  @override
  final int level;
  final List<PathogenEntity> _pathogens;
  @override
  List<PathogenEntity> get pathogens {
    if (_pathogens is EqualUnmodifiableListView) return _pathogens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pathogens);
  }

  final Map<DefenseType, int> _defenses;
  @override
  Map<DefenseType, int> get defenses {
    if (_defenses is EqualUnmodifiableMapView) return _defenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_defenses);
  }

  /// Create a copy of BaseViraleEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseViraleEntityImplCopyWith<_$BaseViraleEntityImpl> get copyWith =>
      __$$BaseViraleEntityImplCopyWithImpl<_$BaseViraleEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaseViraleEntityImplToJson(
      this,
    );
  }
}

abstract class _BaseViraleEntity extends BaseViraleEntity {
  const factory _BaseViraleEntity(
      {required final String id,
      required final String playerId,
      required final String name,
      required final int level,
      required final List<PathogenEntity> pathogens,
      required final Map<DefenseType, int> defenses}) = _$BaseViraleEntityImpl;
  const _BaseViraleEntity._() : super._();

  factory _BaseViraleEntity.fromJson(Map<String, dynamic> json) =
      _$BaseViraleEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get playerId;
  @override
  String get name;
  @override
  int get level;
  @override
  List<PathogenEntity> get pathogens;
  @override
  Map<DefenseType, int> get defenses;

  /// Create a copy of BaseViraleEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseViraleEntityImplCopyWith<_$BaseViraleEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
