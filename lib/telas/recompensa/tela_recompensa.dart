import 'package:app_voluntario/telas/recompensa/tela_conquistas.dart';
import 'package:app_voluntario/telas/recompensa/tela_historico_recompensa.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TelaRecompensa extends StatefulWidget {
  @override
  _TelaRecompensaState createState() => _TelaRecompensaState();
}

class _TelaRecompensaState extends State<TelaRecompensa> {
  bool recompensaRecebida = false;

  void _receberRecompensa() {
    setState(() {
      recompensaRecebida = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Parabéns! 🎉'),
        content: Text(
          'Sua recompensa foi registrada com sucesso. Obrigado por sua dedicação!',
        ),
        actions: [
          TextButton(
            child: Text('Fechar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recompensa'),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.deepPurple[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              recompensaRecebida
                  ? Lottie.asset(
                      'assets/animations/congrats.json',
                      width: 200,
                      height: 200,
                      repeat: true,
                    )
                  : Icon(Icons.emoji_events,
                      size: 100, color: Colors.amber[700]),
              SizedBox(height: 24),
              Text(
                recompensaRecebida
                    ? 'Recompensa Recebida! 👏'
                    : 'Obrigado por fazer a diferença!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Você contribuiu para uma causa importante. Como reconhecimento, você pode resgatar sua recompensa agora.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: recompensaRecebida ? null : _receberRecompensa,
                icon: Icon(Icons.card_giftcard),
                label: Text('Receber Recompensa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
              SizedBox(height: 30),
              Divider(color: Colors.white54),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TelaConquistas()),
                  );
                },
                icon: Icon(Icons.military_tech),
                label: Text('Ver Conquistas / Medalhas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple[900],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TelaHistoricoRecompensas()),
                  );
                },
                icon: Icon(Icons.history),
                label: Text('Ver Histórico de Recompensas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple[900],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
