import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgreementModel {
  final String id;
  final String name;
  final String city;
  final String discount;
  final String imageUrl;
  final String fullName;
  final String description;
  final String offerDate;
  final String discountCode;
  final String address;
  final List<String> howToUse;

  const AgreementModel({
    required this.id,
    required this.name,
    required this.city,
    required this.discount,
    required this.imageUrl,
    required this.fullName,
    required this.description,
    required this.offerDate,
    required this.discountCode,
    required this.address,
    required this.howToUse,
  });
}

class AgreementsController extends ChangeNotifier {
  bool isCopied = false;
  String? copiedCode;

  final List<AgreementModel> agreements = const [
    AgreementModel(
      id: '1',
      name: 'The Green Garden',
      city: 'London',
      discount: '15% OFF',
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      fullName: 'The Green Garden Restaurant',
      description: 'Fine dining with organic and locally sourced ingredients.',
      offerDate: '12-15 Feb, 2026',
      discountCode: 'ENERGY15',
      address: '123 Main Street\nLondon',
      howToUse: [
        'Copy your discount code using the button above',
        'Visit The Green Garden Restaurant at the address shown',
        'Show or mention your discount code when paying',
        'Enjoy your 15% discount!',
      ],
    ),
    AgreementModel(
      id: '2',
      name: 'Bella Italia Trattoria',
      city: 'Manchester',
      discount: '20% OFF',
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
      fullName: 'Bella Italia Trattoria',
      description: 'Authentic Italian cuisine in the heart of Manchester.',
      offerDate: '01-28 Feb, 2026',
      discountCode: 'ENERGY20',
      address: '45 King Street\nManchester',
      howToUse: [
        'Copy your discount code using the button above',
        'Visit Bella Italia Trattoria at the address shown',
        'Show or mention your discount code when paying',
        'Enjoy your 20% discount!',
      ],
    ),
    AgreementModel(
      id: '3',
      name: 'Sushi Master',
      city: 'Birmingham',
      discount: '10% OFF',
      imageUrl: 'https://images.unsplash.com/photo-1559410545-0bdcd187e0a6?w=400',
      fullName: 'Sushi Master',
      description: 'Premium Japanese sushi and sashimi experience.',
      offerDate: '10-20 Feb, 2026',
      discountCode: 'ENERGY10',
      address: '78 Broad Street\nBirmingham',
      howToUse: [
        'Copy your discount code using the button above',
        'Visit Sushi Master at the address shown',
        'Show or mention your discount code when paying',
        'Enjoy your 10% discount!',
      ],
    ),
    AgreementModel(
      id: '4',
      name: 'The Burger Hub',
      city: 'Leeds',
      discount: '15% OFF',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      fullName: 'The Burger Hub',
      description: 'Gourmet burgers made with the finest ingredients.',
      offerDate: '05-25 Feb, 2026',
      discountCode: 'ENERGY15',
      address: '12 Park Row\nLeeds',
      howToUse: [
        'Copy your discount code using the button above',
        'Visit The Burger Hub at the address shown',
        'Show or mention your discount code when paying',
        'Enjoy your 15% discount!',
      ],
    ),
    AgreementModel(
      id: '5',
      name: 'The Seafood Place',
      city: 'Liverpool',
      discount: '25% OFF',
      imageUrl: '',
      fullName: 'The Seafood Place',
      description: 'Fresh seafood caught daily, served in a cosy setting.',
      offerDate: '01-15 Feb, 2026',
      discountCode: 'ENERGY25',
      address: '9 Albert Dock\nLiverpool',
      howToUse: [
        'Copy your discount code using the button above',
        'Visit The Seafood Place at the address shown',
        'Show or mention your discount code when paying',
        'Enjoy your 25% discount!',
      ],
    ),
    AgreementModel(
      id: '6',
      name: 'Spice Garden',
      city: 'Bristol',
      discount: '12% OFF',
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400',
      fullName: 'Spice Garden',
      description: 'Exotic spices and rich flavours from around the world.',
      offerDate: '08-22 Feb, 2026',
      discountCode: 'ENERGY12',
      address: '33 Corn Street\nBristol',
      howToUse: [
        'Copy your discount code using the button above',
        'Visit Spice Garden at the address shown',
        'Show or mention your discount code when paying',
        'Enjoy your 12% discount!',
      ],
    ),
  ];

  Future<void> copyCode(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    copiedCode = code;
    isCopied = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    isCopied = false;
    copiedCode = null;
    notifyListeners();
  }
}
