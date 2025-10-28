import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? text;
  final double size;
  final Color color;

  const LoadingIndicator({
    super.key,
    this.text,
    this.size = 28,
    this.color = Colors.deepPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: 3,
              ),
            ),
            if (text != null) ...[
              const SizedBox(height: 16),
              Text(
                text!,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
