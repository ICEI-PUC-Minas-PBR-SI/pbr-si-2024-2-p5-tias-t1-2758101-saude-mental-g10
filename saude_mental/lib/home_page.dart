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
        title: Text('MenteViva'),
        backgroundColor: Colors.greenAccent, // Usando o tom de cor consistente
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
              SizedBox(height: 24.0),
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
                    MaterialPageRoute(
                        builder: (context) => CadastroServicosClinica()),
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
                label: 'Aprovar Clínicas',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AprovacaoClinica()),
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
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.greenAccent, // Cor do botão
          elevation: 5, // Leve sombra para destacar o botão
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
