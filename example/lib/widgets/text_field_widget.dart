import 'package:example/util/app_contexts.dart';
import 'package:flutter/material.dart';

enum CelType {
  text,
  number,
  int,
  date,
  email,
  password,
  image,
  check,
  list,
}

class EditTextField extends StatefulWidget {
  final String? hint;
  final String? label;
  final ValueSetter valueSetter;
  final CelType celType;
  final ValueNotifier<bool>? checkValidity;
  final dynamic initialValue;
  final int? maxLine;
  final String? name;

  const EditTextField({
    super.key,
    required this.valueSetter,
    required this.celType,
    this.hint,
    this.label,
    this.checkValidity,
    this.initialValue,
    this.maxLine,
    this.name,
  });

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  late bool isObscureText;
  bool hasError = false;
  late TextEditingController myController;

  @override
  void initState() {
    myController = TextEditingController(
      text: widget.initialValue != null
          ? widget.initialValue.toString()
          : widget.celType == CelType.int
              ? '0'
              : widget.celType == CelType.number
                  ? '0.0'
                  : '',
    );
    isObscureText = widget.celType == CelType.password ? true : false;
    if (widget.checkValidity != null) {
      widget.checkValidity!.addListener(_onErrorLister);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.checkValidity != null) {
      widget.checkValidity!.removeListener(_onErrorLister);
    }
    myController.dispose();
    super.dispose();
  }

  void _onErrorLister() {
    if (widget.checkValidity!.value) {
      setState(() {
        hasError = !checkForError();
      });
    } else {
      if (hasError) {
        setState(() {
          hasError = false;
        });
      }
    }
  }

  bool checkForError() {
    if (widget.celType == CelType.text) {
      if (myController.text.trim() == '') return false;
    } else if (widget.celType == CelType.password) {
      if (myController.text.length < 4) return false;
    }
    return true;
  }

  String errorText() {
    if (hasError && widget.name != null) {
      if (widget.celType == CelType.text) {
        return '${widget.name} could not be empty';
      } else if (widget.celType == CelType.password) {
        return '${widget.name} could not be empty min 4 character';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: (widget.maxLine == null) ? 35.0 : null,
          child: TextFormField(
            obscureText: isObscureText,
            style: context.themeText.bodySmall,
            onChanged: (value) => widget.valueSetter(value),
            controller: myController,
            maxLines: widget.maxLine ?? 1,
            decoration: InputDecoration(
              filled: true,
              hintText: widget.hint,
              labelText: widget.label,
              hintStyle: const TextStyle(fontSize: 13),
              fillColor: context.themeColor.surface.withOpacity(0.3),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: (widget.maxLine != null) ? 10 : 0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.themeColor.primary,
                ),
              ),
              suffixIcon: widget.celType == CelType.password
                  ? IconButton(
                      onPressed: () => setState(() {
                        isObscureText = !isObscureText;
                      }),
                      icon: Icon(
                        isObscureText ? Icons.visibility_off : Icons.visibility,
                        size: 15,
                      ),
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? context.themeColor.error
                      : context.themeColor.outline,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          child: Text(
            errorText(),
            style: context.themeText.bodySmall!
                .copyWith(color: context.themeColor.error),
          ),
        ),
      ],
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  final String? hint;
  final String label;
  final ValueSetter valueSetter;
  final CelType celType;
  final ValueNotifier<bool>? checkValidity;
  final dynamic initialValue;
  final int? maxLine;
  const TextFormFieldWidget({
    super.key,
    required this.valueSetter,
    required this.celType,
    required this.label,
    this.hint,
    this.checkValidity,
    this.initialValue,
    this.maxLine,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          EditTextField(
            celType: celType,
            valueSetter: valueSetter,
            checkValidity: checkValidity,
            hint: hint,
            name: label,
            initialValue: initialValue,
            maxLine: maxLine,
          ),
        ],
      ),
    );
  }
}
