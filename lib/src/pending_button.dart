import 'package:flutter/material.dart';
import 'package:pending_button/src/core/extensions.dart';
import 'package:pending_button/src/core/helper.dart';
import 'package:pending_button/src/core/models.dart';
import 'package:pending_button/src/widget/button_widget.dart';

class PendingButton extends StatelessWidget {
  final Widget child;

  //Widget max width
  //Default value child width
  final double? width;

  //Widget max height
  //Default value 40
  final double? height;

  //asynchronise function
  //The button use the future to handle the state
  //on error use onError function
  //onData use onSeccess function
  final Function asynFunction;

  //onError callback
  //return the Error
  final Function? onError;

  //onSucces callback
  //return the success
  final Function? onSuccess;

  //Function trigger before hundle onPresse
  //should return bolean
  final Function? beforeFunction;

  //The background color
  //defalut Primary color
  final Color? backgroundColor;

  //The foreground color
  //defalut onPrimary color
  final Color? foregroundColor;

  //The borderColor color
  final Color? borderColor;

  //The Sucees color
  //defalut Green color
  final Color? successColor;

  //The Error color
  //defalut error color
  final Color? errorColor;

  //The type of the button
  //Normal / Outline / Text / Icon
  final ButtonType buttonType;

  //defalut borderRadius
  final double borderRadius;

  //The animation duration
  //default 300 milleseconde
  final Duration? animationDuration;

  const PendingButton({
    super.key,
    required this.child,
    required this.asynFunction,
    this.width,
    this.height,
    this.beforeFunction,
    this.onError,
    this.backgroundColor,
    this.foregroundColor,
    this.successColor,
    this.errorColor,
    this.borderColor,
    this.borderRadius = 10.0,
    this.animationDuration,
    this.onSuccess,
  }) : buttonType = ButtonType.normal;

  const PendingButton.icon({
    super.key,
    required Icon this.child,
    required this.asynFunction,
    this.width,
    this.height,
    this.beforeFunction,
    this.onError,
    this.successColor,
    this.errorColor,
    Color? iconColor,
    this.animationDuration,
    this.onSuccess,
  })  : buttonType = ButtonType.icon,
        foregroundColor = iconColor,
        backgroundColor = null,
        borderColor = null,
        borderRadius = 40;

  const PendingButton.outlined({
    super.key,
    required this.child,
    required this.asynFunction,
    this.width,
    this.height,
    this.beforeFunction,
    this.onError,
    this.foregroundColor,
    this.borderColor,
    this.successColor,
    this.errorColor,
    this.borderRadius = 10.0,
    this.animationDuration,
    this.onSuccess,
  })  : buttonType = ButtonType.outline,
        backgroundColor = null;

  const PendingButton.text({
    super.key,
    required this.child,
    required this.asynFunction,
    this.width,
    this.height,
    this.beforeFunction,
    this.onError,
    this.successColor,
    this.errorColor,
    this.foregroundColor,
    this.animationDuration,
    this.onSuccess,
  })  : buttonType = ButtonType.text,
        borderColor = null,
        backgroundColor = null,
        borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    Color? colorBackground = backgroundColor ??
        buttonType.mayBeOr<Color?>(
          normal: () => context.themeColor.primary,
          or: () => null,
        );
    Color colorForeground = foregroundColor ??
        buttonType.when<Color>(
          normal: () => context.themeColor.onPrimary,
          text: () => context.themeColor.primary,
          icon: () => context.themeColor.primary,
          outline: () => context.themeColor.primary,
        );
    Color? colorBorder = borderColor ??
        buttonType.when<Color?>(
          normal: () => darken(colorBackground),
          text: () => null,
          icon: () => null,
          outline: () => context.themeColor.primary,
        );
    Color colorSucess = successColor ?? Colors.green[600]!;
    Color colorError = errorColor ?? context.themeColor.error;
    // Icon? newIcon = buttonType == ButtonType.icon
    //     ? Icon(
    //         (child as Icon).icon,
    //         color: context.themeColor.primary,
    //         size: (child as Icon).size,
    //       )
    //     : null;
    return ButtonWidget(
      onError: onError,
      asynFunction: asynFunction,
      beforeFunction: beforeFunction,
      onSuccess: onSuccess,
      height: height,
      width: width,
      backgroundColor: colorBackground,
      foregroundColor: colorForeground,
      borderColor: colorBorder,
      borderRadius: borderRadius,
      buttonType: buttonType,
      succesColor: colorSucess,
      errorColor: colorError,
      animationDuration: animationDuration ?? const Duration(milliseconds: 200),
      //child: buttonType == ButtonType.icon ? newIcon! : child,
      child: child,
    );
  }
}
