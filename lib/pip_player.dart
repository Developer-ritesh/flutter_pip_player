import 'package:flutter/material.dart';
import 'pip_controller.dart';
import 'pip_view.dart';
import 'widget/pip_controls.dart';

/// A widget that displays a PiP player in a Stack
class PipPlayer extends StatelessWidget {
  /// The controller for the PiP player
  final PipController controller;
  
  /// The content to display in the PiP player
  final Widget content;
  
  /// The title of the content
  final String title;
  
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
  
  /// Callback when the close button is pressed
  final VoidCallback? onClose;
  
  /// Callback when the expand button is pressed
  final VoidCallback? onExpand;
  
  /// Callback when the PiP player is tapped
  final VoidCallback? onTap;
  
  /// Callback when the PiP player is reels scroll up
  final VoidCallback? onReelsUp;
  
  /// Callback when the PiP player is reels scroll down
  final VoidCallback? onReelsDown;
  
  /// Custom controls to display when expanded
  final Widget? customControls;
  
  /// Creates a new PipPlayer
  const PipPlayer({
    super.key,
    required this.controller,
    required this.content,
    this.title = '',
    this.isPlaying = false,
    this.onPlayPause,
    this.onRewind,
    this.onForward,
    this.onFullscreen,
    this.onClose,
    this.onExpand,
    this.onTap,
    this.customControls,
    this.onReelsUp,
    this.onReelsDown,
  });

  @override
  Widget build(BuildContext context) {
    // Set the title
    if (controller.title != title) {
      controller.setTitle(title);
    }
    
    // Build the controls
    final controls = customControls ?? PipControls(
      isPlaying: isPlaying,
      onPlayPause: onPlayPause,
      onRewind: onRewind,
      onForward: onForward,
      onFullscreen: onFullscreen,
      backgroundColor: controller.settings.controlsBackgroundColor,
      height: controller.settings.controlsHeight,
    );
    
    return PipView(
      controller: controller,
      content: content,
      controls: controls,
      onClose: onClose,
      onExpand: onExpand,
      onTap: onTap,
      onReelsUp: onReelsUp,
      onReelsDown: onReelsDown,
    );
  }
}
