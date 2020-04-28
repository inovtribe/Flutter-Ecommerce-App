import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageGallery extends StatelessWidget{

  List<String> _imageUrls;
  Function _onImageTap;

  ImageGallery(List<String> images,Function onImageTap){
    if(onImageTap==null){
      this._onImageTap=(){};
    }else {
      this._onImageTap = onImageTap;
    }
    if(null!=images && images.length>0){
      this._imageUrls=images;
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Carousel(
      autoplay: false,
      indicatorBgPadding: 5.0,
      dotIncreasedColor: Colors.deepOrange,
      dotColor: Colors.black26,
      dotSize: 5.0,
      dotIncreaseSize: 1.5,
      dotBgColor: Colors.white,
      images: _buildImageCarousel(_imageUrls),
      onImageTap: (i)=>_onImageTap(i,context,_imageUrls),
    );
  }

  List<Widget> _buildImageCarousel(List<String> images){
    List<Widget> imageWidgets=[];
    if(images!=null && images.length>0){
      images.forEach((imageUrl){
        imageWidgets.add(AspectRatio(
          aspectRatio: 1,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder:(context,url)=>Center(child: CircularProgressIndicator(),),),
        ));
      });

      return imageWidgets;
    }

    return null;
  }

}