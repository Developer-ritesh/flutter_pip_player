# Flutter PiP Player `flutter_pip_player`

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/MIT)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Developer-ritesh/flutter_pip_player/blob/master/LICENSE)

A powerful, customizable Picture-in-Picture (PiP) mini player for Flutter apps with smooth animations and edge snapping.

<table>
  <tr>
    <td colspan="2"><img src="doc/flutter_pip_player.gif?raw=true" alt="A powerful, customizable Picture-in-Picture mini player" height="400"/></td>
    <td colspan="2"><img src="doc/s1.png?raw=true" alt="A powerful, customizable Picture-in-Picture mini player" height="400"/></td>
    <td colspan="2"><img src="doc/s2.png?raw=true" alt="A powerful, customizable Picture-in-Picture mini player" height="400"/></td>
    <td colspan="2"><img src="doc/s3.png?raw=true" alt="A powerful, customizable Picture-in-Picture mini player" height="400"/></td>
  </tr>
</table>


## Features

- 🎮 **Fully Draggable**: Drag the mini player anywhere on the screen
- 📌 **Smart Edge Snapping**: Automatically snaps to the nearest edge when released
- 🔄 **Expandable View**: Tap to expand/collapse for more details and controls
- 🎨 **Highly Customizable**: Customize colors, sizes, animations, and more
- 🧩 **Universal Component**: Can display any content (videos, images, maps, etc.)
- 🎛️ **Custom Controls**: Add your own playback controls
- 📊 **Progress Indicator**: Shows playback progress
- 📱 **Responsive Design**: Works on all screen sizes
- 🔄 **Smooth Animations**: Beautiful transitions between states
- 🎯 **Intuitive Gestures**: Natural interaction patterns

## Installation

```yaml
dependencies:
  flutter_pip_player: ^0.1.0
```
flutter pub get

2. **Basic Usage**
- Import the package in your Dart file:

```dart
import 'package:flutter_pip_player/pip_player.dart';
```

## Create a `PipController` in your widget's state:

```dart
class _MyWidgetState extends State<MyWidget> {

  /// Controller
  final PipController _pipController = PipController(
    title: 'My Video',
  );

  /// ...
}
```

## Add the `PipPlayer` to your widget tree, typically inside a `Stack`:
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Your main content here
        ListView(...),
        
        // PiP player
        PipPlayer(
          controller: _pipController,
          content: YourVideoWidget(),
          isPlaying: _isPlaying,
          onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _pipController.toggleVisibility(),
      child: Icon(Icons.picture_in_picture_alt),
    ),
  );
}
```

## Second Example
```dart
PipPlayer(
  controller: _pipController,
  content: Container(
    color: Colors.amberAccent,
  ),
  onReelsDown: () {
    log('down');
  },
  onReelsUp: () {
    log('up');
  },
  onClose: () {
    _pipController.hide();
  },
  onExpand: () {
    _pipController.expand();
  },
  onRewind: () {
    _pipController.progress - 1;
  },
  onForward: () {
    _pipController.progress + 1;
  },
  onFullscreen: () {
    /// Write logic for full screen
    /// you can navigate to other screen
  },
  onPlayPause: () {
    setState(() => _isPlaying = !_isPlaying);
  },
  onTap: () {
    /// do any action
    /// or
    _pipController.toggleExpanded();
  },
),
```

# Customization

- You can customize the appearance and behavior of the PiP player by passing a `PipSettings` object to the controller:

```dart
final PipController _pipController = PipController(
  title: 'Custom Player',
  settings: PipSettings(
    collapsedWidth: 200,
    collapsedHeight: 120,
    expandedWidth: 350,
    expandedHeight: 280,
    borderRadius: BorderRadius.circular(16),
    backgroundColor: Colors.indigo,
    progressBarColor: Colors.amber,
    animationDuration: Duration(milliseconds: 400),
    animationCurve: Curves.easeOutQuart,
  ),
);
```

## Advanced Usage
  - For more control, you can provide custom controls and callbacks:

```dart
PipPlayer(
  controller: _pipController,
  content: CustomContent(),
  customControls: YourCustomControlsWidget(),
  onTap: () {
    // Custom tap behavior
  },
  onClose: () {
    // Custom close behavior
    _pipController.hide();
  },
);
```

## Enable Reels Mode
- With reels mode you can scroll reels up and down using slider
```dart
final PipController _pipController = PipController(
  title: 'Reels PiP Player',
  settings: PipSettings(
      /// enable reels slider
      isReelsMode: true,
      /// Meta-data of reels slider
      reelsBackgroundColor: Colors.black45,
      reelsDragSensitivity: 50.0,
      reelsHeight: 100.0,
      reelsSliderColor: Colors.white,
      reelsSliderIcon: Icons.drag_handle,
      reelsSliderIconColor: Colors.black,
      reelsSliderSize: 25,
      reelsWidth: 30,
  ),
);
```

## Enable or Disable Snaps the PiP player to the nearest edge of screen of body
```dart
final PipController _pipController = PipController(
  isSnaping: true,
  title: 'Pip Player',
);
```


## Using the Controller API
  - The `PipController` provides several methods to control the PiP player programmatically:

```dart
// Show the PiP player
_pipController.show();

// Hide the PiP player
_pipController.hide();

// Toggle visibility
_pipController.toggleVisibility();

// Expand the PiP player
_pipController.expand();

// Collapse the PiP player
_pipController.collapse();

// Toggle between expanded and collapsed states
_pipController.toggleExpanded();

// Update the progress indicator (0.0 to 1.0)
_pipController.updateProgress(0.5);

// Set a new title
_pipController.setTitle('New Video Title');

// Update settings
_pipController.updateSettings(newSettings);
```

## Handling Player State
  - You can listen to changes in the player's state by using a `ListenableBuilder` or by manually adding a listener to the controller:

```dart 
ListenableBuilder(
  listenable: _pipController,
  builder: (context, child) {
    return Text(_pipController.isVisible ? 'Visible' : 'Hidden');
  },
);

// Or manually:
@override
void initState() {
  super.initState();
  _pipController.addListener(_onPipStateChanged);
}

void _onPipStateChanged() {
  // React to changes in isVisible, isExpanded, etc.
}

@override
void dispose() {
  _pipController.removeListener(_onPipStateChanged);
  super.dispose();
}
```

## Best Practices
  - Always dispose of the controller when you're done with it to prevent memory leaks.
  - Use the controller to manage the player's state instead of trying to manipulate it directly.
  - Consider the user experience when deciding when to show/hide the PiP player.
  - Test your implementation on various screen sizes to ensure responsive behavior.


By following this guide and referring to the README, you should be able to effectively integrate and use the Flutter PiP Player in your application. The package provides a flexible and powerful way to implement a YouTube-style floating mini player with custom content and controls.

## Example
See the complete example in the example directory for a full implementation.


# Contributing
Contributions are welcome! Please open an issue or submit a pull request with any improvements or bug fixes.

# GitHub
For more details, [visit the GitHub repository](https://github.com/Developer-ritesh)

## Copyright (c) 2025 [BihariGraphic](https://biharigraphic.com/)