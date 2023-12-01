import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(selectionColor: Colors.purple,text: const TextSpan(children: [
      TextSpan(text: 'By creating an account you agree to our ',style: TextStyle(color: Colors.black)),
      TextSpan(text: 'Terms & Conditions ',style: TextStyle(decoration: TextDecoration.underline,color: Colors.purple)),
      TextSpan(text: 'and our ',style: TextStyle(color: Colors.black)),
      TextSpan(text: 'Privacy Policy. ',style: TextStyle(decoration: TextDecoration.underline,color: Colors.purple)),
    ]));
  }
}
