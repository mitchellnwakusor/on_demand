import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  static const id = 'feedback_screen';
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave feedback'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Subject'),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Message'),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: messageController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48,),
              ElevatedButton(onPressed: (){}, child: const Text('Send')),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(onPressed: (){
              //       Navigator.pop(context);
              //     }, child: const Text('cancel')),
              //     const SizedBox(width: 24,),
              //     //Todo:
              //     ElevatedButton(onPressed: (){}, child: const Text('Send')),
              //
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
