import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'order_header.dart';

class OrderTile extends StatelessWidget {

  final DocumentSnapshot order; //se tivesse recebendo os dados ao inves do snapshot, seria map

  OrderTile(this.order);

  final states = [
    '', 'Em preparação', 'Em Transporte', 'Aguardando Entrega', 'Entregue'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.id),
          initiallyExpanded: order.get('status') != 4,
          title: Text(
            '#${order.id.substring(order.id.length - 7, order.id.length)} - '
             '${states[order.get('status')]}',
            style: TextStyle(color: order.get('status') != 4 ? Colors.grey[850] : Colors.green),
          ),
          children: [
            Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrderHeader(order),
                Column(
                  mainAxisSize: MainAxisSize.min, //par ocupar o minimo da tela, senão a coluna iria expandir e mostrar na tela inteira
                  children: order.get('products').map<Widget>((p) { // data('products').map((key, p) {
                    return ListTile(
                      title: Text(p['product']['title'] + ' ' + p['size']), //olhar no firebase a arvore do banco
                      subtitle: Text(p['category'] + '/' + p['pid']),
                      trailing: Text(
                        p['quantity'].toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: (){
                        FirebaseFirestore.instance.collection('users').doc(order['clienteId']).collection('orders').doc(order.id).delete();
                        order.reference.delete();
                      },
                      textColor: Colors.red,
                      child: Text('Excluir'),
                    ),
                    FlatButton(
                      onPressed: order.get('status') > 1 ? (){
                        order.reference.update({'status': order.get('status') - 1});
                      } : null,
                      textColor: Colors.grey[850],
                      child: Text('Regredir'),
                    ),
                    FlatButton(
                      onPressed: order.get('status') < 4 ? (){
                        order.reference.update({'status': order.get('status') + 1});
                      } : null,
                      textColor: Colors.green,
                      child: Text('Avançar'),
                    ),
                  ],
                )
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
