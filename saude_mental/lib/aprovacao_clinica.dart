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
      var updateResult = await conn.query('''
        UPDATE tbl_clinica 
        SET status_autorizacao = ? 
        WHERE id = ?
      ''', [status, clinicaId]);

      if (updateResult.affectedRows != null && updateResult.affectedRows! > 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(status == 'aprovado'
                ? 'Clínica aprovada com sucesso!'
                : 'Clínica reprovada!')));

        // Movendo para o histórico (ou registro de rejeições)
        _historico.add({
          'id': clinicaId,
          'status': status,
          'motivo': motivo,
        });

        // Atualizando a lista de clínicas pendentes
        _buscarClinicasPendentes();
      }
    } catch (e) {
      print('Erro ao atualizar o status da clínica: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprovação de Clínicas'),
      ),
      body: ListView.builder(
        itemCount: _clinicas.length,
        itemBuilder: (context, index) {
          final clinica = _clinicas[index];
          return Card(
            child: ListTile(
              title: Text(clinica['nome']),
              subtitle: Text(clinica['endereco']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      _aprovarOuReprovarClinica(clinica['id'], 'aprovado', '');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _aprovarOuReprovarClinica(clinica['id'], 'rejeitado', 'Motivo da reprovação');
                    },
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
