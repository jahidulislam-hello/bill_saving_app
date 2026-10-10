import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final _api = ApiService();

  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  Future<void> fetchNotifications({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await _api.get(
        '${ApiConstants.notifications}?page=$page&limit=20',
      );

      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>;
        final items = (data['data'] as List<dynamic>?)
                ?.map((e) =>
                    NotificationModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        if (page == 1) {
          notifications.value = items;
        } else {
          notifications.addAll(items);
        }

        final meta = data['meta'] as Map<String, dynamic>?;
        currentPage.value = meta?['page'] as int? ?? page;
        totalPages.value = meta?['totalPages'] as int? ?? 1;
        total.value = meta?['total'] as int? ?? 0;
      }
    } catch (e) {
      debugPrint('Failed to fetch notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await _api.get(ApiConstants.notificationsUnreadCount);
      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>;
        unreadCount.value = data['count'] as int? ?? 0;
      }
    } catch (e) {
      debugPrint('Failed to fetch unread count: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final response =
          await _api.patch(ApiConstants.notificationMarkRead(id));
      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true) {
        final index = notifications.indexWhere((n) => n.id == id);
        if (index >= 0 && !notifications[index].isRead) {
          notifications[index] = NotificationModel.fromJson(
            body['data'] as Map<String, dynamic>,
          );
          unreadCount.value = (unreadCount.value - 1).clamp(0, unreadCount.value);
        }
      }
    } catch (e) {
      debugPrint('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _api.patch(ApiConstants.notificationsMarkAllRead);
      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true) {
        // Refresh the list to get updated read states
        await fetchNotifications(page: 1);
        unreadCount.value = 0;
      }
    } catch (e) {
      debugPrint('Failed to mark all as read: $e');
    }
  }

  Future<void> loadMore() async {
    if (currentPage.value < totalPages.value) {
      await fetchNotifications(page: currentPage.value + 1);
    }
  }

  Future<void> refresh() async {
    await fetchNotifications(page: 1);
    await fetchUnreadCount();
  }
}
