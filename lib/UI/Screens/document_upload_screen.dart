import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:on_demand/Utilities/constants.dart';

import '../Components/page_indicator.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});
  static const id = 'document_upload_screen';

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  File? contentFile;
  //select content files
  void getContentFile() async {
    //get files
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(dialogTitle: 'Add document',allowedExtensions: ['jpeg','png','pdf'],allowMultiple: false,type: FileType.custom,withReadStream: true);
    if(filePickerResult!=null){
      setState(() {
        PlatformFile result = filePickerResult.files.first;
        if(result.path!=null){
          File file = File(result.path!);
          contentFile = file;
        }
        //expose state
        // Provider.of<AddBookComponent>(context,listen: false).setContentFiles(filePickerResult.files);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width/2.75,
        leading: const PageIndicator(activeScreenIndex: 3,steps: 4,),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
                padding: kMobileBodyPadding,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Upload identity card',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ))),
        actions: const [
          // TextButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: const Text(
          //     'Skip',
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: kMobileBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 256,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24,),
                  const Text(
                    'Upload either your drivers license or National Identity Number slip or card',
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      height: 1.4
                    ),
                  ),
                  const SizedBox(height: 24,),
                  ElevatedButton(onPressed: (){

                  }, child: const Text('Choose document')),
                ],
              ),
            ),
            ElevatedButton(onPressed: (){}, child: const Text('Done')),
          ],
        ),
      ),
    );
  }
}
