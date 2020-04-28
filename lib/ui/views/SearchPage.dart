import 'dart:async';

import 'package:autofystore_app/core/enums/viewstate.dart';
import 'package:autofystore_app/core/models/Product.dart';
import 'package:autofystore_app/core/services/SearchService.dart';
import 'package:autofystore_app/core/viewmodels/SearchModel.dart';
import 'package:autofystore_app/locator.dart';
import 'package:autofystore_app/ui/shared/constants.dart';
import 'package:autofystore_app/ui/views/BaseView.dart';
import 'package:autofystore_app/ui/views/ProductView.dart';
import 'package:autofystore_app/ui/widgets/CircleProgressBar.dart';
import 'package:autofystore_app/ui/widgets/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/constants.dart';

class SearchPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new SearchPageState();
  }

}

class SearchPageState extends State<SearchPage>{
  final _searchTextContoller=TextEditingController();
  var searchQuery="";
  List<Product> productList;
  SearchService _searchService=locator<SearchService>();
  bool isLoading=false;
  bool isNoResult=false;
  Map<Function, Timer> _timeouts = {};


  @override
  void initState() {
    super.initState();
    _getSearchResults("");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new TextField(
            autofocus: true,
            //controller: _searchTextContoller,
            decoration: InputDecoration(hintText: 'Search..'),
            onEditingComplete: (){},
            onChanged: (val) => debounce(const Duration(milliseconds: 1000), _getSearchResults, [val]),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          _buildResultsGrid(productList),
          _loader(),
        ],
      )
    );
  }

  _loader(){
    if(isLoading){
     return new Center(
          child: new SizedBox(
              height: 40,
              child:new CircleProgressBar(
                foregroundColor: Color(Constants.AutofyColor),
                value: 1.0,
                backgroundColor: Colors.grey,
                animationDuration: Duration(seconds: 1),)
          ));
    }else{
      return new SizedBox(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  _getSearchResults(String text) async{
    var query=text;
    if(query!=null && query!="") {
      setState(() {
        isLoading=!isLoading;
      });
      List<Product> productsList=await _searchService.getSearchResults(text);
      setState(() {
        productList=[];
        if(productsList!=null && productsList.length>0) {
          productList.addAll(productsList);
        }else{
          isNoResult=true;
        }
        isLoading=!isLoading;
      });
    }else{
      setState(() {
        isNoResult=false;
        productList=[];
      });
    }
  }

  @override
  void dispose() {
    _searchTextContoller.dispose();
    super.dispose();
  }

  Widget _buildResultsGrid(List<Product> productsList){
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 60) / 2;
    final double itemWidth = size.width / 2;
    var widget;
    if(productsList!=null && productsList.length>0) {
      widget = new Container(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
          children: List.generate(productsList.length, (index) {
            return new GestureDetector(
              child: _buildCell(productsList[index]),
              onTap: () {
                Navigator.push(context, new CupertinoPageRoute(
                    builder: (context) =>ProductView.fromProductId(productId: productsList[index].id,)));
              },
            );
          }),
        ),
      );
    }else{
      if(!isLoading){
        if(isNoResult){
          widget=new Center(
            child: Text(
                "No Results Found!",
                style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontFamily: 'Open Sans'
            )
            ),
          );
        }else {
          widget = new Center(
            child: Text(
              "What can we do for you today?",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 18,
                   fontFamily: 'Open Sans'
               ),
            ),
          );
        }
      }else{
        return new SizedBox(height: 0,width: 0);
      }
    }
    return widget;
  }

  Widget _buildCell(Product product){
    return new Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 0.2,style: BorderStyle.solid),
        color: Colors.white
      ),
      child: new Column(
        children: <Widget>[
          AspectRatio(
            child: CachedNetworkImage(
              imageUrl: product.images[0],
            ),
            aspectRatio: 1,
          ),
          SizedBox(height: 10,),
          Container(
            child: new Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Text(
                "Rs ${product.regularPrice}",
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              SizedBox(width: 10,),
              Text(
                "Rs ${product.salePrice}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
          alignment: Alignment.centerLeft,
          child: StarRating(
            ratingCount: product.ratingCount,
            rating: double.parse(product.averageRating),
            size: 15.0,
          )
          )
        ],
      ),
    );
  }

  void debounce(Duration timeout, Function target, [List arguments = const []]) {
    if (_timeouts.containsKey(target)) {
      _timeouts[target].cancel();
    }

    Timer timer = Timer(timeout, () {
      Function.apply(target, arguments);
    });

    _timeouts[target] = timer;
  }

}