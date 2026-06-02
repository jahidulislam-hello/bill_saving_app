import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vyzi/core/utils/app_colors.dart';
import 'sign_contract_controller.dart';

class SignContractScreen extends StatefulWidget {
  const SignContractScreen({super.key});

  @override
  State<SignContractScreen> createState() => _SignContractScreenState();
}

class _SignContractScreenState extends State<SignContractScreen> {
  final SignContractController _controller = SignContractController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Action Required + Ready to Sign card ──
            _buildReadyCard(),
            SizedBox(height: 16.h),

            // ── Supplier dark card ──
            _buildSupplierCard(),
            SizedBox(height: 16.h),

            // ── Need help signing? ──
            _buildHelpCard(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  APPBAR
  // ─────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded,
            color: const Color(0xFF1A1A2E), size: 22.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Firma il tuo Contratto',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
          height: 1.22,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  READY TO SIGN CARD
  // ─────────────────────────────────────────────

  Widget _buildReadyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Action Required pill ──
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Azione Richiesta',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.22,
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // ── Title ──
          Text(
            'Pronto da Firmare',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
              height: 1.22,
            ),
          ),

          SizedBox(height: 8.h),

          // ── Description ──
          Text(
            'Il tuo contratto è pronto! Firmalo per completare il tuo passaggio a EnergyPlus.',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF555555),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SUPPLIER DARK CARD
  // ─────────────────────────────────────────────

  Widget _buildSupplierCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2B6B), Color(0xFF4A35B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Supplier label + logo row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo circle
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fornitore',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.22,
                    ),
                  ),
                  Text(
                    'Sorgenia',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.22,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // ── Divider ──
          Divider(
              height: 1,
              thickness: 1,
              color: Colors.white.withOpacity(0.15)),

          SizedBox(height: 16.h),

          // ── Offer Name ──
          _buildCardField(
            label: 'Nome Offerta',
            value: 'Next e-Business Sunlight',
            valueColor: const Color(0xFF7BC8FF),
          ),

          SizedBox(height: 16.h),

          // ── Activation Date ──
          _buildCardField(
            label: 'Data di Attivazione',
            value: '12 Marzo 2026',
            valueColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildCardField({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white.withOpacity(0.6),
            height: 1.22,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
            height: 1.22,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  NEED HELP SIGNING CARD
  // ─────────────────────────────────────────────

  Widget _buildHelpCard() {
    return GestureDetector(
      onTap: () => _showTutorialSheet(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hai bisogno di aiuto per firmare?',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
                height: 1.22,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Text(
                  'Visualizza Tutorial di Firma',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                    height: 1.22,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.arrow_forward_rounded,
                    color: AppColors.primaryColor, size: 14.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  TUTORIAL BOTTOM SHEET
  // ─────────────────────────────────────────────

  void _showTutorialSheet(BuildContext context) {
    _controller.openTutorial();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _TutorialBottomSheet(controller: _controller);
      },
    ).then((_) => _controller.closeTutorial());
  }
}

// ─────────────────────────────────────────────
//  TUTORIAL BOTTOM SHEET WIDGET
// ─────────────────────────────────────────────

class _TutorialBottomSheet extends StatefulWidget {
  final SignContractController controller;
  const _TutorialBottomSheet({required this.controller});

  @override
  State<_TutorialBottomSheet> createState() => _TutorialBottomSheetState();
}

class _TutorialBottomSheetState extends State<_TutorialBottomSheet>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;

  SignContractController get _c => widget.controller;

  // ── Tutorial step data ──
  final List<_TutorialStep> _steps = const [
    _TutorialStep(
      illustration: _IllustrationType.emailCheck,
      stepNumber: 1,
      icon: Icons.mail_outline_rounded,
      title: 'Controlla i tuoi SMS/Email',
      description:
      'Invieremo un codice di verifica unico a 6 cifre al tuo numero di cellulare registrato e all\'indirizzo email per verificare la tua identità.',
    ),
    _TutorialStep(
      illustration: _IllustrationType.sign,
      stepNumber: 2,
      icon: Icons.edit_outlined,
      title: 'Firma il Contratto',
      description:
      'Inserisci il codice di verifica e rivedi i dettagli del contratto. Una volta confermato, apponi la tua firma digitale per procedere.',
    ),
    _TutorialStep(
      illustration: _IllustrationType.done,
      stepNumber: 3,
      icon: Icons.check_circle_outline_rounded,
      title: 'Sei a Posto!',
      description:
      'Il tuo contratto è firmato e il tuo passaggio a EnergyPlus è completo. Benvenuto a bordo — i tuoi risparmi iniziano ora!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _c.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
      _pageController.animateToPage(
        _c.tutorialStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _c.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 8.h),

          // ── Close button row ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded,
                        size: 16.sp, color: const Color(0xFF555555)),
                  ),
                ),
              ],
            ),
          ),

          // ── PageView content ──
          SizedBox(
            height: 420.h,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _steps.length,
              itemBuilder: (_, i) => _buildStepPage(_steps[i]),
            ),
          ),

          // ── Dots ──
          _buildDots(),
          SizedBox(height: 16.h),

          // ── Next / Got it button ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_c.isLastStep) {
                    Navigator.pop(context);
                  } else {
                    _c.nextStep();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  _c.isLastStep ? 'Capito' : 'Avanti',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  // ── Step page ──
  Widget _buildStepPage(_TutorialStep step) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),

          // ── Illustration ──
          _buildIllustration(step.illustration),
          SizedBox(height: 20.h),

          // ── Step number + icon + title ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Step circle
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEFF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step.stepNumber}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                      height: 1.22,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Icon(step.icon,
                  color: AppColors.primaryColor, size: 18.sp),
              SizedBox(width: 6.w),
              Text(
                step.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                  height: 1.22,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Description ──
          Text(
            step.description,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF555555),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Illustration widget ──
  Widget _buildIllustration(_IllustrationType type) {
    return Container(
      width: double.infinity,
      height: 170.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FB),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: _IllustrationPainter(type: type),
    );
  }

  // ── Dot indicators ──
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (i) {
        final isActive = i == _c.tutorialStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 22.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
//  ILLUSTRATION WIDGET (no external assets)
// ─────────────────────────────────────────────

enum _IllustrationType { emailCheck, sign, done }

class _IllustrationPainter extends StatelessWidget {
  final _IllustrationType type;
  const _IllustrationPainter({required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _IllustrationType.emailCheck:
        return _EmailIllustration();
      case _IllustrationType.sign:
        return _SignIllustration();
      case _IllustrationType.done:
        return _DoneIllustration();
    }
  }
}

// ── Step 1: Email/SMS envelope illustration ──
class _EmailIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Envelope body
        Positioned(
          left: 60.w,
          child: Container(
            width: 120.w,
            height: 90.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9900),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Inner white paper
                Container(
                  width: 80.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9900),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_rounded,
                          color: Colors.white, size: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Envelope flap (triangle top)
        Positioned(
          left: 60.w,
          top: 37.h,
          child: ClipPath(
            clipper: _TriangleClipper(),
            child: Container(
              width: 120.w,
              height: 50.h,
              color: const Color(0xFFE68900),
            ),
          ),
        ),

        // Person silhouette (right side)
        Positioned(
          right: 30.w,
          bottom: 10.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Head
              Container(
                width: 22.w,
                height: 22.w,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 2.h),
              // Body
              Container(
                width: 36.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    topRight: Radius.circular(14.r),
                  ),
                ),
              ),
              // Legs
              Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF888888),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    width: 14.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF888888),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(6.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TriangleClipper old) => false;
}

// ── Step 2: Contract / pen illustration ──
class _SignIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 8.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        )),
                    SizedBox(height: 8.h),
                    Container(
                        height: 6.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.r),
                        )),
                    SizedBox(height: 6.h),
                    Container(
                        height: 6.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.r),
                        )),
                    SizedBox(height: 14.h),
                    Container(
                      height: 24.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Text(
                          'Sign',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: -10,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9900),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit_rounded,
                      color: Colors.white, size: 18.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Step 3: Done / success illustration ──
class _DoneIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90.w,
            height: 90.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8EF),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_rounded,
                color: const Color(0xFF27AE60), size: 52.sp),
          ),
          SizedBox(height: 12.h),
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Switch Complete 🎉',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                height: 1.22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DATA CLASS
// ─────────────────────────────────────────────

class _TutorialStep {
  final _IllustrationType illustration;
  final int stepNumber;
  final IconData icon;
  final String title;
  final String description;

  const _TutorialStep({
    required this.illustration,
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
  });
}
