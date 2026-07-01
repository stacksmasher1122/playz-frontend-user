import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/view/USER/Navigation/splash.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/controller/event_fest_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/chat_controller.dart';
import 'package:redesign/controller/presence_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  // Initialize UserProfileController globally
  Get.put(UserProfileController());
  Get.put(MapsController(), permanent: true);
  Get.put(EventFestController(), permanent: true);
  Get.put(FriendsController(), permanent: true);
  Get.put(ChatController(), permanent: true);
  Get.put(PresenceController(), permanent: true);
  Get.put(GroupsController(), permanent: true);
  Get.put(GroupChatController(), permanent: true);

  runApp(const PlayZApp());
}

class PlayZApp extends StatelessWidget {
  const PlayZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayZ',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
      //  home: const TurfDetailScreen(),
    );
  }
}
