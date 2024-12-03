import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subcultures/utils/getx_controller/post_controller.dart';
import 'package:subcultures/routes/routes.dart';

class Subcultures extends StatelessWidget {
  const Subcultures({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PostController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff171C28),
          textTheme: const TextTheme(
              bodyMedium: TextStyle(
            color: Colors.white,
          ))),
      getPages: Routes.pages,
      initialRoute: RoutePath.launch,
    );
  }
}
