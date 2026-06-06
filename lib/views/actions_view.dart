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
    final pad = context.hPad;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: Text('Aksiyon Merkezi')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, topPad, pad, bottomPad),
        children: [
          StaggeredItem(
            index: 0,
            child: _GlassSectionCard(
              icon: Icons.lightbulb_outline_rounded,
              iconColor: const Color(0xFF60A5FA),
              title: 'İçgörüler',
              children: [
                _GlassListItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF60A5FA),
                  title: 'Yeterli veri bekleniyor',
                  subtitle:
                      'Daha fazla veri toplandıkça içgörüler görünecek.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          StaggeredItem(
            index: 1,
            child: _GlassSectionCard(
              icon: Icons.checklist_rounded,
              iconColor: const Color(0xFF34D399),
              title: 'Yapılacak Aksiyonlar',
              children: [
                _GlassListItem(
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF34D399),
                  title: 'Tüm aksiyonlar tamamlandı',
                  subtitle:
                      'Hesaplarınız tarandıkça yeni öneriler eklenecek.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          StaggeredItem(
            index: 2,
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
                      'Tüm aksiyonları kendiniz gerçekleştirirsiniz. '
                      'Bu, platformların kullanım koşullarına uygunluğu garanti eder.',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
    );
  }
}

class _GlassListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _GlassListItem({
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
