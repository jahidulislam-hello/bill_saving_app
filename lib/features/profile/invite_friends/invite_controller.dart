import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vyzi/core/services/referral_service.dart';

class InviteController extends ChangeNotifier {
  final ReferralService _service = ReferralService();

  // ── Referral data ──
  String referralLink = '';
  String referralCode = '';

  // ── Reward amounts ──
  final String youEarn = '€10';
  final String friendGets = '€10';

  // ── Statistics ──
  int invitesSent = 0;
  int completedInvites = 0;

  // ── Earnings ──
  double totalEarnings = 0.0;
  final String earningsType = 'Buoni Amazon';
  String earningsStatus = '';
  String progressAmount = '€0';

  // ── State ──
  bool isLoading = false;
  bool isCopied = false;
  String? errorMessage;

  InviteController() {
    fetchReferralData();
  }

  /// Fetches the user's referral code, share link, and stats from the API.
  Future<void> fetchReferralData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final codeData = await _service.getMyCode();
      referralCode = codeData.referralCode;
      referralLink = codeData.shareLink;
      invitesSent = codeData.stats.totalInvites;
      completedInvites = codeData.stats.rewarded;
      totalEarnings = codeData.stats.totalEarnings;
      earningsStatus = totalEarnings > 0 ? 'profile.invite.earnings_status'.tr : '';
      progressAmount = '€${totalEarnings.toStringAsFixed(0)}';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Copy referral link to clipboard ──
  Future<void> copyLink(BuildContext context) async {
    if (referralLink.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: referralLink));
    isCopied = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    isCopied = false;
    notifyListeners();
  }

  // ── Share link via native share sheet ──
  Future<void> shareLink(BuildContext context) async {
    if (referralLink.isEmpty) return;
    await SharePlus.instance.share(
      ShareParams(
        text: '${'profile.invite.share_text'.tr}: $referralLink',
      ),
    );
  }
}
