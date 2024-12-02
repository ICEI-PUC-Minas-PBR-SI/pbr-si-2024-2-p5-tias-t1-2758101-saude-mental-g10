import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseService {
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

class AprovacaoClinica extends StatefulWidget {
  @override
  _AprovacaoClinicaState createState() => _AprovacaoClinicaState();
}

class _AprovacaoClinicaState extends State<AprovacaoClinica> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _clinicas = [];
  List<Map<String, dynamic>> _historico = [];

  @override
  void initState() {
    super.initState();
    _buscarClinicasPendentes();
  }

  Future<void> _buscarClinicasPendentes() async {
    final conn = await _databaseService.getConnection();
    try {
      var results = await conn.query('''
        SELECT id, nome, endereco, tipo_atendimento, especialidades, telefone, imagem, horario_abertura, horario_fechamento 
        FROM tbl_clinica 
        WHERE status_autorizacao = 'pendente'
      ''');

      List<Map<String, dynamic>> clinicas = results.map((row) {
        return {
          'id': row[0],
          'nome': row[1],
          'endereco': row[2],
          'tipo_atendimento': row[3],
          'especialidades': row[4],
          'telefone': row[5],
          'imagem': row[6],
          'horario_abertura': row[7],
          'horario_fechamento': row[8],
        };
      }).toList();

      setState(() {
        _clinicas = clinicas;
      });
    } catch (e) {
      print('Erro ao buscar clínicas pendentes: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> _aprovarOuReprovarClinica(
      int clinicaId, String status, String motivo) async {
    final conn = await _databaseService.getConnection();
    try {
      // Atualiza o status na tabela tbl_clinica
      var updateResult = await conn.query('''
        UPDATE tbl_clinica 
        SET status_autorizacao = ? 
        WHERE id = ?
      ''', [status, clinicaId]);

      if (updateResult.affectedRows == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Clínica não encontrada ou status não atualizado.')),
        );
        return; // Encerra a função se não encontrou a clínica
      }

      // Define o status de aprovação na tabela tbl_aprovacao_clinica
      String statusAprovacao =
          (status == 'aprovado') ? 'aprovado' : 'reprovado';

      // Insere o registro de aprovação/reprovação
      var insertResult = await conn.query('''
        INSERT INTO tbl_aprovacao_clinica (clinica_id, status_aprovacao, motivo_rejeicao, data_aprovacao) 
        VALUES (?, ?, ?, NOW())
      ''', [clinicaId, statusAprovacao, motivo]);

      setState(() {
        // Remove a clínica da lista
        _clinicas.removeWhere((clinica) => clinica['id'] == clinicaId);

        // Adiciona ao histórico
        _historico.add({
          'clinica_id': clinicaId,
          'status': statusAprovacao,
          'motivo': motivo.isNotEmpty ? motivo : 'Sem motivo informado',
          'data': DateTime.now().toString(),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clínica ${statusAprovacao} com sucesso.')),
      );
    } catch (e) {
      print('Erro ao $status clínica: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao $status clínica.')),
      );
    } finally {
      await conn.close();
    }
  }

  void _showReprovarDialog(
      int clinicaId, String nomeClinica, String enderecoClinica) {
    String motivo = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Motivo da Reprovação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nome da Clínica: $nomeClinica'),
              Text('Endereço: $enderecoClinica'),
              TextField(
                onChanged: (value) {
                  motivo = value;
                },
                decoration:
                    InputDecoration(hintText: 'Insira o motivo da reprovação'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (motivo.isNotEmpty) {
                  _aprovarOuReprovarClinica(clinicaId, 'reprovado', motivo);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, insira um motivo.')),
                  );
                }
              },
              child: Text('Reprovar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _navegarParaHistorico() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HistoricoAprovacaoScreen(historico: _historico)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprovação de Clínica'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _navegarParaHistorico,
          ),
        ],
      ),
      body: _clinicas.isEmpty
          ? Center(child: Text('Sem clínicas para validação'))
          : ListView.builder(
              itemCount: _clinicas.length,
              itemBuilder: (context, index) {
                final clinica = _clinicas[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nome: ${clinica['nome']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Endereço: ${clinica['endereco']}'),
                        Text(
                            'Tipo de Atendimento: ${clinica['tipo_atendimento']}'),
                        Text('Especialidades: ${clinica['especialidades']}'),
                        Text('Telefone: ${clinica['telefone']}'),
                        Text(
                            'Horário de Abertura: ${clinica['horario_abertura']}'),
                        Text(
                            'Horário de Fechamento: ${clinica['horario_fechamento']}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _aprovarOuReprovarClinica(
                                  clinica['id'], 'aprovado', ''),
                              child: Text('Aprovar'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _showReprovarDialog(
                                  clinica['id'],
                                  clinica['nome'],
                                  clinica['endereco']),
                              child: Text('Reprovar'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Classe para a tela de histórico de aprovações
class HistoricoAprovacaoScreen extends StatelessWidget {
  final List<Map<String, dynamic>> historico;

  HistoricoAprovacaoScreen({required this.historico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Aprovações'),
      ),
      body: historico.isEmpty
          ? Center(child: Text('Nenhuma aprovação/reprovação registrada.'))
          : ListView.builder(
              itemCount: historico.length,
              itemBuilder: (context, index) {
                final item = historico[index];
                return ListTile(
                  title: Text(
                      'Clínica ID: ${item['clinica_id']} - Status: ${item['status']}'),
                  subtitle:
                      Text('Motivo: ${item['motivo']} - Data: ${item['data']}'),
                );
              },
            ),
    );
  }
}
