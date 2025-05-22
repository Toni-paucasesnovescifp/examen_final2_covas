import 'package:examen_final2_covas/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:examen_final2_covas/providers/product_form_provider.dart';
import 'package:examen_final2_covas/services/services.dart';
import 'package:examen_final2_covas/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/input_decorations.dart';

//aquesta classe gestiona la pantalla d'edició i creació de productes
class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(
      context,
    ); // accedim al servei de productes

    return ChangeNotifierProvider(
      create:
          (_) => ProductFormProvider(
            productService.selectedProduct,
          ), // proveidor per gestionar el formulari del producte
      child: _ProductScreenBody(productService: productService),
    ); //cos de la pantalla de producte
  }
}

// cos principal de la pantalla del producte
class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({Key? key, required this.productService})
    : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // mostra la imatge del producte
                                ProductImage(url: productService.selectedProduct.foto),



                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    // torna a la pantalla anterior
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),

                Positioned(
                  top: 100,
                  left: 20,
                  right: 20, // Opcional para ajustar el ancho del fondo


                  child: Container(


                    

  
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                        0.6,
                      ), // Fondo semitransparente
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Bordes redondeados
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                      
                        Text(
                          "Nom: ${productService.selectedProduct.nom}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Descripció: ${productService.selectedProduct.descripcio}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Primer llinatge: ${productService.selectedProduct.cognom1}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Segon llinatge: ${productService.selectedProduct.cognom2}",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        
                        
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      // captura d'imatge amb la càmara de fotos
                      final ImagePicker _picker = ImagePicker();
                      final XFile? photo = await _picker.pickImage(
                        source: ImageSource.camera,
                      );
                      print(photo!.path);
                      productService.updateSelectedImage(
                        photo.path,
                      ); // actualitza la imatge del producte
                    },
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),






              ],
            ),
//            _ProductForm(), // formulari d'edició del producte
//            SizedBox(height: 100),
          ],
        ),
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//      floatingActionButton: FloatingActionButton(
//        child:
//            productService.isSaving
//                ? CircularProgressIndicator(
//                  color: Colors.white,
//                ) // mentre es guard mostra indicador de càrregada
//                : Icon(Icons.save_outlined),
//        onPressed:
//            productService.isSaving
//                ? null
//                : () async {
//                  if (!productForm.isValidForm()) return;
//                  final String? imageUrl =
//                      await productService
//                          .uploadImage(); // puja la imatge si és necessari
//                  if (imageUrl != null) productForm.tempProduct.foto = imageUrl;
//                  productService.saveOrCreateProduct(
//                    productForm.tempProduct,
//                  ); // guarda o crea el producte
//                },
//      ),
    );
  }
}

// formulari per editar les dades del producte
class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final tempProduct = productForm.tempProduct;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode:
              AutovalidateMode
                  .onUserInteraction, // activa la validació automàtica en interacció
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                // camp d'edició del nom de producte
                initialValue: tempProduct.nom,
                onChanged: (value) => tempProduct.nom = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nom és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nom del producte',
                  labelText: 'Nom:',
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                // camp d'edició del preu del producte
                initialValue: '${tempProduct.descripcio}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\.?\d{0,2}'),
                  ),
                ],

                onChanged: (value) {
                  if (value == '') {
                    tempProduct.descripcio = '';
                  } else {
                    tempProduct.descripcio = value;
                  }
                },
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nom és obligatori';
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '99€',
                  labelText: 'Preu:',
                ),
              ),
              SizedBox(height: 30),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // decoració per al contenidor del formulari
  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(25),
      bottomLeft: Radius.circular(25),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0, 5),
        blurRadius: 5,
      ),
    ],
  );
}





