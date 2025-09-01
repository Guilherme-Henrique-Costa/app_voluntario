import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api.dart';
import '../models/estatisticas_model.dart';

class DashboardService {
  Future<EstatisticasModel> fetchEstatisticas(int voluntarioId) async {
    final url = Uri.parse('$baseUrl/voluntario/$voluntarioId/estatisticas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return EstatisticasModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao carregar estatísticas');
    }
  }
}
