import 'package:flutter/material.dart';
import 'package:flutter_pip_player/widget/slide_reels_button.dart';
import 'package:provider/provider.dart';
import 'pip_controller.dart';
import 'widget/pip_drag_handle.dart';

/// A widget that displays content in a Picture-in-Picture view
class PipView extends StatefulWidget {
  /// The controller for the PiP player
  final PipController controller;

  /// The content to display in the PiP player
  final Widget content;

  /// The controls to display when expanded
  final Widget? controls;

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

  /// Creates a new PipView
  const PipView({
    super.key,
    required this.controller,
    required this.content,
    this.controls,
    this.onClose,
    this.onExpand,
    this.onTap,
    this.onReelsUp,
    this.onReelsDown,
  });

  @override
  State<PipView> createState() => _PipViewState();
}

class _PipViewState extends State<PipView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.controller.settings.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.controller.settings.animationCurve,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.controller.settings.animationCurve,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: Consumer<PipController>(
        builder: (context, controller, child) {
          if (!controller.isVisible) {
            return const SizedBox.shrink();
          }

          // Get the screen size
          final mediaQuery = MediaQuery.of(context);
          final screenSize = mediaQuery.size;
          controller.setScreenSize(screenSize);

          // Calculate the position
          final position = controller.position.offset;

          // Build the PiP player
          return Positioned(
            left: position.dx,
            top: position.dy,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: _buildPipPlayer(controller),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPipPlayer(PipController controller) {
    final settings = controller.settings;

    return AnimatedContainer(
      duration: settings.animationDuration,
      curve: settings.animationCurve,
      width: controller.width,
      height: controller.height,
      decoration: BoxDecoration(
        color: settings.backgroundColor,
        borderRadius: settings.borderRadius,
        boxShadow: [
          BoxShadow(
            color: settings.shadowColor,
            blurRadius: settings.elevation,
            offset: settings.offset,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: settings.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Content
            Positioned.fill(
              child: widget.content,
            ),

            // Drag handle
            if (settings.showDragHandle && !controller.isExpanded)
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onPanStart: (details) {
                      controller.setDragging(true);
                    },
                    onPanUpdate: (details) {
                      if (settings.allowDrag) {
                        final newPosition = controller.position.offset + details.delta;
                        controller.updatePosition(newPosition);
                      }
                    },
                    onPanEnd: (details) {
                      controller.setDragging(false);
                      if (settings.snapToEdges) {
                        controller.snapToEdge();
                      }
                    },
                    child: PipDragHandle(
                      color: settings.dragHandleColor,
                    ),
                  ),
                ),
              ),

            // Expand button
            if (settings.showExpandButton && !controller.isExpanded)
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () {
                    if (widget.onExpand != null) {
                      widget.onExpand!();
                    } else {
                      controller.toggleExpanded();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fullscreen,
                      color: settings.expandButtonColor,
                      size: 16,
                    ),
                  ),
                ),
              ),

            // Progress bar
            if (settings.showProgressBar)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: controller.progress,
                  backgroundColor: settings.progressBarBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(settings.progressBarColor),
                  minHeight: settings.progressBarHeight,
                ),
              ),

            // Title
            if (settings.showTitle && controller.isExpanded && controller.title.isNotEmpty)
              Positioned(
                bottom: settings.showControls ? settings.controlsHeight : 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.black54,
                  child: Text(
                    controller.title,
                    style: settings.titleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            // Controls
            if (settings.showControls && controller.isExpanded)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: widget.controls ?? const SizedBox.shrink(),
              ),

            // Tap detector
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  controller.setDragging(true);
                },
                onPanUpdate: (details) {
                  if (settings.allowDrag) {
                    final newPosition = controller.position.offset + details.delta;
                    controller.updatePosition(newPosition);
                  }
                },
                onPanEnd: (details) {
                  controller.setDragging(false);
                  if (settings.snapToEdges) {
                    controller.snapToEdge();
                  }
                },
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  } else if (settings.allowExpand) {
                    controller.toggleExpanded();
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),

            // Close button
            if (settings.showCloseButton)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    if (widget.onClose != null) {
                      widget.onClose!();
                    } else {
                      controller.hide();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: settings.closeButtonColor,
                      size: 16,
                    ),
                  ),
                ),
              ),

            // Close button
            if (settings.isReelsMode)
              Align(
                alignment: Alignment.centerRight,
                child: SlidableReelsButton(
                  onReelsUp: widget.onReelsUp!,
                  onReelsDown: widget.onReelsDown!,
                  width: settings.reelsWidth,
                  height: settings.reelsHeight,
                  sliderSize: settings.reelsSliderSize,
                  backgroundColor: settings.reelsBackgroundColor,
                  sliderColor: settings.reelsSliderColor,
                  sliderIcon: settings.reelsSliderIcon,
                  sliderIconColor: settings.reelsSliderIconColor,
                  dragSensitivity: settings.reelsDragSensitivity,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
