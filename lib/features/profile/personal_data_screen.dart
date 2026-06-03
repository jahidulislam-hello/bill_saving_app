import 'package:vyzi/core/appbar/custom_appbar.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalDataScreen extends StatefulWidget {
  final ProfileController controller;

  const PersonalDataScreen({super.key, required this.controller});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  ProfileController get _c => widget.controller;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: const CustomAppBar(title: 'Dati Personali', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Subtitle ──
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
              child: Text(
                'Aggiorna le informazioni del tuo account e come\nti contattiamo.',
                style: AppStyles.body3.copyWith(height: 1.5, color: Colors.black),
              ),
            ),

            // ── Avatar + name card ──
            _buildAvatarCard(),

            SizedBox(height: 20.h),

            // ── Form fields card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildFormCard(),
            ),

            SizedBox(height: 16.h),

            // ── Privacy notice card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildPrivacyCard(),
            ),

            SizedBox(height: 32.h),

            // ── Action buttons ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildActionButtons(),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  // ── Avatar card ──
  Widget _buildAvatarCard() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h),
      child: Column(
        children: [
          // Avatar with edit button
          Stack(
            children: [
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.grey.shade200, width: 2),
                  color: Colors.grey.shade100,
                ),
                child: ClipOval(
                  child: _c.avatarAsset.isNotEmpty
                      ? Image.asset(_c.avatarAsset, fit: BoxFit.cover)
                      : Icon(
                      Icons.person_rounded,
                      size: 48.sp,
                      color: Colors.grey.shade400,
                    ),
                ),
              ),
              // Edit icon badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue,
                    shape: BoxShape.circle,
                    border:
                    Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.edit_rounded,
                      color: Colors.white, size: 12.sp),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Text(
            _c.name,
            style: AppStyles.h2.copyWith(fontSize: 17.sp),
          ),
          SizedBox(height: 3.h),
          Text(
            _c.memberSince,
            style: AppStyles.body4,
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Cambia foto',
              style: AppStyles.body3.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // ── Form card ──
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            label: 'Nome',
            controller: _c.firstNameController,
            hint: '',
          ),
          SizedBox(height: 16.h),
          _buildField(
            label: 'Cognome',
            controller: _c.lastNameController,
            hint: '',
          ),
          SizedBox(height: 16.h),
          _buildField(
            label: 'Email',
            controller: _c.emailController,
            hint: 'alexsmith.mobbin@gmail.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.h),
          _buildField(
            label: 'Numero di Telefono',
            controller: _c.phoneController,
            hint: '',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),
          _buildField(
            label: 'Codice Fiscale',
            controller: _c.codiceFiscaleController,
            hint: 'RSSMRA231X1WDF52',
          ),
        ],
      ),
    );
  }

  // ── Single field ──
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.label.copyWith(fontSize: 13.sp, color: AppColors.darkBlue),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppStyles.body2,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyles.hintStyle,
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w, vertical: 12.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                  color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                  color: AppColors.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── Privacy card ──
  Widget _buildPrivacyCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined,
              color: AppColors.primaryColor, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Prima di Tutto',
                  style: AppStyles.h4.copyWith(fontSize: 13.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  'I tuoi dati sono crittografati e gestiti secondo i nostri standard di protezione premium. Non condividiamo mai i tuoi dati personali con fornitori terzi senza il tuo consenso.',
                  style: AppStyles.body4.copyWith(color: AppColors.primaryColor, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Action buttons ──
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Save Changes — dark filled
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _c.isSaving
                ? null
                : () async {
              await _c.saveChanges();
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: _c.isSaving
                ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(
              'Salva Modifiche',
              style: AppStyles.buttonText.copyWith(fontSize: 15.sp),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Cancel and discard — text button
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: TextButton(
            onPressed: () {
              _c.cancelChanges();
              Navigator.pop(context);
            },
            child: Text(
              'Annulla e scarta',
              style: AppStyles.body2.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
