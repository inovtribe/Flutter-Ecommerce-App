import 'package:autofystore_app/core/enums/viewstate.dart';
import 'package:autofystore_app/core/viewmodels/CategoriesModel.dart';
import 'package:autofystore_app/ui/views/BaseView.dart';
import 'package:autofystore_app/ui/views/ProductGrid.dart';
import 'package:autofystore_app/ui/widgets/AutofyAppBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ProductCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AutofyAppBar(
        title: "Categories",
      ),
      body: new BaseView<CategoriesModel>(
        onModelReady: (model)=>model.getCategories(),
        builder: (context,model,child)=> model.state==ViewState.Busy?
        new Center(
          child: new CircularProgressIndicator()
        ):
        new ListView.separated(
            itemCount: model.categories.length,
            itemBuilder: (context,index){
              return ListTile(
                title: Text(model.categories[index].name),
                trailing: Icon(EvaIcons.arrowRight),
                onTap: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder:(buildContext)=>ProductGrid(
                       attributeType: "category",
                       attributeId: model.categories[index].id,
                       attributeName: model.categories[index].name,
                  )));
                },
              );
            },
          separatorBuilder: (context,index){
              return Divider();
          },
        )
      ),
    );
  }
}