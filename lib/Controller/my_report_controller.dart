import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReportController extends GetxController {
  final reports = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('userPhone');

      if (phone == null || phone.isEmpty) {
        reports.clear();
        return;
      }

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

      reports.assignAll(
        docs.where((d) => d.data()['status'] == 'جديد').toList(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
