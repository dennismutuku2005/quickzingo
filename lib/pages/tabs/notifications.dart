import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': 'NOT001',
      'title': 'Order Delivered Successfully',
      'message': 'Your order QZ001 has been delivered to John Doe at Westlands',
      'type': 'success',
      'time': '2 minutes ago',
      'isRead': false,
      'icon': Icons.check_circle_outline,
      'color': Color(0xFF4CAF50),
      'bgColor': Color(0xFFE8F5E8),
    },
    {
      'id': 'NOT002',
      'title': 'New Order Assigned',
      'message': 'You have been assigned a new Parcel delivery to Karen. Order ID: QZ006',
      'type': 'info',
      'time': '15 minutes ago',
      'isRead': false,
      'icon': Icons.assignment_outlined,
      'color': Color(0xFF2196F3),
      'bgColor': Color(0xFFE3F2FD),
    },
    {
      'id': 'NOT003',
      'title': 'Payment Received',
      'message': 'Payment of 500 KES has been credited to your account',
      'type': 'success',
      'time': '1 hour ago',
      'isRead': true,
      'icon': Icons.account_balance_wallet_outlined,
      'color': Color(0xFF4CAF50),
      'bgColor': Color(0xFFE8F5E8),
    },
    {
      'id': 'NOT004',
      'title': 'Order Cancelled',
      'message': 'Order QZ004 has been cancelled by the customer. Reason: Change of plans',
      'type': 'warning',
      'time': '3 hours ago',
      'isRead': true,
      'icon': Icons.cancel_outlined,
      'color': Color(0xFFE91E63),
      'bgColor': Color(0xFFFFEBEE),
    },
    {
      'id': 'NOT005',
      'title': 'Route Optimization',
      'message': 'Your delivery route has been optimized. Check the updated route for faster delivery',
      'type': 'info',
      'time': '5 hours ago',
      'isRead': true,
      'icon': Icons.route_outlined,
      'color': Color(0xFF2196F3),
      'bgColor': Color(0xFFE3F2FD),
    },
    {
      'id': 'NOT006',
      'title': 'Weekly Performance',
      'message': 'Great job! You completed 24 deliveries this week with 98% customer satisfaction',
      'type': 'achievement',
      'time': '1 day ago',
      'isRead': true,
      'icon': Icons.star_outline,
      'color': Color(0xFFFF9800),
      'bgColor': Color(0xFFFFF3C4),
    },
    {
      'id': 'NOT007',
      'title': 'System Maintenance',
      'message': 'The app will undergo maintenance tonight from 2:00 AM to 4:00 AM',
      'type': 'warning',
      'time': '2 days ago',
      'isRead': true,
      'icon': Icons.build_outlined,
      'color': Color(0xFFFF9800),
      'bgColor': Color(0xFFFFF3C4),
    },
    {
      'id': 'NOT008',
      'title': 'Customer Rating',
      'message': 'You received a 5-star rating from Sarah Johnson for order QZ003',
      'type': 'achievement',
      'time': '3 days ago',
      'isRead': true,
      'icon': Icons.thumb_up_outlined,
      'color': Color(0xFF4CAF50),
      'bgColor': Color(0xFFE8F5E8),
    },
  ];

  final List<Map<String, dynamic>> notificationFilters = [
    {
      'title': 'All',
      'count': 8,
      'color': Color(0xFF2196F3),
      'bgColor': Color(0xFFE3F2FD),
      'icon': Icons.notifications_outlined,
    },
    {
      'title': 'Unread',
      'count': 2,
      'color': Color(0xFFE91E63),
      'bgColor': Color(0xFFFFEBEE),
      'icon': Icons.mark_email_unread_outlined,
    },
    {
      'title': 'Orders',
      'count': 4,
      'color': Color(0xFF4CAF50),
      'bgColor': Color(0xFFE8F5E8),
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'System',
      'count': 2,
      'color': Color(0xFFFF9800),
      'bgColor': Color(0xFFFFF3C4),
      'icon': Icons.settings_outlined,
    },
  ];

  String selectedFilter = 'All';

  List<Map<String, dynamic>> get filteredNotifications {
    switch (selectedFilter) {
      case 'Unread':
        return notifications.where((notif) => !notif['isRead']).toList();
      case 'Orders':
        return notifications.where((notif) => 
          notif['type'] == 'success' || notif['type'] == 'info').toList();
      case 'System':
        return notifications.where((notif) => 
          notif['type'] == 'warning').toList();
      default:
        return notifications;
    }
  }

  int get unreadCount {
    return notifications.where((notif) => !notif['isRead']).length;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFAC638),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAC638),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: SizedBox(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _markAllAsRead();
              },
              icon: const Icon(
                Icons.done_all,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Filter Tabs
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: notificationFilters.map((filter) {
                      bool isActive = selectedFilter == filter['title'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: _buildFilterTab(
                          filter['title'],
                          filter['count'],
                          filter['icon'],
                          isActive,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              // Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _buildSearchBar(),
              ),
              
              // Mark All Read Button
      
              
              // Notifications List
              Container(
                color: const Color(0xFFF8F9FA),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filteredNotifications.isEmpty)
                      _buildEmptyState()
                    else
                      ...filteredNotifications.map((notification) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildNotificationItem(notification),
                        );
                      }).toList(),
                    const SizedBox(height: 100), // Extra space for bottom navigation
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title, int count, IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFAC638).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFFFAC638) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? const Color(0xFFFAC638) : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? Colors.black87 : Colors.grey[600],
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFFAC638) : Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.black87 : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "search notifications",
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500],
            size: 24,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.close,
              color: Colors.grey[600],
              size: 18,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _markAsRead(notification['id']);
        _showNotificationDetails(notification);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: notification['isRead'] ? null : Border.all(
            color: const Color(0xFFFAC638).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: notification['bgColor'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification['icon'],
                color: notification['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: notification['isRead'] ? FontWeight.w500 : FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (!notification['isRead'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE91E63),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up! No new notifications.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = notifications.indexWhere((notif) => notif['id'] == notificationId);
      if (index != -1) {
        notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(0xFFFAC638),
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: notification['bgColor'],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          notification['icon'],
                          color: notification['color'],
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification['time'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    notification['message'],
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Color(0xFFFAC638)),
                          ),
                          child: const Text(
                            'Dismiss',
                            style: TextStyle(
                              color: Color(0xFFFAC638),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pop(context);
                            // Handle action based on notification type
                            _handleNotificationAction(notification);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFAC638),
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    String actionMessage = '';
    
    switch (notification['type']) {
      case 'success':
        actionMessage = 'Opening order details...';
        break;
      case 'info':
        actionMessage = 'Navigating to assigned order...';
        break;
      case 'warning':
        actionMessage = 'Opening system updates...';
        break;
      case 'achievement':
        actionMessage = 'Opening performance dashboard...';
        break;
      default:
        actionMessage = 'Opening notification details...';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(actionMessage),
        backgroundColor: const Color(0xFFFAC638),
      ),
    );
  }
}