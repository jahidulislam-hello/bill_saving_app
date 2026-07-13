import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/profile/settings/controller/static_page_controller.dart';

class TermsCondition extends StatelessWidget {
  TermsCondition({super.key});

  static const _textDark = Color(0xFF1A1A2E);
  static const _bg = Colors.white;

  final StaticPageController _controller = Get.put(
    StaticPageController(slug: 'terms-conditions'),
    tag: 'terms-conditions',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/terms.png",
                  width: 328,
                  height: 172,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (_controller.notFound.value) {
                return _buildNotFoundState();
              }

              if (_controller.error.value.isNotEmpty) {
                return _buildErrorState();
              }

              final page = _controller.page.value;
              if (page == null) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      color: _textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Html(
                    data: page.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(13),
                        lineHeight: LineHeight(1.65),
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: _textDark, size: 28),
        ),
      ),
      title: Text(
        'terms.title'.tr,
        style: const TextStyle(
          color: _textDark,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'static_page.not_available'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'static_page.error'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.fetchPage(),
              child: Text('static_page.retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
