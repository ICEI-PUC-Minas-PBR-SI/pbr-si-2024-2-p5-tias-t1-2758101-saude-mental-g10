import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart'; // Importando o pacote intl

// Serviço para Conexão ao Banco de Dados
class DatabaseService {
  static final ConnectionSettings settings = ConnectionSettings(
    host: 'tisaudebanco.ctcyu2aastmp.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'app',
    password: 'trabalhosaude2024',
    db: 'tisaudebanco',
  );

  static Future<MySqlConnection> getConnection() async {
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
      rethrow;
    }
  }
}

// Tela de Avaliação (Widget Principal)
class AvaliacaoClinicaPage extends StatefulWidget {
  @override
  _AvaliacaoClinicaPageState createState() => _AvaliacaoClinicaPageState();
}

class _AvaliacaoClinicaPageState extends State<AvaliacaoClinicaPage> {
  int _nota = 0;
  int? _idClinicaSelecionada;
  final TextEditingController _comentarioController = TextEditingController();
  List<Map<String, dynamic>> _clinicas = [];
  List<Map<String, dynamic>> _avaliacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarClinicasAprovadas();
    _carregarAvaliacoesUsuario();
  }

  // Carregar clínicas aprovadas do banco de dados
  Future<void> _carregarClinicasAprovadas() async {
    try {
      final conn = await DatabaseService.getConnection();
      final results = await conn.query(
        'SELECT id, nome FROM tbl_clinica WHERE status_autorizacao = ?',
        ['aprovado'],
      );

      setState(() {
        _clinicas = results
            .map((row) => {'id': row['id'], 'nome': row['nome']})
            .toList();
      });

      await conn.close();
    } catch (e) {
      _mostrarDialogo(
        'Erro',
        'Não foi possível carregar as clínicas.',
      );
    }
  }

  // Carregar avaliações do usuário
  Future<void> _carregarAvaliacoesUsuario() async {
    try {
      final conn = await DatabaseService.getConnection();
      const idUsuario = 1; // Substitua pelo ID do usuário logado
      final results = await conn.query(
        '''
        SELECT a.id, c.nome AS clinica, a.nota, a.comentario, a.data_avaliacao
        FROM tbl_avaliacao a
        INNER JOIN tbl_clinica c ON a.id_clinica = c.id
        WHERE a.id_usuario = ? 
        ''',
        [idUsuario],
      );

      setState(() {
        _avaliacoes = results
            .map((row) => {
                  'id': row['id'],
                  'clinica': row['clinica'],
                  'nota': row['nota'],
                  'comentario': row['comentario'],
                  'data': DateFormat('dd/MM/yyyy')
                      .format(row['data_avaliacao']), // Formatação da data
                })
            .toList();
      });

      await conn.close();
    } catch (e) {
      _mostrarDialogo(
        'Erro',
        'Não foi possível carregar suas avaliações.',
      );
    }
  }

  // Enviar avaliação para o banco de dados
  Future<void> _enviarAvaliacao() async {
    if (_idClinicaSelecionada == null) {
      _mostrarDialogo('Erro', 'Selecione uma clínica para avaliar.');
      return;
    }

    try {
      final conn = await DatabaseService.getConnection();
      const idUsuario = 1; // Substitua pelo ID do usuário logado
      final dataAtual =
          DateTime.now().toIso8601String(); // Usando o formato ISO 8601

      await conn.query(
        '''
        INSERT INTO tbl_avaliacao (id_clinica, id_usuario, nota, comentario, data_avaliacao)
        VALUES (?, ?, ?, ?, ?)
        ''',
        [
          _idClinicaSelecionada,
          idUsuario,
          _nota,
          _comentarioController.text,
          dataAtual, // Passando a data no formato correto
        ],
      );

      await conn.close();

      _mostrarDialogo('Sucesso', 'Sua avaliação foi enviada com sucesso.');
      _comentarioController.clear();
      setState(() {
        _nota = 0;
        _idClinicaSelecionada = null;
      });

      // Carregar as avaliações após o envio
      await _carregarAvaliacoesUsuario();
    } catch (e) {
      print('Erro ao enviar avaliação: $e');
      _mostrarDialogo('Erro', 'Não foi possível enviar sua avaliação.');
    }
  }

  // Função para excluir uma avaliação
  Future<void> _excluirAvaliacao(int idAvaliacao) async {
    try {
      final conn = await DatabaseService.getConnection();
      await conn.query(
        'DELETE FROM tbl_avaliacao WHERE id = ?',
        [idAvaliacao],
      );

      await conn.close();

      _mostrarDialogo('Sucesso', 'Avaliação excluída com sucesso.');
      // Atualizar a lista de avaliações
      await _carregarAvaliacoesUsuario();
    } catch (e) {
      print('Erro ao excluir avaliação: $e');
      _mostrarDialogo('Erro', 'Não foi possível excluir a avaliação.');
    }
  }

  // Exibir dialogo de erro ou sucesso
  void _mostrarDialogo(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação da Clínica'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selecione a Clínica:', style: TextStyle(fontSize: 18)),
              DropdownButton<int>(
                value: _idClinicaSelecionada,
                hint: Text('Selecione uma clínica'),
                items: _clinicas.map((clinica) {
                  return DropdownMenuItem<int>(
                    value: clinica['id'],
                    child: Text(clinica['nome']),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    _idClinicaSelecionada = value;
                  });
                },
              ),
              SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: _enviarAvaliacao,
                child: Text('Enviar Avaliação'),
              ),
              SizedBox(height: 40),
              Text('Suas Avaliações:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              _avaliacoes.isEmpty
                  ? Text('Nenhuma avaliação encontrada.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _avaliacoes.length,
                      itemBuilder: (context, index) {
                        final avaliacao = _avaliacoes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(avaliacao['clinica']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nota: ${avaliacao['nota']}'),
                                Text('Comentário: ${avaliacao['comentario']}'),
                                Text('Data: ${avaliacao['data']}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmação'),
                                      content: Text(
                                          'Deseja realmente excluir esta avaliação?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await _excluirAvaliacao(
                                                avaliacao['id']);
                                          },
                                          child: Text('Excluir'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
