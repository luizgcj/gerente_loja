import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/category_tile.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin{ //usa este comando para não refazer a tela, colocando a variavel la embaixo como true, ele mantem ela
  @override
  Widget build(BuildContext context) {

    super.build(context); //sempre que usar o AutomaticKeepAliveClientMixin deve colcoar esta linha

    return StreamBuilder<QuerySnapshot>( //usa FutureBuilder pra buscar do firebase, e somente será buscado uma vez
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot){
           if (!snapshot.hasData) {
             return Center(
               child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
             );
           }
           return ListView.builder(
             itemCount: snapshot.data.docs.length,
               itemBuilder: (context, index){
                  return CategoryTile(snapshot.data.docs[index]);
               }
           );
        }
    );
  }

  @override

  bool get wantKeepAlive => true;
}
