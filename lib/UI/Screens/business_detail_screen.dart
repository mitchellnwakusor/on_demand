import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/routes.dart';
import '../../Utilities/constants.dart';
import '../../Services/providers/signup_provider.dart';
import '../Components/location_drop_down.dart';
import '../Components/occupation_search_field.dart';
import '../Components/page_indicator.dart';

class BusinessDetailScreen extends StatefulWidget {
  const BusinessDetailScreen({super.key});
  static const id = 'business_detail_screen';

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {

  String? _requiredValidator(String? value) {
    if (value == null) {
      return 'This field is required';
    }
    return null;
  }
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? planFieldValue;

  void _saveDetails() async {
    if(formKey.currentState!.validate()){
          Provider.of<SignupProvider>(context,listen: false).addData(key: 'plan', value: planFieldValue!);
          //Todo call code sent
          Navigator.pushNamed(context, otpVerificationScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width/2.75,
        leading: const PageIndicator(activeScreenIndex: 1,steps: 4,),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
                padding: kMobileBodyPadding,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Business details',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, loginScreen),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: kMobileBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const OccupationSearchField(),
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Plan'),
                        const SizedBox(
                          height: 8,
                        ),
                        DropdownButtonFormField(
                          validator: _requiredValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          value: planFieldValue,
                          hint: const Text('Account plan'),
                          decoration: const InputDecoration(filled: true,border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: 'individual',child: Text('Individual')),
                            DropdownMenuItem(value: 'agent',child: Text('Agent')),
                          ],
                          onChanged: (value){
                            planFieldValue = value;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const LocationDropDown(),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: _saveDetails, child: const Text('Continue')),
          ],
        ),
      )
    );
  }
}
