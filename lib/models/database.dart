import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'platform.dart';

part 'database.g.dart';

// MARK: - Tables

class SocialAccounts extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString())();
  TextColumn get platformRaw => text()();
  TextColumn get handle => text().nullable()();
  TextColumn get displayName => text().nullable()();
  IntColumn get followerCount => integer().withDefault(const Constant(0))();
  IntColumn get followingCount => integer().withDefault(const Constant(0))();
  IntColumn get mediaCount => integer().withDefault(const Constant(0))();
  BoolColumn get isConnected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MetricSnapshots extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().microsecondsSinceEpoch.toString())();
  TextColumn get accountId => text()();
  DateTimeColumn get capturedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get followerCount => integer()();
  IntColumn get impressions => integer().withDefault(const Constant(0))();
  IntColumn get reach => integer().withDefault(const Constant(0))();
  IntColumn get engagement => integer().withDefault(const Constant(0))();
  IntColumn get profileVisits => integer().withDefault(const Constant(0))();
  IntColumn get websiteClicks => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Insights extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().microsecondsSinceEpoch.toString())();
  TextColumn get accountId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get title => text()();
  TextColumn get detail => text()();
  TextColumn get severityRaw => text().withDefault(const Constant('info'))();
  BoolColumn get actionable => boolean().withDefault(const Constant(false))();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ActionItems extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().microsecondsSinceEpoch.toString())();
  TextColumn get accountId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get title => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get deepLink => text().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class FollowerSnapshots extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().microsecondsSinceEpoch.toString())();
  TextColumn get platformRaw => text()();
  DateTimeColumn get capturedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get followersJson => text().withDefault(const Constant('[]'))();
  TextColumn get followingJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

// MARK: - Database

@DriftDatabase(tables: [SocialAccounts, MetricSnapshots, Insights, ActionItems, FollowerSnapshots])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'sosyalpanel_db');
  }
}

// Singleton
AppDatabase? _db;
AppDatabase get database => _db ??= AppDatabase();
