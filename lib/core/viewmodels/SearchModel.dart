import 'package:autofystore_app/core/enums/viewstate.dart';
import 'package:autofystore_app/core/models/Product.dart';
import 'package:autofystore_app/core/services/SearchService.dart';
import 'package:autofystore_app/core/viewmodels/BaseModel.dart';
import 'package:autofystore_app/locator.dart';

class SearchModel extends BaseModel{
  SearchService _searchService=locator<SearchService>();

  List<Product> productList;

  Future getSearchResults(String query) async{
    setState(ViewState.Busy);
    productList= await _searchService.getSearchResults(query);
    setState(ViewState.Idle);
  }

}