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
        'Não foi possível carregar as clínicas. Erro: $e', // Melhor exibir erro completo para debug
      );
    }
  }

  // Carregar avaliações do usuário (somente as aprovadas)
  Future<void> _carregarAvaliacoesUsuario() async {
    try {
      final conn = await DatabaseService.getConnection();
      const idUsuario = 1; // Substitua pelo ID do usuário logado
      final results = await conn.query(
        '''
        SELECT a.id, c.nome AS clinica, a.nota, a.comentario, a.data_avaliacao
        FROM tbl_avaliacao a
        INNER JOIN tbl_clinica c ON a.id_clinica = c.id
        WHERE a.id_usuario = ? AND a.status_avaliacao = 'aprovada'
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
        'Não foi possível carregar suas avaliações. Erro: $e', // Exibe erro de maneira amigável
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
        INSERT INTO tbl_avaliacao (id_clinica, id_usuario, nota, comentario, data_avaliacao, status_avaliacao)
        VALUES (?, ?, ?, ?, ?, 'pendente')
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
        actions: [
          // Somente exibe o botão de aprovação para o ADM
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              // Navegar para a tela de aprovação
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaAprovacaoPage(),
                ),
              );
            },
          ),
        ],
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
                isDense: true, // Adicionando o isDense
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
              SizedBox(height: 16),
              Text('Nota:', style: TextStyle(fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
              SizedBox(height: 16),
              TextField(
                controller: _comentarioController,
                decoration: InputDecoration(labelText: 'Comentário'),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _enviarAvaliacao,
                child: Text('Enviar Avaliação'),
              ),
              SizedBox(height: 32),
              Text('Avaliações:', style: TextStyle(fontSize: 18)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _avaliacoes.length,
                itemBuilder: (context, index) {
                  final avaliacao = _avaliacoes[index];
                  return ListTile(
                    title: Text(avaliacao['clinica']),
                    subtitle: Text(
                        '${avaliacao['nota']} estrelas\n${avaliacao['comentario']}'),
                    trailing: Text(avaliacao['data']),
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

// Tela de Aprovação (Administrador)
class TelaAprovacaoPage extends StatefulWidget {
  @override
  _TelaAprovacaoPageState createState() => _TelaAprovacaoPageState();
}

class _TelaAprovacaoPageState extends State<TelaAprovacaoPage> {
  List<Map<String, dynamic>> _avaliacoesPendentes = [];

  @override
  void initState() {
    super.initState();
    _carregarAvaliacoesPendentes();
  }

  // Carregar avaliações pendentes do banco de dados
  Future<void> _carregarAvaliacoesPendentes() async {
    try {
      final conn = await DatabaseService.getConnection();
      final results = await conn.query(
        '''
        SELECT a.id, c.nome AS clinica, a.nota, a.comentario, a.data_avaliacao
        FROM tbl_avaliacao a
        INNER JOIN tbl_clinica c ON a.id_clinica = c.id
        WHERE a.status_avaliacao = 'pendente'
        ''',
      );

      setState(() {
        _avaliacoesPendentes = results
            .map((row) => {
                  'id': row['id'],
                  'clinica': row['clinica'],
                  'nota': row['nota'],
                  'comentario': row['comentario'],
                  'data':
                      DateFormat('dd/MM/yyyy').format(row['data_avaliacao']),
                })
            .toList();
      });

      await conn.close();
    } catch (e) {
      _mostrarDialogo('Erro',
          'Não foi possível carregar as avaliações pendentes. Erro: $e');
    }
  }

  // Aprovar ou Recusar avaliação
  Future<void> _aprovarOuRecusarAvaliacao(int idAvaliacao, String acao) async {
    try {
      final conn = await DatabaseService.getConnection();
      await conn.query(
        'UPDATE tbl_avaliacao SET status_avaliacao = ? WHERE id = ?',
        [acao, idAvaliacao],
      );
      await conn.close();

      _mostrarDialogo('Sucesso',
          'Avaliação ${acao == 'aprovada' ? 'aprovada' : 'reprovada'} com sucesso.');
      await _carregarAvaliacoesPendentes();
    } catch (e) {
      _mostrarDialogo('Erro',
          'Erro ao ${acao == 'aprovada' ? 'aprovar' : 'reprovar'} avaliação. Erro: $e');
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
      appBar: AppBar(title: Text('Avaliações Pendentes')),
      body: ListView.builder(
        itemCount: _avaliacoesPendentes.length,
        itemBuilder: (context, index) {
          final avaliacao = _avaliacoesPendentes[index];
          return ListTile(
            title: Text(avaliacao['clinica']),
            subtitle: Text(
                '${avaliacao['nota']} estrelas\n${avaliacao['comentario']}'),
            trailing: Text(avaliacao['data']),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Aprovar ou Reprovar'),
                    content: Text('Deseja aprovar ou recusar esta avaliação?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _aprovarOuRecusarAvaliacao(
                              avaliacao['id'], 'aprovada');
                          Navigator.of(context).pop();
                        },
                        child: Text('Aprovar'),
                      ),
                      TextButton(
                        onPressed: () {
                          _aprovarOuRecusarAvaliacao(
                              avaliacao['id'], 'reprovada');
                          Navigator.of(context).pop();
                        },
                        child: Text('Reprovar'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AvaliacaoClinicaPage(),
  ));
}
