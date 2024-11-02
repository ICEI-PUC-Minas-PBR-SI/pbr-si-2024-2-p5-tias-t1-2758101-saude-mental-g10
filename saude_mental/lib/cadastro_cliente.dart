import 'package:flutter/material.dart';

class CadastroCliente extends StatefulWidget {
  @override
  _CadastroClienteState createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  // Preferências de Serviço
  bool _psicoterapia = false;
  bool _psiquiatria = false;

  // Função para validação e envio do formulário
  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      // Se caso formos usar e-mail de confirmação, vou ajustar a lógica aqui.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso.')),
      );

      // Limpa os campos do formulário
      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
      _confirmarSenhaController.clear();
      _enderecoController.clear();
      _telefoneController.clear();

      // Reseta os checkboxes
      setState(() {
        _psicoterapia = false;
        _psiquiatria = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Cliente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nome Completo
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              // E-mail
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Insira um e-mail válido';
                  }
                  return null;
                },
              ),
              // Senha
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              // Confirmar Senha
              TextFormField(
                controller: _confirmarSenhaController,
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: (value) {
                  if (value != _senhaController.text) {
                    return 'As senhas não correspondem';
                  }
                  return null;
                },
              ),
              // Endereço Completo (Opcional)
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço Completo (Opcional)'),
              ),
              // Telefone de Contato (Opcional)
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone de Contato (Opcional)'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20.0),
              Text('Preferências de Serviço'),
              CheckboxListTile(
                title: Text('Psicoterapia'),
                value: _psicoterapia,
                onChanged: (bool? value) {
                  setState(() {
                    _psicoterapia = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Psiquiatria'),
                value: _psiquiatria,
                onChanged: (bool? value) {
                  setState(() {
                    _psiquiatria = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20.0),
              
              ElevatedButton(
                onPressed: _cadastrar,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Desenvolvido por Matheus Filipe Alves - Aluno da PUC Minas