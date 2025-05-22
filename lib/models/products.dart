import 'dart:convert';

// classe per modelitzar els articles Producte que se consulten o inserten
// a la base de dades de Firebase
class Product {
    
    String nom;
    String? foto;
    String descripcio;
    String cognom1;
    String cognom2;
    int id;

    Product({
    
        required this.nom,
        this.foto,
        required this.descripcio,
        required this.cognom1,
        required this.cognom2,
        required this.id
    });

    factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Product.fromMap(Map<String, dynamic> json) => Product(
    
        nom: json["nom"],
        foto: json["foto"],
        descripcio: json["descripcio"],
        cognom1: json["cognom1"],
        cognom2: json["cognom2"],
        id: json["id"],
        
        
    );

    Map<String, dynamic> toMap() => {
    
        "nom": nom,
        "foto": foto,
        "descripcio": descripcio,
        "cognom1": cognom1,
        "cognom2": cognom2,
        
    };


    Product copy() =>Product(
    
      nom: this.nom,
      foto: this.foto,
      descripcio: this.descripcio,
      cognom1: this.cognom1,
      cognom2: this.cognom2,
      
      id: this.id);
    
}
