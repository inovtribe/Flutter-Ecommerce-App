import 'package:autofystore_app/core/enums/viewstate.dart';
import 'package:autofystore_app/core/models/Product.dart';
import 'package:autofystore_app/core/viewmodels/ProductsByAttributeModel.dart';
import 'package:autofystore_app/ui/shared/constants.dart';
import 'package:autofystore_app/ui/views/BaseView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FooterBuyButtons extends StatelessWidget{
  Product _product;

  FooterBuyButtons(Product product){
    this._product=product;
  }

  @override
  Widget build(BuildContext context) {
    return new BaseView<ProductsByAttributeModel>(
        onModelReady: (model)=>_product.isFromCache==1? model.getProductById(false, _product.id) : model.product=_product,
        builder: (context,model,child)=>model.state==ViewState.Busy
        ? Container(
          width: MediaQuery.of(context).size.width*0.96,
          child: Text("Loading stock status..."),
        )
        : null!=model.product && model.product.stockStatus=="instock"?
          Container(
            width:MediaQuery.of(context).size.width*0.96,
            child:Row(
              children: <Widget>[
                Expanded(
                  child:RaisedButton(
                    onPressed: () {},
                    child: Text("Add To Cart"),
                    color: Color(Constants.AutofyColor),
                    textColor: Colors.white,
                  ),
                  flex: 1,
                ),
                SizedBox(width: 10,),
                Expanded(
                  child:RaisedButton(
                    onPressed: () {},
                    child: Text("Buy Now"),
                    color: Color(Constants.AutofyColorComp),
                    textColor: Colors.white,
                  ),
                  flex: 1,
                )
              ],
            )
        ):
        Container(
            width:MediaQuery.of(context).size.width*0.96,
            child:Row(
              children: <Widget>[
                Expanded(
                  child:RaisedButton(
                    disabledColor: Colors.black,
                    disabledTextColor: Colors.white,
                    child: Text("Out Of Stock"),
                    color: Color(Constants.AutofyColor),
                    textColor: Colors.white,
                  ),
                  flex: 1,
                ),
                SizedBox(width: 10,),
                Expanded(
                  child:RaisedButton(
                    onPressed: () {},
                    child: Text("Notify Me"),
                    color: Color(Constants.AutofyColor),
                    textColor: Colors.white,
                  ),
                  flex: 1,
                )
              ],
            )
        )
    );
  }

}