import 'package:autofystore_app/core/enums/viewstate.dart';
import 'package:autofystore_app/core/models/Product.dart';
import 'package:autofystore_app/core/services/WooCommerceService.dart';
import 'package:autofystore_app/core/viewmodels/ProductsByAttributeModel.dart';
import 'package:autofystore_app/locator.dart';
import 'package:autofystore_app/ui/shared/constants.dart';
import 'package:autofystore_app/ui/views/BaseView.dart';
import 'package:autofystore_app/ui/views/ProductGallery.dart';
import 'package:autofystore_app/ui/widgets/AutofyAppBar.dart';
import 'package:autofystore_app/ui/widgets/CircleProgressBar.dart';
import 'package:autofystore_app/ui/widgets/FooterBuyButtons.dart';
import 'package:autofystore_app/ui/widgets/ImageGallery.dart';
import 'package:autofystore_app/ui/widgets/StarRating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;


import 'package:flutter_html/flutter_html.dart';

class ProductView extends StatelessWidget {
  Product _product;
  int productId;

  ProductView(Product product) {
    this._product = product;
  }

  ProductView.fromProductId({this.productId});

  @override
  Widget build(BuildContext context) {
    /**/
   return BaseView<ProductsByAttributeModel>(
      onModelReady: (model)=>_product==null && null!=productId?model.getProductById(true, productId):model.product=_product,
      builder: (context,model,child)=>model.state==ViewState.Busy?
      new Container(
          color: Colors.white,
          child:Center(
          child:SizedBox(
          height: 60,
          child:CircleProgressBar(
          foregroundColor: Color(Constants.AutofyColor),
          value: 1.0)
      ))):
      new Scaffold(
        appBar: new AutofyAppBar(
          title: "Autofy",
        ),
        body: new ListView(
          children: <Widget>[
            new Container(
                height: 300.0,
                decoration: BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width,
                child: ImageGallery(model.product.images, _openImageGallery)),
            new SizedBox(height: 10),
            new Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    model.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Rs. ${model.product.regularPrice}",
                        style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 14),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Rs. ${model.product.salePrice}",
                        style: TextStyle(color: Colors.green,fontSize: 14),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _discount(model.product.regularPrice, model.product.salePrice),
                      SizedBox(
                        width: 10,
                      ),
                      StarRating(
                        rating: double.parse(model.product.averageRating),
                        size: 14.0,
                        ratingCount: model.product.ratingCount,
                      ),
                    ],
                  )
                ],
              ),
            ),
            new SizedBox(height: 10,),
            new Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Text("Description",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
                    alignment: Alignment.centerLeft,),
                  SizedBox(height: 10,),
                  Html(data:"""${formatDescription(model.product.description)}""",customTextAlign :(dom.Node node){
                    if (node is dom.Element) {
                      switch (node.localName) {
                        case "p":
                          return TextAlign.justify;
                      }
                    }
                    return null;
                  },)
                ],
              ),
            )
          ],
        ),
        persistentFooterButtons: <Widget>[
          FooterBuyButtons(model.product)
        ],
      )
    );
  }

  void _openImageGallery(int index, BuildContext context,List<String> images) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductGallery(images)));
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
        style: TextStyle(color: Colors.redAccent),
      );
    }
    return Text('');
  }

  String formatDescription(String description){
    description=description.replaceAll("<li>","<p>");
    description=description.replaceAll("<//li>","<//p>");
    description=description.replaceAll("<ul>","");
    description=description.replaceAll("<//ul>","");
    return description;
  }
}
