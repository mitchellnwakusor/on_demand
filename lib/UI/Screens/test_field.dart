import 'package:flutter/material.dart';
import 'package:on_demand/UI/Screens/custom_animated_loading_widget.dart';

class TestField extends StatefulWidget {
  const TestField({super.key});
  static const id = 'test_field_screen';
  @override
  State<TestField> createState() => _TestFieldState();
}

class _TestFieldState extends State<TestField> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Test field'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedLoadingWidget(height: height/3,width: width/1.25,),
          ],
        ),
      ),
    );
  }
}
