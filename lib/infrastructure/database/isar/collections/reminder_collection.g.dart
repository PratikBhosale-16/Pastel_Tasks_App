// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReminderCollectionCollection on Isar {
  IsarCollection<ReminderCollection> get reminderCollections =>
      this.collection();
}

const ReminderCollectionSchema = CollectionSchema(
  name: r'ReminderCollection',
  id: 2334535023166308683,
  properties: {
    r'isEnabled': PropertySchema(
      id: 0,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'notificationId': PropertySchema(
      id: 1,
      name: r'notificationId',
      type: IsarType.long,
    ),
    r'reminderDate': PropertySchema(
      id: 2,
      name: r'reminderDate',
      type: IsarType.dateTime,
    ),
    r'repeatInterval': PropertySchema(
      id: 3,
      name: r'repeatInterval',
      type: IsarType.long,
    ),
    r'repeatType': PropertySchema(
      id: 4,
      name: r'repeatType',
      type: IsarType.byte,
      enumMap: _ReminderCollectionrepeatTypeEnumValueMap,
    ),
    r'taskId': PropertySchema(
      id: 5,
      name: r'taskId',
      type: IsarType.long,
    )
  },
  estimateSize: _reminderCollectionEstimateSize,
  serialize: _reminderCollectionSerialize,
  deserialize: _reminderCollectionDeserialize,
  deserializeProp: _reminderCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'taskId': IndexSchema(
      id: -6391211041487498726,
      name: r'taskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'reminderDate': IndexSchema(
      id: -8358223065858447343,
      name: r'reminderDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reminderDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _reminderCollectionGetId,
  getLinks: _reminderCollectionGetLinks,
  attach: _reminderCollectionAttach,
  version: '3.1.0+1',
);

int _reminderCollectionEstimateSize(
  ReminderCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _reminderCollectionSerialize(
  ReminderCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isEnabled);
  writer.writeLong(offsets[1], object.notificationId);
  writer.writeDateTime(offsets[2], object.reminderDate);
  writer.writeLong(offsets[3], object.repeatInterval);
  writer.writeByte(offsets[4], object.repeatType.index);
  writer.writeLong(offsets[5], object.taskId);
}

ReminderCollection _reminderCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReminderCollection();
  object.id = id;
  object.isEnabled = reader.readBool(offsets[0]);
  object.notificationId = reader.readLong(offsets[1]);
  object.reminderDate = reader.readDateTime(offsets[2]);
  object.repeatInterval = reader.readLong(offsets[3]);
  object.repeatType = _ReminderCollectionrepeatTypeValueEnumMap[
          reader.readByteOrNull(offsets[4])] ??
      RepeatRule.none;
  object.taskId = reader.readLong(offsets[5]);
  return object;
}

P _reminderCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (_ReminderCollectionrepeatTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RepeatRule.none) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReminderCollectionrepeatTypeEnumValueMap = {
  'none': 0,
  'daily': 1,
  'weekly': 2,
  'monthly': 3,
  'yearly': 4,
  'custom': 5,
};
const _ReminderCollectionrepeatTypeValueEnumMap = {
  0: RepeatRule.none,
  1: RepeatRule.daily,
  2: RepeatRule.weekly,
  3: RepeatRule.monthly,
  4: RepeatRule.yearly,
  5: RepeatRule.custom,
};

Id _reminderCollectionGetId(ReminderCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reminderCollectionGetLinks(
    ReminderCollection object) {
  return [];
}

void _reminderCollectionAttach(
    IsarCollection<dynamic> col, Id id, ReminderCollection object) {
  object.id = id;
}

extension ReminderCollectionQueryWhereSort
    on QueryBuilder<ReminderCollection, ReminderCollection, QWhere> {
  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhere>
      anyTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'taskId'),
      );
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhere>
      anyReminderDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reminderDate'),
      );
    });
  }
}

extension ReminderCollectionQueryWhere
    on QueryBuilder<ReminderCollection, ReminderCollection, QWhereClause> {
  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      taskIdEqualTo(int taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      taskIdNotEqualTo(int taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      taskIdGreaterThan(
    int taskId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId',
        lower: [taskId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      taskIdLessThan(
    int taskId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId',
        lower: [],
        upper: [taskId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      taskIdBetween(
    int lowerTaskId,
    int upperTaskId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId',
        lower: [lowerTaskId],
        includeLower: includeLower,
        upper: [upperTaskId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      reminderDateEqualTo(DateTime reminderDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reminderDate',
        value: [reminderDate],
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      reminderDateNotEqualTo(DateTime reminderDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderDate',
              lower: [],
              upper: [reminderDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderDate',
              lower: [reminderDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderDate',
              lower: [reminderDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reminderDate',
              lower: [],
              upper: [reminderDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      reminderDateGreaterThan(
    DateTime reminderDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reminderDate',
        lower: [reminderDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      reminderDateLessThan(
    DateTime reminderDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reminderDate',
        lower: [],
        upper: [reminderDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterWhereClause>
      reminderDateBetween(
    DateTime lowerReminderDate,
    DateTime upperReminderDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reminderDate',
        lower: [lowerReminderDate],
        includeLower: includeLower,
        upper: [upperReminderDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReminderCollectionQueryFilter
    on QueryBuilder<ReminderCollection, ReminderCollection, QFilterCondition> {
  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      isEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      notificationIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      notificationIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      notificationIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      notificationIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      reminderDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      reminderDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      reminderDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      reminderDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatIntervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatIntervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatIntervalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatIntervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatTypeEqualTo(RepeatRule value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatType',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatTypeGreaterThan(
    RepeatRule value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatType',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatTypeLessThan(
    RepeatRule value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatType',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      repeatTypeBetween(
    RepeatRule lower,
    RepeatRule upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      taskIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      taskIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      taskIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterFilterCondition>
      taskIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReminderCollectionQueryObject
    on QueryBuilder<ReminderCollection, ReminderCollection, QFilterCondition> {}

extension ReminderCollectionQueryLinks
    on QueryBuilder<ReminderCollection, ReminderCollection, QFilterCondition> {}

extension ReminderCollectionQuerySortBy
    on QueryBuilder<ReminderCollection, ReminderCollection, QSortBy> {
  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByReminderDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByReminderDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByRepeatInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatInterval', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByRepeatIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatInterval', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByRepeatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatType', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByRepeatTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatType', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }
}

extension ReminderCollectionQuerySortThenBy
    on QueryBuilder<ReminderCollection, ReminderCollection, QSortThenBy> {
  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByReminderDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByReminderDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByRepeatInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatInterval', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByRepeatIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatInterval', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByRepeatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatType', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByRepeatTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatType', Sort.desc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QAfterSortBy>
      thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }
}

extension ReminderCollectionQueryWhereDistinct
    on QueryBuilder<ReminderCollection, ReminderCollection, QDistinct> {
  QueryBuilder<ReminderCollection, ReminderCollection, QDistinct>
      distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QDistinct>
      distinctByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationId');
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QDistinct>
      distinctByReminderDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderDate');
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QDistinct>
      distinctByRepeatInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatInterval');
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QDistinct>
      distinctByRepeatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatType');
    });
  }

  QueryBuilder<ReminderCollection, ReminderCollection, QDistinct>
      distinctByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId');
    });
  }
}

extension ReminderCollectionQueryProperty
    on QueryBuilder<ReminderCollection, ReminderCollection, QQueryProperty> {
  QueryBuilder<ReminderCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReminderCollection, bool, QQueryOperations> isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<ReminderCollection, int, QQueryOperations>
      notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationId');
    });
  }

  QueryBuilder<ReminderCollection, DateTime, QQueryOperations>
      reminderDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderDate');
    });
  }

  QueryBuilder<ReminderCollection, int, QQueryOperations>
      repeatIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatInterval');
    });
  }

  QueryBuilder<ReminderCollection, RepeatRule, QQueryOperations>
      repeatTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatType');
    });
  }

  QueryBuilder<ReminderCollection, int, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }
}
