import 'package:flutter/material.dart';

class ActionsView extends StatelessWidget {
  const ActionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aksiyon Merkezi')),
      body: ListView(
        children: [
          const _SectionHeader('İçgörüler'),
          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.blue),
            title: Text('Yeterli veri bekleniyor'),
            subtitle: Text('Daha fazla veri toplandıkça içgörüler görünecek.'),
          ),
          const Divider(),
          const _SectionHeader('Yapılacak Aksiyonlar'),
          const ListTile(
            leading: Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text('Tüm aksiyonlar tamamlandı'),
            subtitle: Text('Hesaplarınız tarandıkça yeni öneriler eklenecek.'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'ℹ️ Bu uygulama hesaplarınızda otomatik aksiyon ALMAZ. '
              'Tüm aksiyonları kendiniz gerçekleştirirsiniz. '
              'Bu, platformların kullanım koşullarına uygunluğu garanti eder.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
    );
  }
}
