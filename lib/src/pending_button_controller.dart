part of 'pending_button.dart';

class PendingButtonController {
  VoidCallback? _run;

  void _attach(VoidCallback run) {
    _run = run;
  }

  void _detach() {
    _run = null;
  }

  void run() {
    _run?.call();
  }
}
