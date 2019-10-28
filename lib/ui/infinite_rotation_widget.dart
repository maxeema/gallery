
import 'package:flutter/widgets.dart';

class InfiniteRotationWidget extends StatefulWidget {

  final Widget child;
  final Duration duration;

  InfiniteRotationWidget(this.duration, this.child);

  @override
  _InfiniteRotationWidgetState createState() => _InfiniteRotationWidgetState();

}

class _InfiniteRotationWidgetState extends State<InfiniteRotationWidget> with SingleTickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(InfiniteRotationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != null && !_controller.isAnimating)
      _controller.repeat();
    else if (widget.duration == null && _controller.isAnimating)
      _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return RotationTransition(
          turns: _controller,
          child: widget.child,
        );
      },
    );

  }

}
