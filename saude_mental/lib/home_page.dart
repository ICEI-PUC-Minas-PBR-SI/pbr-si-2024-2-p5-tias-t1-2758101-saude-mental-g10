import 'package:flutter/material.dart';
import 'cadastro_cliente.dart';
import 'avaliacao_clinica.dart';
import 'aprovacao_clinica.dart';
import 'cadastro_clinica.dart';
import 'painel_duvidas.dart';
import 'divulgacao_clinica.dart';
import 'exibe_clinica.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saúde Mental'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0, 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Bem-vindo ao Aplicativo de Saúde Mental',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Nosso objetivo é oferecer suporte e conectar você com profissionais da área de saúde mental, incluindo psicólogos e psiquiatras. Comece seu cuidado agora mesmo ao cadastrar-se na nossa plataforma.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildButton(
              context,
              label: 'Cadastrar Cliente',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroCliente()),
                );
              },
            ),
            _buildButton(
              context,
              label: 'Cadastrar Serviços',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroServicosClinica()),
                );
              },
            ),
            _buildButton(
              context,
              label: 'Cadastrar Clínica',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroClinica()),
                );
              },
            ),
            _buildButton(
              context,
              label: 'Avaliar Clínicas',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AvaliacaoClinicaPage()),
                );
              },
            ),
            _buildButton(
              context,
              label: 'Solicitações de Cadastro',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SolicitacaoClinicas()),
                );
              },
            ),
            _buildButton(
              context,
              label: 'Clínicas',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClinicaListScreen()),
                );
              },
            ),
            _buildButton(
              context,
              label: 'Fórum',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoubtsPublicationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
