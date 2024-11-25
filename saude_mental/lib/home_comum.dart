import 'package:flutter/material.dart';
import 'exibe_clinica.dart';
import 'painel_duvidas.dart';
import 'avaliacao_clinica.dart'; // Importando a tela de avaliação

class HomeComumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo ao MenteViva'),
        backgroundColor: Colors.greenAccent, // Cor de fundo alinhada com o estilo de login
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Acesse os recursos abaixo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Cor de destaque
                    ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildButton(
              context,
              label: 'Lista de Clínicas',
              onPressed: () {
                Navigator.pushNamed(context, '/exibe_clinica');
              },
            ),
            _buildButton(
              context,
              label: 'Fórum (Painel de Dúvidas)',
              onPressed: () {
                Navigator.pushNamed(context, '/painel_duvidas');
              },
            ),
            _buildButton(
              context,
              label: 'Avaliar Clínica', // Novo botão para avaliação
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AvaliacaoClinicaPage()), // Rota para avaliação
                );
              },
            ),
            SizedBox(height: 40.0), // Espaço extra após os botões
            _buildButton(
              context,
              label: 'Sair',
              onPressed: () {
                // Limpar o estado da sessão aqui, caso necessário
                Navigator.pushReplacementNamed(context, '/login'); // Navega de volta à tela de login
              },
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir os botões com estilo semelhante à HomePage
  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.greenAccent, // Cor do botão
          elevation: 5, // Sombra leve para destacar o botão
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Cor do texto do botão
          ),
        ),
      ),
    );
  }
}
