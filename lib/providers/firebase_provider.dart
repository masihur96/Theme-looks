import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:theme_looks/model/product_model.dart';

class FirebaseProvider extends ChangeNotifier {
  List<ProductModel> _productList = [];
  get productList => _productList;

  Future<void> getProducts() async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .orderBy('date')
          .get()
          .then((snapShot) {
        _productList.clear();
        snapShot.docChanges.forEach((element) {
          ProductModel productModel = ProductModel(
            date: element.doc['date'],
            id: element.doc['id'],
            image: element.doc['image'],
            description: element.doc['description'],
            productTitle: element.doc['productTitle'],
            blackLargePrice: element.doc['blackLargePrice'],
            whiteLargePrice: element.doc['whiteLargePrice'],
            blackSmallPrice: element.doc['blackSmallPrice'],
            whiteSmallPrice: element.doc['whiteSmallPrice'],
          );
          _productList.add(productModel);
        });
        debugPrint('Product List: ${_productList.length}');
        notifyListeners();
      });
    } catch (error) {
      debugPrint("$error");
    }
  }

  Future<bool> addProductData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(map['id'])
          .set(map);
      getProducts();
      notifyListeners();
      return true;
    } catch (err) {
      debugPrint('$err');
      // showToast(err.toString());
      return false;
    }
  }
}
