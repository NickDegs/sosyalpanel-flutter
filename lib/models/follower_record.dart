import 'dart:convert';

class FollowerRecord {
  final String uid;
  final String handle;
  final String? displayName;

  const FollowerRecord({
    required this.uid,
    required this.handle,
    this.displayName,
  });

  factory FollowerRecord.fromJson(Map<String, dynamic> j) => FollowerRecord(
        uid: j['uid'] as String,
        handle: j['handle'] as String,
        displayName: j['displayName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'handle': handle,
        if (displayName != null) 'displayName': displayName,
      };

  static List<FollowerRecord> listFromJson(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((e) => FollowerRecord.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<FollowerRecord> records) =>
      jsonEncode(records.map((r) => r.toJson()).toList());
}
