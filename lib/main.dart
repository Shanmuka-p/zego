import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
const int appID = 1215738257; 
const String appSign =
    '0d1f6a260cccf266b337f4f46daf676b0d65eba5bd53e73f4c9f59958ac6df56'; // <<< YOUR_APP_SIGN (or Server Secret)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '1-on-1 Tutoring App',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final callIdController = TextEditingController();
  final userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    userIdController.text = 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void dispose() {
    callIdController.dispose();
    userIdController.dispose();
    super.dispose();
  }

  void _joinCall() {
    if (appID == 0 || appSign == 'appid') {
      _showErrorDialog('ERRORS: Please add your appID and appSign in main.dart');
      return;
    }
    if (callIdController.text.isEmpty || userIdController.text.isEmpty) {
      _showErrorDialog('Call ID and User ID cannot be empty.');
      return;
    }

    // Navigate to the CallPage when the join button is pressed.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          callID: callIdController.text,
          userID: userIdController.text,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1-on-1 Tutoring Session'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.blueGrey[800],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Join a Tutoring Room',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  // Input for User ID
                  TextField(
                    controller: userIdController,
                    decoration: InputDecoration(
                      labelText: 'Your User ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Input for Call ID (Room ID)
                  TextField(
                    controller: callIdController,
                    decoration: InputDecoration(
                      labelText: 'Shared Call ID (Room ID)',
                      hintText: 'Both users enter the same ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Join Button
                  ElevatedButton.icon(
                    onPressed: _joinCall,
                    icon: const Icon(Icons.video_call),
                    label: const Text('Join'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// CallPage: The screen that hosts the Zego Cloud video call UI.
class CallPage extends StatelessWidget {
  final String callID;
  final String userID;
  final String userName;

  const CallPage({super.key, required this.callID, required this.userID})
    : userName = 'user_$userID'; // Generate a username from the userID

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),

      // Configure the call for a 1-on-1 video call.
      // config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
      //   ..onOnlySelfInRoom = (context) {
      //     // This function is called when a user is the only one in the room.
      //     // You can navigate them back to the home page.
      //     Navigator.of(context).pop();
      //   },
    );
  }
}
