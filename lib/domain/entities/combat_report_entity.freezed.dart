// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combat_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CombatReportEntity _$CombatReportEntityFromJson(Map<String, dynamic> json) {
  return _CombatReportEntity.fromJson(json);
}

/// @nodoc
mixin _$CombatReportEntity {
  String get combatId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  @combatResultConverter
  CombatResult get result => throw _privateConstructorUsedError;
  List<String> get log => throw _privateConstructorUsedError;
  int get damageDealt => throw _privateConstructorUsedError;
  int get damageTaken => throw _privateConstructorUsedError;
  List<String> get unitsDeployed => throw _privateConstructorUsedError;
  List<String> get unitsLost => throw _privateConstructorUsedError;
  String get baseId => throw _privateConstructorUsedError;
  List<AntibodyEntity>? get antibodiesUsed =>
      throw _privateConstructorUsedError;
  PathogenEntity? get pathogenFought => throw _privateConstructorUsedError;

  /// Serializes this CombatReportEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CombatReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CombatReportEntityCopyWith<CombatReportEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CombatReportEntityCopyWith<$Res> {
  factory $CombatReportEntityCopyWith(
          CombatReportEntity value, $Res Function(CombatReportEntity) then) =
      _$CombatReportEntityCopyWithImpl<$Res, CombatReportEntity>;
  @useResult
  $Res call(
      {String combatId,
      DateTime date,
      @combatResultConverter CombatResult result,
      List<String> log,
      int damageDealt,
      int damageTaken,
      List<String> unitsDeployed,
      List<String> unitsLost,
      String baseId,
      List<AntibodyEntity>? antibodiesUsed,
      PathogenEntity? pathogenFought});

  $PathogenEntityCopyWith<$Res>? get pathogenFought;
}

/// @nodoc
class _$CombatReportEntityCopyWithImpl<$Res, $Val extends CombatReportEntity>
    implements $CombatReportEntityCopyWith<$Res> {
  _$CombatReportEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CombatReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? combatId = null,
    Object? date = null,
    Object? result = null,
    Object? log = null,
    Object? damageDealt = null,
    Object? damageTaken = null,
    Object? unitsDeployed = null,
    Object? unitsLost = null,
    Object? baseId = null,
    Object? antibodiesUsed = freezed,
    Object? pathogenFought = freezed,
  }) {
    return _then(_value.copyWith(
      combatId: null == combatId
          ? _value.combatId
          : combatId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as CombatResult,
      log: null == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as List<String>,
      damageDealt: null == damageDealt
          ? _value.damageDealt
          : damageDealt // ignore: cast_nullable_to_non_nullable
              as int,
      damageTaken: null == damageTaken
          ? _value.damageTaken
          : damageTaken // ignore: cast_nullable_to_non_nullable
              as int,
      unitsDeployed: null == unitsDeployed
          ? _value.unitsDeployed
          : unitsDeployed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unitsLost: null == unitsLost
          ? _value.unitsLost
          : unitsLost // ignore: cast_nullable_to_non_nullable
              as List<String>,
      baseId: null == baseId
          ? _value.baseId
          : baseId // ignore: cast_nullable_to_non_nullable
              as String,
      antibodiesUsed: freezed == antibodiesUsed
          ? _value.antibodiesUsed
          : antibodiesUsed // ignore: cast_nullable_to_non_nullable
              as List<AntibodyEntity>?,
      pathogenFought: freezed == pathogenFought
          ? _value.pathogenFought
          : pathogenFought // ignore: cast_nullable_to_non_nullable
              as PathogenEntity?,
    ) as $Val);
  }

  /// Create a copy of CombatReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PathogenEntityCopyWith<$Res>? get pathogenFought {
    if (_value.pathogenFought == null) {
      return null;
    }

    return $PathogenEntityCopyWith<$Res>(_value.pathogenFought!, (value) {
      return _then(_value.copyWith(pathogenFought: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CombatReportEntityImplCopyWith<$Res>
    implements $CombatReportEntityCopyWith<$Res> {
  factory _$$CombatReportEntityImplCopyWith(_$CombatReportEntityImpl value,
          $Res Function(_$CombatReportEntityImpl) then) =
      __$$CombatReportEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String combatId,
      DateTime date,
      @combatResultConverter CombatResult result,
      List<String> log,
      int damageDealt,
      int damageTaken,
      List<String> unitsDeployed,
      List<String> unitsLost,
      String baseId,
      List<AntibodyEntity>? antibodiesUsed,
      PathogenEntity? pathogenFought});

  @override
  $PathogenEntityCopyWith<$Res>? get pathogenFought;
}

/// @nodoc
class __$$CombatReportEntityImplCopyWithImpl<$Res>
    extends _$CombatReportEntityCopyWithImpl<$Res, _$CombatReportEntityImpl>
    implements _$$CombatReportEntityImplCopyWith<$Res> {
  __$$CombatReportEntityImplCopyWithImpl(_$CombatReportEntityImpl _value,
      $Res Function(_$CombatReportEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CombatReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? combatId = null,
    Object? date = null,
    Object? result = null,
    Object? log = null,
    Object? damageDealt = null,
    Object? damageTaken = null,
    Object? unitsDeployed = null,
    Object? unitsLost = null,
    Object? baseId = null,
    Object? antibodiesUsed = freezed,
    Object? pathogenFought = freezed,
  }) {
    return _then(_$CombatReportEntityImpl(
      combatId: null == combatId
          ? _value.combatId
          : combatId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as CombatResult,
      log: null == log
          ? _value._log
          : log // ignore: cast_nullable_to_non_nullable
              as List<String>,
      damageDealt: null == damageDealt
          ? _value.damageDealt
          : damageDealt // ignore: cast_nullable_to_non_nullable
              as int,
      damageTaken: null == damageTaken
          ? _value.damageTaken
          : damageTaken // ignore: cast_nullable_to_non_nullable
              as int,
      unitsDeployed: null == unitsDeployed
          ? _value._unitsDeployed
          : unitsDeployed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unitsLost: null == unitsLost
          ? _value._unitsLost
          : unitsLost // ignore: cast_nullable_to_non_nullable
              as List<String>,
      baseId: null == baseId
          ? _value.baseId
          : baseId // ignore: cast_nullable_to_non_nullable
              as String,
      antibodiesUsed: freezed == antibodiesUsed
          ? _value._antibodiesUsed
          : antibodiesUsed // ignore: cast_nullable_to_non_nullable
              as List<AntibodyEntity>?,
      pathogenFought: freezed == pathogenFought
          ? _value.pathogenFought
          : pathogenFought // ignore: cast_nullable_to_non_nullable
              as PathogenEntity?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CombatReportEntityImpl extends _CombatReportEntity {
  const _$CombatReportEntityImpl(
      {required this.combatId,
      required this.date,
      @combatResultConverter required this.result,
      required final List<String> log,
      required this.damageDealt,
      required this.damageTaken,
      required final List<String> unitsDeployed,
      required final List<String> unitsLost,
      required this.baseId,
      final List<AntibodyEntity>? antibodiesUsed,
      this.pathogenFought})
      : _log = log,
        _unitsDeployed = unitsDeployed,
        _unitsLost = unitsLost,
        _antibodiesUsed = antibodiesUsed,
        super._();

  factory _$CombatReportEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CombatReportEntityImplFromJson(json);

  @override
  final String combatId;
  @override
  final DateTime date;
  @override
  @combatResultConverter
  final CombatResult result;
  final List<String> _log;
  @override
  List<String> get log {
    if (_log is EqualUnmodifiableListView) return _log;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_log);
  }

  @override
  final int damageDealt;
  @override
  final int damageTaken;
  final List<String> _unitsDeployed;
  @override
  List<String> get unitsDeployed {
    if (_unitsDeployed is EqualUnmodifiableListView) return _unitsDeployed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unitsDeployed);
  }

  final List<String> _unitsLost;
  @override
  List<String> get unitsLost {
    if (_unitsLost is EqualUnmodifiableListView) return _unitsLost;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unitsLost);
  }

  @override
  final String baseId;
  final List<AntibodyEntity>? _antibodiesUsed;
  @override
  List<AntibodyEntity>? get antibodiesUsed {
    final value = _antibodiesUsed;
    if (value == null) return null;
    if (_antibodiesUsed is EqualUnmodifiableListView) return _antibodiesUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final PathogenEntity? pathogenFought;

  /// Create a copy of CombatReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CombatReportEntityImplCopyWith<_$CombatReportEntityImpl> get copyWith =>
      __$$CombatReportEntityImplCopyWithImpl<_$CombatReportEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CombatReportEntityImplToJson(
      this,
    );
  }
}

abstract class _CombatReportEntity extends CombatReportEntity {
  const factory _CombatReportEntity(
      {required final String combatId,
      required final DateTime date,
      @combatResultConverter required final CombatResult result,
      required final List<String> log,
      required final int damageDealt,
      required final int damageTaken,
      required final List<String> unitsDeployed,
      required final List<String> unitsLost,
      required final String baseId,
      final List<AntibodyEntity>? antibodiesUsed,
      final PathogenEntity? pathogenFought}) = _$CombatReportEntityImpl;
  const _CombatReportEntity._() : super._();

  factory _CombatReportEntity.fromJson(Map<String, dynamic> json) =
      _$CombatReportEntityImpl.fromJson;

  @override
  String get combatId;
  @override
  DateTime get date;
  @override
  @combatResultConverter
  CombatResult get result;
  @override
  List<String> get log;
  @override
  int get damageDealt;
  @override
  int get damageTaken;
  @override
  List<String> get unitsDeployed;
  @override
  List<String> get unitsLost;
  @override
  String get baseId;
  @override
  List<AntibodyEntity>? get antibodiesUsed;
  @override
  PathogenEntity? get pathogenFought;

  /// Create a copy of CombatReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CombatReportEntityImplCopyWith<_$CombatReportEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
