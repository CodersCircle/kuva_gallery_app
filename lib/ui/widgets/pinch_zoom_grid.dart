import 'package:flutter/material.dart';

/// Pinch-in = more columns, pinch-out = fewer; debounced threshold (#4).
class PinchZoomGrid extends StatefulWidget {
  const PinchZoomGrid({
    super.key,
    required this.columns,
    required this.onColumnsChanged,
    required this.child,
    this.minColumns = 2,
    this.maxColumns = 10,
  });

  final int columns;
  final ValueChanged<int> onColumnsChanged;
  final Widget child;
  final int minColumns;
  final int maxColumns;

  @override
  State<PinchZoomGrid> createState() => _PinchZoomGridState();
}

class _PinchZoomGridState extends State<PinchZoomGrid> {
  double _startScale = 1.0;
  double _accumulatedDelta = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) {
        _startScale = 1.0;
        _accumulatedDelta = 0;
      },
      onScaleUpdate: (details) {
        _accumulatedDelta += details.scale - _startScale;
        _startScale = details.scale;
        // Commit only after ~0.22 scale delta so columns don't flicker (#4).
        if (_accumulatedDelta.abs() < 0.22) return;
        final pinchIn = _accumulatedDelta < 0;
        _accumulatedDelta = 0;
        final next = pinchIn
            ? widget.columns + 1
            : widget.columns - 1;
        final clamped =
            next.clamp(widget.minColumns, widget.maxColumns).toInt();
        if (clamped != widget.columns) widget.onColumnsChanged(clamped);
      },
      child: widget.child,
    );
  }
}
