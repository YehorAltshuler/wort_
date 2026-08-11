import 'package:flutter/material.dart';

class FullscreenImageViewerRoute extends PageRouteBuilder<void> {
  FullscreenImageViewerRoute({
    required ImageProvider<Object> imageProvider,
    required Object heroTag,
  }) : super(
         opaque: false,
         barrierColor: Colors.transparent,
         transitionDuration: const Duration(milliseconds: 260),
         reverseTransitionDuration: const Duration(milliseconds: 220),
         pageBuilder: (context, animation, secondaryAnimation) =>
             FullscreenImageViewer(
               imageProvider: imageProvider,
               heroTag: heroTag,
               routeAnimation: animation,
             ),
       );
}

class FullscreenImageViewer extends StatefulWidget {
  const FullscreenImageViewer({
    required this.imageProvider,
    required this.heroTag,
    required this.routeAnimation,
    super.key,
  });

  final ImageProvider<Object> imageProvider;
  final Object heroTag;
  final Animation<double> routeAnimation;

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  static const _maxScale = 5.0;
  static const _doubleTapScale = 2.5;
  static const _dismissExtentFactor = 0.18;

  final TransformationController _transformationController =
      TransformationController();
  var _dragOffset = 0.0;
  var _pointerCount = 0;
  var _dragging = false;
  Offset? _doubleTapPosition;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final dragProgress = (_dragOffset.abs() / (size.height * 0.6)).clamp(
      0.0,
      1.0,
    );
    final imageScale = 1 - (dragProgress * 0.16);
    return AnimatedBuilder(
      animation: widget.routeAnimation,
      builder: (context, child) => ColoredBox(
        color: Colors.black.withValues(
          alpha: widget.routeAnimation.value * (1 - dragProgress),
        ),
        child: child,
      ),
      child: Listener(
        onPointerDown: (_) => _pointerCount++,
        onPointerMove: _onPointerMove,
        onPointerUp: (_) => _finishDrag(size.height),
        onPointerCancel: (_) => _finishDrag(size.height),
        child: AnimatedContainer(
          duration: _dragging
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByDouble(0, _dragOffset, 0, 1)
            ..scaleByDouble(imageScale, imageScale, 1, 1),
          child: GestureDetector(
            onDoubleTapDown: (details) =>
                _doubleTapPosition = details.localPosition,
            onDoubleTap: _toggleZoom,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1,
              maxScale: _maxScale,
              child: Hero(
                tag: widget.heroTag,
                child: Image(
                  image: widget.imageProvider,
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointerCount != 1 ||
        !_isAtInitialScale ||
        event.delta.dy.abs() <= event.delta.dx.abs()) {
      return;
    }
    setState(() {
      _dragging = true;
      _dragOffset += event.delta.dy;
    });
  }

  void _finishDrag(double height) {
    if (_pointerCount > 0) _pointerCount--;
    if (_pointerCount != 0) return;
    if (_dragOffset.abs() >= height * _dismissExtentFactor) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _dragging = false;
      _dragOffset = 0;
    });
  }

  void _toggleZoom() {
    if (!_isAtInitialScale) {
      _transformationController.value = Matrix4.identity();
      return;
    }
    final position = _doubleTapPosition ?? Offset.zero;
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(
        -position.dx * (_doubleTapScale - 1),
        -position.dy * (_doubleTapScale - 1),
        0,
        1,
      )
      ..scaleByDouble(_doubleTapScale, _doubleTapScale, 1, 1);
  }

  bool get _isAtInitialScale =>
      _transformationController.value.getMaxScaleOnAxis() <= 1.01;
}
