import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:project_v1/Widgets/app_drawer.dart';

class Alerts extends StatelessWidget {
  const Alerts({super.key});

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color(0xFFDDF4FC),
        endDrawer: const AppDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'لا توجد تنبيهات حاليًا',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
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
