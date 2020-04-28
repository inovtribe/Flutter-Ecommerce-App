import 'package:autofystore_app/core/models/Product.dart';
import 'package:autofystore_app/core/services/WooCommerceService.dart';
import 'package:autofystore_app/core/viewmodels/BaseModel.dart';
import 'package:autofystore_app/core/enums/viewstate.dart';

import '../../locator.dart';

class ProductsByAttributeModel extends BaseModel{

  WooCommerceService _wooCommerceService=locator<WooCommerceService>();
  List<Product> productsList;
  Product product;

  Future getProductsByTag(int tagId,int itemCount) async{
    setState(ViewState.Busy);
    productsList=await _wooCommerceService.getProductsByAtrribute(
        attributeType: "tag",
        count: itemCount,
        id: tagId,
        page: 1
    );

    setState(ViewState.Idle);
  }

  Future getProductById(bool cacheFirst,int productId) async{
    setState(ViewState.Busy);
    product= await _wooCommerceService.getProductById(cacheFirst, productId);
    setState(ViewState.Idle);
  }

}