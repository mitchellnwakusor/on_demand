import 'package:flutter/material.dart';
import 'package:on_demand/Utilities/constants.dart';
import 'package:on_demand/Core/routes.dart';
import 'package:on_demand/UI/Components/text_field.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fNameField = TextEditingController();
  TextEditingController lNameField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  Object? occupationFieldValue;
  bool isChecked = false;

  //Map or list of occupations
  List<String> occupationsList = [
    'Agent',
    'Carpenter',
    'Cleaner',
    'Driver',
    'Electrician',
    'Engineer',
    'Gardener',
    'Hair stylist',
    'Mechanic',
    'Nanny',
    'Plumber',
    'Shoe maker',
    'Tutor'
  ];
  List<DropdownMenuItem> dropDownItems(List<String> list) {
    List<DropdownMenuItem> newList = [];
    for (String item in list) {
      newList.add(DropdownMenuItem(value: item, child: Text(item)));
    }
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        // title: const Text('Create an account'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
                padding: kMobileBodyPadding,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Create an account',
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
        child: SingleChildScrollView( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: fNameField,
                      type: TextFieldType.name,
                      label: 'First name',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      controller: lNameField,
                      type: TextFieldType.name,
                      label: 'Last name',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      controller: phoneField,
                      type: TextFieldType.phone,
                      label: 'Phone number',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text('Occupation'),
                    const SizedBox(
                      height: 8,
                    ),
                    const SearchField(),
                    // DropdownButtonFormField(
                    //   value: occupationFieldValue,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder()
                    //   ),
                    //   hint: const Text('Select Occupation'),
                    //   items: dropDownItems(occupationsList),
                    //   onChanged: (value) {
                    //     occupationFieldValue = value;
                    //   },
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 48,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: kMobileContainerPadding,
                    color: Colors.grey,
                    child: Row(
                      children: [
                        Checkbox(
                            value: isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                isChecked = newValue!;
                              });
                            }),
                        const Text('Agreement'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Continue')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onTap: () => Navigator.pushNamed(context, loginScreen), //Todo Search screen
      readOnly: true,
    );
  }
}
