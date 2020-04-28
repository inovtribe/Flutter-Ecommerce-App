import 'package:algolia/algolia.dart';
import 'package:autofystore_app/core/database/DatasbaseHelper.dart';
import 'package:autofystore_app/core/models/Category.dart';
import 'package:autofystore_app/core/models/Product.dart';
import 'package:autofystore_app/core/services/SearchService.dart';
import 'package:http/http.dart';
import 'dart:convert';



class WooCommerceService{
  static const endpoint = 'https://autofystore.com/wp-json/wc/v3';
  var _key="ck_728bece48c2a0f04029e523f6b47e040eca5dc25";
  var _secret="cs_10dbc9623bf2a6dd19554a886ab5f6420a930174";
  var authToken;
  final db=DatabaseHelper.instance;

  WooCommerceService(){
    this.authToken =
        'Basic ' + base64Encode(utf8.encode('$_key:$_secret'));
  }

  Map<String,String> getHeaders(){
    Map<String,String> headers={'Authorization':authToken,'Content-Type':'application/json'};
    return headers;
  }


  Future<List<Product>> getProductsByAtrribute({int id,int count,int page=1,String attributeType}) async{
    List<Product> products=[];
    String suffix;
    String url;
    int totalProducts;

    if(null!=attributeType){
      if(attributeType=="tag"){
        suffix="t";
        url=endpoint + "/products?tag=$id&per_page=$count&page=$page";
      }else{
        suffix="c";
        url=endpoint + "/products?category=$id&per_page=$count&page=$page";
      }
    }
    //check local db first for products
    if(page==1) {
      products = await db.getProductsByAttribute("$id" + suffix,count);
    }
    if(products!=null && products.length>0){
      return products;
    }else {
      products=[];
      Response response = await get(
          url,
          headers: getHeaders());
      List<dynamic> productList = json.decode(response.body);

      for(var header in response.headers.entries){
        if(header.key=="x-wp-total"){
          totalProducts=int.parse(header.value);
          break;
        }
      }

      productList.forEach((product) {
        var parsedProduct = Product.fromJson(product,totalProducts);
        products.add(parsedProduct);
      });


      //save products retreived from network
      db.saveProducts(products, "$id"+suffix);
      return products;
    }
  }

  Future<Product> getProductById(bool cacheFirst,int productId) async{
    bool isProductFoundInCache=false;
    Product product;

    if(cacheFirst){
      product=await db.getProductById(productId);
      if(product!=null){
        isProductFoundInCache=true;
      }
    }

    if(isProductFoundInCache==false || !cacheFirst)
    {
      Response response = await get(
          endpoint + "/products/$productId",
          headers: getHeaders());
     dynamic productJson= json.decode(response.body);
     if(null!=productJson && productJson['id']!=null) {
       product = Product.fromJson(productJson,1);
     }

    }

    return product;
  }

  Future<List<Category>> getCategories() async{
    List<Category> categories=[];
    categories=await db.getAllCategories();
    if(categories!=null && categories.length>0){
      return categories;
    }else {
      Response response = await get(
          endpoint + "/products/categories?hide_empty=true",
          headers: getHeaders());
      List<dynamic> categoryList = json.decode(response.body);
      if (null != categoryList && categoryList.length > 0) {
        categoryList.forEach((category) {
          var parsedCategory = Category.fromJson(category);
          categories.add(parsedCategory);
        });
      }
      db.saveCategories(categories);
      return categories;
    }
  }


}