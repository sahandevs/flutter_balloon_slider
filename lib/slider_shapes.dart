import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'main.dart';

class CustomSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const CustomSliderThumbShape({
    this.enabledThumbRadius = 8.0,
    this.disabledThumbRadius,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: enabledThumbRadius,
      end: enabledThumbRadius + 8,
    );

    final Tween<double> innerRadiusTween = Tween<double>(
      begin: enabledThumbRadius - 5,
      end: enabledThumbRadius + 6.5,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    canvas.drawCircle(
      center,
      radiusTween.evaluate(activationAnimation),
      Paint()..color = colorTween.evaluate(enableAnimation),
    );

    canvas.drawCircle(
      center,
      innerRadiusTween.evaluate(activationAnimation),
      Paint()..color = Colors.white,
    );
  }
}

class CustomRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const CustomRoundedRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required Animation<double> enableAnimation,
    @required TextDirection textDirection,
    @required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider track height is less than or equal to 0, then it makes no
    // difference whether the track is painted or not, therefore the painting
    // can be a no-op.
    if (sliderTheme.trackHeight <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // The arc rects create a semi-circle with radius equal to track height.
    final Rect leftTrackArcRect = Rect.fromLTWH(
        trackRect.left, trackRect.top, trackRect.height, trackRect.height);
    if (!leftTrackArcRect.isEmpty)
      context.canvas.drawArc(
          leftTrackArcRect, math.pi / 2, math.pi, false, leftTrackPaint);
    final Rect rightTrackArcRect = Rect.fromLTWH(
        trackRect.right - trackRect.height / 2,
        trackRect.top,
        trackRect.height,
        trackRect.height);
    if (!rightTrackArcRect.isEmpty)
      context.canvas.drawArc(
          rightTrackArcRect, -math.pi / 2, math.pi, false, rightTrackPaint);

    final Size thumbSize =
        sliderTheme.thumbShape.getPreferredSize(isEnabled, isDiscrete);
    final Rect leftTrackSegment = Rect.fromLTRB(
        trackRect.left + trackRect.height / 2,
        trackRect.top,
        thumbCenter.dx - thumbSize.width / 2,
        trackRect.bottom);
    if (!leftTrackSegment.isEmpty)
      context.canvas.drawRect(leftTrackSegment, leftTrackPaint);
    final Rect rightTrackSegment = Rect.fromLTRB(
        thumbCenter.dx + thumbSize.width / 2,
        trackRect.top,
        trackRect.right,
        trackRect.bottom);
    if (!rightTrackSegment.isEmpty)
      context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
  }
}

class BalloonPainter extends CustomPainter {
  final double value;

  BalloonPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    var _size = 30.0;
    var _radius = Radius.circular(_size / 2);
    final RRect _rect = RRect.fromLTRBAndCorners(
      0,
      0,
      _size,
      _size,
      topRight: _radius,
      topLeft: _radius,
      bottomLeft: _radius,
    );
    final textStyle = TextStyle(
        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w300);
    final _v = (value * 100).round().toString();
    final textSpan = TextSpan(
      text: _v.length == 2 ? _v : " $_v",
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width + 30,
    );
    final offset = Offset(-7, 15);
    rotate(canvas, 0.0, 0.0, math.pi / 4);
    canvas.drawRRect(_rect, Paint()..color = kActiveColor);
    rotate(canvas, 0.0, 0.0, -math.pi / 4);
    textPainter.paint(canvas, offset);

    // draw triangle

    var path = Path();
    path.moveTo(5, 0);
    path.lineTo(0, 5);
    path.lineTo(0, 0);
    path.close();
    rotate(canvas, 0.0, 0.0, math.pi / 4);
    canvas.translate(30, 30.0);
    canvas.drawPath(
        path,
        Paint()
          ..color = kActiveColor
          ..style = PaintingStyle.fill);
  }

  void rotate(Canvas canvas, double cx, double cy, double angle) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
