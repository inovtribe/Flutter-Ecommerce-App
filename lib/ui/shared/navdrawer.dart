import 'package:autofystore_app/ui/views/ProductCategories.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:autofystore_app/ui/shared//constants.dart';
import 'package:autofystore_app/ui/shared//routes.dart';

class DrawerItem {
  String title;
  IconData icon;
  String route;
  DrawerItem(this.title, this.icon, this.route);
}

class AppDrawer extends StatelessWidget{

  final drawerItems = [
    new DrawerItem("Categories",EvaIcons.folderOutline,Constants.ROUTE_CATEGORIES),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions=[];
    for(int i=0;i<drawerItems.length;i++){
      drawerOptions.add(
        new ListTile(
          leading: new Icon(drawerItems[i].icon),
          title: new Text(drawerItems[i].title),
          onTap: (){
            Navigator.pop(context); //close nav bar
            Navigator.pushNamed(context, drawerItems[i].route);
          }
        )
      );
    }
    Drawer drawer=new Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(accountName: new Text('Subhendu'),
              accountEmail: new Text('sps@vendorskart.com')),
          new Column(children: drawerOptions)
        ],
      ),
    );
    return drawer;
  }

}