// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pathogen_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PathogenEntity _$PathogenEntityFromJson(Map<String, dynamic> json) {
  return _PathogenEntity.fromJson(json);
}

/// @nodoc
mixin _$PathogenEntity {
  String get id => throw _privateConstructorUsedError;
  PathogenType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get health => throw _privateConstructorUsedError;
  int get attack => throw _privateConstructorUsedError;
  AttackType get attackType => throw _privateConstructorUsedError;
  ResistanceType get resistanceType => throw _privateConstructorUsedError;
  PathogenRarity get rarity => throw _privateConstructorUsedError;
  double get mutationRate => throw _privateConstructorUsedError;
  List<String>? get abilities => throw _privateConstructorUsedError;

  /// Serializes this PathogenEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PathogenEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PathogenEntityCopyWith<PathogenEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathogenEntityCopyWith<$Res> {
  factory $PathogenEntityCopyWith(
          PathogenEntity value, $Res Function(PathogenEntity) then) =
      _$PathogenEntityCopyWithImpl<$Res, PathogenEntity>;
  @useResult
  $Res call(
      {String id,
      PathogenType type,
      String name,
      int health,
      int attack,
      AttackType attackType,
      ResistanceType resistanceType,
      PathogenRarity rarity,
      double mutationRate,
      List<String>? abilities});
}

/// @nodoc
class _$PathogenEntityCopyWithImpl<$Res, $Val extends PathogenEntity>
    implements $PathogenEntityCopyWith<$Res> {
  _$PathogenEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PathogenEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? health = null,
    Object? attack = null,
    Object? attackType = null,
    Object? resistanceType = null,
    Object? rarity = null,
    Object? mutationRate = null,
    Object? abilities = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PathogenType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
      attack: null == attack
          ? _value.attack
          : attack // ignore: cast_nullable_to_non_nullable
              as int,
      attackType: null == attackType
          ? _value.attackType
          : attackType // ignore: cast_nullable_to_non_nullable
              as AttackType,
      resistanceType: null == resistanceType
          ? _value.resistanceType
          : resistanceType // ignore: cast_nullable_to_non_nullable
              as ResistanceType,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as PathogenRarity,
      mutationRate: null == mutationRate
          ? _value.mutationRate
          : mutationRate // ignore: cast_nullable_to_non_nullable
              as double,
      abilities: freezed == abilities
          ? _value.abilities
          : abilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PathogenEntityImplCopyWith<$Res>
    implements $PathogenEntityCopyWith<$Res> {
  factory _$$PathogenEntityImplCopyWith(_$PathogenEntityImpl value,
          $Res Function(_$PathogenEntityImpl) then) =
      __$$PathogenEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PathogenType type,
      String name,
      int health,
      int attack,
      AttackType attackType,
      ResistanceType resistanceType,
      PathogenRarity rarity,
      double mutationRate,
      List<String>? abilities});
}

/// @nodoc
class __$$PathogenEntityImplCopyWithImpl<$Res>
    extends _$PathogenEntityCopyWithImpl<$Res, _$PathogenEntityImpl>
    implements _$$PathogenEntityImplCopyWith<$Res> {
  __$$PathogenEntityImplCopyWithImpl(
      _$PathogenEntityImpl _value, $Res Function(_$PathogenEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of PathogenEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? health = null,
    Object? attack = null,
    Object? attackType = null,
    Object? resistanceType = null,
    Object? rarity = null,
    Object? mutationRate = null,
    Object? abilities = freezed,
  }) {
    return _then(_$PathogenEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PathogenType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
      attack: null == attack
          ? _value.attack
          : attack // ignore: cast_nullable_to_non_nullable
              as int,
      attackType: null == attackType
          ? _value.attackType
          : attackType // ignore: cast_nullable_to_non_nullable
              as AttackType,
      resistanceType: null == resistanceType
          ? _value.resistanceType
          : resistanceType // ignore: cast_nullable_to_non_nullable
              as ResistanceType,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as PathogenRarity,
      mutationRate: null == mutationRate
          ? _value.mutationRate
          : mutationRate // ignore: cast_nullable_to_non_nullable
              as double,
      abilities: freezed == abilities
          ? _value._abilities
          : abilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PathogenEntityImpl extends _PathogenEntity {
  const _$PathogenEntityImpl(
      {required this.id,
      required this.type,
      required this.name,
      required this.health,
      required this.attack,
      required this.attackType,
      required this.resistanceType,
      required this.rarity,
      required this.mutationRate,
      final List<String>? abilities})
      : _abilities = abilities,
        super._();

  factory _$PathogenEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PathogenEntityImplFromJson(json);

  @override
  final String id;
  @override
  final PathogenType type;
  @override
  final String name;
  @override
  final int health;
  @override
  final int attack;
  @override
  final AttackType attackType;
  @override
  final ResistanceType resistanceType;
  @override
  final PathogenRarity rarity;
  @override
  final double mutationRate;
  final List<String>? _abilities;
  @override
  List<String>? get abilities {
    final value = _abilities;
    if (value == null) return null;
    if (_abilities is EqualUnmodifiableListView) return _abilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of PathogenEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PathogenEntityImplCopyWith<_$PathogenEntityImpl> get copyWith =>
      __$$PathogenEntityImplCopyWithImpl<_$PathogenEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PathogenEntityImplToJson(
      this,
    );
  }
}

abstract class _PathogenEntity extends PathogenEntity {
  const factory _PathogenEntity(
      {required final String id,
      required final PathogenType type,
      required final String name,
      required final int health,
      required final int attack,
      required final AttackType attackType,
      required final ResistanceType resistanceType,
      required final PathogenRarity rarity,
      required final double mutationRate,
      final List<String>? abilities}) = _$PathogenEntityImpl;
  const _PathogenEntity._() : super._();

  factory _PathogenEntity.fromJson(Map<String, dynamic> json) =
      _$PathogenEntityImpl.fromJson;

  @override
  String get id;
  @override
  PathogenType get type;
  @override
  String get name;
  @override
  int get health;
  @override
  int get attack;
  @override
  AttackType get attackType;
  @override
  ResistanceType get resistanceType;
  @override
  PathogenRarity get rarity;
  @override
  double get mutationRate;
  @override
  List<String>? get abilities;

  /// Create a copy of PathogenEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PathogenEntityImplCopyWith<_$PathogenEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
