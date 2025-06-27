import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TelaDetalheVaga extends StatelessWidget {
  final Map<String, dynamic> vaga;

  TelaDetalheVaga({required this.vaga});

  String formatarData(String data) {
    final parsed = DateTime.parse(data);
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> especificacoes =
        List<String>.from(vaga['especificacoes']);

    return Scaffold(
      appBar: AppBar(
        title: Text(vaga['titulo'] ?? 'Detalhes da Vaga'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cargo:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(vaga['cargo']),
              SizedBox(height: 12),
              Text('Localidade de Trabalho:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(vaga['localidade']),
              SizedBox(height: 12),
              Text('Instituição:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(vaga['instituicao']),
              SizedBox(height: 12),
              Text('Data da Ação:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(formatarData(vaga['data'])),
              SizedBox(height: 12),
              Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(vaga['descricao']),
              SizedBox(height: 12),
              Text('Especificações de vaga:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...especificacoes.map((item) => ListTile(
                    leading: Icon(Icons.check, color: Colors.green),
                    title: Text(item),
                    contentPadding: EdgeInsets.zero,
                  )),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[900],
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(Icons.how_to_reg),
                  label: Text('Candidatar-se'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Candidatura enviada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Futuramente: chamada de API aqui
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
