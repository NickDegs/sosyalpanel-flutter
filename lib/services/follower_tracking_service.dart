import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/platform.dart';
import '../models/follower_record.dart';
import 'keychain_service.dart';

class FollowerLists {
  final List<FollowerRecord> followers;
  final List<FollowerRecord> following;
  const FollowerLists({required this.followers, required this.following});
}

class FollowerDiff {
  final List<FollowerRecord> newFollowers;
  final List<FollowerRecord> unfollowers;
  final List<FollowerRecord> notFollowingBack;
  final List<FollowerRecord> notFollowedBack;
  final int totalFollowers;
  final int totalFollowing;

  const FollowerDiff({
    required this.newFollowers,
    required this.unfollowers,
    required this.notFollowingBack,
    required this.notFollowedBack,
    required this.totalFollowers,
    required this.totalFollowing,
  });

  static const empty = FollowerDiff(
    newFollowers: [],
    unfollowers: [],
    notFollowingBack: [],
    notFollowedBack: [],
    totalFollowers: 0,
    totalFollowing: 0,
  );
}

class FollowerTrackingService {
  FollowerTrackingService._();
  static final FollowerTrackingService shared = FollowerTrackingService._();

  static const List<SocialPlatform> listSupportedPlatforms = [
    SocialPlatform.bluesky,
    SocialPlatform.mastodon,
  ];

  Future<FollowerLists> fetchLists(SocialPlatform platform) async {
    return switch (platform) {
      SocialPlatform.bluesky => await _fetchBlueskyLists(),
      SocialPlatform.mastodon => await _fetchMastodonLists(),
      _ => throw Exception('Bu platform takipçi listesini desteklemiyor.'),
    };
  }

  FollowerDiff computeDiff({
    required List<FollowerRecord> currentFollowers,
    required List<FollowerRecord> currentFollowing,
    List<FollowerRecord>? previousFollowers,
  }) {
    final currentFollowerIds = currentFollowers.map((r) => r.uid).toSet();
    final currentFollowingIds = currentFollowing.map((r) => r.uid).toSet();

    final newFollowerIds = previousFollowers != null
        ? currentFollowerIds.difference(previousFollowers.map((r) => r.uid).toSet())
        : <String>{};
    final unfollowerIds = previousFollowers != null
        ? previousFollowers.map((r) => r.uid).toSet().difference(currentFollowerIds)
        : <String>{};

    return FollowerDiff(
      newFollowers: currentFollowers.where((r) => newFollowerIds.contains(r.uid)).toList(),
      unfollowers: (previousFollowers ?? []).where((r) => unfollowerIds.contains(r.uid)).toList(),
      notFollowingBack: currentFollowing.where((r) => !currentFollowerIds.contains(r.uid)).toList(),
      notFollowedBack: currentFollowers.where((r) => !currentFollowingIds.contains(r.uid)).toList(),
      totalFollowers: currentFollowers.length,
      totalFollowing: currentFollowing.length,
    );
  }

  // MARK: - Bluesky

  Future<FollowerLists> _fetchBlueskyLists() async {
    final prefs = await SharedPreferences.getInstance();
    final did = prefs.getString('bsky.did');
    if (did == null) throw Exception('Bluesky hesabı bulunamadı.');
    final token = await KeychainService.shared.readToken(SocialPlatform.bluesky);

    final followers = await _blueskyFetchPaged(
      endpoint: 'app.bsky.graph.getFollowers',
      key: 'followers',
      actor: did,
      token: token,
    );
    final following = await _blueskyFetchPaged(
      endpoint: 'app.bsky.graph.getFollows',
      key: 'follows',
      actor: did,
      token: token,
    );
    return FollowerLists(followers: followers, following: following);
  }

  Future<List<FollowerRecord>> _blueskyFetchPaged({
    required String endpoint,
    required String key,
    required String actor,
    required String token,
  }) async {
    final all = <FollowerRecord>[];
    String? cursor;

    do {
      final uri = Uri.parse('https://bsky.social/xrpc/$endpoint').replace(queryParameters: {
        'actor': actor,
        'limit': '100',
        if (cursor != null) 'cursor': cursor,
      });
      final resp = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final profiles = (data[key] as List<dynamic>? ?? []);
      for (final p in profiles) {
        final m = p as Map<String, dynamic>;
        all.add(FollowerRecord(
          uid: m['did'] as String,
          handle: '@${m['handle']}',
          displayName: m['displayName'] as String?,
        ));
      }
      cursor = data['cursor'] as String?;
    } while (cursor != null && all.length < 500);

    return all;
  }

  // MARK: - Mastodon

  Future<FollowerLists> _fetchMastodonLists() async {
    final prefs = await SharedPreferences.getInstance();
    final host = prefs.getString('mastodon.instance');
    if (host == null) throw Exception('Mastodon hesabı bulunamadı.');
    final token = await KeychainService.shared.readToken(SocialPlatform.mastodon);

    final verifyResp = await http.get(
      Uri.parse('https://$host/api/v1/accounts/verify_credentials'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final me = jsonDecode(verifyResp.body) as Map<String, dynamic>;
    final accountId = me['id'] as String;

    final followers = await _mastodonFetchPaged(
      host: host, accountId: accountId, endpoint: 'followers', token: token,
    );
    final following = await _mastodonFetchPaged(
      host: host, accountId: accountId, endpoint: 'following', token: token,
    );
    return FollowerLists(followers: followers, following: following);
  }

  Future<List<FollowerRecord>> _mastodonFetchPaged({
    required String host,
    required String accountId,
    required String endpoint,
    required String token,
  }) async {
    final all = <FollowerRecord>[];
    String? nextUrl = 'https://$host/api/v1/accounts/$accountId/$endpoint?limit=80';

    while (nextUrl != null && all.length < 500) {
      final resp = await http.get(
        Uri.parse(nextUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
      final profiles = jsonDecode(resp.body) as List<dynamic>;
      for (final p in profiles) {
        final m = p as Map<String, dynamic>;
        final displayName = m['display_name'] as String?;
        all.add(FollowerRecord(
          uid: m['id'] as String,
          handle: '@${m['acct']}',
          displayName: (displayName?.isNotEmpty == true) ? displayName : null,
        ));
      }
      final linkHeader = resp.headers['link'];
      nextUrl = linkHeader != null ? _parseLinkNext(linkHeader) : null;
    }
    return all;
  }

  String? _parseLinkNext(String header) {
    for (final segment in header.split(',')) {
      final parts = segment.split(';').map((s) => s.trim()).toList();
      if (parts.length >= 2 &&
          parts.sublist(1).contains('rel="next"') &&
          parts[0].startsWith('<') &&
          parts[0].endsWith('>')) {
        return parts[0].substring(1, parts[0].length - 1);
      }
    }
    return null;
  }
}
