import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Services/firebase_database.dart';
import 'package:on_demand/UI/Components/text_field.dart';

import '../Components/progress_dialog.dart';

class AddPortfolioScreen extends StatefulWidget {
  const AddPortfolioScreen({super.key});
  static const id = 'add_portfolio_screen';
  final appBarTitle = 'Add portfolio';
  @override
  State<AddPortfolioScreen> createState() => _AddPortfolioScreenState();
}

class _AddPortfolioScreenState extends State<AddPortfolioScreen> {
  GlobalKey<FormState> titleFormKey = GlobalKey<FormState>();
  TextEditingController portfolioTitle = TextEditingController();
  File? tempFileImage;

  void pickCoverImageFile() async{
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
         type: FileType.custom,
         allowedExtensions: ['jpg','png'],
         allowMultiple: false,
         withData: true
       );
      if(result!=null){
        PlatformFile file = result.files.first;
        setState(() {
          tempFileImage = File(file.path!);
        });
      }
    } on Exception catch (exception) {
      Fluttertoast.showToast(msg: exception.toString());
    }
  }

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

  void saveButtonCallback() {
    if(titleFormKey.currentState!.validate() && tempFileImage!=null){
      //create portfolio in db
      progressView();
      FirebaseDatabase.createPortfolio(context, portfolioTitle.text, tempFileImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight =  MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                // color: Colors.red,
                height: deviceHeight / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: titleFormKey,
                      child: CustomTextField(
                        controller: portfolioTitle,
                        type: TextFieldType.text,
                        label: 'Title',
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: tempFileImage!=null ? Image.file(tempFileImage!) : Image.asset('assets/images/blank_image.png'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          pickCoverImageFile();
                        }, child: const Text('Choose cover image')),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.symmetric(vertical: 48),
                child: ElevatedButton(
                  onPressed: () {
                    saveButtonCallback();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
