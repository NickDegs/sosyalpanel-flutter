// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SocialAccountsTable extends SocialAccounts
    with TableInfo<$SocialAccountsTable, SocialAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().millisecondsSinceEpoch.toString(),
  );
  static const VerificationMeta _platformRawMeta = const VerificationMeta(
    'platformRaw',
  );
  @override
  late final GeneratedColumn<String> platformRaw = GeneratedColumn<String>(
    'platform_raw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _handleMeta = const VerificationMeta('handle');
  @override
  late final GeneratedColumn<String> handle = GeneratedColumn<String>(
    'handle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _followerCountMeta = const VerificationMeta(
    'followerCount',
  );
  @override
  late final GeneratedColumn<int> followerCount = GeneratedColumn<int>(
    'follower_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _followingCountMeta = const VerificationMeta(
    'followingCount',
  );
  @override
  late final GeneratedColumn<int> followingCount = GeneratedColumn<int>(
    'following_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _mediaCountMeta = const VerificationMeta(
    'mediaCount',
  );
  @override
  late final GeneratedColumn<int> mediaCount = GeneratedColumn<int>(
    'media_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isConnectedMeta = const VerificationMeta(
    'isConnected',
  );
  @override
  late final GeneratedColumn<bool> isConnected = GeneratedColumn<bool>(
    'is_connected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_connected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    platformRaw,
    handle,
    displayName,
    followerCount,
    followingCount,
    mediaCount,
    isConnected,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SocialAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('platform_raw')) {
      context.handle(
        _platformRawMeta,
        platformRaw.isAcceptableOrUnknown(
          data['platform_raw']!,
          _platformRawMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_platformRawMeta);
    }
    if (data.containsKey('handle')) {
      context.handle(
        _handleMeta,
        handle.isAcceptableOrUnknown(data['handle']!, _handleMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('follower_count')) {
      context.handle(
        _followerCountMeta,
        followerCount.isAcceptableOrUnknown(
          data['follower_count']!,
          _followerCountMeta,
        ),
      );
    }
    if (data.containsKey('following_count')) {
      context.handle(
        _followingCountMeta,
        followingCount.isAcceptableOrUnknown(
          data['following_count']!,
          _followingCountMeta,
        ),
      );
    }
    if (data.containsKey('media_count')) {
      context.handle(
        _mediaCountMeta,
        mediaCount.isAcceptableOrUnknown(data['media_count']!, _mediaCountMeta),
      );
    }
    if (data.containsKey('is_connected')) {
      context.handle(
        _isConnectedMeta,
        isConnected.isAcceptableOrUnknown(
          data['is_connected']!,
          _isConnectedMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SocialAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      platformRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_raw'],
      )!,
      handle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}handle'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      followerCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}follower_count'],
      )!,
      followingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}following_count'],
      )!,
      mediaCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_count'],
      )!,
      isConnected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_connected'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $SocialAccountsTable createAlias(String alias) {
    return $SocialAccountsTable(attachedDatabase, alias);
  }
}

class SocialAccount extends DataClass implements Insertable<SocialAccount> {
  final String id;
  final String platformRaw;
  final String? handle;
  final String? displayName;
  final int followerCount;
  final int followingCount;
  final int mediaCount;
  final bool isConnected;
  final DateTime? lastSyncedAt;
  const SocialAccount({
    required this.id,
    required this.platformRaw,
    this.handle,
    this.displayName,
    required this.followerCount,
    required this.followingCount,
    required this.mediaCount,
    required this.isConnected,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['platform_raw'] = Variable<String>(platformRaw);
    if (!nullToAbsent || handle != null) {
      map['handle'] = Variable<String>(handle);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['follower_count'] = Variable<int>(followerCount);
    map['following_count'] = Variable<int>(followingCount);
    map['media_count'] = Variable<int>(mediaCount);
    map['is_connected'] = Variable<bool>(isConnected);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  SocialAccountsCompanion toCompanion(bool nullToAbsent) {
    return SocialAccountsCompanion(
      id: Value(id),
      platformRaw: Value(platformRaw),
      handle: handle == null && nullToAbsent
          ? const Value.absent()
          : Value(handle),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      followerCount: Value(followerCount),
      followingCount: Value(followingCount),
      mediaCount: Value(mediaCount),
      isConnected: Value(isConnected),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory SocialAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialAccount(
      id: serializer.fromJson<String>(json['id']),
      platformRaw: serializer.fromJson<String>(json['platformRaw']),
      handle: serializer.fromJson<String?>(json['handle']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      followerCount: serializer.fromJson<int>(json['followerCount']),
      followingCount: serializer.fromJson<int>(json['followingCount']),
      mediaCount: serializer.fromJson<int>(json['mediaCount']),
      isConnected: serializer.fromJson<bool>(json['isConnected']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'platformRaw': serializer.toJson<String>(platformRaw),
      'handle': serializer.toJson<String?>(handle),
      'displayName': serializer.toJson<String?>(displayName),
      'followerCount': serializer.toJson<int>(followerCount),
      'followingCount': serializer.toJson<int>(followingCount),
      'mediaCount': serializer.toJson<int>(mediaCount),
      'isConnected': serializer.toJson<bool>(isConnected),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  SocialAccount copyWith({
    String? id,
    String? platformRaw,
    Value<String?> handle = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    int? followerCount,
    int? followingCount,
    int? mediaCount,
    bool? isConnected,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => SocialAccount(
    id: id ?? this.id,
    platformRaw: platformRaw ?? this.platformRaw,
    handle: handle.present ? handle.value : this.handle,
    displayName: displayName.present ? displayName.value : this.displayName,
    followerCount: followerCount ?? this.followerCount,
    followingCount: followingCount ?? this.followingCount,
    mediaCount: mediaCount ?? this.mediaCount,
    isConnected: isConnected ?? this.isConnected,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  SocialAccount copyWithCompanion(SocialAccountsCompanion data) {
    return SocialAccount(
      id: data.id.present ? data.id.value : this.id,
      platformRaw: data.platformRaw.present
          ? data.platformRaw.value
          : this.platformRaw,
      handle: data.handle.present ? data.handle.value : this.handle,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      followerCount: data.followerCount.present
          ? data.followerCount.value
          : this.followerCount,
      followingCount: data.followingCount.present
          ? data.followingCount.value
          : this.followingCount,
      mediaCount: data.mediaCount.present
          ? data.mediaCount.value
          : this.mediaCount,
      isConnected: data.isConnected.present
          ? data.isConnected.value
          : this.isConnected,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialAccount(')
          ..write('id: $id, ')
          ..write('platformRaw: $platformRaw, ')
          ..write('handle: $handle, ')
          ..write('displayName: $displayName, ')
          ..write('followerCount: $followerCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('mediaCount: $mediaCount, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    platformRaw,
    handle,
    displayName,
    followerCount,
    followingCount,
    mediaCount,
    isConnected,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialAccount &&
          other.id == this.id &&
          other.platformRaw == this.platformRaw &&
          other.handle == this.handle &&
          other.displayName == this.displayName &&
          other.followerCount == this.followerCount &&
          other.followingCount == this.followingCount &&
          other.mediaCount == this.mediaCount &&
          other.isConnected == this.isConnected &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SocialAccountsCompanion extends UpdateCompanion<SocialAccount> {
  final Value<String> id;
  final Value<String> platformRaw;
  final Value<String?> handle;
  final Value<String?> displayName;
  final Value<int> followerCount;
  final Value<int> followingCount;
  final Value<int> mediaCount;
  final Value<bool> isConnected;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const SocialAccountsCompanion({
    this.id = const Value.absent(),
    this.platformRaw = const Value.absent(),
    this.handle = const Value.absent(),
    this.displayName = const Value.absent(),
    this.followerCount = const Value.absent(),
    this.followingCount = const Value.absent(),
    this.mediaCount = const Value.absent(),
    this.isConnected = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SocialAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String platformRaw,
    this.handle = const Value.absent(),
    this.displayName = const Value.absent(),
    this.followerCount = const Value.absent(),
    this.followingCount = const Value.absent(),
    this.mediaCount = const Value.absent(),
    this.isConnected = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : platformRaw = Value(platformRaw);
  static Insertable<SocialAccount> custom({
    Expression<String>? id,
    Expression<String>? platformRaw,
    Expression<String>? handle,
    Expression<String>? displayName,
    Expression<int>? followerCount,
    Expression<int>? followingCount,
    Expression<int>? mediaCount,
    Expression<bool>? isConnected,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platformRaw != null) 'platform_raw': platformRaw,
      if (handle != null) 'handle': handle,
      if (displayName != null) 'display_name': displayName,
      if (followerCount != null) 'follower_count': followerCount,
      if (followingCount != null) 'following_count': followingCount,
      if (mediaCount != null) 'media_count': mediaCount,
      if (isConnected != null) 'is_connected': isConnected,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SocialAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? platformRaw,
    Value<String?>? handle,
    Value<String?>? displayName,
    Value<int>? followerCount,
    Value<int>? followingCount,
    Value<int>? mediaCount,
    Value<bool>? isConnected,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return SocialAccountsCompanion(
      id: id ?? this.id,
      platformRaw: platformRaw ?? this.platformRaw,
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      mediaCount: mediaCount ?? this.mediaCount,
      isConnected: isConnected ?? this.isConnected,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (platformRaw.present) {
      map['platform_raw'] = Variable<String>(platformRaw.value);
    }
    if (handle.present) {
      map['handle'] = Variable<String>(handle.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (followerCount.present) {
      map['follower_count'] = Variable<int>(followerCount.value);
    }
    if (followingCount.present) {
      map['following_count'] = Variable<int>(followingCount.value);
    }
    if (mediaCount.present) {
      map['media_count'] = Variable<int>(mediaCount.value);
    }
    if (isConnected.present) {
      map['is_connected'] = Variable<bool>(isConnected.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialAccountsCompanion(')
          ..write('id: $id, ')
          ..write('platformRaw: $platformRaw, ')
          ..write('handle: $handle, ')
          ..write('displayName: $displayName, ')
          ..write('followerCount: $followerCount, ')
          ..write('followingCount: $followingCount, ')
          ..write('mediaCount: $mediaCount, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetricSnapshotsTable extends MetricSnapshots
    with TableInfo<$MetricSnapshotsTable, MetricSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().microsecondsSinceEpoch.toString(),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _followerCountMeta = const VerificationMeta(
    'followerCount',
  );
  @override
  late final GeneratedColumn<int> followerCount = GeneratedColumn<int>(
    'follower_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _impressionsMeta = const VerificationMeta(
    'impressions',
  );
  @override
  late final GeneratedColumn<int> impressions = GeneratedColumn<int>(
    'impressions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reachMeta = const VerificationMeta('reach');
  @override
  late final GeneratedColumn<int> reach = GeneratedColumn<int>(
    'reach',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _engagementMeta = const VerificationMeta(
    'engagement',
  );
  @override
  late final GeneratedColumn<int> engagement = GeneratedColumn<int>(
    'engagement',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _profileVisitsMeta = const VerificationMeta(
    'profileVisits',
  );
  @override
  late final GeneratedColumn<int> profileVisits = GeneratedColumn<int>(
    'profile_visits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _websiteClicksMeta = const VerificationMeta(
    'websiteClicks',
  );
  @override
  late final GeneratedColumn<int> websiteClicks = GeneratedColumn<int>(
    'website_clicks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    capturedAt,
    followerCount,
    impressions,
    reach,
    engagement,
    profileVisits,
    websiteClicks,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metric_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetricSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    }
    if (data.containsKey('follower_count')) {
      context.handle(
        _followerCountMeta,
        followerCount.isAcceptableOrUnknown(
          data['follower_count']!,
          _followerCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_followerCountMeta);
    }
    if (data.containsKey('impressions')) {
      context.handle(
        _impressionsMeta,
        impressions.isAcceptableOrUnknown(
          data['impressions']!,
          _impressionsMeta,
        ),
      );
    }
    if (data.containsKey('reach')) {
      context.handle(
        _reachMeta,
        reach.isAcceptableOrUnknown(data['reach']!, _reachMeta),
      );
    }
    if (data.containsKey('engagement')) {
      context.handle(
        _engagementMeta,
        engagement.isAcceptableOrUnknown(data['engagement']!, _engagementMeta),
      );
    }
    if (data.containsKey('profile_visits')) {
      context.handle(
        _profileVisitsMeta,
        profileVisits.isAcceptableOrUnknown(
          data['profile_visits']!,
          _profileVisitsMeta,
        ),
      );
    }
    if (data.containsKey('website_clicks')) {
      context.handle(
        _websiteClicksMeta,
        websiteClicks.isAcceptableOrUnknown(
          data['website_clicks']!,
          _websiteClicksMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MetricSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetricSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      followerCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}follower_count'],
      )!,
      impressions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}impressions'],
      )!,
      reach: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reach'],
      )!,
      engagement: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}engagement'],
      )!,
      profileVisits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_visits'],
      )!,
      websiteClicks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}website_clicks'],
      )!,
    );
  }

  @override
  $MetricSnapshotsTable createAlias(String alias) {
    return $MetricSnapshotsTable(attachedDatabase, alias);
  }
}

class MetricSnapshot extends DataClass implements Insertable<MetricSnapshot> {
  final String id;
  final String accountId;
  final DateTime capturedAt;
  final int followerCount;
  final int impressions;
  final int reach;
  final int engagement;
  final int profileVisits;
  final int websiteClicks;
  const MetricSnapshot({
    required this.id,
    required this.accountId,
    required this.capturedAt,
    required this.followerCount,
    required this.impressions,
    required this.reach,
    required this.engagement,
    required this.profileVisits,
    required this.websiteClicks,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['follower_count'] = Variable<int>(followerCount);
    map['impressions'] = Variable<int>(impressions);
    map['reach'] = Variable<int>(reach);
    map['engagement'] = Variable<int>(engagement);
    map['profile_visits'] = Variable<int>(profileVisits);
    map['website_clicks'] = Variable<int>(websiteClicks);
    return map;
  }

  MetricSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return MetricSnapshotsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      capturedAt: Value(capturedAt),
      followerCount: Value(followerCount),
      impressions: Value(impressions),
      reach: Value(reach),
      engagement: Value(engagement),
      profileVisits: Value(profileVisits),
      websiteClicks: Value(websiteClicks),
    );
  }

  factory MetricSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetricSnapshot(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      followerCount: serializer.fromJson<int>(json['followerCount']),
      impressions: serializer.fromJson<int>(json['impressions']),
      reach: serializer.fromJson<int>(json['reach']),
      engagement: serializer.fromJson<int>(json['engagement']),
      profileVisits: serializer.fromJson<int>(json['profileVisits']),
      websiteClicks: serializer.fromJson<int>(json['websiteClicks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'followerCount': serializer.toJson<int>(followerCount),
      'impressions': serializer.toJson<int>(impressions),
      'reach': serializer.toJson<int>(reach),
      'engagement': serializer.toJson<int>(engagement),
      'profileVisits': serializer.toJson<int>(profileVisits),
      'websiteClicks': serializer.toJson<int>(websiteClicks),
    };
  }

  MetricSnapshot copyWith({
    String? id,
    String? accountId,
    DateTime? capturedAt,
    int? followerCount,
    int? impressions,
    int? reach,
    int? engagement,
    int? profileVisits,
    int? websiteClicks,
  }) => MetricSnapshot(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    capturedAt: capturedAt ?? this.capturedAt,
    followerCount: followerCount ?? this.followerCount,
    impressions: impressions ?? this.impressions,
    reach: reach ?? this.reach,
    engagement: engagement ?? this.engagement,
    profileVisits: profileVisits ?? this.profileVisits,
    websiteClicks: websiteClicks ?? this.websiteClicks,
  );
  MetricSnapshot copyWithCompanion(MetricSnapshotsCompanion data) {
    return MetricSnapshot(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      followerCount: data.followerCount.present
          ? data.followerCount.value
          : this.followerCount,
      impressions: data.impressions.present
          ? data.impressions.value
          : this.impressions,
      reach: data.reach.present ? data.reach.value : this.reach,
      engagement: data.engagement.present
          ? data.engagement.value
          : this.engagement,
      profileVisits: data.profileVisits.present
          ? data.profileVisits.value
          : this.profileVisits,
      websiteClicks: data.websiteClicks.present
          ? data.websiteClicks.value
          : this.websiteClicks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetricSnapshot(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('followerCount: $followerCount, ')
          ..write('impressions: $impressions, ')
          ..write('reach: $reach, ')
          ..write('engagement: $engagement, ')
          ..write('profileVisits: $profileVisits, ')
          ..write('websiteClicks: $websiteClicks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    capturedAt,
    followerCount,
    impressions,
    reach,
    engagement,
    profileVisits,
    websiteClicks,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetricSnapshot &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.capturedAt == this.capturedAt &&
          other.followerCount == this.followerCount &&
          other.impressions == this.impressions &&
          other.reach == this.reach &&
          other.engagement == this.engagement &&
          other.profileVisits == this.profileVisits &&
          other.websiteClicks == this.websiteClicks);
}

class MetricSnapshotsCompanion extends UpdateCompanion<MetricSnapshot> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<DateTime> capturedAt;
  final Value<int> followerCount;
  final Value<int> impressions;
  final Value<int> reach;
  final Value<int> engagement;
  final Value<int> profileVisits;
  final Value<int> websiteClicks;
  final Value<int> rowid;
  const MetricSnapshotsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.followerCount = const Value.absent(),
    this.impressions = const Value.absent(),
    this.reach = const Value.absent(),
    this.engagement = const Value.absent(),
    this.profileVisits = const Value.absent(),
    this.websiteClicks = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetricSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    this.capturedAt = const Value.absent(),
    required int followerCount,
    this.impressions = const Value.absent(),
    this.reach = const Value.absent(),
    this.engagement = const Value.absent(),
    this.profileVisits = const Value.absent(),
    this.websiteClicks = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       followerCount = Value(followerCount);
  static Insertable<MetricSnapshot> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<DateTime>? capturedAt,
    Expression<int>? followerCount,
    Expression<int>? impressions,
    Expression<int>? reach,
    Expression<int>? engagement,
    Expression<int>? profileVisits,
    Expression<int>? websiteClicks,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (followerCount != null) 'follower_count': followerCount,
      if (impressions != null) 'impressions': impressions,
      if (reach != null) 'reach': reach,
      if (engagement != null) 'engagement': engagement,
      if (profileVisits != null) 'profile_visits': profileVisits,
      if (websiteClicks != null) 'website_clicks': websiteClicks,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetricSnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<DateTime>? capturedAt,
    Value<int>? followerCount,
    Value<int>? impressions,
    Value<int>? reach,
    Value<int>? engagement,
    Value<int>? profileVisits,
    Value<int>? websiteClicks,
    Value<int>? rowid,
  }) {
    return MetricSnapshotsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      capturedAt: capturedAt ?? this.capturedAt,
      followerCount: followerCount ?? this.followerCount,
      impressions: impressions ?? this.impressions,
      reach: reach ?? this.reach,
      engagement: engagement ?? this.engagement,
      profileVisits: profileVisits ?? this.profileVisits,
      websiteClicks: websiteClicks ?? this.websiteClicks,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (followerCount.present) {
      map['follower_count'] = Variable<int>(followerCount.value);
    }
    if (impressions.present) {
      map['impressions'] = Variable<int>(impressions.value);
    }
    if (reach.present) {
      map['reach'] = Variable<int>(reach.value);
    }
    if (engagement.present) {
      map['engagement'] = Variable<int>(engagement.value);
    }
    if (profileVisits.present) {
      map['profile_visits'] = Variable<int>(profileVisits.value);
    }
    if (websiteClicks.present) {
      map['website_clicks'] = Variable<int>(websiteClicks.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('followerCount: $followerCount, ')
          ..write('impressions: $impressions, ')
          ..write('reach: $reach, ')
          ..write('engagement: $engagement, ')
          ..write('profileVisits: $profileVisits, ')
          ..write('websiteClicks: $websiteClicks, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InsightsTable extends Insights with TableInfo<$InsightsTable, Insight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().microsecondsSinceEpoch.toString(),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityRawMeta = const VerificationMeta(
    'severityRaw',
  );
  @override
  late final GeneratedColumn<String> severityRaw = GeneratedColumn<String>(
    'severity_raw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('info'),
  );
  static const VerificationMeta _actionableMeta = const VerificationMeta(
    'actionable',
  );
  @override
  late final GeneratedColumn<bool> actionable = GeneratedColumn<bool>(
    'actionable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("actionable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    createdAt,
    title,
    detail,
    severityRaw,
    actionable,
    isRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Insight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    } else if (isInserting) {
      context.missing(_detailMeta);
    }
    if (data.containsKey('severity_raw')) {
      context.handle(
        _severityRawMeta,
        severityRaw.isAcceptableOrUnknown(
          data['severity_raw']!,
          _severityRawMeta,
        ),
      );
    }
    if (data.containsKey('actionable')) {
      context.handle(
        _actionableMeta,
        actionable.isAcceptableOrUnknown(data['actionable']!, _actionableMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Insight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Insight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      severityRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity_raw'],
      )!,
      actionable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}actionable'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
    );
  }

  @override
  $InsightsTable createAlias(String alias) {
    return $InsightsTable(attachedDatabase, alias);
  }
}

class Insight extends DataClass implements Insertable<Insight> {
  final String id;
  final String accountId;
  final DateTime createdAt;
  final String title;
  final String detail;
  final String severityRaw;
  final bool actionable;
  final bool isRead;
  const Insight({
    required this.id,
    required this.accountId,
    required this.createdAt,
    required this.title,
    required this.detail,
    required this.severityRaw,
    required this.actionable,
    required this.isRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['title'] = Variable<String>(title);
    map['detail'] = Variable<String>(detail);
    map['severity_raw'] = Variable<String>(severityRaw);
    map['actionable'] = Variable<bool>(actionable);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  InsightsCompanion toCompanion(bool nullToAbsent) {
    return InsightsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      createdAt: Value(createdAt),
      title: Value(title),
      detail: Value(detail),
      severityRaw: Value(severityRaw),
      actionable: Value(actionable),
      isRead: Value(isRead),
    );
  }

  factory Insight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Insight(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      title: serializer.fromJson<String>(json['title']),
      detail: serializer.fromJson<String>(json['detail']),
      severityRaw: serializer.fromJson<String>(json['severityRaw']),
      actionable: serializer.fromJson<bool>(json['actionable']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'title': serializer.toJson<String>(title),
      'detail': serializer.toJson<String>(detail),
      'severityRaw': serializer.toJson<String>(severityRaw),
      'actionable': serializer.toJson<bool>(actionable),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  Insight copyWith({
    String? id,
    String? accountId,
    DateTime? createdAt,
    String? title,
    String? detail,
    String? severityRaw,
    bool? actionable,
    bool? isRead,
  }) => Insight(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    createdAt: createdAt ?? this.createdAt,
    title: title ?? this.title,
    detail: detail ?? this.detail,
    severityRaw: severityRaw ?? this.severityRaw,
    actionable: actionable ?? this.actionable,
    isRead: isRead ?? this.isRead,
  );
  Insight copyWithCompanion(InsightsCompanion data) {
    return Insight(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      title: data.title.present ? data.title.value : this.title,
      detail: data.detail.present ? data.detail.value : this.detail,
      severityRaw: data.severityRaw.present
          ? data.severityRaw.value
          : this.severityRaw,
      actionable: data.actionable.present
          ? data.actionable.value
          : this.actionable,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Insight(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('severityRaw: $severityRaw, ')
          ..write('actionable: $actionable, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    createdAt,
    title,
    detail,
    severityRaw,
    actionable,
    isRead,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Insight &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt &&
          other.title == this.title &&
          other.detail == this.detail &&
          other.severityRaw == this.severityRaw &&
          other.actionable == this.actionable &&
          other.isRead == this.isRead);
}

class InsightsCompanion extends UpdateCompanion<Insight> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<DateTime> createdAt;
  final Value<String> title;
  final Value<String> detail;
  final Value<String> severityRaw;
  final Value<bool> actionable;
  final Value<bool> isRead;
  final Value<int> rowid;
  const InsightsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.title = const Value.absent(),
    this.detail = const Value.absent(),
    this.severityRaw = const Value.absent(),
    this.actionable = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InsightsCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    this.createdAt = const Value.absent(),
    required String title,
    required String detail,
    this.severityRaw = const Value.absent(),
    this.actionable = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       title = Value(title),
       detail = Value(detail);
  static Insertable<Insight> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<DateTime>? createdAt,
    Expression<String>? title,
    Expression<String>? detail,
    Expression<String>? severityRaw,
    Expression<bool>? actionable,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
      if (title != null) 'title': title,
      if (detail != null) 'detail': detail,
      if (severityRaw != null) 'severity_raw': severityRaw,
      if (actionable != null) 'actionable': actionable,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InsightsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<DateTime>? createdAt,
    Value<String>? title,
    Value<String>? detail,
    Value<String>? severityRaw,
    Value<bool>? actionable,
    Value<bool>? isRead,
    Value<int>? rowid,
  }) {
    return InsightsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      severityRaw: severityRaw ?? this.severityRaw,
      actionable: actionable ?? this.actionable,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (severityRaw.present) {
      map['severity_raw'] = Variable<String>(severityRaw.value);
    }
    if (actionable.present) {
      map['actionable'] = Variable<bool>(actionable.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsightsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('severityRaw: $severityRaw, ')
          ..write('actionable: $actionable, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActionItemsTable extends ActionItems
    with TableInfo<$ActionItemsTable, ActionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().microsecondsSinceEpoch.toString(),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _deepLinkMeta = const VerificationMeta(
    'deepLink',
  );
  @override
  late final GeneratedColumn<String> deepLink = GeneratedColumn<String>(
    'deep_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    createdAt,
    title,
    note,
    deepLink,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'action_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('deep_link')) {
      context.handle(
        _deepLinkMeta,
        deepLink.isAcceptableOrUnknown(data['deep_link']!, _deepLinkMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      deepLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deep_link'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $ActionItemsTable createAlias(String alias) {
    return $ActionItemsTable(attachedDatabase, alias);
  }
}

class ActionItem extends DataClass implements Insertable<ActionItem> {
  final String id;
  final String accountId;
  final DateTime createdAt;
  final String title;
  final String note;
  final String? deepLink;
  final bool completed;
  const ActionItem({
    required this.id,
    required this.accountId,
    required this.createdAt,
    required this.title,
    required this.note,
    this.deepLink,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || deepLink != null) {
      map['deep_link'] = Variable<String>(deepLink);
    }
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  ActionItemsCompanion toCompanion(bool nullToAbsent) {
    return ActionItemsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      createdAt: Value(createdAt),
      title: Value(title),
      note: Value(note),
      deepLink: deepLink == null && nullToAbsent
          ? const Value.absent()
          : Value(deepLink),
      completed: Value(completed),
    );
  }

  factory ActionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActionItem(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
      deepLink: serializer.fromJson<String?>(json['deepLink']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
      'deepLink': serializer.toJson<String?>(deepLink),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  ActionItem copyWith({
    String? id,
    String? accountId,
    DateTime? createdAt,
    String? title,
    String? note,
    Value<String?> deepLink = const Value.absent(),
    bool? completed,
  }) => ActionItem(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    createdAt: createdAt ?? this.createdAt,
    title: title ?? this.title,
    note: note ?? this.note,
    deepLink: deepLink.present ? deepLink.value : this.deepLink,
    completed: completed ?? this.completed,
  );
  ActionItem copyWithCompanion(ActionItemsCompanion data) {
    return ActionItem(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      deepLink: data.deepLink.present ? data.deepLink.value : this.deepLink,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActionItem(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('deepLink: $deepLink, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, accountId, createdAt, title, note, deepLink, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActionItem &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt &&
          other.title == this.title &&
          other.note == this.note &&
          other.deepLink == this.deepLink &&
          other.completed == this.completed);
}

class ActionItemsCompanion extends UpdateCompanion<ActionItem> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<DateTime> createdAt;
  final Value<String> title;
  final Value<String> note;
  final Value<String?> deepLink;
  final Value<bool> completed;
  final Value<int> rowid;
  const ActionItemsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.deepLink = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    this.createdAt = const Value.absent(),
    required String title,
    this.note = const Value.absent(),
    this.deepLink = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       title = Value(title);
  static Insertable<ActionItem> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<DateTime>? createdAt,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? deepLink,
    Expression<bool>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (deepLink != null) 'deep_link': deepLink,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActionItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<DateTime>? createdAt,
    Value<String>? title,
    Value<String>? note,
    Value<String?>? deepLink,
    Value<bool>? completed,
    Value<int>? rowid,
  }) {
    return ActionItemsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      note: note ?? this.note,
      deepLink: deepLink ?? this.deepLink,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (deepLink.present) {
      map['deep_link'] = Variable<String>(deepLink.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionItemsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('deepLink: $deepLink, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FollowerSnapshotsTable extends FollowerSnapshots
    with TableInfo<$FollowerSnapshotsTable, FollowerSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FollowerSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().microsecondsSinceEpoch.toString(),
  );
  static const VerificationMeta _platformRawMeta = const VerificationMeta(
    'platformRaw',
  );
  @override
  late final GeneratedColumn<String> platformRaw = GeneratedColumn<String>(
    'platform_raw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _followersJsonMeta = const VerificationMeta(
    'followersJson',
  );
  @override
  late final GeneratedColumn<String> followersJson = GeneratedColumn<String>(
    'followers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _followingJsonMeta = const VerificationMeta(
    'followingJson',
  );
  @override
  late final GeneratedColumn<String> followingJson = GeneratedColumn<String>(
    'following_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    platformRaw,
    capturedAt,
    followersJson,
    followingJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'follower_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<FollowerSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('platform_raw')) {
      context.handle(
        _platformRawMeta,
        platformRaw.isAcceptableOrUnknown(
          data['platform_raw']!,
          _platformRawMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_platformRawMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    }
    if (data.containsKey('followers_json')) {
      context.handle(
        _followersJsonMeta,
        followersJson.isAcceptableOrUnknown(
          data['followers_json']!,
          _followersJsonMeta,
        ),
      );
    }
    if (data.containsKey('following_json')) {
      context.handle(
        _followingJsonMeta,
        followingJson.isAcceptableOrUnknown(
          data['following_json']!,
          _followingJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FollowerSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FollowerSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      platformRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_raw'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      followersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}followers_json'],
      )!,
      followingJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}following_json'],
      )!,
    );
  }

  @override
  $FollowerSnapshotsTable createAlias(String alias) {
    return $FollowerSnapshotsTable(attachedDatabase, alias);
  }
}

class FollowerSnapshot extends DataClass
    implements Insertable<FollowerSnapshot> {
  final String id;
  final String platformRaw;
  final DateTime capturedAt;
  final String followersJson;
  final String followingJson;
  const FollowerSnapshot({
    required this.id,
    required this.platformRaw,
    required this.capturedAt,
    required this.followersJson,
    required this.followingJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['platform_raw'] = Variable<String>(platformRaw);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['followers_json'] = Variable<String>(followersJson);
    map['following_json'] = Variable<String>(followingJson);
    return map;
  }

  FollowerSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return FollowerSnapshotsCompanion(
      id: Value(id),
      platformRaw: Value(platformRaw),
      capturedAt: Value(capturedAt),
      followersJson: Value(followersJson),
      followingJson: Value(followingJson),
    );
  }

  factory FollowerSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FollowerSnapshot(
      id: serializer.fromJson<String>(json['id']),
      platformRaw: serializer.fromJson<String>(json['platformRaw']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      followersJson: serializer.fromJson<String>(json['followersJson']),
      followingJson: serializer.fromJson<String>(json['followingJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'platformRaw': serializer.toJson<String>(platformRaw),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'followersJson': serializer.toJson<String>(followersJson),
      'followingJson': serializer.toJson<String>(followingJson),
    };
  }

  FollowerSnapshot copyWith({
    String? id,
    String? platformRaw,
    DateTime? capturedAt,
    String? followersJson,
    String? followingJson,
  }) => FollowerSnapshot(
    id: id ?? this.id,
    platformRaw: platformRaw ?? this.platformRaw,
    capturedAt: capturedAt ?? this.capturedAt,
    followersJson: followersJson ?? this.followersJson,
    followingJson: followingJson ?? this.followingJson,
  );
  FollowerSnapshot copyWithCompanion(FollowerSnapshotsCompanion data) {
    return FollowerSnapshot(
      id: data.id.present ? data.id.value : this.id,
      platformRaw: data.platformRaw.present
          ? data.platformRaw.value
          : this.platformRaw,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      followersJson: data.followersJson.present
          ? data.followersJson.value
          : this.followersJson,
      followingJson: data.followingJson.present
          ? data.followingJson.value
          : this.followingJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FollowerSnapshot(')
          ..write('id: $id, ')
          ..write('platformRaw: $platformRaw, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('followersJson: $followersJson, ')
          ..write('followingJson: $followingJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, platformRaw, capturedAt, followersJson, followingJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FollowerSnapshot &&
          other.id == this.id &&
          other.platformRaw == this.platformRaw &&
          other.capturedAt == this.capturedAt &&
          other.followersJson == this.followersJson &&
          other.followingJson == this.followingJson);
}

class FollowerSnapshotsCompanion extends UpdateCompanion<FollowerSnapshot> {
  final Value<String> id;
  final Value<String> platformRaw;
  final Value<DateTime> capturedAt;
  final Value<String> followersJson;
  final Value<String> followingJson;
  final Value<int> rowid;
  const FollowerSnapshotsCompanion({
    this.id = const Value.absent(),
    this.platformRaw = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.followersJson = const Value.absent(),
    this.followingJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FollowerSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String platformRaw,
    this.capturedAt = const Value.absent(),
    this.followersJson = const Value.absent(),
    this.followingJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : platformRaw = Value(platformRaw);
  static Insertable<FollowerSnapshot> custom({
    Expression<String>? id,
    Expression<String>? platformRaw,
    Expression<DateTime>? capturedAt,
    Expression<String>? followersJson,
    Expression<String>? followingJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platformRaw != null) 'platform_raw': platformRaw,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (followersJson != null) 'followers_json': followersJson,
      if (followingJson != null) 'following_json': followingJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FollowerSnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? platformRaw,
    Value<DateTime>? capturedAt,
    Value<String>? followersJson,
    Value<String>? followingJson,
    Value<int>? rowid,
  }) {
    return FollowerSnapshotsCompanion(
      id: id ?? this.id,
      platformRaw: platformRaw ?? this.platformRaw,
      capturedAt: capturedAt ?? this.capturedAt,
      followersJson: followersJson ?? this.followersJson,
      followingJson: followingJson ?? this.followingJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (platformRaw.present) {
      map['platform_raw'] = Variable<String>(platformRaw.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (followersJson.present) {
      map['followers_json'] = Variable<String>(followersJson.value);
    }
    if (followingJson.present) {
      map['following_json'] = Variable<String>(followingJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FollowerSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('platformRaw: $platformRaw, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('followersJson: $followersJson, ')
          ..write('followingJson: $followingJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SocialAccountsTable socialAccounts = $SocialAccountsTable(this);
  late final $MetricSnapshotsTable metricSnapshots = $MetricSnapshotsTable(
    this,
  );
  late final $InsightsTable insights = $InsightsTable(this);
  late final $ActionItemsTable actionItems = $ActionItemsTable(this);
  late final $FollowerSnapshotsTable followerSnapshots =
      $FollowerSnapshotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    socialAccounts,
    metricSnapshots,
    insights,
    actionItems,
    followerSnapshots,
  ];
}

typedef $$SocialAccountsTableCreateCompanionBuilder =
    SocialAccountsCompanion Function({
      Value<String> id,
      required String platformRaw,
      Value<String?> handle,
      Value<String?> displayName,
      Value<int> followerCount,
      Value<int> followingCount,
      Value<int> mediaCount,
      Value<bool> isConnected,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$SocialAccountsTableUpdateCompanionBuilder =
    SocialAccountsCompanion Function({
      Value<String> id,
      Value<String> platformRaw,
      Value<String?> handle,
      Value<String?> displayName,
      Value<int> followerCount,
      Value<int> followingCount,
      Value<int> mediaCount,
      Value<bool> isConnected,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$SocialAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $SocialAccountsTable> {
  $$SocialAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformRaw => $composableBuilder(
    column: $table.platformRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get handle => $composableBuilder(
    column: $table.handle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConnected => $composableBuilder(
    column: $table.isConnected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SocialAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $SocialAccountsTable> {
  $$SocialAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformRaw => $composableBuilder(
    column: $table.platformRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get handle => $composableBuilder(
    column: $table.handle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConnected => $composableBuilder(
    column: $table.isConnected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SocialAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SocialAccountsTable> {
  $$SocialAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platformRaw => $composableBuilder(
    column: $table.platformRaw,
    builder: (column) => column,
  );

  GeneratedColumn<String> get handle =>
      $composableBuilder(column: $table.handle, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followingCount => $composableBuilder(
    column: $table.followingCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mediaCount => $composableBuilder(
    column: $table.mediaCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isConnected => $composableBuilder(
    column: $table.isConnected,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$SocialAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SocialAccountsTable,
          SocialAccount,
          $$SocialAccountsTableFilterComposer,
          $$SocialAccountsTableOrderingComposer,
          $$SocialAccountsTableAnnotationComposer,
          $$SocialAccountsTableCreateCompanionBuilder,
          $$SocialAccountsTableUpdateCompanionBuilder,
          (
            SocialAccount,
            BaseReferences<_$AppDatabase, $SocialAccountsTable, SocialAccount>,
          ),
          SocialAccount,
          PrefetchHooks Function()
        > {
  $$SocialAccountsTableTableManager(
    _$AppDatabase db,
    $SocialAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SocialAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SocialAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SocialAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> platformRaw = const Value.absent(),
                Value<String?> handle = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> followerCount = const Value.absent(),
                Value<int> followingCount = const Value.absent(),
                Value<int> mediaCount = const Value.absent(),
                Value<bool> isConnected = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialAccountsCompanion(
                id: id,
                platformRaw: platformRaw,
                handle: handle,
                displayName: displayName,
                followerCount: followerCount,
                followingCount: followingCount,
                mediaCount: mediaCount,
                isConnected: isConnected,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String platformRaw,
                Value<String?> handle = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> followerCount = const Value.absent(),
                Value<int> followingCount = const Value.absent(),
                Value<int> mediaCount = const Value.absent(),
                Value<bool> isConnected = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialAccountsCompanion.insert(
                id: id,
                platformRaw: platformRaw,
                handle: handle,
                displayName: displayName,
                followerCount: followerCount,
                followingCount: followingCount,
                mediaCount: mediaCount,
                isConnected: isConnected,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SocialAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SocialAccountsTable,
      SocialAccount,
      $$SocialAccountsTableFilterComposer,
      $$SocialAccountsTableOrderingComposer,
      $$SocialAccountsTableAnnotationComposer,
      $$SocialAccountsTableCreateCompanionBuilder,
      $$SocialAccountsTableUpdateCompanionBuilder,
      (
        SocialAccount,
        BaseReferences<_$AppDatabase, $SocialAccountsTable, SocialAccount>,
      ),
      SocialAccount,
      PrefetchHooks Function()
    >;
typedef $$MetricSnapshotsTableCreateCompanionBuilder =
    MetricSnapshotsCompanion Function({
      Value<String> id,
      required String accountId,
      Value<DateTime> capturedAt,
      required int followerCount,
      Value<int> impressions,
      Value<int> reach,
      Value<int> engagement,
      Value<int> profileVisits,
      Value<int> websiteClicks,
      Value<int> rowid,
    });
typedef $$MetricSnapshotsTableUpdateCompanionBuilder =
    MetricSnapshotsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<DateTime> capturedAt,
      Value<int> followerCount,
      Value<int> impressions,
      Value<int> reach,
      Value<int> engagement,
      Value<int> profileVisits,
      Value<int> websiteClicks,
      Value<int> rowid,
    });

class $$MetricSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $MetricSnapshotsTable> {
  $$MetricSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reach => $composableBuilder(
    column: $table.reach,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get engagement => $composableBuilder(
    column: $table.engagement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profileVisits => $composableBuilder(
    column: $table.profileVisits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get websiteClicks => $composableBuilder(
    column: $table.websiteClicks,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetricSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $MetricSnapshotsTable> {
  $$MetricSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reach => $composableBuilder(
    column: $table.reach,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get engagement => $composableBuilder(
    column: $table.engagement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profileVisits => $composableBuilder(
    column: $table.profileVisits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get websiteClicks => $composableBuilder(
    column: $table.websiteClicks,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetricSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetricSnapshotsTable> {
  $$MetricSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followerCount => $composableBuilder(
    column: $table.followerCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get impressions => $composableBuilder(
    column: $table.impressions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reach =>
      $composableBuilder(column: $table.reach, builder: (column) => column);

  GeneratedColumn<int> get engagement => $composableBuilder(
    column: $table.engagement,
    builder: (column) => column,
  );

  GeneratedColumn<int> get profileVisits => $composableBuilder(
    column: $table.profileVisits,
    builder: (column) => column,
  );

  GeneratedColumn<int> get websiteClicks => $composableBuilder(
    column: $table.websiteClicks,
    builder: (column) => column,
  );
}

class $$MetricSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetricSnapshotsTable,
          MetricSnapshot,
          $$MetricSnapshotsTableFilterComposer,
          $$MetricSnapshotsTableOrderingComposer,
          $$MetricSnapshotsTableAnnotationComposer,
          $$MetricSnapshotsTableCreateCompanionBuilder,
          $$MetricSnapshotsTableUpdateCompanionBuilder,
          (
            MetricSnapshot,
            BaseReferences<
              _$AppDatabase,
              $MetricSnapshotsTable,
              MetricSnapshot
            >,
          ),
          MetricSnapshot,
          PrefetchHooks Function()
        > {
  $$MetricSnapshotsTableTableManager(
    _$AppDatabase db,
    $MetricSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetricSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetricSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetricSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> followerCount = const Value.absent(),
                Value<int> impressions = const Value.absent(),
                Value<int> reach = const Value.absent(),
                Value<int> engagement = const Value.absent(),
                Value<int> profileVisits = const Value.absent(),
                Value<int> websiteClicks = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetricSnapshotsCompanion(
                id: id,
                accountId: accountId,
                capturedAt: capturedAt,
                followerCount: followerCount,
                impressions: impressions,
                reach: reach,
                engagement: engagement,
                profileVisits: profileVisits,
                websiteClicks: websiteClicks,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String accountId,
                Value<DateTime> capturedAt = const Value.absent(),
                required int followerCount,
                Value<int> impressions = const Value.absent(),
                Value<int> reach = const Value.absent(),
                Value<int> engagement = const Value.absent(),
                Value<int> profileVisits = const Value.absent(),
                Value<int> websiteClicks = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetricSnapshotsCompanion.insert(
                id: id,
                accountId: accountId,
                capturedAt: capturedAt,
                followerCount: followerCount,
                impressions: impressions,
                reach: reach,
                engagement: engagement,
                profileVisits: profileVisits,
                websiteClicks: websiteClicks,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetricSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetricSnapshotsTable,
      MetricSnapshot,
      $$MetricSnapshotsTableFilterComposer,
      $$MetricSnapshotsTableOrderingComposer,
      $$MetricSnapshotsTableAnnotationComposer,
      $$MetricSnapshotsTableCreateCompanionBuilder,
      $$MetricSnapshotsTableUpdateCompanionBuilder,
      (
        MetricSnapshot,
        BaseReferences<_$AppDatabase, $MetricSnapshotsTable, MetricSnapshot>,
      ),
      MetricSnapshot,
      PrefetchHooks Function()
    >;
typedef $$InsightsTableCreateCompanionBuilder =
    InsightsCompanion Function({
      Value<String> id,
      required String accountId,
      Value<DateTime> createdAt,
      required String title,
      required String detail,
      Value<String> severityRaw,
      Value<bool> actionable,
      Value<bool> isRead,
      Value<int> rowid,
    });
typedef $$InsightsTableUpdateCompanionBuilder =
    InsightsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<DateTime> createdAt,
      Value<String> title,
      Value<String> detail,
      Value<String> severityRaw,
      Value<bool> actionable,
      Value<bool> isRead,
      Value<int> rowid,
    });

class $$InsightsTableFilterComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severityRaw => $composableBuilder(
    column: $table.severityRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get actionable => $composableBuilder(
    column: $table.actionable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severityRaw => $composableBuilder(
    column: $table.severityRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get actionable => $composableBuilder(
    column: $table.actionable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<String> get severityRaw => $composableBuilder(
    column: $table.severityRaw,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get actionable => $composableBuilder(
    column: $table.actionable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$InsightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InsightsTable,
          Insight,
          $$InsightsTableFilterComposer,
          $$InsightsTableOrderingComposer,
          $$InsightsTableAnnotationComposer,
          $$InsightsTableCreateCompanionBuilder,
          $$InsightsTableUpdateCompanionBuilder,
          (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
          Insight,
          PrefetchHooks Function()
        > {
  $$InsightsTableTableManager(_$AppDatabase db, $InsightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<String> severityRaw = const Value.absent(),
                Value<bool> actionable = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion(
                id: id,
                accountId: accountId,
                createdAt: createdAt,
                title: title,
                detail: detail,
                severityRaw: severityRaw,
                actionable: actionable,
                isRead: isRead,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String accountId,
                Value<DateTime> createdAt = const Value.absent(),
                required String title,
                required String detail,
                Value<String> severityRaw = const Value.absent(),
                Value<bool> actionable = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion.insert(
                id: id,
                accountId: accountId,
                createdAt: createdAt,
                title: title,
                detail: detail,
                severityRaw: severityRaw,
                actionable: actionable,
                isRead: isRead,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InsightsTable,
      Insight,
      $$InsightsTableFilterComposer,
      $$InsightsTableOrderingComposer,
      $$InsightsTableAnnotationComposer,
      $$InsightsTableCreateCompanionBuilder,
      $$InsightsTableUpdateCompanionBuilder,
      (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
      Insight,
      PrefetchHooks Function()
    >;
typedef $$ActionItemsTableCreateCompanionBuilder =
    ActionItemsCompanion Function({
      Value<String> id,
      required String accountId,
      Value<DateTime> createdAt,
      required String title,
      Value<String> note,
      Value<String?> deepLink,
      Value<bool> completed,
      Value<int> rowid,
    });
typedef $$ActionItemsTableUpdateCompanionBuilder =
    ActionItemsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<DateTime> createdAt,
      Value<String> title,
      Value<String> note,
      Value<String?> deepLink,
      Value<bool> completed,
      Value<int> rowid,
    });

class $$ActionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ActionItemsTable> {
  $$ActionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deepLink => $composableBuilder(
    column: $table.deepLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActionItemsTable> {
  $$ActionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deepLink => $composableBuilder(
    column: $table.deepLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActionItemsTable> {
  $$ActionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get deepLink =>
      $composableBuilder(column: $table.deepLink, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$ActionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActionItemsTable,
          ActionItem,
          $$ActionItemsTableFilterComposer,
          $$ActionItemsTableOrderingComposer,
          $$ActionItemsTableAnnotationComposer,
          $$ActionItemsTableCreateCompanionBuilder,
          $$ActionItemsTableUpdateCompanionBuilder,
          (
            ActionItem,
            BaseReferences<_$AppDatabase, $ActionItemsTable, ActionItem>,
          ),
          ActionItem,
          PrefetchHooks Function()
        > {
  $$ActionItemsTableTableManager(_$AppDatabase db, $ActionItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> deepLink = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActionItemsCompanion(
                id: id,
                accountId: accountId,
                createdAt: createdAt,
                title: title,
                note: note,
                deepLink: deepLink,
                completed: completed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String accountId,
                Value<DateTime> createdAt = const Value.absent(),
                required String title,
                Value<String> note = const Value.absent(),
                Value<String?> deepLink = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActionItemsCompanion.insert(
                id: id,
                accountId: accountId,
                createdAt: createdAt,
                title: title,
                note: note,
                deepLink: deepLink,
                completed: completed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActionItemsTable,
      ActionItem,
      $$ActionItemsTableFilterComposer,
      $$ActionItemsTableOrderingComposer,
      $$ActionItemsTableAnnotationComposer,
      $$ActionItemsTableCreateCompanionBuilder,
      $$ActionItemsTableUpdateCompanionBuilder,
      (
        ActionItem,
        BaseReferences<_$AppDatabase, $ActionItemsTable, ActionItem>,
      ),
      ActionItem,
      PrefetchHooks Function()
    >;
typedef $$FollowerSnapshotsTableCreateCompanionBuilder =
    FollowerSnapshotsCompanion Function({
      Value<String> id,
      required String platformRaw,
      Value<DateTime> capturedAt,
      Value<String> followersJson,
      Value<String> followingJson,
      Value<int> rowid,
    });
typedef $$FollowerSnapshotsTableUpdateCompanionBuilder =
    FollowerSnapshotsCompanion Function({
      Value<String> id,
      Value<String> platformRaw,
      Value<DateTime> capturedAt,
      Value<String> followersJson,
      Value<String> followingJson,
      Value<int> rowid,
    });

class $$FollowerSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $FollowerSnapshotsTable> {
  $$FollowerSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformRaw => $composableBuilder(
    column: $table.platformRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get followersJson => $composableBuilder(
    column: $table.followersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get followingJson => $composableBuilder(
    column: $table.followingJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FollowerSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $FollowerSnapshotsTable> {
  $$FollowerSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformRaw => $composableBuilder(
    column: $table.platformRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get followersJson => $composableBuilder(
    column: $table.followersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get followingJson => $composableBuilder(
    column: $table.followingJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FollowerSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FollowerSnapshotsTable> {
  $$FollowerSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platformRaw => $composableBuilder(
    column: $table.platformRaw,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get followersJson => $composableBuilder(
    column: $table.followersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get followingJson => $composableBuilder(
    column: $table.followingJson,
    builder: (column) => column,
  );
}

class $$FollowerSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FollowerSnapshotsTable,
          FollowerSnapshot,
          $$FollowerSnapshotsTableFilterComposer,
          $$FollowerSnapshotsTableOrderingComposer,
          $$FollowerSnapshotsTableAnnotationComposer,
          $$FollowerSnapshotsTableCreateCompanionBuilder,
          $$FollowerSnapshotsTableUpdateCompanionBuilder,
          (
            FollowerSnapshot,
            BaseReferences<
              _$AppDatabase,
              $FollowerSnapshotsTable,
              FollowerSnapshot
            >,
          ),
          FollowerSnapshot,
          PrefetchHooks Function()
        > {
  $$FollowerSnapshotsTableTableManager(
    _$AppDatabase db,
    $FollowerSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FollowerSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FollowerSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FollowerSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> platformRaw = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<String> followersJson = const Value.absent(),
                Value<String> followingJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FollowerSnapshotsCompanion(
                id: id,
                platformRaw: platformRaw,
                capturedAt: capturedAt,
                followersJson: followersJson,
                followingJson: followingJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String platformRaw,
                Value<DateTime> capturedAt = const Value.absent(),
                Value<String> followersJson = const Value.absent(),
                Value<String> followingJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FollowerSnapshotsCompanion.insert(
                id: id,
                platformRaw: platformRaw,
                capturedAt: capturedAt,
                followersJson: followersJson,
                followingJson: followingJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FollowerSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FollowerSnapshotsTable,
      FollowerSnapshot,
      $$FollowerSnapshotsTableFilterComposer,
      $$FollowerSnapshotsTableOrderingComposer,
      $$FollowerSnapshotsTableAnnotationComposer,
      $$FollowerSnapshotsTableCreateCompanionBuilder,
      $$FollowerSnapshotsTableUpdateCompanionBuilder,
      (
        FollowerSnapshot,
        BaseReferences<
          _$AppDatabase,
          $FollowerSnapshotsTable,
          FollowerSnapshot
        >,
      ),
      FollowerSnapshot,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SocialAccountsTableTableManager get socialAccounts =>
      $$SocialAccountsTableTableManager(_db, _db.socialAccounts);
  $$MetricSnapshotsTableTableManager get metricSnapshots =>
      $$MetricSnapshotsTableTableManager(_db, _db.metricSnapshots);
  $$InsightsTableTableManager get insights =>
      $$InsightsTableTableManager(_db, _db.insights);
  $$ActionItemsTableTableManager get actionItems =>
      $$ActionItemsTableTableManager(_db, _db.actionItems);
  $$FollowerSnapshotsTableTableManager get followerSnapshots =>
      $$FollowerSnapshotsTableTableManager(_db, _db.followerSnapshots);
}
