import 'package:flutter/material.dart';
import 'package:on_demand/Services/authentication.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/UI/Components/progress_dialog.dart';
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

  late BuildContext dialogContext;

  void progressView() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return ProgressDialog(message: "Processing, Please wait...",);
      },
    );

  }

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
      progressView();
          Provider.of<SignupProvider>(context,listen: false).addDataBusiness(key: 'business_type', value: planFieldValue!);
          Map<String, dynamic> data = Provider.of<SignupProvider>(context, listen: false).signupBusinessData;
      FirebaseDatabase.saveBusinessDetails(context,data: data, uid: Authentication.instance.currentUser!.uid);
          //Todo: change route
          Navigator.pushReplacementNamed(context, authHandlerScreen);
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Business type'),
                        const SizedBox(
                          height: 8,
                        ),
                        DropdownButtonFormField(
                          validator: _requiredValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          value: planFieldValue,
                          hint: const Text('Individual or Agency'),
                          decoration: const InputDecoration(filled: true,border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: 'individual',child: Text('Individual')),
                            DropdownMenuItem(value: 'agency',child: Text('Agency')),
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
                    const OccupationSearchField(),
                    const SizedBox(
                      height: 24,
                    ),
                     LocationDropDown(currentLocation:  'Current Location'),
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
