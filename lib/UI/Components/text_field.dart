import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldType {
  name,
  email,
  phone,
  number,
  date,
  password,
  rate
}

//validators
String? _requiredValidator(String? value) {
  if (value != null && value.isNotEmpty) {
    if (value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
  return null;
}
String? _dateOfBirthValidator(String? value) {
  if (_requiredValidator(value) != null) {
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
String? _passwordValidator(String? value) {
  if (value != null) {
    if (_requiredValidator(value) != null) {
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
String? _emailValidator(String? value) {
  if (value != null && value.isNotEmpty) {
    if (_requiredValidator(value) != null) {
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
final List<TextInputFormatter> _nameFormatter = [
  FilteringTextInputFormatter.deny(RegExp(r'[0-9 ]')),
];
final List<TextInputFormatter> _dateFormatter = [
  FilteringTextInputFormatter.deny(RegExp("[!#\$~&*]")),
  FilteringTextInputFormatter.deny(RegExp("[a-zA-Z]")),
];
final List<TextInputFormatter> _emailFormatter = [
  FilteringTextInputFormatter.deny(RegExp("[!#/\$~&*]")),
  // FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
];
final List<TextInputFormatter> _phoneFormatter = [
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(10)
];


class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.type,
      this.label,
      this.helperText,
      this.hint,this.onEditingComplete});

  //config options
  final TextEditingController controller;
  final TextFieldType type;
  final String? label;
  final String? hint;
  final String? helperText;
  final VoidCallback? onEditingComplete;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isVisible = true;
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
     if(date!=null){
       String formattedDate = '${date.month}/${date.day}/${date.year}';
       widget.controller.text = formattedDate;
     }
   });
  }

  @override
  Widget build(BuildContext context) {
    //no label
   if(widget.label==null){
     switch (widget.type) {
     //name
       case TextFieldType.name:
         return TextFormField(
           controller: widget.controller,
           validator: _requiredValidator,
           inputFormatters: _nameFormatter,
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
           validator: _emailValidator,
           inputFormatters: _emailFormatter,
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
     //phone
       case TextFieldType.phone:
         return TextFormField(
           controller: widget.controller,
           validator: _requiredValidator,
           inputFormatters: _phoneFormatter,
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
     //number
       case TextFieldType.number:
         return TextFormField(
           controller: widget.controller,
           validator: _requiredValidator,
           inputFormatters: _phoneFormatter,
           keyboardType: TextInputType.phone,
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
     //password
       case TextFieldType.password:
         return TextFormField(
           controller: widget.controller,
           validator: _passwordValidator,
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
       case TextFieldType.rate:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _requiredValidator,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               inputFormatters: [
                 NumericTextFormatter(),
                 LengthLimitingTextInputFormatter(20),
                ],
               keyboardType: TextInputType.number,
               textCapitalization: TextCapitalization.none,
               textInputAction: TextInputAction.next,
               decoration: InputDecoration(
                 prefixText: '₦',
                 // labelText: widget.label,
                 hintText: widget.hint,
                 helperText: widget.helperText,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );

     //date
       case TextFieldType.date:
         return TextFormField(
           controller: widget.controller,
           validator: _dateOfBirthValidator,
           inputFormatters: _dateFormatter,
           keyboardType: TextInputType.datetime,
           textInputAction: TextInputAction.next,
           decoration: InputDecoration(
             labelText: widget.label,
             hintText: widget.hint,
             contentPadding: const EdgeInsets.all(16),
             filled: true,
             suffixIcon: Padding(
               padding: const EdgeInsets.only(right: 12),
               child: IconButton(onPressed: displayDatePicker, icon: const Icon(Icons.calendar_month),),
             ),
             border: const OutlineInputBorder(),
           ),
         );
     }
   }
   //label
   else{
     switch (widget.type) {
     //name
       case TextFieldType.name:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _requiredValidator,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               inputFormatters: _nameFormatter,
               keyboardType: TextInputType.name,
               textCapitalization: TextCapitalization.none,
               textInputAction: TextInputAction.next,
               decoration: InputDecoration(
                 // labelText: widget.label,
                 hintText: widget.hint,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );
     //email
       case TextFieldType.email:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _emailValidator,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               inputFormatters: _emailFormatter,
               keyboardType: TextInputType.emailAddress,
               textCapitalization: TextCapitalization.none,
               textInputAction: TextInputAction.next,
               onEditingComplete: widget.onEditingComplete,
               decoration: InputDecoration(
                 // labelText: widget.label,
                 errorMaxLines: 2,
                 hintText: widget.hint,
                 helperText: widget.helperText,
                 helperMaxLines: 3,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );
     //phone
       case TextFieldType.phone:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _requiredValidator,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               inputFormatters: _phoneFormatter,
               keyboardType: TextInputType.phone,
               onEditingComplete: widget.onEditingComplete,
               textCapitalization: TextCapitalization.none,
               textInputAction: TextInputAction.next,
               decoration: InputDecoration(
                 prefixText: '+234',
                 // labelText: widget.label,
                 hintText: widget.hint,
                 helperText: widget.helperText,
                 helperMaxLines: 3,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );
     //number
       case TextFieldType.number:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _requiredValidator,
               inputFormatters: _phoneFormatter,
               keyboardType: TextInputType.phone,
               textCapitalization: TextCapitalization.none,
               textInputAction: TextInputAction.next,
               decoration: InputDecoration(
                 // labelText: widget.label,
                 hintText: widget.hint,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );
     //password
       case TextFieldType.password:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _passwordValidator,
               keyboardType: TextInputType.visiblePassword,
               textInputAction: TextInputAction.next,
               onEditingComplete: widget.onEditingComplete,
               obscureText: isVisible ? false : true,
               decoration: InputDecoration(
                 // labelText: widget.label,
                 hintText: widget.hint,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 helperText: widget.helperText,
                 helperMaxLines: 3,
                 suffixIcon: IconButton(onPressed: toggleVisibility, icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),),
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );
     //date
       case TextFieldType.date:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _dateOfBirthValidator,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               inputFormatters: _dateFormatter,
               keyboardType: TextInputType.datetime,
               textInputAction: TextInputAction.next,
               decoration: InputDecoration(
                 // labelText: widget.label,
                 hintText: widget.hint,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 suffixIcon: Padding(
                   padding: const EdgeInsets.only(right: 12),
                   child: IconButton(onPressed: displayDatePicker, icon: const Icon(Icons.calendar_month),),
                 ),
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );

       case TextFieldType.rate:
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.label!),
             const SizedBox(height: 8,),
             TextFormField(
               controller: widget.controller,
               validator: _requiredValidator,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               inputFormatters:[
                 NumericTextFormatter(),
                 LengthLimitingTextInputFormatter(20),
               ],
               keyboardType: TextInputType.number,
               textCapitalization: TextCapitalization.none,
               textInputAction: TextInputAction.next,
               decoration: InputDecoration(
                 prefixText: '₦',
                 // labelText: widget.label,
                 hintText: widget.hint,
                 helperText: widget.helperText,
                 contentPadding: const EdgeInsets.all(16),
                 filled: true,
                 border: const OutlineInputBorder(),
               ),
             ),
           ],
         );
     }
   }
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight = newValue.text.length -newValue.selection.end;

      var value = newValue.text;
      if (newValue.text.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ', ');
        // print("Value ---- $value");
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length  -selectionIndexFromTheRight),);
    } else {
      return newValue;
    }
  }}


