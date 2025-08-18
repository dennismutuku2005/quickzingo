import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final List<Map<String, dynamic>> orders = [
    {
      'id': 'QZ001',
      'type': 'Doorstep',
      'status': 'Completed',
      'time': '2 hours ago',
      'amount': '350 KES',
      'customer': 'John Doe',
      'location': 'Westlands',
      'icon': Icons.home_outlined,
    },
    {
      'id': 'QZ002',
      'type': 'Parcel',
      'status': 'In Transit',
      'time': '4 hours ago',
      'amount': '500 KES',
      'customer': 'Mary Smith',
      'location': 'Karen',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'id': 'QZ003',
      'type': 'Jetpack',
      'status': 'Pending',
      'time': '6 hours ago',
      'amount': '800 KES',
      'customer': 'Peter Wilson',
      'location': 'CBD',
      'icon': Icons.rocket_launch_outlined,
    },
    {
      'id': 'QZ004',
      'type': 'Doorstep',
      'status': 'Rejected',
      'time': '1 day ago',
      'amount': '450 KES',
      'customer': 'Sarah Johnson',
      'location': 'Kilimani',
      'icon': Icons.home_outlined,
    },
    {
      'id': 'QZ005',
      'type': 'Parcel',
      'status': 'Pending',
      'time': '2 days ago',
      'amount': '600 KES',
      'customer': 'Mike Brown',
      'location': 'Kileleshwa',
      'icon': Icons.inventory_2_outlined,
    },
  ];

  final List<Map<String, dynamic>> statusFilters = [
    {
      'title': 'Pending',
      'count': 2,
      'color': Color(0xFFFF9800),
      'bgColor': Color(0xFFFFF3C4),
      'icon': Icons.pending_actions,
    },
    {
      'title': 'Completed',
      'count': 1,
      'color': Color(0xFF4CAF50),
      'bgColor': Color(0xFFE8F5E8),
      'icon': Icons.check_circle_outline,
    },
    {
      'title': 'Rejected',
      'count': 1,
      'color': Color(0xFFE91E63),
      'bgColor': Color(0xFFFFEBEE),
      'icon': Icons.cancel_outlined,
    },
    {
      'title': 'In Transit',
      'count': 1,
      'color': Color(0xFF2196F3),
      'bgColor': Color(0xFFE3F2FD),
      'icon': Icons.local_shipping_outlined,
    },
  ];

  String selectedStatus = 'All';

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedStatus == 'All') return orders;
    return orders.where((order) => order['status'] == selectedStatus).toList();
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
          automaticallyImplyLeading: false, // This removes the back button
  centerTitle: true,
          leading: SizedBox() ,
          title: const Text(
            "My Orders",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Service Tabs
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    _buildServiceTab('Quickzingo', true),
                    const SizedBox(width: 20),
                    _buildServiceTab('Doorstep', false),
                    const SizedBox(width: 20),
                    _buildServiceTab('Parcel', false),
                    const SizedBox(width: 20),
                    _buildServiceTab('Rent a shelf', false),
                  ],
                ),
              ),
              
              // Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _buildSearchBar(),
              ),
              
              // Create Order Button
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _showCreateOrderModal(context);
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Create New Order',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Content Area
              Container(
                color: const Color(0xFFF8F9FA),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status List Items
                    _buildStatusItem('Unpaid', Icons.shopping_basket, false),
                    const SizedBox(height: 12),
                    _buildStatusItem('Submitted', Icons.assignment_outlined, false),
                    const SizedBox(height: 12),
                    _buildStatusItem('Paid', Icons.credit_card, false),
                    const SizedBox(height: 12),
                    _buildStatusItem('Dropped', Icons.inventory_outlined, false),
                    const SizedBox(height: 12),
                    _buildStatusItem('Transit', Icons.local_shipping, false),
                    const SizedBox(height: 12),
                    _buildStatusItem('Sorting at warehouse', Icons.warehouse, false),
                    const SizedBox(height: 12),
                    _buildStatusItem('Delivered', Icons.check_circle, false),
                    const SizedBox(height: 12),
                    _buildStatusItem('Collected', Icons.person_pin_circle, false),
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

  Widget _buildServiceTab(String title, bool isActive) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.black87 : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        if (isActive)
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFAC638),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
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
          hintText: "search package",
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

  Widget _buildStatusItem(String title, IconData icon, bool hasNotification) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to specific status page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $title orders...'),
            backgroundColor: const Color(0xFFFAC638),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFAC638).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFAC638),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            if (hasNotification)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE91E63),
                  shape: BoxShape.circle,
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



  void _showCreateOrderModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Create New Order',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_business_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Order Creation Form',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This feature will be implemented next',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}