import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_voluntario/core/constants/api.dart';
import '../models/voluntario.dart';

/// Serviço responsável por operações relacionadas ao Voluntário.
class VoluntarioService {
  static const _endpoint = ApiEndpoints.voluntarios;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// 🔐 Login de voluntário
  Future<Voluntario?> login(String email, String senha) async {
    final url = Uri.parse('$_endpoint/login');
    final body = jsonEncode({
      'emailInstitucional': email,
      'password': senha,
    });

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        return Voluntario.fromJson(jsonDecode(response.body));
      }

      _logErro('login', response);
      return null;
    } catch (e) {
      print('❌ Erro no login: $e');
      return null;
    }
  }

  /// 🔍 Busca voluntário por ID
  Future<Voluntario?> buscarPorId(int id) async {
    final url = Uri.parse('$_endpoint/$id');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return Voluntario.fromJson(jsonDecode(response.body));
      }

      _logErro('buscarPorId', response);
      return null;
    } catch (e) {
      print('❌ Erro ao buscar voluntário: $e');
      return null;
    }
  }

  /// 📝 Cadastro de voluntário
  Future<bool> cadastrarVoluntario(Voluntario voluntario) async {
    final url = Uri.parse(_endpoint);
    final body = jsonEncode(voluntario.toJsonCompleto());

    try {
      final response = await http.post(url, headers: _headers, body: body);

      print('🔹 [POST] Status: ${response.statusCode}');
      print('🔹 Body: ${response.body}');

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('❌ Erro ao cadastrar voluntário: $e');
      return false;
    }
  }

  /// ✏️ Atualização de voluntário existente
  Future<bool> atualizarVoluntario(Voluntario voluntario) async {
    if (voluntario.id == null) {
      print('⚠️ ID ausente ao tentar atualizar voluntário.');
      return false;
    }

    final url = Uri.parse('$_endpoint/${voluntario.id}');
    final body = jsonEncode(voluntario.toJsonCompleto());

    try {
      final response = await http.put(url, headers: _headers, body: body);

      print('🔹 [PUT] Status: ${response.statusCode}');
      print('🔹 Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erro ao atualizar voluntário: $e');
      return false;
    }
  }

  /// 🔄 Redefinição de senha
  Future<Map<String, dynamic>> redefinirSenha(
      String email, String senha) async {
    final url = Uri.parse('$_endpoint/redefinir-senha');
    final body = jsonEncode({'email': email, 'senha': senha});

    try {
      final response = await http.post(url, headers: _headers, body: body);
      print('🔹 [POST] redefinir-senha: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return _erro('Erro ao redefinir senha (status ${response.statusCode}).');
    } catch (e) {
      print('❌ Erro ao redefinir senha: $e');
      return _erro('Falha de conexão com o servidor.');
    }
  }

  /// Helpers internos
  void _logErro(String metodo, http.Response r) {
    print('⚠️ Erro em $metodo: ${r.statusCode}');
    print('Body: ${r.body}');
  }

  Map<String, dynamic> _erro(String msg) => {'sucesso': false, 'mensagem': msg};
}
