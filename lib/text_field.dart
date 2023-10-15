import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldType {
  name,
  email,
  phoneNumber,
  date,
  password
}

//validators
String? requiredValidator(String? value) {
  if (value != null) {
    if (value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
  return null;
}
String? dateOfBirthValidator(String? value) {
  if (requiredValidator(value) != null) {
    return 'This field is required';
  }
  String pattern =
      r"(0[1-9]|1[0-2])[\/](0[1-9]|1\d|2\d|3[0-1])[\/](19\d\d|20\d\d)";

  String month;
  String day;
  String year;

  if (value != null) {
    if (RegExp(pattern).hasMatch(value)) {
      month = value.substring(0, 2);
      day = value.substring(3, 5);
      year = value.substring(6, 10);
      switch (int.parse(month)) {
        case < 01 || > 12:
          return 'The date is invalid. An example of a valid date is 01/01/2000 -January/01/2000-';
      }
      switch (int.parse(day)) {
        case < 01 || > 31:
          return 'The date is invalid. An example of a valid date is 01/01/2000 -January/01/2000-';
      }
      switch (int.parse(year)) {
//:TODO update first and last year annually
        case < 1900 || > 2023:
          return 'The date is invalid. An example of a valid date is 01/01/2000 -January/01/2000-';
      }
    } else {
      return 'The date is invalid. An example of a valid date is 01/01/2000 -January/01/2000-';
    }
  }
  return null;
}
String? passwordValidator(String? value) {
  if (value != null) {
    if (requiredValidator(value) != null) {
      return 'This field is required';
    }
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'A good password should be more than 8 digits and be a mix of uppercase letters, lowercase letters, numbers and symbols';
    }
    return null;
  }
  return null;
}
String? emailValidator(String? value) {
  if (value != null) {
    if (requiredValidator(value) != null) {
      return 'This field is required';
    }
    String emailPattern = r'\w+@\w+\.\w+';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Incorrect email format. A correct email address is john@example.com';
    }
  }
  return null;
}

//input formatter
final List<TextInputFormatter> nameFormatter = [
  FilteringTextInputFormatter.deny(RegExp(r'[0-9 ]')),
];
final List<TextInputFormatter> dateFormatter = [
  FilteringTextInputFormatter.deny(RegExp("[!#\$~&*]")),
  FilteringTextInputFormatter.deny(RegExp("[a-zA-Z]")),
];
final List<TextInputFormatter> emailFormatter = [
  FilteringTextInputFormatter.deny(RegExp("[!#/\$~&*]")),
  // FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
];
final List<TextInputFormatter> phoneFormatter = [
  FilteringTextInputFormatter.digitsOnly,
];


class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.type,
      this.label,
      this.hint});

  //config options
  final TextEditingController controller;
  final TextFieldType type;
  final String? label;
  final String? hint;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isVisible = false;
  DateTime firstDate = DateTime(1900,1,1);
  DateTime lastDate = DateTime.now();
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }
  void displayDatePicker() async {
   var date = await showDatePicker(context: context, initialDate: lastDate, firstDate: firstDate, lastDate: lastDate);
   setState(() {
     widget.controller.text = date.toString();
   });
  }

  @override
  Widget build(BuildContext context) {

    switch (widget.type) {
      //name
      case TextFieldType.name:
        return TextFormField(
          controller: widget.controller,
          validator: requiredValidator,
          inputFormatters: nameFormatter,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            border: const OutlineInputBorder(),
          ),
        );
        //email
      case TextFieldType.email:
        return TextFormField(
          controller: widget.controller,
          validator: emailValidator,
          inputFormatters: emailFormatter,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            border: const OutlineInputBorder(),
          ),
        );
        //number
      case TextFieldType.phoneNumber:
        return TextFormField(
          controller: widget.controller,
          validator: requiredValidator,
          inputFormatters: phoneFormatter,
          keyboardType: TextInputType.phone,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixText: '+234',
            labelText: widget.label,
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            border: const OutlineInputBorder(),
          ),
        );
        //password
      case TextFieldType.password:
        return TextFormField(
          controller: widget.controller,
          validator: passwordValidator,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          obscureText: isVisible ? false : true,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            suffixIcon: IconButton(onPressed: toggleVisibility, icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),),
            border: const OutlineInputBorder(),
          ),
        );
        //date
      case TextFieldType.date:
        return TextFormField(
          controller: widget.controller,
          validator: dateOfBirthValidator,
          inputFormatters: dateFormatter,
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            suffixIcon: IconButton(onPressed: displayDatePicker, icon: const Icon(Icons.calendar_today),),
            border: const OutlineInputBorder(),
          ),
        );
    }
  }
}
