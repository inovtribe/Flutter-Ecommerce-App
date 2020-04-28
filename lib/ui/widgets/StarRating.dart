import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget{
  int rating=0;
  double size;
  final int ratingCount;

  StarRating({rating:"rating",size:"size",this.ratingCount}){
    if(rating!= null && rating>0) {
      this.rating = rating.round();
    }else{
      rating=0;
    }

    this.size=size;
  }

  @override
  Widget build(BuildContext context) {
    int unfilledStar=5-rating;
    List<Widget> starList=[];
    for(var i=0;i<rating;i++){
        starList.add(new Icon(EvaIcons.star,color: Colors.amber,size: size,));
    }
    for(var i=0;i<unfilledStar;i++){
      starList.add(new Icon(EvaIcons.starOutline,size: size));
    }
    starList.add(new Text("(${ratingCount})"));
    return Wrap(
      children:starList,
    );
  }

}