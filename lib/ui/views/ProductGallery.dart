import 'package:autofystore_app/ui/widgets/AutofyAppBar.dart';
import 'package:autofystore_app/ui/widgets/ImageGallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductGallery extends StatelessWidget{

  List<String> _images;

  ProductGallery(List<String> images){
      this._images=images;
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: new AutofyAppBar(title:"Autofy",),
      body:Container(
      decoration: BoxDecoration(color: Colors.white),
      height: height*0.9,
      width: width,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ImageGallery(_images,null)
    )
    );
  }

}