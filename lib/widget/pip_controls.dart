import 'package:flutter/material.dart';

/// Default controls for the PiP player
class PipControls extends StatelessWidget {
  /// Whether the content is playing
  final bool isPlaying;
  
  /// Callback when the play/pause button is pressed
  final VoidCallback? onPlayPause;
  
  /// Callback when the rewind button is pressed
  final VoidCallback? onRewind;
  
  /// Callback when the forward button is pressed
  final VoidCallback? onForward;
  
  /// Callback when the fullscreen button is pressed
  final VoidCallback? onFullscreen;
  
  /// The color of the icons
  final Color iconColor;
  
  /// The size of the icons
  final double iconSize;
  
  /// The background color of the controls
  final Color backgroundColor;
  
  /// The height of the controls
  final double height;
  
  /// Creates new PipControls
  const PipControls({
    super.key,
    this.isPlaying = false,
    this.onPlayPause,
    this.onRewind,
    this.onForward,
    this.onFullscreen,
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
    this.backgroundColor = Colors.black87,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (onRewind != null)
            IconButton(
              icon: Icon(Icons.replay_10, color: iconColor, size: iconSize),
              onPressed: onRewind,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (onPlayPause != null)
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: iconColor,
                size: iconSize + 4,
              ),
              onPressed: onPlayPause,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (onForward != null)
            IconButton(
              icon: Icon(Icons.forward_10, color: iconColor, size: iconSize),
              onPressed: onForward,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (onFullscreen != null)
            IconButton(
              icon: Icon(Icons.fullscreen, color: iconColor, size: iconSize),
              onPressed: onFullscreen,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
