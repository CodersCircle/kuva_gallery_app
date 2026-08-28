// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_target.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCloudTargetCollection on Isar {
  IsarCollection<CloudTarget> get cloudTargets => this.collection();
}

const CloudTargetSchema = CollectionSchema(
  name: r'CloudTarget',
  id: -5052213880049905754,
  properties: {
    r'backupVault': PropertySchema(
      id: 0,
      name: r'backupVault',
      type: IsarType.bool,
    ),
    r'configJson': PropertySchema(
      id: 1,
      name: r'configJson',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 2,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'isConnected': PropertySchema(
      id: 3,
      name: r'isConnected',
      type: IsarType.bool,
    ),
    r'lastSyncAt': PropertySchema(
      id: 4,
      name: r'lastSyncAt',
      type: IsarType.dateTime,
    ),
    r'provider': PropertySchema(
      id: 5,
      name: r'provider',
      type: IsarType.string,
      enumMap: _CloudTargetproviderEnumValueMap,
    )
  },
  estimateSize: _cloudTargetEstimateSize,
  serialize: _cloudTargetSerialize,
  deserialize: _cloudTargetDeserialize,
  deserializeProp: _cloudTargetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _cloudTargetGetId,
  getLinks: _cloudTargetGetLinks,
  attach: _cloudTargetAttach,
  version: '3.1.0+1',
);

int _cloudTargetEstimateSize(
  CloudTarget object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.configJson.length * 3;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.provider.name.length * 3;
  return bytesCount;
}

void _cloudTargetSerialize(
  CloudTarget object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.backupVault);
  writer.writeString(offsets[1], object.configJson);
  writer.writeString(offsets[2], object.displayName);
  writer.writeBool(offsets[3], object.isConnected);
  writer.writeDateTime(offsets[4], object.lastSyncAt);
  writer.writeString(offsets[5], object.provider.name);
}

CloudTarget _cloudTargetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CloudTarget();
  object.backupVault = reader.readBool(offsets[0]);
  object.configJson = reader.readString(offsets[1]);
  object.displayName = reader.readString(offsets[2]);
  object.id = id;
  object.isConnected = reader.readBool(offsets[3]);
  object.lastSyncAt = reader.readDateTimeOrNull(offsets[4]);
  object.provider =
      _CloudTargetproviderValueEnumMap[reader.readStringOrNull(offsets[5])] ??
          CloudProvider.googleDrive;
  return object;
}

P _cloudTargetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (_CloudTargetproviderValueEnumMap[
              reader.readStringOrNull(offset)] ??
          CloudProvider.googleDrive) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CloudTargetproviderEnumValueMap = {
  r'googleDrive': r'googleDrive',
  r'cloudinary': r'cloudinary',
  r's3': r's3',
};
const _CloudTargetproviderValueEnumMap = {
  r'googleDrive': CloudProvider.googleDrive,
  r'cloudinary': CloudProvider.cloudinary,
  r's3': CloudProvider.s3,
};

Id _cloudTargetGetId(CloudTarget object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cloudTargetGetLinks(CloudTarget object) {
  return [];
}

void _cloudTargetAttach(
    IsarCollection<dynamic> col, Id id, CloudTarget object) {
  object.id = id;
}

extension CloudTargetQueryWhereSort
    on QueryBuilder<CloudTarget, CloudTarget, QWhere> {
  QueryBuilder<CloudTarget, CloudTarget, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CloudTargetQueryWhere
    on QueryBuilder<CloudTarget, CloudTarget, QWhereClause> {
  QueryBuilder<CloudTarget, CloudTarget, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CloudTarget, CloudTarget, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterWhereClause> idBetween(
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
}

extension CloudTargetQueryFilter
    on QueryBuilder<CloudTarget, CloudTarget, QFilterCondition> {
  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      backupVaultEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backupVault',
        value: value,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'configJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'configJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configJson',
        value: '',
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      configJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'configJson',
        value: '',
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      isConnectedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isConnected',
        value: value,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      lastSyncAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncAt',
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      lastSyncAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncAt',
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      lastSyncAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      lastSyncAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      lastSyncAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      lastSyncAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition> providerEqualTo(
    CloudProvider value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      providerGreaterThan(
    CloudProvider value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      providerLessThan(
    CloudProvider value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition> providerBetween(
    CloudProvider lower,
    CloudProvider upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'provider',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      providerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      providerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      providerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition> providerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'provider',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      providerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'provider',
        value: '',
      ));
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterFilterCondition>
      providerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'provider',
        value: '',
      ));
    });
  }
}

extension CloudTargetQueryObject
    on QueryBuilder<CloudTarget, CloudTarget, QFilterCondition> {}

extension CloudTargetQueryLinks
    on QueryBuilder<CloudTarget, CloudTarget, QFilterCondition> {}

extension CloudTargetQuerySortBy
    on QueryBuilder<CloudTarget, CloudTarget, QSortBy> {
  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByBackupVault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupVault', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByBackupVaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupVault', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByConfigJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByConfigJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByIsConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConnected', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByIsConnectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConnected', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByLastSyncAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> sortByProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.desc);
    });
  }
}

extension CloudTargetQuerySortThenBy
    on QueryBuilder<CloudTarget, CloudTarget, QSortThenBy> {
  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByBackupVault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupVault', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByBackupVaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupVault', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByConfigJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByConfigJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByIsConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConnected', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByIsConnectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConnected', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByLastSyncAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAt', Sort.desc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.asc);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QAfterSortBy> thenByProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.desc);
    });
  }
}

extension CloudTargetQueryWhereDistinct
    on QueryBuilder<CloudTarget, CloudTarget, QDistinct> {
  QueryBuilder<CloudTarget, CloudTarget, QDistinct> distinctByBackupVault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupVault');
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QDistinct> distinctByConfigJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'configJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QDistinct> distinctByDisplayName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QDistinct> distinctByIsConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isConnected');
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QDistinct> distinctByLastSyncAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncAt');
    });
  }

  QueryBuilder<CloudTarget, CloudTarget, QDistinct> distinctByProvider(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'provider', caseSensitive: caseSensitive);
    });
  }
}

extension CloudTargetQueryProperty
    on QueryBuilder<CloudTarget, CloudTarget, QQueryProperty> {
  QueryBuilder<CloudTarget, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CloudTarget, bool, QQueryOperations> backupVaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupVault');
    });
  }

  QueryBuilder<CloudTarget, String, QQueryOperations> configJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'configJson');
    });
  }

  QueryBuilder<CloudTarget, String, QQueryOperations> displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<CloudTarget, bool, QQueryOperations> isConnectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isConnected');
    });
  }

  QueryBuilder<CloudTarget, DateTime?, QQueryOperations> lastSyncAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncAt');
    });
  }

  QueryBuilder<CloudTarget, CloudProvider, QQueryOperations>
      providerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'provider');
    });
  }
}
