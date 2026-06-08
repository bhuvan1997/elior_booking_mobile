import 'package:flutter/material.dart';

class DebouncedTap extends StatefulWidget {
  const DebouncedTap({
    super.key,
    required this.child,
    required this.onTap,
    this.window = const Duration(milliseconds: 900),
  });

  final Widget child;
  final VoidCallback? onTap;
  final Duration window;

  @override
  State<DebouncedTap> createState() => _DebouncedTapState();
}

class _DebouncedTapState extends State<DebouncedTap> {
  bool _locked = false;

  void _handle() {
    if (_locked) return;
    _locked = true;
    widget.onTap?.call();
    Future.delayed(widget.window, () => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: _handle, highlightColor: Colors.transparent, splashColor: Colors.transparent, child: widget.child);
  }
}