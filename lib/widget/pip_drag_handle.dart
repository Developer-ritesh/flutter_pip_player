import 'package:flutter/material.dart';

/// A drag handle for the PiP player
class PipDragHandle extends StatelessWidget {
  /// The color of the drag handle
  final Color color;
  
  /// The width of the drag handle
  final double width;
  
  /// The height of the drag handle
  final double height;
  
  /// The border radius of the drag handle
  final BorderRadius borderRadius;
  
  /// Creates a new PipDragHandle
  const PipDragHandle({
    super.key,
    this.color = Colors.white60,
    this.width = 40.0,
    this.height = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(2.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
    );
  }
}
