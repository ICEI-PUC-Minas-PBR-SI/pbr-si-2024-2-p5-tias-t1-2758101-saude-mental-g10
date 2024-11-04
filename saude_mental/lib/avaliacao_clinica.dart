import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'package:saude_mental/database/mysql_connection.dart';


class AvaliacaoClinicaPage extends StatefulWidget {
  @override
  _AvaliacaoClinicaPageState createState() => _AvaliacaoClinicaPageState();
}

class _AvaliacaoClinicaPageState extends State<AvaliacaoClinicaPage> {
  int _nota = 0;
  final TextEditingController _comentarioController = TextEditingController();
  List<String> _tiposServicos = ['Psicoterapia', 'Psiquiatria'];
  List<String> _servicosSelecionados = [];

  void _enviarAvaliacao() {
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
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()), // Redirecionar para HomePage
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // Limpar os campos (opcional)
    setState(() {
      _nota = 0;
      _comentarioController.clear();
      _servicosSelecionados.clear();
    });
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
