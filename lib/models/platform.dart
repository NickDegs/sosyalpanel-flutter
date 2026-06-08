import 'package:flutter/material.dart';

enum ShareMode {
  url,        // platform has a share URL (opens browser/app)
  clipboard,  // no share URL — copy text + open app
  video,      // video-only platform (no text posts)
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

  String get displayName => switch (this) {
        instagram => 'Instagram',
        youtube    => 'YouTube',
        facebook   => 'Facebook',
        threads    => 'Threads',
        pinterest  => 'Pinterest',
        tiktok     => 'TikTok',
        reddit     => 'Reddit',
        tumblr     => 'Tumblr',
        vk         => 'VK',
        mastodon   => 'Mastodon',
        bluesky    => 'Bluesky',
        telegram   => 'Telegram',
        discord    => 'Discord',
        devto      => 'Dev.to',
      };

  Color get brandColor => switch (this) {
        instagram => const Color(0xFFE84873),
        youtube   => const Color(0xFFFF0000),
        facebook  => const Color(0xFF1A57A6),
        threads   => Colors.black,
        pinterest => const Color(0xFFE80020),
        tiktok    => const Color(0xFF00F2F5),
        reddit    => const Color(0xFFFF4500),
        tumblr    => const Color(0xFF364458),
        vk        => const Color(0xFF4D73A6),
        mastodon  => const Color(0xFF5C6FF2),
        bluesky   => const Color(0xFF0086FF),
        telegram  => const Color(0xFF269ADA),
        discord   => const Color(0xFF5865F2),
        devto     => Colors.black,
      };

  IconData get icon => switch (this) {
        instagram => Icons.camera_alt,
        youtube   => Icons.play_circle_fill,
        facebook  => Icons.group,
        threads   => Icons.alternate_email,
        pinterest => Icons.push_pin,
        tiktok    => Icons.music_note,
        reddit    => Icons.forum,
        tumblr    => Icons.dashboard,
        vk        => Icons.people,
        mastodon  => Icons.public,
        bluesky   => Icons.cloud,
        telegram  => Icons.send,
        discord   => Icons.sports_esports,
        devto     => Icons.code,
      };

  ShareMode get shareMode => switch (this) {
        youtube   => ShareMode.video,
        instagram => ShareMode.clipboard,
        tiktok    => ShareMode.clipboard,
        discord   => ShareMode.clipboard,
        devto     => ShareMode.clipboard,
        _         => ShareMode.url,
      };

  // Returns a web intent URL for the post text, or null if not supported.
  String? shareUrl(String text) {
    final encoded = Uri.encodeComponent(text);
    return switch (this) {
      threads   => 'https://www.threads.net/intent/post?text=$encoded',
      bluesky   => 'https://bsky.app/intent/compose?text=$encoded',
      mastodon  => 'https://mastodon.social/share?text=$encoded',
      reddit    => 'https://www.reddit.com/submit?title=$encoded',
      facebook  => 'https://www.facebook.com/sharer/sharer.php?quote=$encoded&u=',
      pinterest => 'https://pinterest.com/pin/create/button/?description=$encoded',
      tumblr    => 'https://www.tumblr.com/widgets/share/tool?posttype=text&content=$encoded',
      vk        => 'https://vkontakte.ru/share.php?description=$encoded',
      telegram  => 'https://t.me/share/url?url=&text=$encoded',
      _         => null,
    };
  }

  // Native app URI scheme to open the app directly.
  String? get nativeScheme => switch (this) {
        instagram => 'instagram://',
        youtube   => 'youtube://',
        facebook  => 'fb://',
        threads   => 'barcelona://',
        pinterest => 'pinterest://',
        tiktok    => 'tiktok://',
        reddit    => 'reddit://',
        tumblr    => 'tumblr://',
        vk        => 'vk://',
        mastodon  => null,
        bluesky   => 'bluesky://',
        telegram  => 'tg://',
        discord   => 'discord://',
        devto     => null,
      };

  // Fallback web URL when native app is not installed.
  String get webUrl => switch (this) {
        instagram => 'https://www.instagram.com',
        youtube   => 'https://studio.youtube.com',
        facebook  => 'https://www.facebook.com',
        threads   => 'https://www.threads.net',
        pinterest => 'https://www.pinterest.com',
        tiktok    => 'https://www.tiktok.com',
        reddit    => 'https://www.reddit.com',
        tumblr    => 'https://www.tumblr.com',
        vk        => 'https://vk.com',
        mastodon  => 'https://mastodon.social',
        bluesky   => 'https://bsky.app',
        telegram  => 'https://web.telegram.org',
        discord   => 'https://discord.com/app',
        devto     => 'https://dev.to/new',
      };

  // Optional character limit for the composer warning.
  int? get characterLimit => switch (this) {
        bluesky  => 300,
        threads  => 500,
        mastodon => 500,
        reddit   => 40000,
        _        => null,
      };
}
