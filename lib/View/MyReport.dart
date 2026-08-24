import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_v1/Widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class MyReport extends StatelessWidget {
  const MyReport({super.key});

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('userPhone');
    if (phone == null || phone.isEmpty) return [];

    final ref = FirebaseFirestore.instance.collection('reports');
    final snapshot = await ref.where('userPhone', isEqualTo: phone).get();
    final now = DateTime.now();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final expiry = data['expiresAt'];

      if (data['status'] == 'مسودة' &&
          expiry is Timestamp &&
          !expiry.toDate().isAfter(now)) {
        await doc.reference.update({
          'status': 'جديد',
          'finalizedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    final refreshed = await ref.where('userPhone', isEqualTo: phone).get();
    final docs = refreshed.docs.toList();

    docs.sort((a, b) {
      final at =
          (a.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final bt =
          (b.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      return bt.compareTo(at);
    });

    return docs.where((d) => d.data()['status'] == 'جديد').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF4FC),

      endDrawer: const AppDrawer(),

      body: SafeArea(
        child: Stack(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                future: _loadReports(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('تعذر تحميل البلاغات: ${snapshot.error}'),
                    );
                  }

                  final reports = snapshot.data ?? [];

                  if (reports.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد بلاغات مرسلة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 65, 18, 18),
                    itemCount: reports.length,
                    itemBuilder: (_, index) {
                      final data = reports[index].data();
                      final status = data['status']?.toString() ?? 'غير معروف';
                      final isNew = status == 'جديد';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['reportType']?.toString() ?? 'بلاغ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isNew
                                          ? const Color(0xffe7f7eb)
                                          : const Color(0xfffff4df),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: isNew
                                            ? const Color(0xff20883a)
                                            : Colors.orange.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if ((data['description']?.toString() ?? '')
                                  .isNotEmpty)
                                Text(
                                  data['description'].toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                'رقم البلاغ: ${reports[index].id.substring(0, 8)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (data['createdAt'] is Timestamp)
                                Text(
                                  'تاريخ الإنشاء: ${_formatDate((data['createdAt'] as Timestamp).toDate())}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Positioned(
              top: 18,
              right: 4,
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  iconSize: 30,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
