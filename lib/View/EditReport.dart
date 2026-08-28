import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/edit_report_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:project_v1/Widgets/View_Widgets/EditReportWidgets.dart';
import 'package:project_v1/Widgets/app_drawer.dart';

class Editreport extends StatelessWidget {
  const Editreport({super.key});

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color(0xFFDDF4FC),
        endDrawer: const AppDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              GetBuilder<EditReportController>(
                builder: (c) {
                  if (c.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (c.reports.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا يوجد بلاغ متاح للتعديل',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'تعديل البلاغات',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 18),

                          selector(c),

                          const SizedBox(height: 18),

                          form(context, c),
                        ],
                      ),
                    ),
                  );
                },
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
