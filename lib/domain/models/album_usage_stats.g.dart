// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_usage_stats.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAlbumUsageStatsCollection on Isar {
  IsarCollection<AlbumUsageStats> get albumUsageStats => this.collection();
}

const AlbumUsageStatsSchema = CollectionSchema(
  name: r'AlbumUsageStats',
  id: -797438723268332548,
  properties: {
    r'albumId': PropertySchema(
      id: 0,
      name: r'albumId',
      type: IsarType.string,
    ),
    r'lastOpenedAt': PropertySchema(
      id: 1,
      name: r'lastOpenedAt',
      type: IsarType.dateTime,
    ),
    r'openCount': PropertySchema(
      id: 2,
      name: r'openCount',
      type: IsarType.long,
    )
  },
  estimateSize: _albumUsageStatsEstimateSize,
  serialize: _albumUsageStatsSerialize,
  deserialize: _albumUsageStatsDeserialize,
  deserializeProp: _albumUsageStatsDeserializeProp,
  idName: r'id',
  indexes: {
    r'albumId': IndexSchema(
      id: -3314078833704812111,
      name: r'albumId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'albumId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _albumUsageStatsGetId,
  getLinks: _albumUsageStatsGetLinks,
  attach: _albumUsageStatsAttach,
  version: '3.1.0+1',
);

int _albumUsageStatsEstimateSize(
  AlbumUsageStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  return bytesCount;
}

void _albumUsageStatsSerialize(
  AlbumUsageStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumId);
  writer.writeDateTime(offsets[1], object.lastOpenedAt);
  writer.writeLong(offsets[2], object.openCount);
}

AlbumUsageStats _albumUsageStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlbumUsageStats();
  object.albumId = reader.readString(offsets[0]);
  object.id = id;
  object.lastOpenedAt = reader.readDateTime(offsets[1]);
  object.openCount = reader.readLong(offsets[2]);
  return object;
}

P _albumUsageStatsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _albumUsageStatsGetId(AlbumUsageStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _albumUsageStatsGetLinks(AlbumUsageStats object) {
  return [];
}

void _albumUsageStatsAttach(
    IsarCollection<dynamic> col, Id id, AlbumUsageStats object) {
  object.id = id;
}

extension AlbumUsageStatsByIndex on IsarCollection<AlbumUsageStats> {
  Future<AlbumUsageStats?> getByAlbumId(String albumId) {
    return getByIndex(r'albumId', [albumId]);
  }

  AlbumUsageStats? getByAlbumIdSync(String albumId) {
    return getByIndexSync(r'albumId', [albumId]);
  }

  Future<bool> deleteByAlbumId(String albumId) {
    return deleteByIndex(r'albumId', [albumId]);
  }

  bool deleteByAlbumIdSync(String albumId) {
    return deleteByIndexSync(r'albumId', [albumId]);
  }

  Future<List<AlbumUsageStats?>> getAllByAlbumId(List<String> albumIdValues) {
    final values = albumIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'albumId', values);
  }

  List<AlbumUsageStats?> getAllByAlbumIdSync(List<String> albumIdValues) {
    final values = albumIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'albumId', values);
  }

  Future<int> deleteAllByAlbumId(List<String> albumIdValues) {
    final values = albumIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'albumId', values);
  }

  int deleteAllByAlbumIdSync(List<String> albumIdValues) {
    final values = albumIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'albumId', values);
  }

  Future<Id> putByAlbumId(AlbumUsageStats object) {
    return putByIndex(r'albumId', object);
  }

  Id putByAlbumIdSync(AlbumUsageStats object, {bool saveLinks = true}) {
    return putByIndexSync(r'albumId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAlbumId(List<AlbumUsageStats> objects) {
    return putAllByIndex(r'albumId', objects);
  }

  List<Id> putAllByAlbumIdSync(List<AlbumUsageStats> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'albumId', objects, saveLinks: saveLinks);
  }
}

extension AlbumUsageStatsQueryWhereSort
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QWhere> {
  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlbumUsageStatsQueryWhere
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QWhereClause> {
  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhereClause>
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

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhereClause> idBetween(
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

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhereClause>
      albumIdEqualTo(String albumId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'albumId',
        value: [albumId],
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterWhereClause>
      albumIdNotEqualTo(String albumId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [],
              upper: [albumId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [albumId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [albumId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [],
              upper: [albumId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AlbumUsageStatsQueryFilter
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QFilterCondition> {
  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      albumIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
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

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
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

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
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

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      lastOpenedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      lastOpenedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      lastOpenedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastOpenedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      lastOpenedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastOpenedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      openCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      openCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      openCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterFilterCondition>
      openCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AlbumUsageStatsQueryObject
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QFilterCondition> {}

extension AlbumUsageStatsQueryLinks
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QFilterCondition> {}

extension AlbumUsageStatsQuerySortBy
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QSortBy> {
  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy> sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      sortByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.asc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      sortByLastOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.desc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      sortByOpenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCount', Sort.asc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      sortByOpenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCount', Sort.desc);
    });
  }
}

extension AlbumUsageStatsQuerySortThenBy
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QSortThenBy> {
  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy> thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      thenByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.asc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      thenByLastOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedAt', Sort.desc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      thenByOpenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCount', Sort.asc);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QAfterSortBy>
      thenByOpenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openCount', Sort.desc);
    });
  }
}

extension AlbumUsageStatsQueryWhereDistinct
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QDistinct> {
  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QDistinct> distinctByAlbumId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QDistinct>
      distinctByLastOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastOpenedAt');
    });
  }

  QueryBuilder<AlbumUsageStats, AlbumUsageStats, QDistinct>
      distinctByOpenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openCount');
    });
  }
}

extension AlbumUsageStatsQueryProperty
    on QueryBuilder<AlbumUsageStats, AlbumUsageStats, QQueryProperty> {
  QueryBuilder<AlbumUsageStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AlbumUsageStats, String, QQueryOperations> albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<AlbumUsageStats, DateTime, QQueryOperations>
      lastOpenedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastOpenedAt');
    });
  }

  QueryBuilder<AlbumUsageStats, int, QQueryOperations> openCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openCount');
    });
  }
}
