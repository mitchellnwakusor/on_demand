import 'package:flutter/material.dart';
import 'package:on_demand/Services/providers/start_screen_provider.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:provider/provider.dart';

class AccountSelectionScreen extends StatelessWidget {
  static const id = 'account_selection_screen';
  const AccountSelectionScreen({super.key});

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
    String firstButtonLabel = 'Artisan';
    String firstButtonHint = 'Service provider';
    String secondButtonLabel = 'Client';
    String secondButtonHint = 'Find Service providers';

    navigateTo({required String route, Object? arguments}) {
      Provider.of<StartScreenProvider>(context,listen: false).saveUserType(arguments as UserType);
      Navigator.pushNamed(context, route);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstButtonHint,
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
            onPressed: () => navigateTo(route: startScreen,arguments: UserType.artisan),
            child: Text(firstButtonLabel)),
        const SizedBox(
          height: 48,
        ),
        Text(
          secondButtonHint,
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
            onPressed: () => navigateTo(route: startScreen,arguments: UserType.client),
            child: Text(secondButtonLabel))
      ],
    );
  }
}
