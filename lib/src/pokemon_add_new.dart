import 'package:flutter/material.dart';
import 'pokemon_model.dart';

class AddPokemonFormPage extends StatefulWidget {
  const AddPokemonFormPage({Key? key}) : super(key: key);

  @override
  _AddPokemonFormPageState createState() => _AddPokemonFormPageState();
}

class _AddPokemonFormPageState extends State<AddPokemonFormPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void submitPokemon(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var newPokemon = Pokemon(_nameController.text);
      Navigator.of(context).pop(newPokemon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Pokemon'),
        backgroundColor: const Color(0xFF0B479E),
      ),
      body: Container(
        color: const Color(0xFFABCAED),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pokemon Name',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pokemon name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => submitPokemon(context),
                child: const Text('Submit Pokemon'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
