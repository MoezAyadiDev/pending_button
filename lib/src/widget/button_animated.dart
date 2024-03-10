import 'package:flutter/material.dart';
import 'package:pending_button/src/core/extensions.dart';
import 'package:pending_button/src/core/helper.dart';
import 'package:pending_button/src/core/models.dart';

class ButtonAnimated extends StatefulWidget {
  final double? height;
  final double? width;
  final double borderRadius;
  final Color foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget child;
  final ButtonState buttonState;
  final VoidCallback onPressed;
  final ButtonType buttonType;
  final Color succesColor;
  final Color errorColor;
  final Duration animationDuration;
  const ButtonAnimated({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
    required this.buttonState,
    required this.onPressed,
    required this.buttonType,
    required this.succesColor,
    required this.errorColor,
    required this.animationDuration,
  });

  @override
  State<ButtonAnimated> createState() => _ButtonAnimatedState();
}

class _ButtonAnimatedState extends State<ButtonAnimated>
    with SingleTickerProviderStateMixin {
  List<ButtonDecoration> currentState = [];
  late final ButtonDecoration buttonDecore;
  final GlobalKey childKey = GlobalKey();

  late AnimationController _animationController;

  late Animation<double> _animateWidth;
  late Animation<double> _animateBounce;
  late Animation<double> _animateBorederRadius;
  late Animation<double> _animateOpacityMain;
  late Animation<double> _animateOpacityLoading;
  late Animation<double> _animateOpacityCheck;
  bool isInitialised = false;
  late Widget checkWidget;
  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    getDimensions();

    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _animationController.reset();
        currentState.removeAt(0);
        if (currentState.length > 1) {
          initAnimation(currentState[0], currentState[1]);
          _animationController.forward();
        } else {
          initAnimation(currentState[0], currentState[0]);
        }
      }
    });

    super.initState();
  }

  void getDimensions() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox logoBox =
          childKey.currentContext!.findRenderObject() as RenderBox;
      final size = logoBox.size;
      buttonDecore = ButtonDecoration(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        borderColor: widget.borderColor,
        sucessColor: widget.succesColor,
        errorColor: widget.errorColor,
        onCheckColor: context.themeColor.onTertiary,
        width: size.width,
        height: size.height - 5,
        borderRadius: widget.borderRadius,
        buttonType: widget.buttonType,
        state: ButtonState.idle,
      );
      currentState.add(buttonDecore);
      initAnimation(buttonDecore, buttonDecore);
      isInitialised = true;
      checkWidget = _widgetSucess;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ButtonAnimated oldWidget) {
    if (currentState.last.state != widget.buttonState) {
      currentState.add(
        buttonDecore.animate(widget.buttonState),
      );
      if (widget.buttonState == ButtonState.success) {
        checkWidget = _widgetSucess;
      } else if (widget.buttonState == ButtonState.error) {
        checkWidget = _widgetError;
      }
      if (_animationController.isDismissed ||
          _animationController.isCompleted) {
        initAnimation(currentState[0], currentState[1]);
        _animationController.reset();
        _animationController.forward();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  initAnimation(ButtonDecoration etat1, ButtonDecoration etat2) {
    _animateWidth = Tween<double>(begin: etat1.width, end: etat2.width).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, (etat1.width > etat2.width) ? 1 : 0.6,
            curve: Curves.easeInOutCirc),
      ),
    );

    _animateBounce = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: Tween(begin: 0.0, end: 0), weight: 5),
        TweenSequenceItem<double>(tween: Tween(begin: 0, end: 4), weight: 2),
        TweenSequenceItem<double>(tween: Tween(begin: 4, end: -4), weight: 1),
        TweenSequenceItem<double>(tween: Tween(begin: -4, end: 3), weight: 1),
        TweenSequenceItem<double>(tween: Tween(begin: 3, end: -1), weight: 1),
        TweenSequenceItem<double>(tween: Tween(begin: -1, end: 0), weight: 1),
      ],
    ).animate(_animationController);

    _animateBorederRadius =
        Tween<double>(begin: etat1.borderRadius, end: etat2.borderRadius)
            .animate(
      CurvedAnimation(
        parent: _animationController,
        curve:
            (etat2.state == ButtonState.idle && etat1.state != ButtonState.idle)
                ? const Interval(0.6, 1, curve: Curves.easeInOut)
                : const Interval(0, 0.4, curve: Curves.easeInOut),
      ),
    );
    _animateOpacityMain =
        Tween<double>(begin: etat1.opacity(0), end: etat2.opacity(0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval((etat2.opacity(0) == 1) ? 0.8 : 0,
            (etat2.opacity(0) == 1) ? 1 : 0.2,
            curve: Curves.easeInOut),
      ),
    );
    _animateOpacityLoading =
        Tween<double>(begin: etat1.opacity(1), end: etat2.opacity(1)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
    _animateOpacityCheck =
        Tween<double>(begin: etat1.opacity(2), end: etat2.opacity(2)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialised) {
      return initWidget();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final colorBack = getColor();
        final colorBorder = getBoredrColor();
        double bounce = (currentState.length == 1)
            ? 0
            : (currentState[1]
                    .state
                    .has([ButtonState.error, ButtonState.success]))
                ? _animateBounce.value
                : 0;
        return Container(
          height: buttonDecore.height + 5,
          width: buttonDecore.width,
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          child: Center(
            child: Material(
              textStyle: context.themeText.bodyMedium!
                  .copyWith(color: buttonDecore.foregroundColor),
              borderRadius: BorderRadius.circular(_animateBorederRadius.value),
              color: Colors.transparent,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(_animateBorederRadius.value),
                ),
                hoverColor: lighten(buttonDecore.backgroundColor),
                onTap: currentState[0].state == ButtonState.idle
                    ? widget.onPressed
                    : null,
                child: Ink(
                  height: buttonDecore.height + bounce,
                  width: _animateWidth.value + bounce,
                  decoration: BoxDecoration(
                    color: colorBack,
                    borderRadius:
                        BorderRadius.circular(_animateBorederRadius.value),
                    border: colorBorder != null
                        ? Border.all(color: colorBorder)
                        : null,
                  ),
                  child: Stack(
                    fit: StackFit.loose,
                    clipBehavior: Clip.none,
                    children: [
                      Opacity(
                        opacity: _animateOpacityCheck.value,
                        child: checkWidget,
                      ),
                      Opacity(
                        opacity: _animateOpacityLoading.value,
                        child: _widgetLoading,
                      ),
                      Opacity(
                        opacity: _animateOpacityMain.value,
                        child: Center(child: _widgetMain),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get _widgetMain => Padding(
        padding: _padding(),
        child: widget.child,
      );

  Widget get _widgetLoading => Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: buttonDecore.height - 12,
          height: buttonDecore.height - 12,
          child: CircularProgressIndicator(
            color: widget.foregroundColor,
            strokeWidth: 2,
          ),
        ),
      );

  Widget get _widgetSucess => Align(
        alignment: Alignment.center,
        child: widget.buttonType.when(
          normal: () => Icon(
            Icons.check,
            color: context.themeColor.onTertiary,
          ),
          text: () => Icon(
            Icons.check,
            color: widget.succesColor,
          ),
          icon: () => Icon(
            Icons.check,
            color: widget.succesColor,
          ),
          outline: () => Icon(
            Icons.check,
            color: widget.succesColor,
          ),
        ),
      );
  Widget get _widgetError => Align(
        alignment: Alignment.center,
        child: SizedBox(
          // width: height - 12,
          // height: height - 12,
          child: widget.buttonType.when(
            normal: () => Icon(
              Icons.priority_high_rounded,
              color: context.themeColor.onTertiary,
            ),
            text: () => Icon(
              Icons.priority_high_rounded,
              color: widget.errorColor,
            ),
            icon: () => Icon(
              Icons.priority_high_rounded,
              color: widget.errorColor,
            ),
            outline: () => Icon(
              Icons.priority_high_rounded,
              color: widget.errorColor,
            ),
          ),
        ),
      );
  Widget initWidget() => Material(
        textStyle: context.themeText.bodyMedium!
            .copyWith(color: widget.foregroundColor),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.backgroundColor,
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!)
                : null,
          ),
          key: childKey,
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          width: widget.width,
          height: widget.height,
          child: _widgetMain,
        ),
      );

  EdgeInsets _padding() => widget.buttonType.when(
        normal: () => const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 6.0,
        ),
        text: () => const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 6.0,
        ),
        icon: () => const EdgeInsets.symmetric(
          horizontal: 1.0,
          vertical: 1.0,
        ),
        outline: () => const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 6.0,
        ),
      );

  Color? getMainColor(ButtonState btnState) {
    return btnState.when(
      idle: () => widget.buttonType.mayBeOr(
        normal: () => widget.backgroundColor,
        or: () => null,
      ),
      loading: () => widget.buttonType.mayBeOr(
        normal: () => widget.backgroundColor,
        or: () => null,
      ),
      success: () => widget.buttonType.mayBeOr(
        normal: () => widget.succesColor,
        or: () => null,
      ),
      error: () => widget.buttonType.mayBeOr(
        normal: () => widget.errorColor,
        or: () => null,
      ),
    );
  }

  Color? getColor() {
    if (currentState.length == 1) {
      return getMainColor(currentState[0].state);
    }
    return currentState[1].state.when(
          idle: () => currentState[0].state.mayBeOr(
                or: () => widget.backgroundColor,
                success: () => Color.lerp(getMainColor(currentState[1].state),
                    widget.backgroundColor, _animationController.value),
                error: () => Color.lerp(getMainColor(currentState[1].state),
                    widget.backgroundColor, _animationController.value),
              ),
          loading: () => widget.backgroundColor,
          success: () => Color.lerp(widget.backgroundColor,
              getMainColor(currentState[1].state), _animationController.value),
          error: () => Color.lerp(widget.backgroundColor,
              getMainColor(currentState[1].state), _animationController.value),
        );
  }

  Color? getBoredrColor() {
    if (currentState.length == 1) {
      return currentState[0].state.when(
            idle: () => widget.borderColor,
            loading: () => widget.borderColor,
            success: () => darken(widget.succesColor),
            error: () => darken(widget.errorColor),
          );
    }
    return currentState[1].state.when(
          idle: () => currentState[0].state.mayBeOr(
                or: () => widget.borderColor,
                success: () => widget.borderColor,
                error: () => widget.borderColor,
              ),
          loading: () => widget.borderColor,
          success: () => Color.lerp(widget.borderColor,
              darken(widget.succesColor), _animationController.value),
          error: () => Color.lerp(widget.borderColor, darken(widget.errorColor),
              _animationController.value),
        );
  }
}
