import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseService {
  // Configuração do banco de dados
  final ConnectionSettings settings = ConnectionSettings(
    host: 'tisaudebanco.ctcyu2aastmp.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'app',
    password: 'trabalhosaude2024',
    db: 'tisaudebanco',
  );

  Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(settings);
  }
}

class CadastroClinica extends StatefulWidget {
  @override
  _CadastroClinicaState createState() => _CadastroClinicaState();
}

class _CadastroClinicaState extends State<CadastroClinica> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _tipoAtendimentoController = TextEditingController();
  final TextEditingController _especialidadesController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();
  final TextEditingController _horarioAberturaController = TextEditingController();
  final TextEditingController _horarioFechamentoController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  // Método para salvar os dados no banco
  Future<void> _salvarClinicaNoBanco() async {
    final conn = await _databaseService.getConnection();

    try {
      await conn.query(
        '''
        INSERT INTO tbl_clinica (nome, endereco, tipo_atendimento, especialidades, telefone, imagem, horario_abertura, horario_fechamento, status_autorizacao) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          _nomeController.text,
          _enderecoController.text,
          _tipoAtendimentoController.text,
          _especialidadesController.text,
          _telefoneController.text,
          _imagemController.text,
          _horarioAberturaController.text,
          _horarioFechamentoController.text,
          'pendente' // Definido como 'pendente' para indicar que aguarda aprovação
        ],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro enviado para análise e validação.')),
      );
    } catch (e) {
      print('Erro ao cadastrar clínica: $e');
    } finally {
      await conn.close();
    }
  }

  // Método de validação e cadastro
  void _cadastrarClinica() async {
    if (_formKey.currentState!.validate()) {
      await _salvarClinicaNoBanco();

      // Limpar campos após o cadastro
      _nomeController.clear();
      _enderecoController.clear();
      _tipoAtendimentoController.clear();
      _especialidadesController.clear();
      _telefoneController.clear();
      _imagemController.clear();
      _horarioAberturaController.clear();
      _horarioFechamentoController.clear();
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
                controller: _tipoAtendimentoController,
                decoration: InputDecoration(labelText: 'Tipo de Atendimento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo de atendimento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _especialidadesController,
                decoration: InputDecoration(labelText: 'Especialidades'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira as especialidades';
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
                controller: _imagemController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horarioAberturaController,
                decoration: InputDecoration(labelText: 'Horário de Abertura (HH:MM:SS)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o horário de abertura';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horarioFechamentoController,
                decoration: InputDecoration(labelText: 'Horário de Fechamento (HH:MM:SS)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o horário de fechamento';
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