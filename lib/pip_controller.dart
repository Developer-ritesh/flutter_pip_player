import 'package:flutter/material.dart';
import 'models/pip_position.dart';
import 'models/pip_settings.dart';

/// Controller for the PiP player
class PipController extends ChangeNotifier {
  bool _isVisible = false;
  bool _isExpanded = false;
  bool _isDragging = false;
  PipPosition _position;
  PipSettings _settings;
  double _progress = 0.0;
  String _title;
  Size _screenSize = Size.zero;

  /// Minimum margin to ensure safe area
  double margin;

  /// Ensuring visibility at the bottom
  double bottomSafePadding;

  /// Enable Snaps the PiP player to the nearest edge
  bool isSnaping;

  PipController({
    PipSettings settings = const PipSettings(),
    String title = '',
    PipPosition? initialPosition,
    this.bottomSafePadding = 80.0,
    this.isSnaping = true,
    this.margin = 10.0,
  })  : _settings = settings,
        _title = title,
        _position = initialPosition ??
            const PipPosition(
              offset: Offset.zero,
              anchor: PipAnchor.bottomRight,
            );

  bool get isVisible => _isVisible;
  bool get isExpanded => _isExpanded;
  bool get isDragging => _isDragging;
  PipPosition get position => _position;
  PipSettings get settings => _settings;
  double get progress => _progress;
  String get title => _title;
  Size get screenSize => _screenSize;
  double get width => _isExpanded ? _settings.expandedWidth : _settings.collapsedWidth;
  double get height => _isExpanded ? _settings.expandedHeight : _settings.collapsedHeight;

  void setScreenSize(Size size) {
    if (_screenSize != size) {
      _screenSize = size;
      if (_position.offset == Offset.zero) {
        _initializePosition();
      }
      notifyListeners();
    }
  }

  void _initializePosition() {
    if (_screenSize == Size.zero) return;
    _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
  }

  Offset _getSafeOffset(Offset offset) {
    double x = offset.dx;
    double y = offset.dy;

    x = x.clamp(margin, _screenSize.width - width - margin);
    y = y.clamp(margin, _screenSize.height - height - margin - bottomSafePadding);

    return Offset(x, y);
  }

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      _isExpanded = false;
      notifyListeners();
    }
  }

  void toggleVisibility() {
    _isVisible = !_isVisible;
    if (!_isVisible) {
      _isExpanded = false;
    }
    notifyListeners();
  }

  void expand() {
    if (!_isExpanded && _settings.allowExpand) {
      _isExpanded = true;
      _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
      notifyListeners();
    }
  }

  void collapse() {
    if (_isExpanded) {
      _isExpanded = false;
      _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
      notifyListeners();
    }
  }

  void toggleExpanded() {
    if (_settings.allowExpand) {
      _isExpanded = !_isExpanded;
      _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
      notifyListeners();
    }
  }

  void setDragging(bool dragging) {
    if (_isDragging != dragging) {
      _isDragging = dragging;
      notifyListeners();
    }
  }

  void updatePosition(Offset offset) {
    _position = _position.copyWith(offset: _getSafeOffset(offset));
    notifyListeners();
  }

  void snapToEdge() {
    if (!isSnaping) return;
    if (_screenSize == Size.zero) return;

    final double x = _position.offset.dx;
    final double y = _position.offset.dy;

    final double leftDistance = x;
    final double rightDistance = _screenSize.width - (x + _settings.collapsedWidth);
    final double topDistance = y;
    final double bottomDistance =
        _screenSize.height - (y + _settings.collapsedHeight) - bottomSafePadding;

    double newX = x;
    double newY = y;
    PipAnchor newAnchor;

    if (leftDistance < rightDistance) {
      newX = margin;
    } else {
      newX = _screenSize.width - _settings.collapsedWidth - margin;
    }

    if (topDistance < bottomDistance) {
      newY = margin;
      newAnchor = leftDistance < rightDistance ? PipAnchor.topLeft : PipAnchor.topRight;
    } else {
      newY = _screenSize.height - _settings.collapsedHeight - margin - bottomSafePadding;
      newAnchor = leftDistance < rightDistance ? PipAnchor.bottomLeft : PipAnchor.bottomRight;
    }

    _position = _position.copyWith(
      offset: Offset(newX, newY),
      anchor: newAnchor,
    );

    notifyListeners();
  }

  void updateProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setTitle(String title) {
    if (_title != title) {
      _title = title;
      notifyListeners();
    }
  }

  void updateSettings(PipSettings settings) {
    _settings = settings;
    notifyListeners();
  }
}
