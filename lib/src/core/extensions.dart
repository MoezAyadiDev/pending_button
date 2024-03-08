import 'package:flutter/material.dart';
import 'package:pending_button/src/core/models.dart';

extension Contexts on BuildContext {
  TextTheme get themeText => Theme.of(this).textTheme;
  ColorScheme get themeColor => Theme.of(this).colorScheme;
}

extension StatusWhen on ButtonType {
  R when<R>({
    required R Function() normal,
    required R Function() text,
    required R Function() icon,
    required R Function() outline,
  }) {
    switch (this) {
      case ButtonType.normal:
        return normal();
      case ButtonType.text:
        return text();
      case ButtonType.icon:
        return icon();
      default:
        return outline();
    }
  }

  R? mayBe<R>({
    R Function()? outline,
    R Function()? normal,
    R Function()? text,
    R Function()? icon,
  }) {
    switch (this) {
      case ButtonType.normal:
        if (normal != null) {
          return normal();
        }
      case ButtonType.text:
        if (text != null) {
          return text();
        }
      case ButtonType.icon:
        if (icon != null) {
          return icon();
        }
      case ButtonType.outline:
        if (outline != null) {
          return outline();
        }
    }
    return null;
  }

  R mayBeOr<R>({
    R Function()? outline,
    R Function()? normal,
    R Function()? text,
    R Function()? icon,
    required R Function() or,
  }) {
    switch (this) {
      case ButtonType.normal:
        if (normal != null) {
          return normal();
        }
      case ButtonType.text:
        if (text != null) {
          return text();
        }
      case ButtonType.icon:
        if (icon != null) {
          return icon();
        }
      case ButtonType.outline:
        if (outline != null) {
          return outline();
        }
    }
    return or();
  }

  bool has<R>(List<ButtonType> statuss) {
    return statuss.contains(this);
  }

  bool equal<R>(ButtonType status) {
    return status == this;
  }

  bool diffirent<R>(ButtonType status) {
    return status != this;
  }
}
