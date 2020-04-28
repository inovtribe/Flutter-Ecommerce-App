import 'package:autofystore_app/ui/views/SearchPage.dart';
import 'package:autofystore_app/ui/widgets/FocussedProductsGrid.dart';
import 'package:autofystore_app/ui/widgets/AutofyCachedImage.dart';
import 'package:autofystore_app/ui/shared//navdrawer.dart';
import 'package:autofystore_app/ui/widgets/HorizontaltemsSlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:autofystore_app/ui/widgets/widget_json.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new TextField(
              onTap:(){
                Navigator.push(context, new CupertinoPageRoute(builder: (context)=>SearchPage()));
              } ,
              decoration:
                  InputDecoration(hintText: 'Search..')),
          actions: <Widget>[
            new IconButton(
              icon: Icon(EvaIcons.bellOutline),
              onPressed: null,
              iconSize: 25,
              color: Colors.black,
              tooltip: 'Search',
            ),
            new IconButton(
              icon: Icon(EvaIcons.shoppingBagOutline),
              onPressed: null,
              iconSize: 25,
              tooltip: 'Cart',
            )
          ],
        ),
        drawer: new AppDrawer(),
        body: FutureBuilder<Widget>(
                future: _buildWidget(context),
                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return snapshot.hasData
                      ?
                  /**/
                  SizedBox.expand(
                    child: snapshot.data,
                  )
                      : Center(
                    child: CircularProgressIndicator(),
                  );
                }),
        );
  }


  Future<Widget> _buildWidget(BuildContext context) async {
    DynamicWidgetBuilder.addParser(AutofyCachedImage());
    DynamicWidgetBuilder.addParser(HorizontalItemsSlider());
    DynamicWidgetBuilder.addParser(FocusedProductGrid());
    /* var url="https://raw.githubusercontent.com/subhendupsingh/WonderApps/master/widget.json";
    var response=await http.get(url);
    if(response.statusCode==200){*/

    return DynamicWidgetBuilder()
        .build(homePage, context, new DefaultClickListener());
    /* }*/
  }
}

class DefaultClickListener implements ClickListener {
  @override
  void onClicked(String event) {
    print("Receive click event: " + event);

  }
}