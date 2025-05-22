import 'dart:convert';

// classe per modelitzar els articles Producte que se consulten o inserten
// a la base de dades de Firebase
class Product {
    bool disponible;
    String nom;
    String? foto;
    String descripcio;
    String tipus;
    String restaurant;
    String geo;

    String? id;

    Product({
        required this.disponible,
        required this.nom,
        this.foto,
        required this.descripcio,
        required this.tipus,
        required this.restaurant,
        required this.geo,
        this.id
    });

    factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        disponible: json["disponible"],
        nom: json["nom"],
        foto: json["foto"],
        descripcio: json["descripcio"],
        tipus: json["tipus"],
        restaurant: json["restaurant"],
        geo: json["geo"],
        
    );

    Map<String, dynamic> toMap() => {
        "disponible": disponible,
        "nom": nom,
        "foto": foto,
        "descripcio": descripcio,
        "tipus": tipus,
        "restaurant": restaurant,
        "geo": geo,
    };


    Product copy() =>Product(
      disponible: this.disponible,
      nom: this.nom,
      foto: this.foto,
      descripcio: this.descripcio,
      tipus: this.tipus,
      restaurant: this.restaurant,
      geo: this.geo,
      id: this.id);
    
}
