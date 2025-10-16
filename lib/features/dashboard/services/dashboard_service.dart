import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api.dart';
import '../models/estatisticas_model.dart';

/// Serviço responsável por buscar dados analíticos do dashboard.
class DashboardService {
  Future<EstatisticasModel> fetchEstatisticas(int voluntarioId) async {
    final url = Uri.parse('$baseUrl/voluntario/$voluntarioId/estatisticas');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return EstatisticasModel.fromJson(jsonDecode(response.body));
      } else {
        print('⚠️ Erro ${response.statusCode}: ${response.body}');
        throw Exception('Falha ao carregar estatísticas do servidor');
      }
    } catch (e) {
      print('❌ Erro na requisição: $e');
      throw Exception('Erro de conexão com o servidor');
    }
  }
}
