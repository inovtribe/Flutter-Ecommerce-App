import 'package:autofystore_app/core/database/DatasbaseHelper.dart';

class Product{
  int id;
  String name;
  String sku;
  String regularPrice;
  String salePrice;
  String taxClass;
  String stockStatus;
  String description;
  int stock;
  List<int> relatedIds;
  List<String> images;
  String averageRating;
  int ratingCount;
  int isFromCache;
  int totalProducts;

  Product();

  Product.fromJson(Map<String, dynamic> json,int total) {
    images=[];
    id=json['id'];
    name = json['name'];
    sku = json['sku'];
    regularPrice = json['regular_price'];
    salePrice=json['sale_price'];
    taxClass=json['tax_class'];
    stockStatus=json['stock_status'];
    description=json['short_description'];
    if(json['stock_quantity']!=null) {
      stock = json['stock_quantity'];
    }else{
      stock=0;
    }
    relatedIds=json['related_ids'].cast<int>();
    List<dynamic> imagesArray=json['images'] as List;
    for(var i=0;i<imagesArray.length;i++){
      images.add(imagesArray[i]['src']);
    }
    averageRating=json['average_rating'];
    ratingCount=json['rating_count'];
    isFromCache=0;
    totalProducts=total;
  }

  static fromMap(Map map){
    Product product=new Product();
    product.id=map[DatabaseHelper.productId];
    product.name=map[DatabaseHelper.productName];
    product.description=map[DatabaseHelper.productDescription];
    product.sku=map[DatabaseHelper.productSku];
    product.regularPrice=map[DatabaseHelper.productRegularPrice];
    product.salePrice=map[DatabaseHelper.productSalePrice];
    product.stockStatus=map[DatabaseHelper.productStockStatus];
    product.stock=map[DatabaseHelper.productStock];
    product.images=map[DatabaseHelper.productImages].toString().split(",");
    if(map[DatabaseHelper.productRelatedIds]!=null) {
      product.relatedIds =
          map[DatabaseHelper.productRelatedIds].split(",").cast<int>();
    }
    product.averageRating=map[DatabaseHelper.productAverageRating];
    product.ratingCount=map[DatabaseHelper.productRatingCount];
    product.isFromCache=1;
    return product;
  }

  static fromSearch(Map map){
    Product product=new Product();
    product.id=map['post_id'];
    product.ratingCount=map['rating_count'];
    product.salePrice=map['sale_price'].toString();
    product.regularPrice=map['regular_price'].toString();
    product.averageRating=map['average_rating'].toString();
    product.name=map['post_title'];
    product.images=[map['images']['shop_catalog']['url']];
    product.description=map['content'];
    product.isFromCache=0;
    return product;
  }
}