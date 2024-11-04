import 'package:mysql1/mysql1.dart';
import 'package:saude_mental/database/mysql_connection.dart';

// Configuração de conexão com o MySQL
Future<MySqlConnection> connectToDatabase() async {
  final connectionSettings = ConnectionSettings(
    host: 'tisaudebanco.ctcyu2aastmp.us-east-1.rds.amazonaws.com', // Endereço do servidor MySQL
    port: 3306, // Porta do MySQL
    user: 'app', // Nome do usuário do banco
    password: 'trabalhosaude2024', // Senha do usuário do banco
    db: 'tisaudebanco', // Nome do banco de dados
  );

  return await MySqlConnection.connect(connectionSettings);
}
