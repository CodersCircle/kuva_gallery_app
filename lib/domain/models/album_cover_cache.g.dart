// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_cover_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAlbumCoverCacheCollection on Isar {
  IsarCollection<AlbumCoverCache> get albumCoverCaches => this.collection();
}

const AlbumCoverCacheSchema = CollectionSchema(
  name: r'AlbumCoverCache',
  id: 7393901288786544093,
  properties: {
    r'albumId': PropertySchema(
      id: 0,
      name: r'albumId',
      type: IsarType.string,
    ),
    r'bytes': PropertySchema(
      id: 1,
      name: r'bytes',
      type: IsarType.longList,
    )
  },
  estimateSize: _albumCoverCacheEstimateSize,
  serialize: _albumCoverCacheSerialize,
  deserialize: _albumCoverCacheDeserialize,
  deserializeProp: _albumCoverCacheDeserializeProp,
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
  getId: _albumCoverCacheGetId,
  getLinks: _albumCoverCacheGetLinks,
  attach: _albumCoverCacheAttach,
  version: '3.1.0+1',
);

int _albumCoverCacheEstimateSize(
  AlbumCoverCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  bytesCount += 3 + object.bytes.length * 8;
  return bytesCount;
}

void _albumCoverCacheSerialize(
  AlbumCoverCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumId);
  writer.writeLongList(offsets[1], object.bytes);
}

AlbumCoverCache _albumCoverCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlbumCoverCache();
  object.albumId = reader.readString(offsets[0]);
  object.bytes = reader.readLongList(offsets[1]) ?? [];
  object.id = id;
  return object;
}

P _albumCoverCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _albumCoverCacheGetId(AlbumCoverCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _albumCoverCacheGetLinks(AlbumCoverCache object) {
  return [];
}

void _albumCoverCacheAttach(
    IsarCollection<dynamic> col, Id id, AlbumCoverCache object) {
  object.id = id;
}

extension AlbumCoverCacheByIndex on IsarCollection<AlbumCoverCache> {
  Future<AlbumCoverCache?> getByAlbumId(String albumId) {
    return getByIndex(r'albumId', [albumId]);
  }

  AlbumCoverCache? getByAlbumIdSync(String albumId) {
    return getByIndexSync(r'albumId', [albumId]);
  }

  Future<bool> deleteByAlbumId(String albumId) {
    return deleteByIndex(r'albumId', [albumId]);
  }

  bool deleteByAlbumIdSync(String albumId) {
    return deleteByIndexSync(r'albumId', [albumId]);
  }

  Future<List<AlbumCoverCache?>> getAllByAlbumId(List<String> albumIdValues) {
    final values = albumIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'albumId', values);
  }

  List<AlbumCoverCache?> getAllByAlbumIdSync(List<String> albumIdValues) {
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

  Future<Id> putByAlbumId(AlbumCoverCache object) {
    return putByIndex(r'albumId', object);
  }

  Id putByAlbumIdSync(AlbumCoverCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'albumId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAlbumId(List<AlbumCoverCache> objects) {
    return putAllByIndex(r'albumId', objects);
  }

  List<Id> putAllByAlbumIdSync(List<AlbumCoverCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'albumId', objects, saveLinks: saveLinks);
  }
}

extension AlbumCoverCacheQueryWhereSort
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QWhere> {
  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlbumCoverCacheQueryWhere
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QWhereClause> {
  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhereClause>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhereClause>
      albumIdEqualTo(String albumId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'albumId',
        value: [albumId],
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterWhereClause>
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

extension AlbumCoverCacheQueryFilter
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QFilterCondition> {
  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      albumIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      albumIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      albumIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      albumIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bytes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bytes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bytes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      bytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterFilterCondition>
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
}

extension AlbumCoverCacheQueryObject
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QFilterCondition> {}

extension AlbumCoverCacheQueryLinks
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QFilterCondition> {}

extension AlbumCoverCacheQuerySortBy
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QSortBy> {
  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterSortBy> sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterSortBy>
      sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }
}

extension AlbumCoverCacheQuerySortThenBy
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QSortThenBy> {
  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterSortBy> thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterSortBy>
      thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AlbumCoverCacheQueryWhereDistinct
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QDistinct> {
  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QDistinct> distinctByAlbumId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlbumCoverCache, AlbumCoverCache, QDistinct> distinctByBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bytes');
    });
  }
}

extension AlbumCoverCacheQueryProperty
    on QueryBuilder<AlbumCoverCache, AlbumCoverCache, QQueryProperty> {
  QueryBuilder<AlbumCoverCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AlbumCoverCache, String, QQueryOperations> albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<AlbumCoverCache, List<int>, QQueryOperations> bytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bytes');
    });
  }
}
