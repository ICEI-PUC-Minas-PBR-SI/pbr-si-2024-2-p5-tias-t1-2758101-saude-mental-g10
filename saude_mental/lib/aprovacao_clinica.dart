import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solicitações de Cadastro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SolicitacaoClinicas(),
    );
  }
}

class SolicitacaoClinicas extends StatefulWidget {
  @override
  _SolicitacaoClinicasState createState() => _SolicitacaoClinicasState();
}

class _SolicitacaoClinicasState extends State<SolicitacaoClinicas> {
  // Lista de clínicas para simulação
  final List<Clinica> clinicas = [
    Clinica(nome: 'Clínica A', email: 'clinicaA@email.com', endereco: 'Rua A, 123'),
    Clinica(nome: 'Clínica B', email: 'clinicaB@email.com', endereco: 'Rua B, 456'),
    // Adicione mais clínicas conforme necessário
  ];

  // Lista de clínicas já processadas
  final List<Historico> historico = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitações de Cadastro'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Navega para a tela de histórico
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoricoAprovacoes(historico: historico),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: clinicas.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${clinicas[index].nome}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('E-mail: ${clinicas[index].email}'),
                  Text('Endereço: ${clinicas[index].endereco}'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para aprovar o cadastro
                          _aprovarCadastro(clinicas[index]);
                        },
                        child: Text('Aprovar'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para reprovar o cadastro
                          _reprovarCadastro(clinicas[index]);
                        },
                        child: Text('Reprovar'),
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

  void _aprovarCadastro(Clinica clinica) {
    // Adiciona a clínica ao histórico com status aprovado
    setState(() {
      historico.add(Historico(nome: clinica.nome, email: clinica.email, endereco: clinica.endereco, status: 'Aprovada'));
      clinicas.remove(clinica); // Remove a clínica da lista
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cadastro da ${clinica.nome} aprovado.')),
    );
  }

  void _reprovarCadastro(Clinica clinica) {
    // Adiciona a clínica ao histórico com status reprovado
    setState(() {
      historico.add(Historico(nome: clinica.nome, email: clinica.email, endereco: clinica.endereco, status: 'Reprovada'));
      clinicas.remove(clinica); // Remove a clínica da lista
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cadastro da ${clinica.nome} reprovado.')),
    );
  }
}

class HistoricoAprovacoes extends StatelessWidget {
  final List<Historico> historico;

  HistoricoAprovacoes({required this.historico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Aprovações'),
      ),
      body: ListView.builder(
        itemCount: historico.length,
        itemBuilder: (context, index) {
          final item = historico[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${item.nome}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('E-mail: ${item.email}'),
                  Text('Endereço: ${item.endereco}'),
                  Chip(
                    label: Text(item.status),
                    backgroundColor: item.status == 'Aprovada' ? Colors.green : Colors.red,
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

// Classe para representar os dados da clínica
class Clinica {
  final String nome;
  final String email;
  final String endereco;

  Clinica({required this.nome, required this.email, required this.endereco});
}

// Classe para representar o histórico de aprovações
class Historico {
  final String nome;
  final String email;
  final String endereco;
  final String status;

  Historico({required this.nome, required this.email, required this.endereco, required this.status});
}
