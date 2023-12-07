import 'package:flutter/material.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:provider/provider.dart';

import '../../Services/providers/signup_provider.dart';

class OccupationSearchField extends StatefulWidget {
  const OccupationSearchField({super.key,});

  @override
  State<OccupationSearchField> createState() => _OccupationSearchFieldState();
}

class _OccupationSearchFieldState extends State<OccupationSearchField> {

  late TextEditingController occupationFieldController;
  late FocusNode occupationFieldFocusNode;
  String? occupationValue;

  String? _requiredValidator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }
    return null;
  }

  @override
  void initState() {
    occupationFieldController = TextEditingController();
    occupationFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    occupationFieldController.dispose();
    occupationFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Occupation'),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          validator: _requiredValidator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: occupationFieldController,
          focusNode: occupationFieldFocusNode,
          enableSuggestions: true,
          decoration: const InputDecoration(
            filled: true,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onTap: () async {
            // *** disable all cases of focus on tap and after selection
            FocusScopeNode currentFocus = FocusScope.of(context);
            if(currentFocus.hasPrimaryFocus){
              FocusManager.instance.primaryFocus?.unfocus();
            }
            currentFocus.unfocus();
            occupationFieldFocusNode.unfocus();
            var value = await Navigator.pushNamed(context, searchScreen);
            if(value!=null){
              occupationValue = value as String;
              occupationFieldController.text = occupationValue!;
              if(context.mounted){
                Provider.of<SignupProvider>(context,listen: false).addDataBusiness(key: 'occupation', value: occupationValue!);
              }
            }
          },
          readOnly: true,
        ),
      ],
    );
  }
}
