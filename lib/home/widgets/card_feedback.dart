import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_voluntario/features/feedback/models/feedback_model.dart';
import 'package:app_voluntario/shared/widgets/app_card.dart';

class CardFeedback extends StatelessWidget {
  final FeedbackModel feedback;

  const CardFeedback({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        leading: Icon(Icons.feedback, color: Colors.deepPurple[800]),
        title: Text(feedback.mensagem),
        subtitle: Text(
          DateFormat('dd/MM/yyyy – HH:mm').format(feedback.data),
        ),
      ),
    );
  }
}
