import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/providers/app_theme_provider.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});
  static const id = 'app_settings_screen';


  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {

  late AppTheme appTheme;
  bool tempIsNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    appTheme = Provider.of<AppTheme>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: const Text('Enable dark mode'),
            subtitle: const Text('Turn dark mode on or off'),
            trailing: Switch(value: appTheme.isDarkMode, onChanged: (value){
              appTheme.toggleDarkMode(value);
            }),
          ),
          ListTile(
            title: const Text('Enable push notifications'),
            subtitle: const Text('Allow notifications and alerts'),
            trailing: Switch(value: tempIsNotificationEnabled, onChanged: (value){setState(() {
              tempIsNotificationEnabled = value;
            });}),
          ),
          const ListTile(
            title: Text('Leave feedback'),
            subtitle: Text('Leave a message or suggestion on how we can serve you better.'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return const CustomFeedbackDialog(dialogTitle: 'Leave feedback');
              });
            }, child: const Text('Leave feedback')),
          ),
        ],
      ),
    );
  }
}


class CustomFeedbackDialog extends StatefulWidget {
  const CustomFeedbackDialog({super.key,required this.dialogTitle});
  final String dialogTitle;

  @override
  State<CustomFeedbackDialog> createState() => _CustomFeedbackDialogState();
}

class _CustomFeedbackDialogState extends State<CustomFeedbackDialog> {

  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.dialogTitle,textAlign: TextAlign.center,),
      titlePadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
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
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),

              ),
            ),
          ],
        ),
        const SizedBox(height: 32,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('cancel')),
            const SizedBox(width: 24,),
            //Todo:
            ElevatedButton(onPressed: (){}, child: const Text('Send')),

          ],
        )
      ],

    );
  }
}
