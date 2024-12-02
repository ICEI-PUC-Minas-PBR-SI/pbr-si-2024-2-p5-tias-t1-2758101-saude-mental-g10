import 'package:flutter/material.dart'; 
import 'package:saude_mental/database/mysql_connection.dart';
import 'home_page.dart'; //home ADM
import 'cadastro_cliente.dart'; 
import 'cadastro_clinica.dart'; // Tela de cadastro de clínica
import 'avaliacao_clinica.dart'; 
import 'aprovacao_clinica.dart'; // Tela de aprovação de clínica
import 'painel_duvidas.dart';
import 'divulgacao_clinica.dart';
import 'exibe_clinica.dart';
import 'LoginPage.dart'; // Página de login
import 'home_comum.dart'; //home dos usuários comuns
import 'home_clinicas.dart'; //home das clínicas

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde Mental',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 3, 51, 4)),
        useMaterial3: true,
      ),
      home: LoginPage(), // Página inicial ajustada para ser a de login
      routes: {
        '/home': (context) => HomePage(),
        '/home_comum': (context) => HomeComumPage(),
        '/home_clinicas': (context) => HomeClinicasPage(),
        '/cadastro_cliente': (context) => CadastroCliente(), // Tela de cadastro de usuário
        '/cadastro_clinica': (context) => CadastroClinica(), // Tela de cadastro de clínica
        '/avaliacao_clinica': (context) => AvaliacaoClinicaPage(),
        '/aprovacao_clinica': (context) => AprovacaoClinica(), // Tela de aprovação de clínica
        '/painel_duvidas': (context) => DoubtsPublicationScreen(),
        '/divulgacao_clinica': (context) => CadastroServicosClinica(),
        '/exibe_clinica': (context) => ClinicaListScreen(),
        '/login': (context) => LoginPage(),  // Rota adicionada para a tela de login
      },
    );
  }
}
