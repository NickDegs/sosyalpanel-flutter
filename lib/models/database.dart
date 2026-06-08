import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// MARK: - Tables

class TrackedAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get platformRaw => text()();
  TextColumn get username => text()();
  TextColumn get displayName => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}

class MetricSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(TrackedAccounts, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get capturedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get followers => integer()();
  IntColumn get following => integer().nullable()();
  IntColumn get posts => integer().nullable()();
}

// MARK: - DAO

@DriftAccessor(tables: [TrackedAccounts, MetricSnapshots])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  Stream<List<TrackedAccount>> watchAll() =>
      (select(trackedAccounts)..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.addedAt)])).watch();

  Future<List<TrackedAccount>> getAll() =>
      (select(trackedAccounts)..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.addedAt)])).get();

  Future<int> insertAccount(TrackedAccountsCompanion entry) =>
      into(trackedAccounts).insert(entry);

  Future<void> deleteAccount(int id) =>
      (delete(trackedAccounts)..where((t) => t.id.equals(id))).go();

  Future<void> updateAccount(TrackedAccountsCompanion entry) =>
      (update(trackedAccounts)..where((t) => t.id.equals((entry.id as Value<int>).value))).write(entry);

  Future<MetricSnapshot?> latestSnapshot(int accountId) =>
      (select(metricSnapshots)
            ..where((t) => t.accountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.capturedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<MetricSnapshot>> snapshotHistory(int accountId, {int limit = 60}) =>
      (select(metricSnapshots)
            ..where((t) => t.accountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.capturedAt)])
            ..limit(limit))
          .get();

  Future<int> insertSnapshot(MetricSnapshotsCompanion entry) =>
      into(metricSnapshots).insert(entry);

  Future<void> deleteOldSnapshots(int accountId, {int keep = 90}) async {
    final rows = await (select(metricSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.capturedAt)]))
        .get();
    if (rows.length <= keep) return;
    final toDelete = rows.skip(keep).map((r) => r.id).toList();
    await (delete(metricSnapshots)
          ..where((t) => t.id.isIn(toDelete)))
        .go();
  }
}

// MARK: - Database

@DriftDatabase(tables: [TrackedAccounts, MetricSnapshots], daos: [AccountDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createAll();
          }
        },
      );

  static QueryExecutor _openConnection() => driftDatabase(name: 'sosyalpanel_db');
}

AppDatabase? _db;
AppDatabase get database => _db ??= AppDatabase();
