import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;

// aquesta classe s'encarrega de gestionar els productes
// utilitzant Firebase com a backend

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'ca1baaae4f1f9e02a394.free.beeceptor.com';
  final List<Product> products = [];

  late Product selectedProduct;
  File? newPicture;

  bool isLoading = true;
  bool isSaving = false;

  // Constructor: carrega els productes quan s'instancia
  ProductsService() {
    this.loadProducts();
  }

  // Mètode per carregar els productes des de Firebase
  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'api/plats');
    final resp = await http.get(url);

    // Convertim la resposta en un mapa de productes
    final List<dynamic>    productsMap = json.decode(resp.body);
    print("Contenido de productsMap: $productsMap");

    // recorrem els productes i els afegim a la llista
    productsMap.forEach(( value) {
      final tempProduct = value;
      tempProduct.id = value.id;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
  }

  // Mètode per guardar o crear un producte nou
  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      await createProduct(product); // si no té id, cream un producte
    } else {
      await updateProduct(product); // si ja té id, actualitzam
    }

    isSaving = false;
    notifyListeners();
  }

  // actualitzam un porducte existent
  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;
    print(decodedData);

    // cercam el producte dins la llista i el substituim
    final index =
        this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;

    return product.id.toString();
  }

  // cream un porducte nou a Firebase
  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    // assignma l'ID generat per Firebase al producte
    product.id = decodedData['name'];
    this.products.add(product);

    return product.id.toString();
  }

  // actualitza la imatge seleccionada
  void updateSelectedImage(String path) {
    this.newPicture = File.fromUri(Uri(path: path));
    this.selectedProduct.foto = path;
    notifyListeners();
  }

  // puja la imatge a Cloudinary
  Future<String?> uploadImage() async {
    if (this.newPicture == null) return null;
    this.isSaving = true;
    notifyListeners();

    // url de cloudinary per fer pujada
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dposeledj/image/upload?upload_preset=ToniuploadPresetCloudinary');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPicture!.path);
    imageUploadRequest.files.add(file);

    final streamRespose = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamRespose);

    // comprovam si la pujada ha estat exitosa
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Hi ha un error!');
      print(resp.body);
      return null;
    }

    this.newPicture = null;

    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
  }
}
