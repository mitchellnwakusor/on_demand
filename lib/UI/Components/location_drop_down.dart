//Nigeria

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/providers/signup_provider.dart';

class LocationDropDown extends StatefulWidget {
   const LocationDropDown({super.key, required this.currentLocation});
   final String? currentLocation;

  @override
  State<LocationDropDown> createState() => _LocationDropDownState();
}

class _LocationDropDownState extends State<LocationDropDown> {


  List locations = [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'Cross River',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Enugu',
    'F.C.T',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nasarawa',
    'Niger',
    'Ogun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara',

  ];
  String? selectedLocation;

  get currentLocation => widget.currentLocation;
  
  List<DropdownMenuItem> locationItems(List list) {
    List<DropdownMenuItem> temp = [];
    for(var item in list){
      temp.add(
        DropdownMenuItem(
          value: item,
          child: Text(item),
        ),
      );
    }
    return temp;
  }

  String? _requiredValidator(dynamic value) {
    if (value == null) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location'),
        const SizedBox(height: 8,),
        DropdownButtonFormField(
          validator: _requiredValidator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: selectedLocation,
          hint:  Text('$currentLocation'),
          decoration: const InputDecoration(filled: true,border: OutlineInputBorder()),
          items: locationItems(locations),
          onChanged: (value){
            selectedLocation = value;
            Provider.of<SignupProvider>(context,listen: false).addDataBusiness(key: 'location', value: value);
          },
        ),
      ],
    );
  }
}
