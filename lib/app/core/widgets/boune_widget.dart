import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  final Widget? child;
  final bool enabled;

  const Bouncing({required this.child, Key? key, this.enabled = true})
      : super(key: key);

  @override
  _BouncingState createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() {
      setState(() {
        _scale = 1 - _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.enabled
          ? (PointerDownEvent event) {
        _controller.forward();
      }
          : null,
      onPointerUp: widget.enabled
          ? (PointerUpEvent event) {
        _controller.reverse();
      }
          : null,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
