import 'package:flutter/material.dart';
import 'package:pending_button/src/core/models.dart';
import 'package:pending_button/src/widget/button_animated.dart';

class ButtonWidget extends StatefulWidget {
  final Function? onError;
  final Function? beforeFunction;
  final Function asynFunction;
  final double? height;
  final double? width;
  final double borderRadius;
  final Color foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color succesColor;
  final Color errorColor;
  final ButtonType buttonType;
  final Duration animationDuration;
  final Widget child;
  const ButtonWidget({
    super.key,
    required this.asynFunction,
    required this.onError,
    required this.beforeFunction,
    required this.height,
    required this.width,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.buttonType,
    required this.succesColor,
    required this.errorColor,
    required this.animationDuration,
    required this.child,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  Future<void>? pending;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pending,
      builder: (context, snapshot) {
        late ButtonState buttonState;
        if (snapshot.connectionState == ConnectionState.none) {
          buttonState = ButtonState.idle;
        } else if (snapshot.hasError &&
            snapshot.connectionState != ConnectionState.waiting) {
          Future.delayed(Duration.zero).then(
            (value) {
              if (widget.onError != null) {
                widget.onError!(snapshot.error);
              }
            },
          );
          Future.delayed(const Duration(seconds: 1)).then((value) {
            if (mounted) {
              setState(() {
                pending = null;
              });
            }
          });
          buttonState = ButtonState.error;
        } else if (snapshot.connectionState == ConnectionState.done) {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            if (mounted) {
              setState(() {
                pending = null;
              });
            }
          });
          buttonState = ButtonState.success;
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          buttonState = ButtonState.loading;
        } else {
          buttonState = ButtonState.idle;
        }

        // debugPrint('buttonState from main $buttonState');

        return ButtonAnimated(
          backgroundColor: widget.backgroundColor,
          borderColor: widget.borderColor,
          buttonState: buttonState,
          foregroundColor: widget.foregroundColor,
          height: widget.height,
          borderRadius: widget.borderRadius,
          width: widget.width,
          buttonType: widget.buttonType,
          succesColor: widget.succesColor,
          errorColor: widget.errorColor,
          animationDuration: widget.animationDuration,
          onPressed: () async {
            if (widget.beforeFunction != null) {
              final beforResult = await widget.beforeFunction!();
              if (!beforResult) return;
            }
            if (widget.asynFunction.runtimeType == functionCheck.runtimeType) {
              // }
              final future = (widget.asynFunction() as Future<void>);
              setState(() {
                pending = future;
              });
            } else {
              widget.asynFunction();
            }
          },
          child: widget.child,
        );
      },
    );
  }

  Future<void> functionCheck() async {}
}
