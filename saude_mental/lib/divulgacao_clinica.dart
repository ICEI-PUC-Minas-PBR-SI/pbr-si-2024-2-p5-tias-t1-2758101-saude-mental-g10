import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Serviços',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CadastroServicosClinica(),
    );
  }
}

class CadastroServicosClinica extends StatefulWidget {
  @override
  _CadastroServicosClinicaState createState() => _CadastroServicosClinicaState();
}

class _CadastroServicosClinicaState extends State<CadastroServicosClinica> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _servicosController = TextEditingController();
  List<String> _servicosCadastrados = []; // Lista para armazenar serviços cadastrados

  // Função para validação e envio do formulário
  void _cadastrarServicos() {
    if (_formKey.currentState!.validate()) {
      // Adiciona o serviço à lista
      setState(() {
        _servicosCadastrados.add(_servicosController.text);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serviço "${_servicosController.text}" cadastrado com sucesso.')),
      );

      // Limpar o campo após o cadastro
      _servicosController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Serviços da Clínica'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Serviços Realizados
              TextFormField(
                controller: _servicosController,
                decoration: InputDecoration(labelText: 'Serviços que realiza'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _cadastrarServicos,
                child: Text('Cadastrar Serviços'),
              ),
              SizedBox(height: 20.0),
              // Exibir serviços cadastrados
              Text(
                'Serviços Cadastrados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              // Lista de serviços cadastrados
              for (var servico in _servicosCadastrados)
                Text(
                  '- $servico',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
