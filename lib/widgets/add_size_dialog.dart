import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
          ),
          FlatButton(
              onPressed: (){
                Navigator.of(context).pop(_controller.text);
              },
              child: Text('Add'),
              textColor: Colors.pinkAccent
          ),
        ]),
      ),
    );
  }
}
