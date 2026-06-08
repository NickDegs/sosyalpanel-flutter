import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/database.dart';
import '../models/platform.dart';

// Combines a tracked account with its most recent metric snapshot.
class AccountEntry {
  final TrackedAccount account;
  final MetricSnapshot? latest;

  const AccountEntry({required this.account, this.latest});

  SocialPlatform get platform => SocialPlatform.values.firstWhere(
        (p) => p.name == account.platformRaw,
        orElse: () => SocialPlatform.instagram,
      );
}

class AccountNotifier extends AsyncNotifier<List<AccountEntry>> {
  @override
  Future<List<AccountEntry>> build() => _loadAll();

  Future<List<AccountEntry>> _loadAll() async {
    final dao = database.accountDao;
    final accounts = await dao.getAll();
    final entries = <AccountEntry>[];
    for (final a in accounts) {
      final latest = await dao.latestSnapshot(a.id);
      entries.add(AccountEntry(account: a, latest: latest));
    }
    return entries;
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadAll);
  }

  Future<void> addAccount({
    required SocialPlatform platform,
    required String username,
    String? displayName,
  }) async {
    await database.accountDao.insertAccount(
      TrackedAccountsCompanion.insert(
        platformRaw: platform.name,
        username: username.trim().replaceFirst(RegExp(r'^@'), ''),
        displayName: Value(displayName?.trim()),
      ),
    );
    await reload();
  }

  Future<void> removeAccount(int id) async {
    await database.accountDao.deleteAccount(id);
    await reload();
  }

  Future<void> saveMetric({
    required int accountId,
    required int followers,
    int? following,
    int? posts,
  }) async {
    final dao = database.accountDao;
    await dao.insertSnapshot(
      MetricSnapshotsCompanion.insert(
        accountId: accountId,
        followers: followers,
        following: Value(following),
        posts: Value(posts),
      ),
    );
    await dao.deleteOldSnapshots(accountId);
    await reload();
  }
}

final accountProvider =
    AsyncNotifierProvider<AccountNotifier, List<AccountEntry>>(AccountNotifier.new);
