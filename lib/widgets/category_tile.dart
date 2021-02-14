import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/screens/product_screen.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context) => EditCategoryDialog(category: category,)
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(category.get('icon')),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(category.get('title'),
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: [
            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection('itens').get(),
                builder: (context, snapshot){
                    if (!snapshot.hasData) return Container();
                    return Column(
                      children: snapshot.data.docs.map((doc) {
                         return ListTile(
                           leading: CircleAvatar(
                             backgroundImage: NetworkImage(doc['images'][0]),
                             backgroundColor: Colors.transparent,
                           ),
                           title: Text(doc['title']),
                           trailing: Text(
                             'R\$${doc['price'].toStringAsFixed(2)}'
                           ),
                           onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> ProductScreen(
                                  categoryId: category.id,
                                  product: doc,
                                ))
                              );
                           },
                         );
                      }).toList()..add( //para adicionar mais itens alem do que foi retornado do firebase
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.add, color: Colors.pinkAccent,),
                          ),
                          title: Text('Adicionar'),
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> ProductScreen(
                                  categoryId: category.id,
                                ))
                            );
                          },
                        )
                      ),
                    );
                }
            )
          ],

        ),
      ),
    );
  }
}
