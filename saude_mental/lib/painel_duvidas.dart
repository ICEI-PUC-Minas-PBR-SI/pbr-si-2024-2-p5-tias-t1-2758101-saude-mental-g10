import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:saude_mental/database/mysql_connection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Saúde Mental',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DoubtsPublicationScreen(),
    );
  }
}

class DatabaseService {
  final ConnectionSettings settings = ConnectionSettings(
    host: 'tisaudebanco.ctcyu2aastmp.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'app',
    password: 'trabalhosaude2024',
    db: 'tisaudebanco',
  );

  Future<MySqlConnection> connect() async {
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Erro ao conectar com o banco de dados: $e');
      rethrow;
    }
  }

  Future<int?> insertDoubt(String doubtText) async {
    final connection = await connect();
    try {
      var result = await connection.query(
        'INSERT INTO tbl_duvida (descricao) VALUES (?)',
        [doubtText],
      );
      return result.insertId;
    } catch (e) {
      print('Erro ao inserir dúvida: $e');
      return null;
    } finally {
      await connection.close();
    }
  }

  Future<void> deleteDoubt(int doubtId) async {
    final connection = await connect();
    try {
      await connection.query(
        'DELETE FROM tbl_duvida WHERE id = ?',
        [doubtId],
      );
    } catch (e) {
      print('Erro ao deletar dúvida: $e');
    } finally {
      await connection.close();
    }
  }

  Future<void> insertResponse(int doubtId, String responseText) async {
    final connection = await connect();
    try {
      await connection.query(
        'UPDATE tbl_duvida SET resposta = ?, data_resposta = NOW() WHERE id = ?',
        [responseText, doubtId],
      );
    } catch (e) {
      print('Erro ao inserir resposta: $e');
    } finally {
      await connection.close();
    }
  }

  Future<void> deleteResponse(int responseId) async {
    final connection = await connect();
    try {
      await connection.query(
        'DELETE FROM tbl_resposta WHERE id = ?',
        [responseId],
      );
    } catch (e) {
      print('Erro ao deletar resposta: $e');
    } finally {
      await connection.close();
    }
  }
}

class DoubtsPublicationScreen extends StatefulWidget {
  @override
  _DoubtsPublicationScreenState createState() =>
      _DoubtsPublicationScreenState();
}

class _DoubtsPublicationScreenState extends State<DoubtsPublicationScreen> {
  final TextEditingController _doubtController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();
  final List<Doubt> _doubts = [];
  bool _showResponsibilityMessage = true;
  final DatabaseService _databaseService = DatabaseService();

  void _publishDoubt() async {
    if (_doubtController.text.trim().isNotEmpty) {
      if (_showResponsibilityMessage) {
        _showResponsibilityDialog();
      } else {
        _addDoubt();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, escreva uma dúvida!')),
      );
    }
  }

  void _showResponsibilityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('🛑 Importante:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Você é responsável pelas perguntas que realiza. '
                'Por favor, evite perguntas fora de contexto.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Não mostrar mais esta mensagem'),
                value: !_showResponsibilityMessage,
                onChanged: (value) {
                  setState(() {
                    _showResponsibilityMessage = value;
                  });
                  Navigator.of(context).pop();
                  _addDoubt();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Continuar'),
              onPressed: () {
                Navigator.of(context).pop();
                _addDoubt();
              },
            ),
          ],
        );
      },
    );
  }

  void _addDoubt() async {
    try {
      int? doubtId =
          await _databaseService.insertDoubt(_doubtController.text.trim());
      if (doubtId != null) {
        setState(() {
          _doubts.add(Doubt(
              id: doubtId, text: _doubtController.text.trim(), responses: []));
          _doubtController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dúvida publicada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dúvida no banco de dados.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dúvida no banco de dados.')),
      );
      print('Erro: $e');
    }
  }

  void _deleteDoubt(int doubtId) async {
    try {
      await _databaseService.deleteDoubt(doubtId);
      setState(() {
        _doubts.removeWhere((doubt) => doubt.id == doubtId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dúvida deletada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar dúvida do banco de dados.')),
      );
      print('Erro: $e');
    }
  }

  void _addResponse(int doubtId) async {
    if (_responseController.text.trim().isNotEmpty) {
      try {
        await _databaseService.insertResponse(
            doubtId, _responseController.text.trim());
        setState(() {
          var doubt = _doubts.firstWhere((d) => d.id == doubtId);
          doubt.responses.add(_responseController.text.trim());
          _responseController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resposta adicionada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar resposta.')),
        );
        print('Erro: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Publicar Dúvidas',
          style: TextStyle(color: const Color.fromARGB(255, 24, 11, 11)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Sinta-se à vontade para perguntar. Sua saúde mental é importante!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _doubtController,
              decoration: InputDecoration(
                labelText: 'Digite sua dúvida',
                hintText: 'Digite sua dúvida...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: const Color.fromARGB(255, 248, 250, 250),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Cor cinza claro
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: _publishDoubt,
              child: Text(
                'Enviar Pergunta',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _doubts.length,
                itemBuilder: (context, index) {
                  final doubt = _doubts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doubt.text,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _responseController,
                            decoration: InputDecoration(
                              labelText: 'Digite sua resposta',
                              hintText: 'Digite sua resposta...',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey[300], // Cor cinza claro
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _addResponse(doubt.id),
                            child: Text(
                              'Responder',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 8),
                          if (doubt.responses.isNotEmpty)
                            for (var response in doubt.responses)
                              Text(
                                'Resposta: $response',
                                style: TextStyle(fontSize: 16),
                              ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteDoubt(doubt.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Doubt {
  final int id;
  final String text;
  final List<String> responses;

  Doubt({required this.id, required this.text, required this.responses});
}
