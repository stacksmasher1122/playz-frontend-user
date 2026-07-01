import 'package:get/get.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/tennis_player_model.dart';

class PlayerManagementController extends GetxController {
  final Rx<TennisPlayerModel?> playerA = Rx<TennisPlayerModel?>(null);
  final Rx<TennisPlayerModel?> playerB = Rx<TennisPlayerModel?>(null);

  final List<TennisPlayerModel> suggestedPlayers = [
    TennisPlayerModel(
      id: '1',
      name: 'Roger Federer',
      club: 'Swiss Tennis Club',
      ranking: '#2',
      countryCode: 'SUI',
      imageUrl:
          'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&q=80&w=150',
    ),
    TennisPlayerModel(
      id: '2',
      name: 'Rafael Nadal',
      club: 'Rafa Nadal Academy',
      ranking: '#3',
      countryCode: 'ESP',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=150',
    ),
    TennisPlayerModel(
      id: '3',
      name: 'Novak Djokovic',
      club: 'Partizan Tennis Club',
      ranking: '#4',
      countryCode: 'SRB',
      imageUrl:
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&q=80&w=150',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Mock initial state for Player A (Server) as per screenshot
    playerA.value = TennisPlayerModel(
      id: '0',
      name: 'Carlos Alcaraz',
      club: 'Real Sociedad Tenis',
      ranking: '#1',
      countryCode: 'ESP',
      imageUrl:
          'https://images.unsplash.com/photo-1599586120429-48281b6f0ece?auto=format&fit=crop&q=80&w=150',
    );
  }

  void selectPlayerB(TennisPlayerModel player) {
    playerB.value = player;
  }

  void removePlayerB() {
    playerB.value = null;
  }

  var isQrModalVisible = false.obs;
  void showQrModal() {
    isQrModalVisible.value = true;
  }

  void hideQrModal() {
    isQrModalVisible.value = false;
  }

  void changePlayerA() {}
  void changePlayerB() {}
  void confirmParticipants() {}
}
