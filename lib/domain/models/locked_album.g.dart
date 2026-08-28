// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locked_album.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLockedAlbumCollection on Isar {
  IsarCollection<LockedAlbum> get lockedAlbums => this.collection();
}

const LockedAlbumSchema = CollectionSchema(
  name: r'LockedAlbum',
  id: -2445145209529537514,
  properties: {
    r'albumId': PropertySchema(
      id: 0,
      name: r'albumId',
      type: IsarType.string,
    ),
    r'pinHash': PropertySchema(
      id: 1,
      name: r'pinHash',
      type: IsarType.string,
    ),
    r'pinSalt': PropertySchema(
      id: 2,
      name: r'pinSalt',
      type: IsarType.string,
    ),
    r'useMasterPin': PropertySchema(
      id: 3,
      name: r'useMasterPin',
      type: IsarType.bool,
    )
  },
  estimateSize: _lockedAlbumEstimateSize,
  serialize: _lockedAlbumSerialize,
  deserialize: _lockedAlbumDeserialize,
  deserializeProp: _lockedAlbumDeserializeProp,
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
  getId: _lockedAlbumGetId,
  getLinks: _lockedAlbumGetLinks,
  attach: _lockedAlbumAttach,
  version: '3.1.0+1',
);

int _lockedAlbumEstimateSize(
  LockedAlbum object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  bytesCount += 3 + object.pinHash.length * 3;
  bytesCount += 3 + object.pinSalt.length * 3;
  return bytesCount;
}

void _lockedAlbumSerialize(
  LockedAlbum object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumId);
  writer.writeString(offsets[1], object.pinHash);
  writer.writeString(offsets[2], object.pinSalt);
  writer.writeBool(offsets[3], object.useMasterPin);
}

LockedAlbum _lockedAlbumDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LockedAlbum();
  object.albumId = reader.readString(offsets[0]);
  object.id = id;
  object.pinHash = reader.readString(offsets[1]);
  object.pinSalt = reader.readString(offsets[2]);
  object.useMasterPin = reader.readBool(offsets[3]);
  return object;
}

P _lockedAlbumDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lockedAlbumGetId(LockedAlbum object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lockedAlbumGetLinks(LockedAlbum object) {
  return [];
}

void _lockedAlbumAttach(
    IsarCollection<dynamic> col, Id id, LockedAlbum object) {
  object.id = id;
}

extension LockedAlbumByIndex on IsarCollection<LockedAlbum> {
  Future<LockedAlbum?> getByAlbumId(String albumId) {
    return getByIndex(r'albumId', [albumId]);
  }

  LockedAlbum? getByAlbumIdSync(String albumId) {
    return getByIndexSync(r'albumId', [albumId]);
  }

  Future<bool> deleteByAlbumId(String albumId) {
    return deleteByIndex(r'albumId', [albumId]);
  }

  bool deleteByAlbumIdSync(String albumId) {
    return deleteByIndexSync(r'albumId', [albumId]);
  }

  Future<List<LockedAlbum?>> getAllByAlbumId(List<String> albumIdValues) {
    final values = albumIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'albumId', values);
  }

  List<LockedAlbum?> getAllByAlbumIdSync(List<String> albumIdValues) {
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

  Future<Id> putByAlbumId(LockedAlbum object) {
    return putByIndex(r'albumId', object);
  }

  Id putByAlbumIdSync(LockedAlbum object, {bool saveLinks = true}) {
    return putByIndexSync(r'albumId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAlbumId(List<LockedAlbum> objects) {
    return putAllByIndex(r'albumId', objects);
  }

  List<Id> putAllByAlbumIdSync(List<LockedAlbum> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'albumId', objects, saveLinks: saveLinks);
  }
}

extension LockedAlbumQueryWhereSort
    on QueryBuilder<LockedAlbum, LockedAlbum, QWhere> {
  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LockedAlbumQueryWhere
    on QueryBuilder<LockedAlbum, LockedAlbum, QWhereClause> {
  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhereClause> idBetween(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhereClause> albumIdEqualTo(
      String albumId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'albumId',
        value: [albumId],
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterWhereClause> albumIdNotEqualTo(
      String albumId) {
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

extension LockedAlbumQueryFilter
    on QueryBuilder<LockedAlbum, LockedAlbum, QFilterCondition> {
  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> albumIdEqualTo(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> albumIdLessThan(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> albumIdBetween(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> albumIdEndsWith(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> albumIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> albumIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      albumIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      albumIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pinHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinHashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinHashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pinHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinHash',
        value: '',
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pinHash',
        value: '',
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinSaltEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinSaltGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinSaltLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinSaltBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pinSalt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinSaltStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinSaltEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinSaltContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition> pinSaltMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pinSalt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinSaltIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinSalt',
        value: '',
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      pinSaltIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pinSalt',
        value: '',
      ));
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterFilterCondition>
      useMasterPinEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useMasterPin',
        value: value,
      ));
    });
  }
}

extension LockedAlbumQueryObject
    on QueryBuilder<LockedAlbum, LockedAlbum, QFilterCondition> {}

extension LockedAlbumQueryLinks
    on QueryBuilder<LockedAlbum, LockedAlbum, QFilterCondition> {}

extension LockedAlbumQuerySortBy
    on QueryBuilder<LockedAlbum, LockedAlbum, QSortBy> {
  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> sortByPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> sortByPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.desc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> sortByPinSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> sortByPinSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.desc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> sortByUseMasterPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMasterPin', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy>
      sortByUseMasterPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMasterPin', Sort.desc);
    });
  }
}

extension LockedAlbumQuerySortThenBy
    on QueryBuilder<LockedAlbum, LockedAlbum, QSortThenBy> {
  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.desc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByPinSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByPinSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.desc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy> thenByUseMasterPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMasterPin', Sort.asc);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QAfterSortBy>
      thenByUseMasterPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMasterPin', Sort.desc);
    });
  }
}

extension LockedAlbumQueryWhereDistinct
    on QueryBuilder<LockedAlbum, LockedAlbum, QDistinct> {
  QueryBuilder<LockedAlbum, LockedAlbum, QDistinct> distinctByAlbumId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QDistinct> distinctByPinHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QDistinct> distinctByPinSalt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinSalt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LockedAlbum, LockedAlbum, QDistinct> distinctByUseMasterPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useMasterPin');
    });
  }
}

extension LockedAlbumQueryProperty
    on QueryBuilder<LockedAlbum, LockedAlbum, QQueryProperty> {
  QueryBuilder<LockedAlbum, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LockedAlbum, String, QQueryOperations> albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<LockedAlbum, String, QQueryOperations> pinHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinHash');
    });
  }

  QueryBuilder<LockedAlbum, String, QQueryOperations> pinSaltProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinSalt');
    });
  }

  QueryBuilder<LockedAlbum, bool, QQueryOperations> useMasterPinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useMasterPin');
    });
  }
}
