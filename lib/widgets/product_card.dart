import 'package:flutter/material.dart';
import 'package:examen_final2_covas/models/models.dart';




// Widget per mostrar una targeta de producte
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroudWidget(
                url: product.foto), // fons amb imatge del producte
            _ProductDetails(
              name: product.nom,
              subtitle: '',
            ), // detalls del producte
            //Positioned(
            //    top: 0,
            //    right: 0,
            //    child: _DescriptionTag(
            //      description: product.descripcio,
            //    )), // etiqueta del preu
            //TODO: Mostrar de forma condicional depenent de si el producte està disponible o no
          //  if (!product.disponible)
          //    Positioned(
          //        top: 0,
          //        left: 0,
          //        child: _Availability()), // indicador de disponibilitat
          ],
        ),
      ),
    );
  }

  // decoració de la targeta amb ombres i vores arrodonides
  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          ),
        ],
      );
}

// widget per mostrar el fons amb la imatge del producte
class _BackgroudWidget extends StatelessWidget {
  final String? url;

  const _BackgroudWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: (url == '' )
            ? Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              ) 
            : FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

// widget per mostrar els detalls del producte
class _ProductDetails extends StatelessWidget {
  final String name, subtitle;

  const _ProductDetails({
    Key? key,
    required this.name,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: double.infinity,
        height: 80,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      );
}

// widget permostrar l'etiqueta de preu
class _DescriptionTag extends StatelessWidget {
  final String description;

  const _DescriptionTag({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$description',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
    );
  }
}

// widget per indicar que el producte no està disponible
