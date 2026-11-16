import 'package:material_ui/material_ui.dart';

enum ButtonInteractionState { normal, hovered, pressed, disabled }

class CustomButtonStyle {
  final Color normalColor;
  final Color hoverColor;
  final Color pressedColor;
  final Color disabledColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final double elevation;
  final TextStyle textStyle;

  const CustomButtonStyle({
    this.normalColor = const Color(0xFFFF9800),
    this.hoverColor = const Color(0xFFFB8C00),
    this.pressedColor = const Color(0xFFE65100),
    this.disabledColor = const Color(0xFFBDBDBD),
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderRadius = 12.0,
    this.borderWidth = 0.0,
    this.elevation = 4.0,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  });

  Color resolveBackgroundColor(ButtonInteractionState state) {
    switch (state) {
      case ButtonInteractionState.disabled:
        return disabledColor;
      case ButtonInteractionState.pressed:
        return pressedColor;
      case ButtonInteractionState.hovered:
        return hoverColor;
      case ButtonInteractionState.normal:
        return normalColor;
    }
  }
}

class CustomButtonPainter extends CustomPainter {
  final String label;
  final ButtonInteractionState state;
  final CustomButtonStyle style;

  CustomButtonPainter({
    required this.label,
    required this.state,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double pressOffset = (state == ButtonInteractionState.pressed)
        ? 2.5
        : 0.0;
    final double currentElevation =
        (state == ButtonInteractionState.pressed ||
            state == ButtonInteractionState.disabled)
        ? 0.0
        : style.elevation;

    final Rect buttonRect = Rect.fromLTWH(
      0,
      pressOffset,
      size.width,
      size.height - 2.5,
    );

    final RRect roundedRect = RRect.fromRectAndRadius(
      buttonRect,
      Radius.circular(style.borderRadius),
    );

    if (currentElevation > 0) {
      final Path shadowPath = Path()..addRRect(roundedRect);
      canvas.drawShadow(
        shadowPath,
        Colors.black.withValues(alpha: 0.4),
        currentElevation,
        true,
      );
    }

    final Paint backgroundPaint = Paint()
      ..color = style.resolveBackgroundColor(state)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(roundedRect, backgroundPaint);

    if (style.borderWidth > 0) {
      final Paint borderPaint = Paint()
        ..color = style.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = style.borderWidth;
      canvas.drawRRect(roundedRect, borderPaint);
    }

    final TextSpan textSpan = TextSpan(
      text: label,
      style: style.textStyle.copyWith(color: style.textColor),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: size.width - 24);

    final Offset textOffset = Offset(
      (size.width - textPainter.width) / 2,
      pressOffset + (buttonRect.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomButtonPainter oldDelegate) {
    return oldDelegate.label != label ||
        oldDelegate.state != state ||
        oldDelegate.style != style;
  }
}

class CustomCanvasButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final CustomButtonStyle style;
  final double width;
  final double height;

  const CustomCanvasButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = const CustomButtonStyle(),
    this.width = 220,
    this.height = 52,
  });

  @override
  State<CustomCanvasButton> createState() => _CustomCanvasButtonState();
}

class _CustomCanvasButtonState extends State<CustomCanvasButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null;

  ButtonInteractionState get _currentState {
    if (!_isEnabled) return ButtonInteractionState.disabled;
    if (_isPressed) return ButtonInteractionState.pressed;
    if (_isHovered) return ButtonInteractionState.hovered;
    return ButtonInteractionState.normal;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isEnabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: _isEnabled
            ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: _isEnabled
            ? () => setState(() => _isPressed = false)
            : null,
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: CustomButtonPainter(
            label: widget.label,
            state: _currentState,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}
