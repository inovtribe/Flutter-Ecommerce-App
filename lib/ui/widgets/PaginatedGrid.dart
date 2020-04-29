import 'package:autofystore_app/core/models/Product.dart';
import 'package:autofystore_app/core/services/WooCommerceService.dart';
import 'package:autofystore_app/ui/shared/constants.dart';
import 'package:autofystore_app/ui/views/ProductView.dart';
import 'package:autofystore_app/ui/widgets/CircleProgressBar.dart';
import 'package:autofystore_app/ui/widgets/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class PaginatedGrid extends StatefulWidget {
  final String attributeType;
  final int attributeId;
  final int perPage;

  PaginatedGrid({this.perPage = 6, this.attributeType, this.attributeId});

  @override
  State<StatefulWidget> createState() {
    return new PaginatedGridState(
        attributeType: attributeType, attributeId: attributeId);
  }
}

class PaginatedGridState extends State<PaginatedGrid> {
  ScrollController controller;
  bool isLoading = false;
  WooCommerceService _wooCommerceService = locator<WooCommerceService>();
  List<Product> productsList = [];
  int pageNumber = 0;
  final String attributeType;
  final int attributeId;
  final int perPage;
  bool isFetchMore=true;

  PaginatedGridState({this.perPage = 6, this.attributeType, this.attributeId});

  @override
  void initState() {
    super.initState();

    startLoader();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      if(isFetchMore) {
        startLoader();
      }
    }
  }

  void startLoader() async {


    setState(() {
      isLoading = !isLoading;
      fetchData();
    });
  }

  fetchData() async {
    pageNumber = pageNumber + 1;

    List<Product> products = await _wooCommerceService.getProductsByAtrribute(
        page: pageNumber,
        id: attributeId,
        count: perPage,
        attributeType: attributeType);

    setState(() {
      isLoading = !isLoading;
      productsList.addAll(products);

      if (productsList != null && productsList.length > 0) {
        if (productsList[0].totalProducts == productsList.length) {
             isFetchMore=false;
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[_buildGrid(), _loader()],
    );
  }

  Widget _buildGrid() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return GridView.count(
        crossAxisCount: 2,
        controller: controller,
        childAspectRatio: (itemWidth / itemHeight),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(productsList.length, (index) {
          return GestureDetector(
            child: _buildCell(productsList[index]),
            onTap: () => Navigator.push(
                context, CupertinoPageRoute(builder:(buildContext)=>ProductView(productsList[index]))),
          );
        }));
  }

  Widget _buildCell(Product product) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        border: Border.all(width: 0.2,style: BorderStyle.solid,color: Colors.grey),
        color: Colors.white
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl:product.images[0],
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),),
            ),
            flex: 2,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    product.name,
                    style: TextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Rs ${product.regularPrice}",
                          style: TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          "Rs ${product.salePrice}",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 14),
                        ),
                        flex: 1,
                      )
                      ,
                      Expanded(
                        child: _discount(product.regularPrice,product.salePrice),
                        flex: 1,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: StarRating(
                    rating: double.parse(product.averageRating),
                    size: 15.0,
                    ratingCount: product.ratingCount,
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _loader() {
    return isLoading
        ? new Align(
            child: new Container(
              width: 70.0,
              height: 70.0,
              child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Center(
                    child: new SizedBox(
                      height: 40,
                    child:new CircleProgressBar(
                    foregroundColor: Color(Constants.AutofyColor),
                    value: 1.0,
                    backgroundColor: Colors.grey,
                    animationDuration: Duration(seconds: 1),)
                  ))
              ),
            ),
            alignment: FractionalOffset.bottomCenter,
          )
        : new SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Widget _discount(String regularPrice, String salePrice) {
    if ((null != regularPrice && regularPrice.isNotEmpty) &&
        (null != salePrice && salePrice.isNotEmpty)) {
      double discount =
          ((double.parse(regularPrice) - double.parse(salePrice)) /
              double.parse(regularPrice)) *
              100;
      return Text(
        "(${discount.round()}% OFF)",
        style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 12),
      );
    }
    return Text('');
  }
}
