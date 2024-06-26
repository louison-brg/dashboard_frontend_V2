import 'package:flutter/material.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({
    Key? key,
    required this.name,
    required this.color,
  }) : super(key: key);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  const LegendsListWidget({
    Key? key,
    required this.legends,
  }) : super(key: key);

  final List<Legend> legends;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
          key: ValueKey(e.name), // Ajout d'une clé unique pour chaque légende
          name: e.name,
          color: e.color,
        ),
      )
          .toList(),
    );
  }
}

class Legend {
  Legend(this.name, this.color);
  final String name;
  final Color color;
}
