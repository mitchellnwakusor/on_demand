import 'package:flutter/material.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/Core/routes.dart';

class StartScreen extends StatelessWidget {
  static const id = 'start_screen';
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kMobileBodyPadding,
          child: Column(
            children: [
              Expanded(flex: 2, child: OnboardingPanel()),
              Spacer(),
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

    navigateTo(String route) {
      Navigator.pushNamed(context,route);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(onPressed: () => navigateTo(registerScreen), child: Text(firstButtonLabel)),
        const SizedBox(height: 48),
        OutlinedButton(onPressed: () => navigateTo(loginScreen), child: Text(secondButtonLabel)),
        const SizedBox(height: 48),
      ],
    );
  }
}


