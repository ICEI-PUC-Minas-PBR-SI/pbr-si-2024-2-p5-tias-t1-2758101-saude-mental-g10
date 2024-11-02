import 'package:flutter/material.dart';

// Ponto de entrada do aplicativo
void main() {
  runApp(MyApp());
}

// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Saúde Mental',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema de cor primária
      ),
      home: DoubtsPublicationScreen(), // Tela inicial do aplicativo
    );
  }
}

// Tela para publicação de dúvidas
class DoubtsPublicationScreen extends StatefulWidget {
  @override
  _DoubtsPublicationScreenState createState() => _DoubtsPublicationScreenState();
}

// Classe de estado para a tela de publicação de dúvidas
class _DoubtsPublicationScreenState extends State<DoubtsPublicationScreen> {
  final TextEditingController _doubtController = TextEditingController(); // Controlador para o campo de texto
  final List<String> _doubts = []; // Lista para armazenar as dúvidas publicadas
  bool _isDarkMode = false; // Variável para rastrear o status do modo escuro
  bool _isHighContrast = false; // Variável para rastrear o status do modo de alto contraste

  // Cores baseadas no tema atual
  Color get backgroundColor => _isDarkMode ? Colors.black : Colors.white; // Cor de fundo
  Color get textColor => _isHighContrast ? Colors.black : (_isDarkMode ? Colors.white : Colors.black); // Cor do texto
  Color get buttonColor => _isDarkMode ? Colors.blueGrey : Colors.blue; // Cor do botão

  // Função para publicar uma dúvida
  void _publishDoubt() {
    if (_doubtController.text.isNotEmpty) {
      setState(() {
        _doubts.add(_doubtController.text); // Adiciona a dúvida à lista
        _doubtController.clear(); // Limpa o campo de entrada
      });
    }
  }

  // Função para alternar o modo escuro
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Alterna a variável do modo escuro
    });
  }

  // Função para alternar o modo de alto contraste
  void _toggleHighContrast() {
    setState(() {
      _isHighContrast = !_isHighContrast; // Alterna a variável do alto contraste
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicação de Dúvidas'),
        actions: [
          // Botão para ativar o modo escuro
          IconButton(
            icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            tooltip: 'Alternar Modo Escuro',
            onPressed: _toggleDarkMode,
          ),
          // Botão para ativar o modo de alto contraste
          IconButton(
            icon: Icon(Icons.accessibility_new),
            tooltip: 'Alternar Alto Contraste',
            onPressed: _toggleHighContrast,
          ),
        ],
      ),
      body: Container(
        color: backgroundColor, // Define a cor de fundo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Compartilhe suas dúvidas sobre saúde mental e receba apoio da comunidade.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _doubtController,
              decoration: InputDecoration(
                labelText: 'Escreva sua dúvida',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(color: textColor), // Define a cor do texto
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // Define a cor do botão
              ),
              onPressed: _publishDoubt,
              child: Text('Publicar Dúvida', style: TextStyle(color: textColor)), // Define a cor do texto do botão
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _doubts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _doubts[index],
                        style: TextStyle(fontSize: 16, color: textColor), // Define a cor do texto
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showFAQDialog(context), // Exibe as FAQs ao ser clicado
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Perguntas Frequentes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para exibir as FAQs em um diálogo
  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Perguntas Frequentes', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('O que é este aplicativo?', style: TextStyle(color: textColor)),
                Text('Este aplicativo oferece suporte em saúde mental e conecta usuários a profissionais.', style: TextStyle(color: textColor)),
                SizedBox(height: 10),
                Text('Como funciona o cadastro de clientes?', style: TextStyle(color: textColor)),
                Text('Você cria uma senha, precisa ter um e-mail, informar o endereço completo e um telefone de contato (opcional para resguardar os dados pessoais do usuário).', style: TextStyle(color: textColor)),
                SizedBox(height: 10),
                Text('Quais são as opções de serviço?', style: TextStyle(color: textColor)),
                Text('Oferecemos serviços de psicoterapia e psiquiatria.', style: TextStyle(color: textColor)),
                SizedBox(height: 10),
                Text('O que são psicoterapia e psiquiatria?', style: TextStyle(color: textColor)),
                Text('Psicoterapia é um tratamento psicológico, enquanto psiquiatria lida com diagnósticos e medicamentos.', style: TextStyle(color: textColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar', style: TextStyle(color: buttonColor)),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }
}

// Desenvolvido por Max Gabriel Pereira Moreira - Aluno da PUC Minas
// Projeto de Sustentabilidade em Saúde Mental
