import 'dart:io';
import 'package:autofystore_app/core/database/Attribute.dart';
import 'package:autofystore_app/core/models/Category.dart';
import 'package:autofystore_app/core/models/Product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final _databaseName = "autofy.db";
  static final _databaseVersion = 1;

  //Attributes table (not used currently)
  static final attributeTable = 'attributes';
  static final attributeName="attribute_name";
  static final attributeId="attribute_id";
  static final attributeUpdated="updated";

  //Products table
  static final productTable="product";
  static final productId="id";
  static final productName="name";
  static final productSku="sku";
  static final productRegularPrice="regular_price";
  static final productSalePrice="sale_price";
  static final productStockStatus="stock_status";
  static final productDescription="description";
  static final productStock="stock";
  static final productImages="images";
  static final productUpdated="updated";
  static final productAttributeId="attribute_id";
  static final productRelatedIds="relatedIds";
  static final productAverageRating="average_rating";
  static final productRatingCount="rating_count";

  //Categories table
  static final categoryTable="categories";
  static final categoryName="category_name";
  static final categoryId="category_id";
  static final categoryCount="category_count";
  static final categoryUpdated="updated";
  static final categoryTableNotCreated=true;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  // only have a single app-wide reference to the database
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    await db.execute('''
          CREATE TABLE $productTable(
            $productId INTEGER PRIMARY KEY,
            $productName TEXT NOT NULL,
            $productDescription TEXT NOT NULL,
            $productImages TEXT NOT NULL,
            $productRegularPrice TEXT NOT NULL,
            $productSalePrice TEXT NOT NULL,
            $productSku TEXT NOT NULL,
            $productStock INTEGER NOT NULL,
            $productStockStatus TEXT NOT NULL,
            $productAttributeId TEXT NOT NULL,
            $productUpdated INTEGER NOT NULL,
            $productRelatedIds TEXT NOT NULL,
            $productAverageRating TEXT NOT NULL,
            $productRatingCount INTEGER NOT NULL
          )
    ''');

    await db.execute('''
           CREATE TABLE $categoryTable(
            $categoryId INTEGER  PRIMARY KEY,
            $categoryCount INTEGER,
            $categoryName TEXT NOT NULL,
            $categoryUpdated INTEGER NOT NULL
           )
    ''');
  }





  /*Future<int> saveAttribute(Attribute attribute) async{
    Database db = await instance.database;
    return await db.rawInsert("INSERT INTO $attributeTable"
        "($attributeId,$attributeName,$attributeUpdated) "
        "VALUES(?,?,?)",
        [attribute.id,attribute.name,attribute.updated]);

  }*/

  /*Future<int> saveAttribute(String attributeId,String name) async{
    Database db = await instance.database;
    return await db.rawInsert("INSERT INTO $attributeTable"
        "($attributeId,$attributeName,$attributeUpdated) "
        "VALUES(?,?,?)",
        [attributeId,attributeName,new DateTime.now().millisecondsSinceEpoch]);

  }*/

  void saveProducts(List<Product> products,String attributeId) async{
    if(products!=null && products.length>0) {
      Database db = await instance.database;
      int count=Sqflite.firstIntValue(await db.rawQuery("select COUNT(*) from $productTable where $productAttributeId=?",[attributeId]));
      if(count>=9){
        return;
      }
      int length = products.length < 9 ? products.length : 9;
      Batch batch = db.batch();
      for (var i = 0; i < length; i++) {
        Product product=products[i];
        String images=product.images.join(',');
        String relatedIds=product.relatedIds.join(',');
        batch.rawInsert("INSERT OR REPLACE INTO $productTable"
            "($productId,$productName,$productSku,$productRegularPrice,$productSalePrice,$productStockStatus,$productDescription,$productStock,$productImages,$productUpdated,$productAttributeId,$productRelatedIds,$productAverageRating,$productRatingCount) "
            "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", [product.id,product.name,product.sku,product.regularPrice,product.salePrice,product.stockStatus,product.description,product.stock,images,new DateTime.now().millisecondsSinceEpoch,attributeId,relatedIds,product.averageRating,product.ratingCount]);
      }
      batch.commit(noResult: true);
    }
  }

  Future<List<Product>> getProductsByAttribute(String id,int perPage) async{
    List<Product> productsList=[];
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db.rawQuery('select COUNT(*) from $productTable where $productAttributeId=?',[id]));
    List<Map<String,dynamic>> rows=await db.rawQuery("select * from $productTable where $productAttributeId=? and (julianday('now','localtime')-julianday(datetime(updated/1000,'unixepoch','localtime')))*24*60<=10 LIMIT $perPage",[id]);
    if(rows!=null && rows.length>0 && rows.length>=perPage) {
      rows.forEach((map) {
        Product product = Product.fromMap(map);
        productsList.add(product);
      });
    }else{
        if(count>0) {
          await db.rawQuery(
              "delete from $productTable where $productAttributeId=?", [id]);
        }
    }

    return productsList;
  }

  Future<Product> getProductById(int id) async{
    Database db = await instance.database;
    List<Map<String,dynamic>> rows= await db.rawQuery("select * from $productTable where $productId=?",[id]);
    if(rows!=null && rows.length>0){
      rows.forEach((map){
        Product product=Product.fromMap(map);
        return product;
      });
    }

    return null;
  }

  void saveCategories(List<Category> categories) async{
    Database db = await instance.database;
    if(categories!=null && categories.length>0){
      Batch batch=db.batch();
      categories.forEach((category){
        batch.rawInsert("INSERT INTO $categoryTable"
            "($categoryId,$categoryUpdated,$categoryName,$categoryCount)"
            "VALUES(?,?,?,?)",[category.id,new DateTime.now().millisecondsSinceEpoch,category.name,category.count]);
      });

      batch.commit();
    }
  }

  Future<List<Category>> getAllCategories() async{
    List<Category> categoryList=[];
    Database db = await instance.database;
    List<Map<String,dynamic>> rows=await db.rawQuery("select * from $categoryTable where (julianday('now','localtime')-julianday(datetime(updated/1000,'unixepoch','localtime')))*24<=24");
    if(rows!=null && rows.length>0) {
      rows.forEach((map) {
        Category category = Category.fromMap(map);
        categoryList.add(category);
      });

    }else{
      await db.rawQuery("delete from $categoryTable");
    }

    return categoryList;
  }
}