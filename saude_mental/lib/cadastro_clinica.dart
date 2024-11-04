import 'package:flutter/material.dart';
import 'package:saude_mental/database/mysql_connection.dart';

class CadastroClinica extends StatefulWidget {
  @override
  _CadastroClinicaState createState() => _CadastroClinicaState();
}

class _CadastroClinicaState extends State<CadastroClinica> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();

  void _cadastrarClinica() {
    if (_formKey.currentState!.validate()) {
      // Exibir mensagem de confirmação ao cadastrar a clínica
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro enviado para análise e validação.')),
      );

      // Limpar campos após o cadastro
      _nomeController.clear();
      _emailController.clear();
      _enderecoController.clear();
      _telefoneController.clear();
      _horarioController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Clínica'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Clínica'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da clínica';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o e-mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone de Contato'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone de contato';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horarioController,
                decoration: InputDecoration(labelText: 'Horário de Funcionamento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o horário de funcionamento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrarClinica,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
