import 'package:get/get.dart';
import 'package:redesign/model/User_Models/More_Models/support_faq_model.dart';

class SupportFaqController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;

  final categories = const ['All', 'Bookings', 'Scoreboards', 'Payments', 'Account'];

  final faqList = <FaqItemModel>[
    FaqItemModel(
      id: 'faq_1',
      category: 'Bookings',
      question: 'How do I access the live scoreboard for my turf booking?',
      answer: 'Scoreboard access opens 20 minutes prior to your scheduled slot start time. Navigate to My Bookings, tap on your active slot card, and tap "Start Scoreboard" or "Continue Scoreboard". Access remains open up to 20 minutes after your slot end time.',
      helpfulCount: 142,
    ),
    FaqItemModel(
      id: 'faq_2',
      category: 'Bookings',
      question: 'What happens if my app closes mid-scoring during a match?',
      answer: 'PlayZ uses local SQFlite persistence. Your score state is automatically saved per slot booking ID. When you re-open the app or go to My Bookings, tap "Continue Scoreboard" to resume your live match seamlessly.',
      helpfulCount: 98,
    ),
    FaqItemModel(
      id: 'faq_3',
      category: 'Scoreboards',
      question: 'Which sports currently support live scoreboards?',
      answer: 'Cricket (Friendly & Tournament modes) and Badminton (Singles/Doubles standard rules) are currently fully supported with specialized UI, toss flows, and stats analytics. Additional sports are rolling out soon!',
      helpfulCount: 75,
    ),
    FaqItemModel(
      id: 'faq_4',
      category: 'Payments',
      question: 'How does Split & Pay work for group turf bookings?',
      answer: 'When creating a open play or booking a turf with Split & Pay, each player can contribute their split share through UPI/Card. Once target amount is collected, the slot is confirmed automatically.',
      helpfulCount: 110,
    ),
    FaqItemModel(
      id: 'faq_5',
      category: 'Account',
      question: 'How do I update my profile or favorite sports?',
      answer: 'Go to More screen -> App Settings -> Favorite Sports to choose your primary sports. To edit your name or avatar, tap your profile header on the More screen.',
      helpfulCount: 54,
    ),
    FaqItemModel(
      id: 'faq_6',
      category: 'Bookings',
      question: 'Can I cancel or reschedule a turf booking?',
      answer: 'Cancellations and rescheduling depend on individual turf partner policies. Visit My Bookings -> View QR Code / Slot Details to view partner cancellation terms or initiate support.',
      helpfulCount: 63,
    ),
  ].obs;

  List<FaqItemModel> get filteredFaqs {
    return faqList.where((item) {
      final matchesCategory = selectedCategory.value == 'All' || item.category == selectedCategory.value;
      final query = searchQuery.value.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          item.question.toLowerCase().contains(query) ||
          item.answer.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void toggleExpand(String id) {
    final idx = faqList.indexWhere((element) => element.id == id);
    if (idx != -1) {
      faqList[idx].isExpanded = !faqList[idx].isExpanded;
      faqList.refresh();
    }
  }

  void voteHelpful(String id, bool isHelpful) {
    final idx = faqList.indexWhere((element) => element.id == id);
    if (idx != -1) {
      if (isHelpful) {
        faqList[idx].helpfulCount++;
      } else {
        faqList[idx].unhelpfulCount++;
      }
      faqList.refresh();
    }
  }
}
