import 'package:autofystore_app/core/enums/viewstate.dart';
import 'package:autofystore_app/core/viewmodels/ProductsByAttributeModel.dart';
import 'package:autofystore_app/ui/shared/constants.dart';
import 'package:autofystore_app/ui/views/BaseView.dart';
import 'package:autofystore_app/ui/views/ProductView.dart';
import 'package:autofystore_app/ui/widgets/CircleProgressBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';


class FocusedProductGrid extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "FocusedProductGrid" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    int color = int.parse(map['color']);
    int count = map['count'];
    String attributeType = map['attributeType'];
    int attributeId = map['attributeId'];
    String title = map['title'];

    return BaseView<ProductsByAttributeModel>(
      onModelReady: (model)=> attributeType=="tag"? model.getProductsByTag(attributeId, count):null,
      builder: (buildContext,model,child)=>model.state==ViewState.Busy
      ? Center(child: SizedBox(
          height: 60,
          child:CircleProgressBar(
        foregroundColor: Color(Constants.AutofyColor),
        value: 1.0,
        backgroundColor: Colors.grey,
        animationDuration: Duration(seconds: 1),)
      ))
      : model.productsList!=null && model.productsList.length>0
        ?Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(color), Colors.white],
                  stops: [0.9, 0.1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Card(
                //elevation: 5.0,
                  child: new GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      physics: ScrollPhysics(),
                      children:
                      List.generate(model.productsList.length, (index) {
                        return GestureDetector(
                            onTap: () => Navigator.push(
                                buildContext, CupertinoPageRoute(builder:(buildContext)=>ProductView(model.productsList[index]))), //print(model.productsList[index].sku),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.2)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                        child: AspectRatio(
                                          aspectRatio: 1.0,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            model.productsList[index].images.first,
                                            // width: MediaQuery.of(buildContext).size.width,
                                            // fit: BoxFit.fill,
                                          ),
                                        )),
                                    flex: 2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(model.productsList[index].name,
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Open Sans',
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Align(
                                              child: Row(
                                                children: <Widget>[
                                                  Text("Rs "+
                                                      model.productsList[index].regularPrice,
                                                    style: TextStyle(decoration: TextDecoration.lineThrough),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Text("Rs "+
                                                      model.productsList[index]
                                                          .salePrice,
                                                    style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              alignment:
                                              Alignment.centerLeft,
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            5.0, 2.0, 5.0, 0)),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            )
                        );
                      })))
            ],
          )
      ):Text("Could not load products,check your internet connection!")
    );
}}
