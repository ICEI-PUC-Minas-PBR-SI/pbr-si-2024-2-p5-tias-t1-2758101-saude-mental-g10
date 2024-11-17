import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:saude_mental/database/mysql_connection.dart';
import 'package:mysql1/mysql1.dart';

//TESTE 17/11/2024/222
class AvaliacaoClinicaPage extends StatefulWidget {
  @override
  _AvaliacaoClinicaPageState createState() => _AvaliacaoClinicaPageState();
}

class _AvaliacaoClinicaPageState extends State<AvaliacaoClinicaPage> {
  int _nota = 0;
  final TextEditingController _comentarioController = TextEditingController();
  List<String> _tiposServicos = ['Psicoterapia', 'Psiquiatria'];
  List<String> _servicosSelecionados = [];
  final DatabaseService _dbService = DatabaseService();

  void _enviarAvaliacao() async {
    try {
      // Chame o método para enviar os dados ao banco
      await _dbService.enviarAvaliacao(
        idClinica: 1, // Substitua
        idUsuario: 123, // Substitua
        nota: _nota,
        comentario: _comentarioController.text,
      );

      // Exibir um pop-up de confirmação
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Avaliação Enviada'),
            content: Text('Sua avaliação foi submetida com sucesso.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o pop-up
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // Limpar os campos
      setState(() {
        _nota = 0;
        _comentarioController.clear();
        _servicosSelecionados.clear();
      });
    } catch (e) {
      // Exibir um erro caso falhe ao enviar a avaliação
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Ocorreu um erro ao enviar sua avaliação.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação da Clínica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nota:', style: TextStyle(fontSize: 18)),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _nota ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _nota = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _comentarioController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Comentário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Indicação de Serviço:', style: TextStyle(fontSize: 18)),
            Column(
              children: _tiposServicos.map((servico) {
                return CheckboxListTile(
                  title: Text(servico),
                  value: _servicosSelecionados.contains(servico),
                  onChanged: (bool? selecionado) {
                    setState(() {
                      if (selecionado == true) {
                        _servicosSelecionados.add(servico);
                      } else {
                        _servicosSelecionados.remove(servico);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarAvaliacao,
              child: Text('Enviar Avaliação'),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe para o serviço de banco de dados.
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

  Future<void> enviarAvaliacao({
    required int idClinica,
    required int idUsuario,
    required int nota,
    String? comentario,
  }) async {
    final conn = await connect();
    try {
      // Insere os dados na tabela tbl_avaliacao
      await conn.query(
        'INSERT INTO tbl_avaliacao (id_clinica, id_usuario, nota, comentario, data_avaliacao) VALUES (?, ?, ?, ?, NOW())',
        [idClinica, idUsuario, nota, comentario],
      );
    } catch (e) {
      print('Erro ao enviar avaliação: $e');
      throw e;
    } finally {
      await conn.close();
    }
  }
}
