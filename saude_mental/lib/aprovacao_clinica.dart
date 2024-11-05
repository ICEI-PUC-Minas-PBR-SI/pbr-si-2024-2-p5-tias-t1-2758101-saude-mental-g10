import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:saude_mental/database/mysql_connection.dart';

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

  // Função para buscar todas as clínicas
  Future<List<Map<String, dynamic>>> listarClinicas() async {
    final conn = await connect();
    try {
      var results = await conn.query('SELECT id, nome, status_autorizacao FROM tbl_clinica');
      return results.map((row) => {
        'id': row['id'],
        'nome': row['nome'],
        'status_autorizacao': row['status_autorizacao'] == 'aprovado'
      }).toList();
    } catch (e) {
      print('Erro ao buscar clínicas: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  // Função para atualizar o status de aprovação da clínica
  Future<void> atualizarStatusClinica(int clinicaId, bool aprovada) async {
    final conn = await connect();
    try {
      await conn.query(
        'UPDATE tbl_clinica SET status_autorizacao = ? WHERE id = ?',
        [aprovada ? 'aprovado' : 'pendente', clinicaId],
      );
    } catch (e) {
      print('Erro ao atualizar status de aprovação da clínica: $e');
    } finally {
      await conn.close();
    }
  }
}

// Widget para listar clínicas e aprovar/reprovar
class ListaClinicasWidget extends StatefulWidget {
  @override
  _ListaClinicasWidgetState createState() => _ListaClinicasWidgetState();
}

class _ListaClinicasWidgetState extends State<ListaClinicasWidget> {
  late Future<List<Map<String, dynamic>>> _clinicasFuture;

  @override
  void initState() {
    super.initState();
    _clinicasFuture = DatabaseService().listarClinicas();
  }

  // Função para atualizar o status da clínica e recarregar a lista
  void _atualizarStatus(int clinicaId, bool aprovada) async {
    await DatabaseService().atualizarStatusClinica(clinicaId, aprovada);
    setState(() {
      _clinicasFuture = DatabaseService().listarClinicas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clínicas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _clinicasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as clínicas.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma clínica encontrada.'));
          }

          final clinicas = snapshot.data!;
          return ListView.builder(
            itemCount: clinicas.length,
            itemBuilder: (context, index) {
              final clinica = clinicas[index];
              return ListTile(
                title: Text(clinica['nome']),
                subtitle: Text('Status: ${clinica['status_autorizacao'] ? 'Aprovada' : 'Pendente'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _atualizarStatus(clinica['id'], true),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _atualizarStatus(clinica['id'], false),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
