import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/add_report_controller.dart';
import 'package:project_v1/Widgets/app_drawer.dart';
import 'package:project_v1/Widgets/View_Widgets/AddReportWidgets.dart';

class Addreport extends StatelessWidget {
  const Addreport({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddReportController>();

    return GetBuilder<AddReportController>(
      builder: (_) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

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

              backgroundColor: Color(0xFFDDF4FC),
              textConfirm: 'نعم',
              buttonColor: Color(0xff32b34a),
              textCancel: 'إلغاء',
              onConfirm: () {
                Get.back();
                SystemNavigator.pop();
              },
            );
          },
          child: Scaffold(
            backgroundColor: background,
            endDrawer: const AppDrawer(),
            body: SafeArea(
              child: Stack(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'إضافة بلاغ جديد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: textDark,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'أدخل بيانات البلاغ ثم أرسله',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 28),

                          sectionTitle('نوع البلاغ'),
                          const SizedBox(height: 8),
                          buildReportType(controller),

                          const SizedBox(height: 22),

                          sectionTitle('موقع البلاغ'),
                          const SizedBox(height: 8),
                          buildLocation(controller),

                          const SizedBox(height: 22),

                          sectionTitle('الملاحظات'),
                          const SizedBox(height: 8),
                          buildNotes(controller),

                          const SizedBox(height: 22),

                          sectionTitle('صور البلاغ'),
                          const SizedBox(height: 8),
                          buildImages(context, controller),

                          const SizedBox(height: 45),

                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () async {
                                      await controller.submitReport();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                disabledBackgroundColor: green.withValues(
                                  alpha: .55,
                                ),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(radius),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'إبلاغ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // زر فتح الدراور
                  Positioned(
                    top: 18,
                    right: 4,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        iconSize: 30,
                        color: textDark,
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
