import 'package:flutter/material.dart';
import 'package:on_demand/UI/Components/progress_dialog.dart';

import '../../Core/routes.dart';
import '../../Utilities/constants.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  static const id = 'start_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(),
    body: const SafeArea(
      child: Padding(
        padding: kMobileBodyPadding,
        child: Column(
          children: [
            Expanded(flex: 2, child: OnboardingPanel()),
            SizedBox(
              height: 48,
            ),
            Expanded(child: CTAButtons()),
          ],
        ),
      ),
    ),
    );
  }
}

//** Custom Widgets **//
class OnboardingPanel extends StatelessWidget {
  const OnboardingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kMobileContainerPadding,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 400,
    );
  }
}

class CTAButtons extends StatelessWidget {
  const CTAButtons({super.key});

  @override
  Widget build(BuildContext context) {

    String firstButtonLabel = 'Register';
    String secondButtonLabel = 'Login';

    navigateTo({required String route}) {
      Navigator.pushNamed(context, route);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => navigateTo(route: registerScreen,),
            child: Text(firstButtonLabel)),
        const SizedBox(
          height: 48,
        ),
        OutlinedButton(
            onPressed: () {

              navigateTo(route: loginScreen);

              },
            child: Text(secondButtonLabel))
      ],
    );
  }
}

