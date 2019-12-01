import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/models/lost_object.dart';
import 'package:lost_and_found/widgets/custom_drawer.dart';

class FoundObjectDetailPage extends StatefulWidget {
  static const String routeName = '/Detail';
  @override
  _FoundObjectDetailPageState createState() => _FoundObjectDetailPageState();
}

class _FoundObjectDetailPageState extends State<FoundObjectDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Novo objeto encontrado"),
    );
  }

  Widget _buildBody() {
    return WillPopScope(
      onWillPop: _requestPop,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildAppBar(),
            _buildTitleText(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
  bool _editing = false;

  Future<bool> _requestPop(){
    if (_editing){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar alterações"),
            content: Text("Se vc sair as alterações serão perdidas"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.of(context).pop();
                },

              ),
              FlatButton(
                child: Text("Confirmar"),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
        }else{
          return Future.value(true);
        }
  }

  var _titleController = new TextEditingController();
  var _descriptionController = new TextEditingController();

  Widget _buildTitleText() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(labelText: "Titulo"),
    );
  }

  Widget _buildDescriptionText() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(labelText: "Descricao"),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: _onSave,
      child: Text("Registrar"),
    );
  }

  void _onSave() async {
    final lostObject = new LostObject(
      title: _titleController.text,
      description: _descriptionController.text,
    );
    final result = await Firestore.instance
        .collection("lost_object")
        .add(lostObject.toMap());

    print('Add ${result.documentID}');
    Navigator.of(context).pop();
  }
}
