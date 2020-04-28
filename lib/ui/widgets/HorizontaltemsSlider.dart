import 'package:autofystore_app/core/models/horizontal_slider_item.dart';
import 'package:autofystore_app/ui/shared/constants.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HorizontalItemsSlider extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "HorizontalItemsSlider" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    List<dynamic> children = map['children'];
    double itemHeight = map['itemHeight'];
    var widget = new Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: itemHeight + 35.0,
      child: new Card(
          child: new ListView.builder(
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              itemCount: children.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                HorizontalSliderItem item =
                    HorizontalSliderItem.fromJson(children.elementAt(index));
                return Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, Constants.ROUTE_CATEGORIES);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Container(
                            child: new ClipRRect(
                              child: new CachedNetworkImage(
                                  imageUrl: item.imageSrc),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: itemHeight,
                          ),
                          new Text(
                            item.title,
                            style: new TextStyle(
                                //fontFamily: 'Raleway',
                                fontSize: 10),
                          )
                        ],
                      ),
                    ));
              })),
    );
    return widget;
  }
}
