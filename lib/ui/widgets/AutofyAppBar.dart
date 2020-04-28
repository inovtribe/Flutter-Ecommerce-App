import 'package:autofystore_app/core/viewmodels/AppBarModel.dart';
import 'package:autofystore_app/ui/views/BaseView.dart';
import 'package:autofystore_app/ui/views/SearchPage.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutofyAppBar extends StatelessWidget implements PreferredSizeWidget{

  final String title;
  final double height;

  const AutofyAppBar({this.height=55,@required this.title});

  @override
  Widget build(BuildContext buildContext) {
    return new BaseView<AppBarModel>(
      onModelReady: (model)=>{},
      builder: (child,context,model)=>new AppBar(
        title: Text(title),
        actions: <Widget>[
          new IconButton(
            icon: Icon(EvaIcons.searchOutline),
            onPressed: (){
              Navigator.push(buildContext, new CupertinoPageRoute(builder: (buildContext)=> SearchPage()));
            },
            iconSize: 25,
            color: Colors.black,
            tooltip: 'Search',
          ),
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

}