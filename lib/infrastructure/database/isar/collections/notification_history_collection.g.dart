// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_history_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationHistoryCollectionCollection on Isar {
  IsarCollection<NotificationHistoryCollection>
      get notificationHistoryCollections => this.collection();
}

const NotificationHistoryCollectionSchema = CollectionSchema(
  name: r'NotificationHistoryCollection',
  id: 8915750321721869676,
  properties: {
    r'recordedAt': PropertySchema(
      id: 0,
      name: r'recordedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 1,
      name: r'status',
      type: IsarType.byte,
      enumMap: _NotificationHistoryCollectionstatusEnumValueMap,
    ),
    r'taskDescription': PropertySchema(
      id: 2,
      name: r'taskDescription',
      type: IsarType.string,
    ),
    r'taskId': PropertySchema(
      id: 3,
      name: r'taskId',
      type: IsarType.string,
    ),
    r'taskTitle': PropertySchema(
      id: 4,
      name: r'taskTitle',
      type: IsarType.string,
    ),
    r'triggerTime': PropertySchema(
      id: 5,
      name: r'triggerTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _notificationHistoryCollectionEstimateSize,
  serialize: _notificationHistoryCollectionSerialize,
  deserialize: _notificationHistoryCollectionDeserialize,
  deserializeProp: _notificationHistoryCollectionDeserializeProp,
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
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _notificationHistoryCollectionGetId,
  getLinks: _notificationHistoryCollectionGetLinks,
  attach: _notificationHistoryCollectionAttach,
  version: '3.1.0+1',
);

int _notificationHistoryCollectionEstimateSize(
  NotificationHistoryCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.taskDescription.length * 3;
  bytesCount += 3 + object.taskId.length * 3;
  bytesCount += 3 + object.taskTitle.length * 3;
  return bytesCount;
}

void _notificationHistoryCollectionSerialize(
  NotificationHistoryCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.recordedAt);
  writer.writeByte(offsets[1], object.status.index);
  writer.writeString(offsets[2], object.taskDescription);
  writer.writeString(offsets[3], object.taskId);
  writer.writeString(offsets[4], object.taskTitle);
  writer.writeDateTime(offsets[5], object.triggerTime);
}

NotificationHistoryCollection _notificationHistoryCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationHistoryCollection();
  object.id = id;
  object.recordedAt = reader.readDateTime(offsets[0]);
  object.status = _NotificationHistoryCollectionstatusValueEnumMap[
          reader.readByteOrNull(offsets[1])] ??
      NotificationStatus.missed;
  object.taskDescription = reader.readString(offsets[2]);
  object.taskId = reader.readString(offsets[3]);
  object.taskTitle = reader.readString(offsets[4]);
  object.triggerTime = reader.readDateTime(offsets[5]);
  return object;
}

P _notificationHistoryCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (_NotificationHistoryCollectionstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          NotificationStatus.missed) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _NotificationHistoryCollectionstatusEnumValueMap = {
  'missed': 0,
  'completed': 1,
  'dismissed': 2,
  'snoozed': 3,
};
const _NotificationHistoryCollectionstatusValueEnumMap = {
  0: NotificationStatus.missed,
  1: NotificationStatus.completed,
  2: NotificationStatus.dismissed,
  3: NotificationStatus.snoozed,
};

Id _notificationHistoryCollectionGetId(NotificationHistoryCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationHistoryCollectionGetLinks(
    NotificationHistoryCollection object) {
  return [];
}

void _notificationHistoryCollectionAttach(
    IsarCollection<dynamic> col, Id id, NotificationHistoryCollection object) {
  object.id = id;
}

extension NotificationHistoryCollectionQueryWhereSort on QueryBuilder<
    NotificationHistoryCollection, NotificationHistoryCollection, QWhere> {
  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhere> anyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status'),
      );
    });
  }
}

extension NotificationHistoryCollectionQueryWhere on QueryBuilder<
    NotificationHistoryCollection,
    NotificationHistoryCollection,
    QWhereClause> {
  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> taskIdEqualTo(String taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> taskIdNotEqualTo(String taskId) {
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

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> statusEqualTo(NotificationStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> statusNotEqualTo(NotificationStatus status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> statusGreaterThan(
    NotificationStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [status],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> statusLessThan(
    NotificationStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [],
        upper: [status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterWhereClause> statusBetween(
    NotificationStatus lowerStatus,
    NotificationStatus upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [lowerStatus],
        includeLower: includeLower,
        upper: [upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationHistoryCollectionQueryFilter on QueryBuilder<
    NotificationHistoryCollection,
    NotificationHistoryCollection,
    QFilterCondition> {
  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> recordedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> recordedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> recordedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> recordedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> statusEqualTo(NotificationStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> statusGreaterThan(
    NotificationStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> statusLessThan(
    NotificationStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> statusBetween(
    NotificationStatus lower,
    NotificationStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
          QAfterFilterCondition>
      taskDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
          QAfterFilterCondition>
      taskDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
          QAfterFilterCondition>
      taskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
          QAfterFilterCondition>
      taskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
          QAfterFilterCondition>
      taskTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
          QAfterFilterCondition>
      taskTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> taskTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> triggerTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> triggerTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> triggerTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterFilterCondition> triggerTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationHistoryCollectionQueryObject on QueryBuilder<
    NotificationHistoryCollection,
    NotificationHistoryCollection,
    QFilterCondition> {}

extension NotificationHistoryCollectionQueryLinks on QueryBuilder<
    NotificationHistoryCollection,
    NotificationHistoryCollection,
    QFilterCondition> {}

extension NotificationHistoryCollectionQuerySortBy on QueryBuilder<
    NotificationHistoryCollection, NotificationHistoryCollection, QSortBy> {
  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTaskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTaskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTriggerTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> sortByTriggerTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTime', Sort.desc);
    });
  }
}

extension NotificationHistoryCollectionQuerySortThenBy on QueryBuilder<
    NotificationHistoryCollection, NotificationHistoryCollection, QSortThenBy> {
  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTaskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTaskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTriggerTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QAfterSortBy> thenByTriggerTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTime', Sort.desc);
    });
  }
}

extension NotificationHistoryCollectionQueryWhereDistinct on QueryBuilder<
    NotificationHistoryCollection, NotificationHistoryCollection, QDistinct> {
  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QDistinct> distinctByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordedAt');
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QDistinct> distinctByTaskDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QDistinct> distinctByTaskId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QDistinct> distinctByTaskTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationHistoryCollection,
      QDistinct> distinctByTriggerTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerTime');
    });
  }
}

extension NotificationHistoryCollectionQueryProperty on QueryBuilder<
    NotificationHistoryCollection,
    NotificationHistoryCollection,
    QQueryProperty> {
  QueryBuilder<NotificationHistoryCollection, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationHistoryCollection, DateTime, QQueryOperations>
      recordedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordedAt');
    });
  }

  QueryBuilder<NotificationHistoryCollection, NotificationStatus,
      QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<NotificationHistoryCollection, String, QQueryOperations>
      taskDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskDescription');
    });
  }

  QueryBuilder<NotificationHistoryCollection, String, QQueryOperations>
      taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<NotificationHistoryCollection, String, QQueryOperations>
      taskTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskTitle');
    });
  }

  QueryBuilder<NotificationHistoryCollection, DateTime, QQueryOperations>
      triggerTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerTime');
    });
  }
}
