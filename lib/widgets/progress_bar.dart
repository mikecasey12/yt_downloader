import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final int progress;
  const ProgressBar({super.key, required this.progress});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: 20,
          width: (size.width - 20) * 1,
          color: Colors.red[100],
        ),
        Container(
          height: 20,
          color: Colors.red,
          width: widget.progress < 0
              ? size.width
              : (size.width - 20) * (widget.progress / 100),
        ),
        Center(
          child: Text(
            '${widget.progress}%',
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
