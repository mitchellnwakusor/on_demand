import 'package:flutter/material.dart';

class OauthDivider extends StatelessWidget {
  const OauthDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2,child: Container(height: 1,color: Colors.black45,)),
        const Expanded(child: Text('OR',textAlign: TextAlign.center,)),
        Expanded(flex: 2,child: Container(height: 1,color: Colors.black45,)),
      ],
    );
  }
}
