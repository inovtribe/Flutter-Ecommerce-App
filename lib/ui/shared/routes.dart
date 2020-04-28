import 'package:autofystore_app/ui/views/ProductView.dart';
import 'package:autofystore_app/ui/views/ProductCategories.dart';
import 'package:flutter/material.dart';
import 'package:autofystore_app/ui/shared//constants.dart';

class Routes {

  static final routes = <String, WidgetBuilder>{
    Constants.ROUTE_CATEGORIES: (BuildContext context) =>
        ProductCategories(),
    /*Constants.ROUTE_PRODUCT: (BuildContext context) =>
        ProductView(),*/
  };

}