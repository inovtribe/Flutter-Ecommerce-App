import 'package:autofystore_app/ui/widgets/AutofyAppBar.dart';
import 'package:autofystore_app/ui/widgets/PaginatedGrid.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget{

  final String attributeName;
  final int attributeId;
  final String attributeType;

  ProductGrid({this.attributeName="Autofy",this.attributeId,this.attributeType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AutofyAppBar(
        title: attributeName,
      ),
      body: new PaginatedGrid(
        perPage: 12,
        attributeId: attributeId ,
        attributeType: attributeType
      ),
    );
  }

}