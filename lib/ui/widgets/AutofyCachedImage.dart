
import 'package:autofystore_app/ui/shared/CustomCacheManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class AutofyCachedImage extends WidgetParser{
  @override
  bool forWidget(String widgetName) {
    return "AutofyCachedImage" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener listener){
    String src=map['src'];
    CustomCacheManager cacheManager=new CustomCacheManager();
    double width=map.containsKey('width')?map['width']:MediaQuery.of(buildContext).size.width;
    double height=map.containsKey('height')?map['height']:null;
    String fit=map.containsKey('fit')?map['fit']:null;
    BoxFit boxFit;
    if(null!=fit){
      if(fit=="fill"){
        boxFit=BoxFit.fill;
      }
    }
    return CachedNetworkImage(
      imageUrl: src,
      cacheManager: cacheManager,
      placeholder: (context,url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      height: height,
      //width: width,
      fit: boxFit
    );
  }


}