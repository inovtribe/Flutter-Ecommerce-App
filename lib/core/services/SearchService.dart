import 'package:algolia/algolia.dart';
import 'package:autofystore_app/core/models/Product.dart';

class SearchService{
  Algolia algolia = Algolia.init(
    applicationId: 'LRWPUNEVKJ',
    apiKey: '7081161f10e3bdf8cf90d6c633a4b899',
  );

  Future<List<Product>> getSearchResults(String search) async {
    List<Product> productList=[];
    AlgoliaQuery query = algolia.instance.index('alg_posts_product').search(search);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    print('Hits Count: ${snap.nbHits}');
    var results = snap.hits;
    if (results != null && results.length > 0){
      for (var i = 0; i < results.length; i++) {
        Product product=Product.fromSearch(results[i].data);
        productList.add(product);
      }

      return productList;
    }
    return null;
  }
}