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
        backgroundColor:
            Colors.greenAccent, // Cor de fundo alinhada com o estilo de login
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Bem-vindo ao Aplicativo MenteViva',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Cor de destaque
                    ),
              ),
            ),
            SizedBox(height: 12.0),
            Center(
              child: Text(
                'Nosso objetivo é oferecer suporte e conectar você com profissionais da área de saúde mental, incluindo psicólogos e psiquiatras.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                    ),
              ),
            ),
            SizedBox(height: 20.0), // Espaçamento adicional após o texto
            // Grid de ícones
            GridView.count(
              crossAxisCount: 2, // Dois ícones por linha
              shrinkWrap:
                  true, // Para o GridView ocupar apenas o espaço necessário
              physics:
                  NeverScrollableScrollPhysics(), // Desativa a rolagem do GridView
              childAspectRatio:
                  1.2, // Ajuste para diminuir o tamanho dos quadrados
              crossAxisSpacing:
                  16.0, // Aumenta o espaço horizontal entre os cards
              mainAxisSpacing: 8.0, // Menor distância entre as linhas
              children: [
                _buildIconButton(
                  context,
                  icon: Icons
                      .local_hospital, // Ícone de hospital para Lista de Clínicas
                  label: 'Lista de Clínicas',
                  onPressed: () {
                    Navigator.pushNamed(context, '/exibe_clinica');
                  },
                ),
                _buildIconButton(
                  context,
                  icon: Icons.forum, // Ícone de fórum para Painel de Dúvidas
                  label: 'Fórum (Painel de Dúvidas)',
                  onPressed: () {
                    Navigator.pushNamed(context, '/painel_duvidas');
                  },
                ),
                _buildIconButton(
                  context,
                  icon:
                      Icons.star_rate, // Ícone de estrela para Avaliar Clínica
                  label: 'Avaliar Clínica',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AvaliacaoClinicaPage()),
                    );
                  },
                ),
                _buildSmallIconButton(
                  // Botão "Sair" com ícone menor e texto abaixo
                  context,
                  icon: Icons.exit_to_app,
                  label: 'Sair', // Texto abaixo do ícone
                  onPressed: () {
                    // Limpar o estado da sessão aqui, caso necessário
                    Navigator.pushReplacementNamed(
                        context, '/login'); // Navega de volta à tela de login
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para os ícones de navegação
  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        onEnter: (_) =>
            SystemMouseCursors.click, // Corrigindo a adição do "pointer"
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(
                12.0), // Menor padding para diminuir o tamanho do card
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 40.0, color: Colors.greenAccent), // Ícone menor
                SizedBox(height: 8.0),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0, // Fonte menor
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para o botão "Sair" com ícone menor e texto abaixo
  Widget _buildSmallIconButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        onEnter: (_) =>
            SystemMouseCursors.click, // Corrigindo a adição do "pointer"
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.0), // Menor padding para o botão "Sair"
              child: Icon(icon,
                  size: 30.0, color: Colors.greenAccent), // Apenas o ícone
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0, // Tamanho da fonte do texto
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
