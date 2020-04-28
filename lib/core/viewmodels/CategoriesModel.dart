import 'package:autofystore_app/core/enums/viewstate.dart';
import 'package:autofystore_app/core/models/Category.dart';
import 'package:autofystore_app/core/services/WooCommerceService.dart';
import 'package:autofystore_app/core/viewmodels/BaseModel.dart';

import '../../locator.dart';

class CategoriesModel extends BaseModel{
  WooCommerceService _wooCommerceService=locator<WooCommerceService>();
  List<Category> categories;

  Future getCategories() async{
    setState(ViewState.Busy);
    categories=await _wooCommerceService.getCategories();
    setState(ViewState.Idle);
  }

}