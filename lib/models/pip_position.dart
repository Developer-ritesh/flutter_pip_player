import 'package:flutter/material.dart';

/// Represents the position of the PiP player on the screen
class PipPosition {
  /// The current position of the PiP player
  final Offset offset;
  
  /// The anchor position (corner) of the PiP player
  final PipAnchor anchor;
  
  /// Creates a new PipPosition
  const PipPosition({
    required this.offset,
    this.anchor = PipAnchor.bottomRight,
  });
  
  /// Creates a copy of this position with the given fields replaced
  PipPosition copyWith({
    Offset? offset,
    PipAnchor? anchor,
  }) {
    return PipPosition(
      offset: offset ?? this.offset,
      anchor: anchor ?? this.anchor,
    );
  }
}

/// Represents the anchor position of the PiP player
enum PipAnchor {
  /// Top left corner of the screen
  topLeft,
  
  /// Top right corner of the screen
  topRight,
  
  /// Bottom left corner of the screen
  bottomLeft,
  
  /// Bottom right corner of the screen
  bottomRight,
  
  /// Custom position (not anchored to a corner)
  custom,
}

/// Extension methods for PipAnchor
extension PipAnchorExtension on PipAnchor {
  /// Returns true if this anchor is on the left side of the screen
  bool get isLeft => this == PipAnchor.topLeft || this == PipAnchor.bottomLeft;
  
  /// Returns true if this anchor is on the right side of the screen
  bool get isRight => this == PipAnchor.topRight || this == PipAnchor.bottomRight;
  
  /// Returns true if this anchor is on the top of the screen
  bool get isTop => this == PipAnchor.topLeft || this == PipAnchor.topRight;
  
  /// Returns true if this anchor is on the bottom of the screen
  bool get isBottom => this == PipAnchor.bottomLeft || this == PipAnchor.bottomRight;
}
