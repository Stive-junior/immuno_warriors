// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'research_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResearchEntity _$ResearchEntityFromJson(Map<String, dynamic> json) {
  return _ResearchEntity.fromJson(json);
}

/// @nodoc
mixin _$ResearchEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost')
  int get researchCost => throw _privateConstructorUsedError;
  List<String> get prerequisites => throw _privateConstructorUsedError;
  Map<String, dynamic> get effects => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;

  /// Serializes this ResearchEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResearchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResearchEntityCopyWith<ResearchEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResearchEntityCopyWith<$Res> {
  factory $ResearchEntityCopyWith(
          ResearchEntity value, $Res Function(ResearchEntity) then) =
      _$ResearchEntityCopyWithImpl<$Res, ResearchEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      @JsonKey(name: 'cost') int researchCost,
      List<String> prerequisites,
      Map<String, dynamic> effects,
      int level,
      bool isUnlocked});
}

/// @nodoc
class _$ResearchEntityCopyWithImpl<$Res, $Val extends ResearchEntity>
    implements $ResearchEntityCopyWith<$Res> {
  _$ResearchEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResearchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? researchCost = null,
    Object? prerequisites = null,
    Object? effects = null,
    Object? level = null,
    Object? isUnlocked = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      researchCost: null == researchCost
          ? _value.researchCost
          : researchCost // ignore: cast_nullable_to_non_nullable
              as int,
      prerequisites: null == prerequisites
          ? _value.prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      effects: null == effects
          ? _value.effects
          : effects // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResearchEntityImplCopyWith<$Res>
    implements $ResearchEntityCopyWith<$Res> {
  factory _$$ResearchEntityImplCopyWith(_$ResearchEntityImpl value,
          $Res Function(_$ResearchEntityImpl) then) =
      __$$ResearchEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      @JsonKey(name: 'cost') int researchCost,
      List<String> prerequisites,
      Map<String, dynamic> effects,
      int level,
      bool isUnlocked});
}

/// @nodoc
class __$$ResearchEntityImplCopyWithImpl<$Res>
    extends _$ResearchEntityCopyWithImpl<$Res, _$ResearchEntityImpl>
    implements _$$ResearchEntityImplCopyWith<$Res> {
  __$$ResearchEntityImplCopyWithImpl(
      _$ResearchEntityImpl _value, $Res Function(_$ResearchEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResearchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? researchCost = null,
    Object? prerequisites = null,
    Object? effects = null,
    Object? level = null,
    Object? isUnlocked = null,
  }) {
    return _then(_$ResearchEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      researchCost: null == researchCost
          ? _value.researchCost
          : researchCost // ignore: cast_nullable_to_non_nullable
              as int,
      prerequisites: null == prerequisites
          ? _value._prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      effects: null == effects
          ? _value._effects
          : effects // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResearchEntityImpl extends _ResearchEntity {
  const _$ResearchEntityImpl(
      {required this.id,
      required this.name,
      required this.description,
      @JsonKey(name: 'cost') required this.researchCost,
      required final List<String> prerequisites,
      required final Map<String, dynamic> effects,
      required this.level,
      this.isUnlocked = false})
      : _prerequisites = prerequisites,
        _effects = effects,
        super._();

  factory _$ResearchEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResearchEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey(name: 'cost')
  final int researchCost;
  final List<String> _prerequisites;
  @override
  List<String> get prerequisites {
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prerequisites);
  }

  final Map<String, dynamic> _effects;
  @override
  Map<String, dynamic> get effects {
    if (_effects is EqualUnmodifiableMapView) return _effects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_effects);
  }

  @override
  final int level;
  @override
  @JsonKey()
  final bool isUnlocked;

  /// Create a copy of ResearchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResearchEntityImplCopyWith<_$ResearchEntityImpl> get copyWith =>
      __$$ResearchEntityImplCopyWithImpl<_$ResearchEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResearchEntityImplToJson(
      this,
    );
  }
}

abstract class _ResearchEntity extends ResearchEntity {
  const factory _ResearchEntity(
      {required final String id,
      required final String name,
      required final String description,
      @JsonKey(name: 'cost') required final int researchCost,
      required final List<String> prerequisites,
      required final Map<String, dynamic> effects,
      required final int level,
      final bool isUnlocked}) = _$ResearchEntityImpl;
  const _ResearchEntity._() : super._();

  factory _ResearchEntity.fromJson(Map<String, dynamic> json) =
      _$ResearchEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'cost')
  int get researchCost;
  @override
  List<String> get prerequisites;
  @override
  Map<String, dynamic> get effects;
  @override
  int get level;
  @override
  bool get isUnlocked;

  /// Create a copy of ResearchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResearchEntityImplCopyWith<_$ResearchEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
