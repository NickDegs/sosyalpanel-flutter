import 'package:flutter/material.dart';
import '../theme/liquid_glass.dart';
import '../utils/adaptive.dart';
import '../utils/animations.dart';

class ActionsView extends StatelessWidget {
  const ActionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 16;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: Text('İçerik Önerileri')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(context.hPad, topPad, context.hPad, bottomPad),
        children: [
          StaggeredItem(
            index: 0,
            child: _GlassSectionCard(
              icon: Icons.schedule_rounded,
              iconColor: const Color(0xFF60A5FA),
              title: 'En İyi Paylaşım Saatleri',
              children: const [
                _TipItem(
                  icon: Icons.camera_alt,
                  iconColor: Color(0xFFE84873),
                  title: 'Instagram',
                  subtitle: 'Salı–Cuma, 09:00–11:00 ve 18:00–20:00',
                ),
                _TipItem(
                  icon: Icons.alternate_email,
                  iconColor: Colors.black,
                  title: 'Threads',
                  subtitle: 'Hafta içi sabahları 08:00–10:00',
                ),
                _TipItem(
                  icon: Icons.forum,
                  iconColor: Color(0xFFFF4500),
                  title: 'Reddit',
                  subtitle: 'Pazartesi–Cuma, 08:00–12:00 (EST)',
                ),
                _TipItem(
                  icon: Icons.cloud,
                  iconColor: Color(0xFF0086FF),
                  title: 'Bluesky',
                  subtitle: 'Hafta içi öğle arası 12:00–14:00',
                ),
                _TipItem(
                  icon: Icons.public,
                  iconColor: Color(0xFF5C6FF2),
                  title: 'Mastodon',
                  subtitle: 'Akşamları 19:00–22:00',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          StaggeredItem(
            index: 1,
            child: _GlassSectionCard(
              icon: Icons.lightbulb_outline_rounded,
              iconColor: const Color(0xFFFBBF24),
              title: 'İçerik Fikirleri',
              children: const [
                _TipItem(
                  icon: Icons.question_answer_outlined,
                  iconColor: Color(0xFF34D399),
                  title: 'Soru-Cevap',
                  subtitle: 'Takipçilerinize soru sorun, etkileşim artar.',
                ),
                _TipItem(
                  icon: Icons.format_list_numbered_rounded,
                  iconColor: Color(0xFF60A5FA),
                  title: 'Top 5 / Top 10 Listeleri',
                  subtitle: 'Liste formatındaki içerikler daha çok paylaşılır.',
                ),
                _TipItem(
                  icon: Icons.tips_and_updates_outlined,
                  iconColor: Color(0xFFFBBF24),
                  title: 'Kısa İpuçları',
                  subtitle: 'Alanınızda 1 cümlelik hızlı ipuçları paylaşın.',
                ),
                _TipItem(
                  icon: Icons.history_rounded,
                  iconColor: Color(0xFFA78BFA),
                  title: 'Geçmişe Bakış',
                  subtitle: 'Bu gün X yıl önce ne oldu? formatı ilgi çeker.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          StaggeredItem(
            index: 2,
            child: _GlassSectionCard(
              icon: Icons.tag_rounded,
              iconColor: const Color(0xFF34D399),
              title: 'Hashtag Stratejisi',
              children: const [
                _TipItem(
                  icon: Icons.looks_3_outlined,
                  iconColor: Color(0xFF34D399),
                  title: 'Instagram: 3–5 hashtag',
                  subtitle: 'Çok fazla hashtag görünürlüğü düşürebilir.',
                ),
                _TipItem(
                  icon: Icons.looks_two_outlined,
                  iconColor: Color(0xFF60A5FA),
                  title: 'Threads: 1–2 hashtag',
                  subtitle: 'Platformun algoritması az hashtag tercih eder.',
                ),
                _TipItem(
                  icon: Icons.tag_outlined,
                  iconColor: Color(0xFF5C6FF2),
                  title: 'Mastodon: Konu bazlı',
                  subtitle: 'Toplulukla alakalı spesifik hashtagler kullanın.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          StaggeredItem(
            index: 3,
            child: GlassContainer(
              borderRadius: 16,
              tint: const Color(0x0FFFFFFF),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: LiquidGlass.textSecondary(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Bu uygulama hesaplarınızda otomatik aksiyon ALMAZ. '
                      'Tüm paylaşımları kendiniz gerçekleştirirsiniz. '
                      'Platform kullanım koşullarına tam uyum.',
                      style: TextStyle(
                        fontSize: 12,
                        color: LiquidGlass.textSecondary(context),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassSectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;

  const _GlassSectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(4),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 14, color: iconColor),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: LiquidGlass.textSecondary(context),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ...children,
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _TipItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: LiquidGlass.textPrimary(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: LiquidGlass.textSecondary(context),
          fontSize: 12,
        ),
      ),
    );
  }
}
