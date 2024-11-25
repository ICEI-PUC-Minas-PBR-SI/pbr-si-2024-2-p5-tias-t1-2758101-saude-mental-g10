import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

// Configuração de conexão com o banco de dados
class DatabaseService {
  final ConnectionSettings settings = ConnectionSettings(
    host: 'tisaudebanco.ctcyu2aastmp.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'app',
    password: 'trabalhosaude2024',
    db: 'tisaudebanco',
  );

  Future<MySqlConnection> getConnection() async {
    try {
      final conn = await MySqlConnection.connect(settings);
      print("Conexão bem-sucedida!");
      return conn;
    } catch (e) {
      print("Erro ao conectar ao banco de dados: $e");
      rethrow;
    }
  }
}

// Classe para representar uma clínica
class Clinica {
  final int id;
  final String nome;
  final String endereco;
  final String tipoAtendimento;
  final String especialidades; // Mantenha como String
  final String telefone;
  final String horarioAbertura;
  final String horarioFechamento;

  Clinica({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.tipoAtendimento,
    required this.especialidades,
    required this.telefone,
    required this.horarioAbertura,
    required this.horarioFechamento,
  });

  // Construtor para criar uma instância a partir de um Map
  factory Clinica.fromMap(Map<String, dynamic> map) {
    return Clinica(
      id: map['id'] as int,
      nome: map['nome'] as String,
      endereco: map['endereco'] as String,
      tipoAtendimento: map['tipo_atendimento'] as String,
      especialidades: map['especialidades'] != null
          ? map['especialidades'].toString()
          : '', // Tratamento como String
      telefone: map['telefone'] as String,
      horarioAbertura: map['horario_abertura']?.toString() ?? '',
      horarioFechamento: map['horario_fechamento']?.toString() ?? '',
    );
  }
}

// Tela para exibir a lista de clínicas com filtro de busca
class ClinicaListScreen extends StatefulWidget {
  @override
  _ClinicaListScreenState createState() => _ClinicaListScreenState();
}

class _ClinicaListScreenState extends State<ClinicaListScreen> {
  List<Clinica> clinicas = [];
  List<Clinica> filteredClinicas = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClinicas();
  }

  // Busca as clínicas no banco de dados
  Future<void> fetchClinicas() async {
    final dbService = DatabaseService();
    MySqlConnection? conn;

    try {
      conn = await dbService.getConnection();
      // Atualize a consulta SQL para incluir a filtragem por status
      final results = await conn.query(
          'SELECT id, nome, endereco, tipo_atendimento, especialidades, telefone, horario_abertura, horario_fechamento '
          'FROM tbl_clinica '
          'WHERE status_autorizacao = ?',
          ['aprovado']); // Filtra clínicas com status 'aprovado'

      List<Clinica> fetchedClinicas = results.map((row) {
        return Clinica.fromMap(row.fields);
      }).toList();

      setState(() {
        clinicas = fetchedClinicas;
        filteredClinicas = List.from(clinicas); // Copia a lista original
      });

      print("Clínicas buscadas com sucesso: ${clinicas.length}");
    } catch (e) {
      print("Erro ao buscar clínicas: $e");
    } finally {
      if (conn != null) {
        await conn.close();
      }
    }
  }

  // Filtra as clínicas com base no texto digitado
  void _filterClinicas() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredClinicas = clinicas.where((clinica) {
        return clinica.nome.toLowerCase().contains(query) ||
            clinica.endereco.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Função para mostrar os detalhes da clínica em um modal
  void _showClinicaDetails(Clinica clinica) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(clinica.nome),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Endereço: ${clinica.endereco}'),
                Text('Telefone: ${clinica.telefone}'),
                Text('Tipo de Atendimento: ${clinica.tipoAtendimento}'),
                Text('Especialidades: ${clinica.especialidades}'),
                Text('Horário de Abertura: ${clinica.horarioAbertura}'),
                Text('Horário de Fechamento: ${clinica.horarioFechamento}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clínicas de Saúde Mental'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => _filterClinicas(),
              decoration: InputDecoration(
                labelText: 'Buscar Clínica',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: filteredClinicas.isEmpty
          ? Center(child: Text('Nenhuma clínica encontrada.'))
          : ListView.builder(
              itemCount: filteredClinicas.length,
              itemBuilder: (context, index) {
                final clinica = filteredClinicas[index];
                return GestureDetector(
                  onTap: () => _showClinicaDetails(
                      clinica), // Exibe o modal ao clicar no card
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinica.nome,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('Endereço: ${clinica.endereco}'),
                          Text('Telefone: ${clinica.telefone}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Função principal que inicia o aplicativo
void main() {
  runApp(MaterialApp(
    title: 'Clínicas de Saúde Mental',
    home: ClinicaListScreen(),
  ));
}
