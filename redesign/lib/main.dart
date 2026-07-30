import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force lock application to portrait vertical orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Guard Firebase Initialization against duplicate app initialization on engine re-entry / hot restart
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp();
      debugPrint('🔥 [Main] Firebase initialized successfully.');
    } catch (e) {
      debugPrint('⚠️ [Main] Firebase.initializeApp warning: $e');
    }
  } else {
    debugPrint('🔥 [Main] Re-using existing Firebase App instance: ${Firebase.app().name}');
  }

  // Configure Firestore offline persistence & settings for fast loading & resilience
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint('⚡ [Main] Firestore offline persistence & unlimited cache enabled.');
  } catch (e) {
    debugPrint('⚠️ [Main] Firestore settings setup warning: $e');
  }

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('⚠️ [Main] Dotenv load warning: $e');
  }

  // Initialize core GetX controllers globally
  debugPrint('🚀 [Main] Initializing global GetX controllers...');
  Get.put(UserProfileController());
  Get.put(MapsController(), permanent: true);
  Get.put(EventFestController(), permanent: true);
  Get.put(FriendsController(), permanent: true);
  Get.put(ChatController(), permanent: true);
  Get.put(PresenceController(), permanent: true);
  Get.put(GroupsController(), permanent: true);
  Get.put(GroupChatController(), permanent: true);
  Get.put(BookingController(), permanent: true);
  Get.put(MatchController(), permanent: true);

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
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Prevents transparent black screen
        canvasColor: const Color(0xFF0F172A),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
    );
  }
}
