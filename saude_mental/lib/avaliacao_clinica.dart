import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:saude_mental/database/mysql_connection.dart';

class AvaliacaoClinicaPage extends StatefulWidget {
  final int idClinica;
  final int idUsuario;

  AvaliacaoClinicaPage({required this.idClinica, required this.idUsuario});

  @override
  _AvaliacaoClinicaPageState createState() => _AvaliacaoClinicaPageState();
}

class _AvaliacaoClinicaPageState extends State<AvaliacaoClinicaPage> {
  int _nota = 0;
  final TextEditingController _comentarioController = TextEditingController();
  List<String> _tiposServicos = ['Psicoterapia', 'Psiquiatria'];
  List<String> _servicosSelecionados = [];

  // Configuração do banco de dados
  final ConnectionSettings settings = ConnectionSettings(
    host: 'tisaudebanco.ctcyu2aastmp.us-east-1.rds.amazonaws.com',
    port: 3306,
    user: 'app',
    password: 'trabalhosaude2024',
    db: 'tisaudebanco',
  );

  Future<void> _enviarAvaliacao() async {
    final conn = await MySqlConnection.connect(settings);

    try {
      // Inserir dados no banco
      await conn.query(
        'INSERT INTO tbl_avaliacoes (id_clinica, id_usuario, nota, comentario, data_avaliacao) VALUES (?, ?, ?, ?, NOW())',
        [
          widget.idClinica, // ID da clínica passado como argumento
          widget.idUsuario, // ID do usuário passado como argumento
          _nota,
          _comentarioController.text,
        ],
      );

      // Exibir pop-up de confirmação
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
                  Navigator.pop(context); // Voltar para a página anterior
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
      // Mostrar erro se ocorrer
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content:
                Text('Ocorreu um erro ao enviar a avaliação. Tente novamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print('Erro ao enviar avaliação: $e');
    } finally {
      await conn.close();
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
