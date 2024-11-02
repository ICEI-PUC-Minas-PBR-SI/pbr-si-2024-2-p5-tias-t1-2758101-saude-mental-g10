import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'cadastro_cliente.dart';
import 'avaliacao_clinica.dart'; 
import 'aprovacao_clinica.dart';
import 'painel_duvidas.dart';
import 'divulgacao_clinica.dart';
import 'exibe_clinica.dart'; 

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
      home: HomePage(), 
    );
  }
}
