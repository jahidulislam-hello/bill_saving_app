import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteController extends ChangeNotifier {
  // ── Referral link ──
  final String referralLink = 'easyrisparmio.it/ref/USER123';

  // ── Reward amounts ──
  final String youEarn = '€10';
  final String friendGets = '€10';

  // ── Statistics ──
  int invitesSent = 12;
  int completedInvites = 12;

  // ── Earnings ──
  double totalEarnings = 40.00;
  final String earningsType = 'Amazon vouchers';
  final String earningsStatus = 'AVAILABLE';
  final String progressAmount = '€10';

  bool isCopied = false;

  // ── Copy referral link to clipboard ──
  Future<void> copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: referralLink));
    isCopied = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    isCopied = false;
    notifyListeners();
  }

  // ── Share link (uses share_plus) ──
  Future<void> shareLink(BuildContext context) async {
    // If you add share_plus to pubspec:
    // await Share.share(
    //   'Use my referral link to save on your utility bills: https://$referralLink',
    //   subject: 'Save on your utility bills!',
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Link shared!'),
        backgroundColor: const Color(0xFF6C52D9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}