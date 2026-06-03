import 'package:flutter/material.dart';

enum AuthMode {
  oauth2,
  appPassword,
  apiKey,
  botToken,
  webhook,
  oauth2PerInstance,
}

enum SocialPlatform {
  instagram,
  youtube,
  facebook,
  threads,
  pinterest,
  tiktok,
  reddit,
  tumblr,
  vk,
  mastodon,
  bluesky,
  telegram,
  discord,
  devto;

  String get id => name;

  String get displayName => switch (this) {
        instagram => 'Instagram',
        youtube => 'YouTube',
        facebook => 'Facebook',
        threads => 'Threads',
        pinterest => 'Pinterest',
        tiktok => 'TikTok',
        reddit => 'Reddit',
        tumblr => 'Tumblr',
        vk => 'VK',
        mastodon => 'Mastodon',
        bluesky => 'Bluesky',
        telegram => 'Telegram',
        discord => 'Discord',
        devto => 'Dev.to',
      };

  Color get brandColor => switch (this) {
        instagram => const Color(0xFFE84873),
        youtube => const Color(0xFFFF0000),
        facebook => const Color(0xFF1A57A6),
        threads => Colors.black,
        pinterest => const Color(0xFFE80020),
        tiktok => const Color(0xFF00F2F5),
        reddit => const Color(0xFFFF4500),
        tumblr => const Color(0xFF364458),
        vk => const Color(0xFF4D73A6),
        mastodon => const Color(0xFF5C6FF2),
        bluesky => const Color(0xFF0086FF),
        telegram => const Color(0xFF269ADA),
        discord => const Color(0xFF5865F2),
        devto => Colors.black,
      };

  IconData get icon => switch (this) {
        instagram => Icons.camera_alt,
        youtube => Icons.play_circle_fill,
        facebook => Icons.group,
        threads => Icons.alternate_email,
        pinterest => Icons.push_pin,
        tiktok => Icons.music_note,
        reddit => Icons.forum,
        tumblr => Icons.dashboard,
        vk => Icons.people,
        mastodon => Icons.public,
        bluesky => Icons.cloud,
        telegram => Icons.send,
        discord => Icons.sports_esports,
        devto => Icons.code,
      };

  AuthMode get authMode => switch (this) {
        instagram ||
        youtube ||
        facebook ||
        threads ||
        pinterest ||
        reddit ||
        tumblr ||
        vk ||
        tiktok =>
          AuthMode.oauth2,
        bluesky => AuthMode.appPassword,
        devto => AuthMode.apiKey,
        telegram => AuthMode.botToken,
        discord => AuthMode.webhook,
        mastodon => AuthMode.oauth2PerInstance,
      };

  bool get supportsPosting => this != SocialPlatform.tiktok;

  bool get supportsFollowerList =>
      this == SocialPlatform.bluesky || this == SocialPlatform.mastodon;

  String get nativeAppScheme => switch (this) {
        instagram => 'instagram://',
        youtube => 'youtube://',
        facebook => 'fb://',
        threads => 'barcelona://',
        pinterest => 'pinterest://',
        tiktok => 'tiktok://',
        reddit => 'reddit://',
        tumblr => 'tumblr://',
        vk => 'vk://',
        mastodon => 'mastodon://',
        bluesky => 'bluesky://',
        telegram => 'tg://',
        discord => 'discord://',
        devto => 'https://dev.to',
      };
}
