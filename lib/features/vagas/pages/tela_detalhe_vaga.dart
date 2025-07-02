// Atualização: TelaDetalheVaga agora aceita VagaInstituicao ou VagaCandidatada com botão de candidatura opcional

import 'package:flutter/material.dart';
import 'package:app_voluntario/features/vagas/models/vaga_instituicao_model.dart';
import 'package:app_voluntario/features/vagas/models/vaga_candidatada_model.dart';
import 'package:app_voluntario/core/constants/storage_service.dart';
import 'package:app_voluntario/features/vagas/services/vaga_voluntario_service.dart';
import 'package:intl/intl.dart';

class TelaDetalheVaga extends StatefulWidget {
  final dynamic vaga;

  const TelaDetalheVaga({required this.vaga, super.key});

  @override
  State<TelaDetalheVaga> createState() => _TelaDetalheVagaState();
}

class _TelaDetalheVagaState extends State<TelaDetalheVaga> {
  bool _carregando = false;

  bool get podeCandidatar => widget.vaga is VagaInstituicao;

  Future<void> _candidatar() async {
    setState(() => _carregando = true);

    try {
      final voluntario = await StorageService.obterAtual();
      if (voluntario == null) throw Exception("Voluntário não autenticado");

      await VagasVoluntariasService().candidatar(
        vagaId: widget.vaga.id,
        voluntarioId: voluntario.id!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Candidatura enviada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar candidatura: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaga = widget.vaga;

    final cargo = vaga.cargo;
    final localidade = vaga.localidade;
    final area = vaga.area;
    final tipoVaga = vaga.tipoVaga;
    final horario = vaga.horario;
    final tempoVoluntariado = vaga.tempoVoluntariado;
    final disponibilidade = vaga.disponibilidade;
    final descricao = vaga.descricao;
    final instituicao = vaga.instituicao.nome;
    final especificacoes = vaga.especificacoes ?? [];
    final dataCandidatura =
        vaga is VagaCandidatada ? vaga.dataCandidatura : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cargo,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Instituição:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(instituicao),
              SizedBox(height: 12),
              Text('Localidade:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(localidade),
              SizedBox(height: 12),
              Text('Área:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(area),
              SizedBox(height: 12),
              Text('Tipo de Vaga:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(tipoVaga),
              SizedBox(height: 12),
              Text('Horário:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(horario),
              SizedBox(height: 12),
              Text('Tempo de Voluntariado:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(tempoVoluntariado),
              SizedBox(height: 12),
              Text('Disponibilidade:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(disponibilidade),
              SizedBox(height: 12),
              if (dataCandidatura != null)
                Text(
                    'Candidatado em: ${DateFormat('dd/MM/yyyy').format(dataCandidatura)}'),
              SizedBox(height: 12),
              Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(descricao),
              SizedBox(height: 12),
              Text('Especificações:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...especificacoes.map(
                (e) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.check, color: Colors.green),
                  title: Text(e),
                ),
              ),
              SizedBox(height: 20),
              if (podeCandidatar)
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    icon: _carregando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.how_to_reg, color: Colors.white),
                    label: Text(
                      _carregando ? 'Enviando...' : 'Candidatar-se',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: _carregando ? null : _candidatar,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
