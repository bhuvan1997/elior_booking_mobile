import 'package:elior/app_values/app_theme.dart';
import 'package:elior/response_model/notification_model.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';

import '../network/service_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationModel notificationModel = NotificationModel();
  bool isLoading = false;

  Future<void> fetchNotification() async {
    try {
      setState(() => isLoading = true);

      notificationModel = await ServiceProvider().getNotification();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: getAppBar(context, "My Notifications", isLeading: false),

      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF0057C2),
      //   foregroundColor: Colors.white,
      //   title: const Text(
      //     "Your notifications",
      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      // ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationModel.data == null || notificationModel.data!.isEmpty
          ? const Center(child: Text("No Notifications Found"))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: notificationModel.data!.length,
        itemBuilder: (context, index) {
          final notification = notificationModel.data![index];

          return _notificationTile(
            // icon:
            // "https://eliorbooking.com/public/uploads/property/1761911755_6904a3cb19972.jpg",
             title: notification.title ?? "",
            subtitle: notification.message ?? "",
            date: notification.message ?? "",
            isRead: notification.isRead ?? 0,
          );
        },
      ),
    );
  }

  // ---------------- NOTIFICATION ITEM WIDGET ----------------
  Widget _notificationTile({
    // required String icon,
    required String title,
    required String subtitle,
    required String date,
    required int isRead,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.white),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ClipOval(
          //   child: Image.network(
          //     icon,
          //     height: 55,
          //     width: 55,
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    if (isRead == 0)
                      Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.appThemeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),

                // const SizedBox(height: 6),

                // Text(
                //   date,
                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
