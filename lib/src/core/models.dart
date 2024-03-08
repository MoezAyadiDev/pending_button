import 'package:flutter/widgets.dart';
import 'package:pending_button/src/core/helper.dart';

enum ButtonType { normal, text, icon, outline }

enum ButtonState { idle, loading, success, error }

class ButtonDecoration {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color onCheckColor;
  final Color? borderColor;
  final Color sucessColor;
  final Color errorColor;
  final double width;
  final double height;
  final double borderRadius;
  final ButtonType buttonType;
  final ButtonState state;

  const ButtonDecoration({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.sucessColor,
    required this.errorColor,
    required this.onCheckColor,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.buttonType,
    required this.state,
  });

  ButtonDecoration copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? width,
    double? height,
    double? borderRadius,
    required ButtonState state,
  }) =>
      ButtonDecoration(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        borderColor: borderColor ?? this.borderColor,
        sucessColor: sucessColor,
        errorColor: errorColor,
        width: width ?? this.width,
        height: height ?? this.height,
        borderRadius: borderRadius ?? this.borderRadius,
        buttonType: buttonType,
        onCheckColor: onCheckColor,
        state: state,
      );

  ButtonDecoration loading() => copyWith(
        width: height,
        borderRadius: height / 2,
        state: ButtonState.loading,
      );

  ButtonDecoration success() => copyWith(
        width: height,
        backgroundColor: sucessColor,
        foregroundColor: onCheckColor,
        borderColor: darken(sucessColor),
        borderRadius: height / 2,
        state: ButtonState.success,
      );
  ButtonDecoration error() => copyWith(
        width: height,
        backgroundColor: errorColor,
        foregroundColor: onCheckColor,
        borderColor: darken(errorColor),
        borderRadius: height / 2,
        state: ButtonState.error,
      );

  ButtonDecoration idle() => copyWith(
        width: width,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        borderColor: borderColor,
        state: ButtonState.idle,
      );
  ButtonDecoration animate(ButtonState newState) => newState.when(
        idle: () => idle(),
        loading: () => loading(),
        success: () => success(),
        error: () => error(),
      );

  double opacity(int index) => (index == 0)
      ? state.mayBeOr(idle: () => 1, or: () => 0)
      : (index == 1)
          ? state.mayBeOr(loading: () => 1, or: () => 0)
          : state.mayBeOr(success: () => 1, error: () => 1, or: () => 0);

  @override
  String toString() {
    return state.toString();
  }
}

extension ButtonWhen on ButtonState {
  R when<R>({
    required R Function() idle,
    required R Function() loading,
    required R Function() success,
    required R Function() error,
  }) {
    switch (this) {
      case ButtonState.idle:
        return idle();
      case ButtonState.loading:
        return loading();
      case ButtonState.success:
        return success();
      default:
        return error();
    }
  }

  R? mayBe<R>({
    R Function()? idle,
    R Function()? loading,
    R Function()? success,
    R Function()? error,
  }) {
    switch (this) {
      case ButtonState.idle:
        if (idle != null) {
          return idle();
        }
      case ButtonState.loading:
        if (loading != null) {
          return loading();
        }
      case ButtonState.success:
        if (success != null) {
          return success();
        }
      case ButtonState.error:
        if (error != null) {
          return error();
        }
    }
    return null;
  }

  R mayBeOr<R>({
    R Function()? idle,
    R Function()? loading,
    R Function()? success,
    R Function()? error,
    required R Function() or,
  }) {
    switch (this) {
      case ButtonState.idle:
        if (idle != null) {
          return idle();
        }
      case ButtonState.loading:
        if (loading != null) {
          return loading();
        }
      case ButtonState.success:
        if (success != null) {
          return success();
        }
      case ButtonState.error:
        if (error != null) {
          return error();
        }
    }
    return or();
  }

  bool has<R>(List<ButtonState> statuss) {
    return statuss.contains(this);
  }

  bool equal<R>(ButtonState status) {
    return status == this;
  }

  bool diffirent<R>(ButtonState status) {
    return status != this;
  }
}
