import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:saude_mental/database/mysql_connection.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isClinica = false; // Identifica se é clínica ou usuário
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final conn = await connectToDatabase();

      // Consulta ajustada com base no tipo selecionado
      String query;
      List<dynamic> params;

      if (_isClinica) {
        query = 'SELECT email FROM tbl_clinica WHERE email = ? AND senha = ?';
        params = [_emailController.text, _senhaController.text];
      } else {
        query = 'SELECT tipo_usuario FROM tbl_usuario WHERE email = ? AND senha = ?';
        params = [_emailController.text, _senhaController.text];
      }

      final results = await conn.query(query, params);

      if (results.isNotEmpty) {
        if (_isClinica) {
          // Redireciona clínica para a página de serviços
          Navigator.pushReplacementNamed(context, '/home_clinicas');
        } else {
          final tipoUsuario = results.first['tipo_usuario'];
          if (tipoUsuario == 'ADM') {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (tipoUsuario == 'USUARIO') {
            Navigator.pushReplacementNamed(context, '/home_comum');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciais inválidas. Verifique o e-mail e senha.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao tentar fazer login. Tente novamente mais tarde.')),
      );
      print('Erro ao tentar fazer login: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Bem-vindo ao MenteViva',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              // Formulário com validação
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.greenAccent),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.greenAccent),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Por favor, insira um e-mail válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.greenAccent),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.greenAccent),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),// Checkbox para selecionar o tipo de login
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Checkbox(
                    value: _isClinica,
                    onChanged: (value) {
                      setState(() {
                        _isClinica = value!;
                      });
                    },
                  ),
                  const Text('Sou uma clínica'),
                    ],
                  ),
                    
                    const SizedBox(height: 15),
                    // Botão de Login
                    _isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.greenAccent))
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Opções de Cadastro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro_cliente');
                    },
                    child: const Text('Cadastre-se usuário', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro_clinica');
                    },
                    child: const Text('Cadastre-se clínica', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
