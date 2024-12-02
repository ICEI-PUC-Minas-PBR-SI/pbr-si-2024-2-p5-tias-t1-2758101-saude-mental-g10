import 'package:flutter/material.dart';
import 'avaliacao_clinica.dart';
import 'painel_duvidas.dart';
import 'divulgacao_clinica.dart';

class HomeClinicasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MenteViva - Clínicas'),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Bem-vindo, Clínica!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ),
              SizedBox(height: 12.0),
              Center(
                child: Text(
                  'Aqui você pode gerenciar seus serviços, interagir no fórum e verificar avaliações.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                ),
              ),
              SizedBox(height: 24.0),
              // Grid de ícones
              GridView.count(
                crossAxisCount: 2, // Dois ícones por linha
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 8.0,
                children: [
                  _buildIconButton(
                    context,
                    icon: Icons.checklist_rtl,
                    label: 'Cadastrar Serviços',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastroServicosClinica(),
                        ),
                      );
                    },
                  ),
                  _buildIconButton(
                    context,
                    icon: Icons.star_rate,
                    label: 'Avaliações',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvaliacaoClinicaPage(),
                        ),
                      );
                    },
                  ),
                  _buildIconButton(
                    context,
                    icon: Icons.forum,
                    label: 'Fórum',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoubtsPublicationScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSmallIconButton(
                    context,
                    icon: Icons.exit_to_app,
                    label: 'Sair',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ],
          ),
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
        cursor: SystemMouseCursors.click,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40.0, color: Colors.greenAccent),
                SizedBox(height: 8.0),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
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

  // Widget para o botão "Sair"
  Widget _buildSmallIconButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Icon(icon, size: 30.0, color: Colors.greenAccent),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
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
