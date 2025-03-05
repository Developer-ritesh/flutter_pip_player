import 'package:flutter/material.dart';

class SlidableReelsButton extends StatefulWidget {
  final VoidCallback onReelsUp;
  final VoidCallback onReelsDown;
  final double width;
  final double height;
  final double sliderSize;
  final Color backgroundColor;
  final Color sliderColor;
  final IconData sliderIcon;
  final Color sliderIconColor;
  final double dragSensitivity;

  const SlidableReelsButton({
    super.key,
    required this.onReelsUp,
    required this.onReelsDown,
    this.width = 30,
    this.height = 100,
    this.sliderSize = 25,
    this.backgroundColor = Colors.black45,
    this.sliderColor = Colors.white,
    this.sliderIcon = Icons.drag_handle,
    this.sliderIconColor = Colors.black,
    this.dragSensitivity = 50.0,
  });

  @override
  _SlidableReelsButtonState createState() => _SlidableReelsButtonState();
}

class _SlidableReelsButtonState extends State<SlidableReelsButton> {
  double position = 0.0; // 0 means center, -1 up, 1 down

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.width / 2),
        ),
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            setState(() {
              position += details.primaryDelta! / widget.dragSensitivity;
              position = position.clamp(-1.0, 1.0);
            });
          },
          onVerticalDragEnd: (details) {
            if (position <= -0.5) {
              widget.onReelsUp();
            } else if (position >= 0.5) {
              widget.onReelsDown();
            }
            setState(() {
              position = 0.0;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: (widget.height / 2 - widget.sliderSize / 2) + (position * (widget.height / 4)),
                child: Container(
                  width: widget.sliderSize,
                  height: widget.sliderSize,
                  decoration: BoxDecoration(
                    color: widget.sliderColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.sliderIcon,
                    color: widget.sliderIconColor,
                    size: widget.sliderSize / 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}