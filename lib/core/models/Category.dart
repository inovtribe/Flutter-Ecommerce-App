// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

import 'package:autofystore_app/core/database/DatasbaseHelper.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  int id;
  String name;
  String slug;
  int count;

  Category({
    this.id,
    this.name,
    this.slug,
    this.count,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "count": count,
  };

  static fromMap(Map map){
    Category category=new Category();
    category.id=map[DatabaseHelper.categoryId];
    category.name=map[DatabaseHelper.categoryName];
    category.count=map[DatabaseHelper.categoryCount];
    return category;
  }
}
