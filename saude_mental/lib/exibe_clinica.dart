import 'package:flutter/material.dart';

// Classe que representa uma Clínica
class Clinica {
  final String nome;
  final String endereco;
  final String telefone;

  Clinica({required this.nome, required this.endereco, required this.telefone});
}

// Serviço para gerar clínicas aleatórias
class ClinicaService {
  // Função para gerar uma lista de clínicas aleatórias
  static List<Clinica> generateClinicas(int count) {
    final List<Clinica> clinicas = [];
    final List<String> nomes = [
      'Clínica A',
      'Clínica B',
      'Clínica C',
      'Clínica D',
      'Clínica E',
      'Clínica F',
      'Clínica G',
      'Clínica H',
      'Clínica I',
      'Clínica J',
    ];

    for (int i = 0; i < count; i++) {
      clinicas.add(Clinica(
        nome: nomes[i % nomes.length],
        endereco: 'Endereço ${i + 1}',
        telefone: '(00) 1234-567${i % 10}',
      ));
    }
    
    return clinicas;
  }
}

// Tela para exibir a lista de clínicas
class ClinicaListScreen extends StatefulWidget {
  @override
  _ClinicaListScreenState createState() => _ClinicaListScreenState();
}

class _ClinicaListScreenState extends State<ClinicaListScreen> {
  late List<Clinica> clinicas;
  List<Clinica> filteredClinicas = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clinicas = ClinicaService.generateClinicas(10); // Gera 10 clínicas aleatórias
    filteredClinicas = clinicas; // Inicializa com todas as clínicas
  }

  void _filterClinicas() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredClinicas = clinicas.where((clinica) {
        return clinica.nome.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clínicas de Saúde Mental'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => _filterClinicas(),
              decoration: InputDecoration(
                labelText: 'Buscar Clínica',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredClinicas.length,
        itemBuilder: (context, index) {
          final clinica = filteredClinicas[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinica.nome,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Endereço: ${clinica.endereco}'),
                  Text('Telefone: ${clinica.telefone}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Função principal que inicia o aplicativo
void main() {
  runApp(MaterialApp(
    title: 'Clínicas de Saúde Mental',
    home: ClinicaListScreen(),
  ));
}