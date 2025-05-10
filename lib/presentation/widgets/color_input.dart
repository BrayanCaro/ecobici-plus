import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _ColorSelected extends Cubit<Color?> {
  _ColorSelected({required this.onSelected, Color? initial}) : super(initial);

  final void Function(Color color) onSelected;

  void select(Color color) {
    onSelected(color);
    emit(color);
  }
}

class ColorInput extends StatelessWidget {
  const ColorInput({super.key, required this.onSelected, this.initial});

  final void Function(Color color) onSelected;

  final Color? initial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _ColorSelected(onSelected: onSelected, initial: initial),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final color in [
            Colors.red,
            Colors.pink,
            Colors.purple,
            Colors.deepPurple,
            Colors.indigo,
            Colors.blue,
            Colors.lightBlue,
            Colors.cyan,
            Colors.teal,
            Colors.green,
            Colors.lightGreen,
            Colors.lime,
            Colors.yellow,
            Colors.amber,
            Colors.orange,
            Colors.deepOrange,
            Colors.brown,
            Colors.grey,
            Colors.blueGrey,
          ])
            _ColorInputChoice(color: color),
        ],
      ),
    );
  }
}

class _ColorInputChoice extends StatelessWidget {
  const _ColorInputChoice({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<_ColorSelected>().select(color),
      child: BlocBuilder<_ColorSelected, Color?>(
        builder:
            (context, state) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border:
                    color == state
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
              ),
            ),
        buildWhen:
            (previous, current) => (previous == color) ^ (current == color),
      ),
    );
  }
}
