import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/my_report_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:project_v1/Widgets/app_drawer.dart';
import 'package:project_v1/Widgets/View_Widgets/MyReportWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyReport extends StatelessWidget {
  const MyReport({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyReportController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }

        Get.defaultDialog(
          title: 'تأكيد الخروج',
          content: const SizedBox(
            width: 380,
            child: Text(
              'هل أنت متأكد من الخروج من التطبيق؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
            ),
          ),
          backgroundColor: const Color(0xFFDDF4FC),
          textConfirm: 'نعم',
          buttonColor: const Color(0xff32b34a),
          textCancel: 'إلغاء',
          onConfirm: () {
            Get.back();
            SystemNavigator.pop();
          },
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFDDF4FC),
        endDrawer: const AppDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final reports = controller.reports;

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
                              const SizedBox(height: 5),
                              if (data['createdAt'] is Timestamp)
                                Text(
                                  'تاريخ الإنشاء: ${formatDate((data['createdAt'] as Timestamp).toDate())}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
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

              Positioned(
                top: 18,
                left: 4,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30,
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.addReport);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
