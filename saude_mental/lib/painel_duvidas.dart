import 'package:flutter/material.dart';
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
      ),
      home: DoubtsPublicationScreen(),
    );
  }
}

class DoubtsPublicationScreen extends StatefulWidget {
  @override
  _DoubtsPublicationScreenState createState() => _DoubtsPublicationScreenState();
}

class _DoubtsPublicationScreenState extends State<DoubtsPublicationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _doubtController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();
  final List<Doubt> _doubts = [];
  bool _isHighContrast = false;
  late AnimationController _controller;
  late Animation<Color?> _titleColorAnimation;
  Color _buttonColor = Colors.teal;
  bool _showResponsibilityMessage = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _titleColorAnimation = ColorTween(
      begin: Colors.teal.shade900,
      end: Colors.teal.shade700,
    ).animate(_controller);
    _controller.repeat(reverse: true);
  }

  void _publishDoubt() {
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
                'Por favor, evite perguntas fora de contexto, pois isso pode resultar em '
                'sua exclusão da plataforma.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Não mostrar mais esta mensagem'),
                value: !_showResponsibilityMessage,
                onChanged: (value) {
                  setState(() {
                    _showResponsibilityMessage = !value;
                  });
                  Navigator.of(context).pop(); // Fecha o dialog
                  _addDoubt(); // Adiciona a dúvida após fechar o dialog
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
                _addDoubt(); // Adiciona a dúvida se continuar
              },
            ),
          ],
        );
      },
    );
  }

  void _addDoubt() {
    setState(() {
      _doubts.add(Doubt(text: _doubtController.text.trim(), responses: []));
      _doubtController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dúvida publicada com sucesso!')),
    );
  }

  void _toggleHighContrast() {
    setState(() {
      _isHighContrast = !_isHighContrast;
      _buttonColor = _isHighContrast ? Colors.yellow[600]! : Colors.teal;
    });
  }

  void _deleteDoubt(int index) {
    setState(() {
      _doubts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dúvida deletada com sucesso!')),
    );
  }

  void _respondToDoubt(int index) {
    if (_responseController.text.trim().isNotEmpty) {
      setState(() {
        _doubts[index].responses.add(_responseController.text.trim());
        _responseController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta enviada com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, escreva uma resposta!')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isHighContrast ? Colors.black : Colors.white,
        title: AnimatedBuilder(
          animation: _titleColorAnimation,
          builder: (context, child) {
            return AnimatedOpacity(
              opacity: _isHighContrast ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Seja Bem-vindo!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: _isHighContrast ? Colors.white : _titleColorAnimation.value,
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isHighContrast ? Icons.wb_sunny : Icons.nights_stay,
              color: _isHighContrast ? Colors.white : Colors.teal,
            ),
            onPressed: _toggleHighContrast,
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _isHighContrast ? Colors.black : Colors.tealAccent.shade100,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: _isHighContrast ? BorderSide(color: Colors.white, width: 2) : BorderSide.none,
              ),
              elevation: 5,
              color: _isHighContrast ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    AnimatedOpacity(
                      opacity: _isHighContrast ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        '📢 Publicação de Dúvidas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _isHighContrast ? Colors.white : Colors.teal.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedOpacity(
                      opacity: _isHighContrast ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        'Sinta-se à vontade para perguntar. Sua saúde mental é importante!',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: _isHighContrast ? Colors.white70 : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _doubtController,
              decoration: InputDecoration(
                hintText: 'Digite sua dúvida',
                hintStyle: TextStyle(color: _isHighContrast ? Colors.white70 : Colors.black54),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: _isHighContrast ? Colors.grey[700] : Colors.white,
              ),
              style: TextStyle(color: _isHighContrast ? Colors.white : Colors.black),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _buttonColor = _isHighContrast ? Colors.yellow[300]! : Colors.teal[300]!;
                });
              },
              onExit: (_) {
                setState(() {
                  _buttonColor = _isHighContrast ? Colors.yellow[600]! : Colors.teal;
                });
              },
              child: GestureDetector(
                onTap: _publishDoubt,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_buttonColor, _isHighContrast ? Colors.yellow[300]! : Colors.teal[400]!],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: Text(
                      'Enviar Pergunta',
                      style: TextStyle(
                        color: _isHighContrast ? Colors.black : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _doubts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: _isHighContrast ? Colors.grey[800] : Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _doubts[index].text,
                            style: TextStyle(
                              fontSize: 16,
                              color: _isHighContrast ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _responseController,
                            decoration: InputDecoration(
                              hintText: 'Digite sua resposta',
                              hintStyle: TextStyle(color: _isHighContrast ? Colors.white70 : Colors.black54),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: _isHighContrast ? Colors.grey[700] : Colors.white,
                            ),
                            style: TextStyle(color: _isHighContrast ? Colors.white : Colors.black),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _respondToDoubt(index),
                            child: Text('Responder'),
                          ),
                          SizedBox(height: 10),
                          if (_doubts[index].responses.isNotEmpty) ...[
                            Text(
                              'Respostas:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isHighContrast ? Colors.white : Colors.black,
                              ),
                            ),
                            for (var response in _doubts[index].responses)
                              Text(
                                response,
                                style: TextStyle(color: _isHighContrast ? Colors.white70 : Colors.black54),
                              ),
                          ],
                          IconButton(
                            icon: Icon(Icons.delete, color: _isHighContrast ? Colors.red : Colors.black),
                            onPressed: () => _deleteDoubt(index),
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
  final String text;
  final List<String> responses;

  Doubt({required this.text, required this.responses});
}
