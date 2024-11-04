import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:saude_mental/database/mysql_connection.dart';

// Classe para o serviço de banco de dados
class DatabaseService {
  // Configuração do banco de dados
  final ConnectionSettings settings = ConnectionSettings(
    host: 'tisaudebanco.ctcyu2aastmp.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'app',
    password: 'trabalhosaude2024',
    db: 'tisaudebanco',
  );

  Future<MySqlConnection> connect() async {
    return await MySqlConnection.connect(settings);
  }

  Future<void> cadastrarCliente({
    required String nome,
    required String email,
    required String senha,
    String? endereco,
    String? telefone,
    bool psicoterapia = false,
    bool psiquiatria = false,
  }) async {
    final conn = await connect();
    try {
      // Alterado para inserir na tabela tbl_usuario
      await conn.query(
        'INSERT INTO tbl_usuario (nome, email, senha, endereco, telefone, psicoterapia, psiquiatria) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [nome, email, senha, endereco, telefone, psicoterapia ? 1 : 0, psiquiatria ? 1 : 0],
      );
    } catch (e) {
      print('Erro ao cadastrar cliente: $e');
    } finally {
      await conn.close();
    }
  }
}

// Widget de cadastro de cliente
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
  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      final databaseService = DatabaseService();

      // Enviar dados para o banco
      await databaseService.cadastrarCliente(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        endereco: _enderecoController.text.isNotEmpty ? _enderecoController.text : null,
        telefone: _telefoneController.text.isNotEmpty ? _telefoneController.text : null,
        psicoterapia: _psicoterapia,
        psiquiatria: _psiquiatria,
      );

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
