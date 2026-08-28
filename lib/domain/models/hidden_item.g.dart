// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hidden_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHiddenItemCollection on Isar {
  IsarCollection<HiddenItem> get hiddenItems => this.collection();
}

const HiddenItemSchema = CollectionSchema(
  name: r'HiddenItem',
  id: 5417872208535832677,
  properties: {
    r'albumId': PropertySchema(
      id: 0,
      name: r'albumId',
      type: IsarType.string,
    ),
    r'albumName': PropertySchema(
      id: 1,
      name: r'albumName',
      type: IsarType.string,
    ),
    r'encryptedPath': PropertySchema(
      id: 2,
      name: r'encryptedPath',
      type: IsarType.string,
    ),
    r'hiddenAt': PropertySchema(
      id: 3,
      name: r'hiddenAt',
      type: IsarType.dateTime,
    ),
    r'isVideo': PropertySchema(
      id: 4,
      name: r'isVideo',
      type: IsarType.bool,
    ),
    r'mimeType': PropertySchema(
      id: 5,
      name: r'mimeType',
      type: IsarType.string,
    ),
    r'originalAssetId': PropertySchema(
      id: 6,
      name: r'originalAssetId',
      type: IsarType.string,
    ),
    r'originalPath': PropertySchema(
      id: 7,
      name: r'originalPath',
      type: IsarType.string,
    ),
    r'originalSize': PropertySchema(
      id: 8,
      name: r'originalSize',
      type: IsarType.long,
    ),
    r'tag': PropertySchema(
      id: 9,
      name: r'tag',
      type: IsarType.string,
    )
  },
  estimateSize: _hiddenItemEstimateSize,
  serialize: _hiddenItemSerialize,
  deserialize: _hiddenItemDeserialize,
  deserializeProp: _hiddenItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'originalAssetId': IndexSchema(
      id: 1549034879569109739,
      name: r'originalAssetId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'originalAssetId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'tag': IndexSchema(
      id: -8827799455852696894,
      name: r'tag',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tag',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _hiddenItemGetId,
  getLinks: _hiddenItemGetLinks,
  attach: _hiddenItemAttach,
  version: '3.1.0+1',
);

int _hiddenItemEstimateSize(
  HiddenItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  bytesCount += 3 + object.albumName.length * 3;
  bytesCount += 3 + object.encryptedPath.length * 3;
  bytesCount += 3 + object.mimeType.length * 3;
  bytesCount += 3 + object.originalAssetId.length * 3;
  bytesCount += 3 + object.originalPath.length * 3;
  {
    final value = object.tag;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _hiddenItemSerialize(
  HiddenItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumId);
  writer.writeString(offsets[1], object.albumName);
  writer.writeString(offsets[2], object.encryptedPath);
  writer.writeDateTime(offsets[3], object.hiddenAt);
  writer.writeBool(offsets[4], object.isVideo);
  writer.writeString(offsets[5], object.mimeType);
  writer.writeString(offsets[6], object.originalAssetId);
  writer.writeString(offsets[7], object.originalPath);
  writer.writeLong(offsets[8], object.originalSize);
  writer.writeString(offsets[9], object.tag);
}

HiddenItem _hiddenItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HiddenItem();
  object.albumId = reader.readString(offsets[0]);
  object.albumName = reader.readString(offsets[1]);
  object.encryptedPath = reader.readString(offsets[2]);
  object.hiddenAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.isVideo = reader.readBool(offsets[4]);
  object.mimeType = reader.readString(offsets[5]);
  object.originalAssetId = reader.readString(offsets[6]);
  object.originalPath = reader.readString(offsets[7]);
  object.originalSize = reader.readLong(offsets[8]);
  object.tag = reader.readStringOrNull(offsets[9]);
  return object;
}

P _hiddenItemDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hiddenItemGetId(HiddenItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hiddenItemGetLinks(HiddenItem object) {
  return [];
}

void _hiddenItemAttach(IsarCollection<dynamic> col, Id id, HiddenItem object) {
  object.id = id;
}

extension HiddenItemQueryWhereSort
    on QueryBuilder<HiddenItem, HiddenItem, QWhere> {
  QueryBuilder<HiddenItem, HiddenItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HiddenItemQueryWhere
    on QueryBuilder<HiddenItem, HiddenItem, QWhereClause> {
  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause>
      originalAssetIdEqualTo(String originalAssetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'originalAssetId',
        value: [originalAssetId],
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause>
      originalAssetIdNotEqualTo(String originalAssetId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalAssetId',
              lower: [],
              upper: [originalAssetId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalAssetId',
              lower: [originalAssetId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalAssetId',
              lower: [originalAssetId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'originalAssetId',
              lower: [],
              upper: [originalAssetId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> tagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tag',
        value: [null],
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> tagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tag',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> tagEqualTo(
      String? tag) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tag',
        value: [tag],
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterWhereClause> tagNotEqualTo(
      String? tag) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tag',
              lower: [],
              upper: [tag],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tag',
              lower: [tag],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tag',
              lower: [tag],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tag',
              lower: [],
              upper: [tag],
              includeUpper: false,
            ));
      }
    });
  }
}

extension HiddenItemQueryFilter
    on QueryBuilder<HiddenItem, HiddenItem, QFilterCondition> {
  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdEqualTo(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdLessThan(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdBetween(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdStartsWith(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdEndsWith(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdContains(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdMatches(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      albumIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      albumNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      albumNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'albumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'albumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> albumNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      albumNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumName',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      albumNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumName',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedPath',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      encryptedPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedPath',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> hiddenAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hiddenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      hiddenAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hiddenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> hiddenAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hiddenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> hiddenAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hiddenAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> isVideoEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isVideo',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> mimeTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      mimeTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> mimeTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> mimeTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mimeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      mimeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> mimeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> mimeTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> mimeTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mimeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      mimeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      mimeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalAssetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalAssetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalAssetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalAssetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalAssetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalAssetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalAssetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalAssetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalAssetId',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalAssetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalAssetId',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalSize',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalSize',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalSize',
        value: value,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition>
      originalSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tag',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tag',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tag',
        value: '',
      ));
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterFilterCondition> tagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tag',
        value: '',
      ));
    });
  }
}

extension HiddenItemQueryObject
    on QueryBuilder<HiddenItem, HiddenItem, QFilterCondition> {}

extension HiddenItemQueryLinks
    on QueryBuilder<HiddenItem, HiddenItem, QFilterCondition> {}

extension HiddenItemQuerySortBy
    on QueryBuilder<HiddenItem, HiddenItem, QSortBy> {
  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByAlbumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByAlbumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByEncryptedPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPath', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByEncryptedPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPath', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByHiddenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenAt', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByHiddenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenAt', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByIsVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVideo', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByIsVideoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVideo', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByOriginalAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAssetId', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy>
      sortByOriginalAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAssetId', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByOriginalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByOriginalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByOriginalSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSize', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByOriginalSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSize', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tag', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> sortByTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tag', Sort.desc);
    });
  }
}

extension HiddenItemQuerySortThenBy
    on QueryBuilder<HiddenItem, HiddenItem, QSortThenBy> {
  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByAlbumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByAlbumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumName', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByEncryptedPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPath', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByEncryptedPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPath', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByHiddenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenAt', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByHiddenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiddenAt', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByIsVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVideo', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByIsVideoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVideo', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByOriginalAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAssetId', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy>
      thenByOriginalAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAssetId', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByOriginalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByOriginalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByOriginalSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSize', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByOriginalSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalSize', Sort.desc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tag', Sort.asc);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QAfterSortBy> thenByTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tag', Sort.desc);
    });
  }
}

extension HiddenItemQueryWhereDistinct
    on QueryBuilder<HiddenItem, HiddenItem, QDistinct> {
  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByAlbumId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByAlbumName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByEncryptedPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByHiddenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hiddenAt');
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByIsVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isVideo');
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByMimeType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mimeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByOriginalAssetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalAssetId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByOriginalPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByOriginalSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalSize');
    });
  }

  QueryBuilder<HiddenItem, HiddenItem, QDistinct> distinctByTag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tag', caseSensitive: caseSensitive);
    });
  }
}

extension HiddenItemQueryProperty
    on QueryBuilder<HiddenItem, HiddenItem, QQueryProperty> {
  QueryBuilder<HiddenItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HiddenItem, String, QQueryOperations> albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<HiddenItem, String, QQueryOperations> albumNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumName');
    });
  }

  QueryBuilder<HiddenItem, String, QQueryOperations> encryptedPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedPath');
    });
  }

  QueryBuilder<HiddenItem, DateTime, QQueryOperations> hiddenAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hiddenAt');
    });
  }

  QueryBuilder<HiddenItem, bool, QQueryOperations> isVideoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isVideo');
    });
  }

  QueryBuilder<HiddenItem, String, QQueryOperations> mimeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mimeType');
    });
  }

  QueryBuilder<HiddenItem, String, QQueryOperations> originalAssetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalAssetId');
    });
  }

  QueryBuilder<HiddenItem, String, QQueryOperations> originalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalPath');
    });
  }

  QueryBuilder<HiddenItem, int, QQueryOperations> originalSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalSize');
    });
  }

  QueryBuilder<HiddenItem, String?, QQueryOperations> tagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tag');
    });
  }
}
