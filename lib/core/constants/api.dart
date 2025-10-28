/// 🌐 Configurações da API do backend
///
/// Este arquivo centraliza todos os endpoints usados pela aplicação.
/// Assim, qualquer alteração no IP/porta/baseUrl é feita em um único lugar.

const String baseUrl = 'http://192.168.0.111:8080/api/v1';

class ApiEndpoints {
  static const String voluntarios = '$baseUrl/voluntario';
  static const String candidaturas = '$baseUrl/candidaturas';
  static const String mensagens = '$baseUrl/mensagem-voluntaria';
  static const String vagasDisponiveis = '$baseUrl/vagasDisponiveis';
  static const String vagasInstituicao = '$baseUrl/vagasInstituicao';
  static const String eventos = '$baseUrl/eventos';
}
