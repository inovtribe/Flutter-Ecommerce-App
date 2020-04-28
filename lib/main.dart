import 'package:autofystore_app/ui/views/ProductCategories.dart';
import 'package:autofystore_app/ui/shared//constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autofystore_app/ui/views/home_page.dart';
import 'locator.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white
  ));

  setupLocator();
  runApp(AutofyApp());
}

class AutofyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Autofy',
      theme: ThemeData(
          /*primaryColor: const Color(0xffdf0145)*/
            primaryColor: Colors.white
      ),
      home: HomePage(),
      routes: {
        Constants.ROUTE_CATEGORIES:(context) => ProductCategories(),
       // Constants.ROUTE_PRODUCT:(context)=> ProductView(),
       // Constants.ROUTE_PRODUCT_GALLERY:(context)=> ProductGallery()
      },
    );
  }
}

