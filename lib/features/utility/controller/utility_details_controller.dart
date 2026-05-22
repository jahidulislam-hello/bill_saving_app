import 'package:get/get.dart';

class UtilityDetailsController extends GetxController {
  RxList<FaqModel> faqList = <FaqModel>[
    FaqModel(
      question: "How does the switching process work?",
      answer:
      "The switching process usually takes a few business days and does not interrupt your utility service.",
    ),
    FaqModel(
      question: "Will my service be interrupted?",
      answer:
      "No, your electricity or gas service will continue without interruption.",
    ),
    FaqModel(
      question: "What if I’m still under contract?",
      answer:
      "You can still switch providers depending on your current contract conditions.",
    ),
    FaqModel(
      question:
      "How long does it take to receive my contract?",
      answer:
      "The contract is usually sent within 24-48 hours after activation.",
    ),
  ].obs;
}

class FaqModel {
  final String question;
  final String answer;

  FaqModel({
    required this.question,
    required this.answer,
  });
}