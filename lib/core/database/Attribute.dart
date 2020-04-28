import 'package:autofystore_app/core/database/DatasbaseHelper.dart';

class Attribute{
  int id;
  String name;
  int updated;

  static fromMap(Map map){
    Attribute attribute=new Attribute();
    attribute.id=map[DatabaseHelper.attributeId];
    attribute.name=map[DatabaseHelper.attributeName];
    attribute.updated=map[DatabaseHelper.attributeUpdated];
    return attribute;
  }
}