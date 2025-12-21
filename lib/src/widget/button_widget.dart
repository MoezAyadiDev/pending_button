part of '../pending_button.dart';

class _ButtonWidget extends StatefulWidget {
  final Function? onError;
  final Function? onSuccess;
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
  final Color onCheckColor;
  final TextStyle mediumTheme;
  final PendingButtonController? autoRun;
  final Widget child;

  const _ButtonWidget({
    required this.asynFunction,
    required this.onError,
    required this.onSuccess,
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
    required this.onCheckColor,
    required this.mediumTheme,
    required this.autoRun,
    required this.child,
  });

  @override
  State<_ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<_ButtonWidget> {
  Future<void>? pending;
  @override
  void initState() {
    super.initState();
    if (widget.autoRun != null) {
      widget.autoRun?._attach(_runAsync);
    }
  }

  @override
  void dispose() {
    if (widget.autoRun != null) {
      widget.autoRun?._detach();
    }
    super.dispose();
  }

  Future<void> _runAsync() async {
    if (pending != null) return;
    _onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
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
          Future.delayed(const Duration(seconds: 1)).then(
            (value) {
              if (mounted) {
                setState(
                  () {
                    pending = null;
                  },
                );
              }
            },
          );
          buttonState = ButtonState.error;
        } else if (snapshot.connectionState == ConnectionState.done) {
          Future.delayed(Duration.zero).then(
            (value) {
              if (widget.onSuccess != null) {
                widget.onSuccess!(snapshot.data);
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
          buttonState = ButtonState.success;
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          buttonState = ButtonState.loading;
        } else {
          buttonState = ButtonState.idle;
        }

        return _ButtonAnimated(
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
          onCheckColor: widget.onCheckColor,
          mediumTheme: widget.mediumTheme,
          onPressed: _onPressed,
          child: widget.child,
        );
      },
    );
  }

  bool chcekSync(Function func) {
    if (func is Future Function()) return true;
    return false;
  }

  void _onPressed() async {
    if (widget.beforeFunction != null) {
      final beforResult = await widget.beforeFunction!();
      if (!beforResult) return;
    }
    if (chcekSync(widget.asynFunction)) {
      final future = (widget.asynFunction() as Future<void>);
      setState(() {
        pending = future;
      });
    } else {
      try {
        final functionResponse = widget.asynFunction();

        if (widget.onSuccess != null) {
          widget.onSuccess!(functionResponse);
        }
      } catch (er) {
        if (widget.onError != null) {
          widget.onError!(er);
        }
      }
    }
  }
}
