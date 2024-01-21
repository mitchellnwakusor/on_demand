import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_demand/Services/firebase_database.dart';

import '../Components/progress_dialog.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});
  static const id = 'portfolio_screen';

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String? title;
  String? imageURL;
  String? uploadDate;
  String? formattedDate;
  String? formattedTime;

  @override
  void didChangeDependencies() {
    List temp = ModalRoute.of(context)?.settings.arguments as List;
    title = temp[0];
    imageURL = temp[1];
    uploadDate = temp[2];
    formattedDate =
        "${DateTime.parse(uploadDate!).day}-${DateTime.parse(uploadDate!).month}-${DateTime.parse(uploadDate!).year}";
    formattedTime =
        "${DateTime.parse(uploadDate!).hour}:${DateTime.parse(uploadDate!).minute}";
    super.didChangeDependencies();
  }

  bool isDisabled = true;
  TextEditingController titleController = TextEditingController();
  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {

    void progressView() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return const ProgressDialog(
            message: "Processing, Please wait...",
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            decoration: BoxDecoration(
              color: isDisabled ? null : Colors.grey[200],
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    isDisabled = !isDisabled;
                  });
                },
                icon: const Icon(Icons.edit_outlined)),
          ),
          IconButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  title: 'Delete portfolio',
                  desc: 'Are you sure you want to delete portfolio?',
                  btnCancelOnPress: (){

                    // Navigator.pop(context);
                  },
                  btnOkOnPress: (){
                    progressView();
                    FirebaseDatabase.deletePortfolio(context, uploadDate!);
                  },
                ).show();
              },
              icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isDisabled
                ? Text(
                    title!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  )
                : TextFormField(
                    controller: titleController,
                    textInputAction: TextInputAction.done,
                    autofocus: true,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.all(16),
                      filled: false,
                      border: const UnderlineInputBorder(),
                      labelText: 'Title',
                      hintText: title!,
                    ),
                    onEditingComplete: (){
                      if(titleController.text.length>2){
                        progressView();
                        FirebaseDatabase.editPortfolioTitle(context, uploadDate!, titleController.text);
                      }
                      else{
                        Fluttertoast.showToast(msg: 'Portfolio title should be more than 2 characters');
                      }
                    },
                  ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  formattedDate!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  formattedTime!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(imageURL!), fit: BoxFit.contain),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
