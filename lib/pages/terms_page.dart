import 'package:flutter/material.dart';
import 'package:quickzingo/pages/type_page.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool hasScrolledToBottom = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 50) {
      if (!hasScrolledToBottom) {
        setState(() {
          hasScrolledToBottom = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
       
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Clean Terms Content - Full scroll
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              child: const Text(
                """TERMS AND CONDITIONS FOR QUICKZINGO

Last updated: August 2025

WELCOME TO QUICKZINGO
These Terms and Conditions ("Terms") govern your use of QuickZingo's motorcycle delivery services within Nairobi, Kenya. By using our services, you agree to these terms.

1. ACCEPTANCE OF TERMS
By registering for or using QuickZingo services, you acknowledge that you:
• Are at least 18 years old or have parental/guardian consent
• Have read, understood, and agree to be bound by these Terms
• Agree to comply with all applicable laws and regulations

2. SERVICE DESCRIPTION
QuickZingo provides on-demand motorcycle delivery services including:
• Package and document delivery
• Food delivery from restaurants and shops
• Emergency delivery services
• Same-day delivery within Nairobi

3. USER RESPONSIBILITIES
As a QuickZingo user, you agree to:
• Provide accurate pickup and delivery information
• Ensure all items comply with our prohibited items policy
• Pay for services according to agreed pricing
• Treat our delivery partners with respect and courtesy
• Be available at pickup and delivery locations at scheduled times
• Report any issues or damages within 24 hours

4. PROHIBITED ITEMS
We do not transport:
• Illegal substances or contraband
• Hazardous or dangerous materials
• Live animals (except service animals with prior arrangement)
• Perishable items without proper packaging
• Fragile items over KSh 50,000 without insurance
• Items exceeding 25kg in weight
• Weapons or ammunition
• Cash amounts exceeding KSh 100,000

5. PRICING AND PAYMENT
• All prices include applicable taxes and service fees
• Payment is required before service confirmation
• We accept mobile money (M-Pesa, Airtel Money), cards, and cash
• Cancellation fees apply for cancellations made less than 10 minutes after booking
• Additional charges may apply for waiting time, multiple stops, or special handling

6. DELIVERY TERMS
• Delivery times are estimates based on distance and traffic conditions
• We are not liable for delays due to traffic, weather, or circumstances beyond our control
• Items must be properly packaged by the sender
• We reserve the right to refuse delivery of improperly packaged items
• Delivery confirmation requires recipient signature or photo proof

7. LIABILITY AND INSURANCE
• QuickZingo maintains comprehensive insurance coverage for all deliveries
• Users must declare items valued over KSh 10,000 for insurance purposes
• Our liability is limited to the declared value of items
• We are not liable for indirect, consequential, or punitive damages
• Items left unattended at delivery location are delivered at recipient's risk

8. PRIVACY AND DATA PROTECTION
• We collect and process personal data in accordance with Kenya's Data Protection Act
• Location data is collected only during active delivery tracking
• We do not share personal information with third parties except as required by law
• Users can request data deletion by contacting support@quickzingo.co.ke

9. SERVICE AVAILABILITY
• Services are available 24/7 within our coverage areas in Nairobi
• Service availability may be affected by weather, traffic, or other factors
• We reserve the right to suspend services during emergencies or maintenance

10. DISPUTE RESOLUTION
• Disputes should first be reported through our customer service channels
• We aim to resolve all complaints within 48 hours
• Unresolved disputes may be escalated to the Kenya Bureau of Standards
• These Terms are governed by the laws of Kenya

11. ACCOUNT TERMINATION
We may suspend or terminate accounts for:
• Violation of these Terms
• Fraudulent or illegal activity
• Repeated cancellations or no-shows
• Abusive behavior toward delivery partners

12. MODIFICATIONS TO TERMS
• QuickZingo reserves the right to modify these Terms with 30 days' notice
• Continued use of services after modifications constitutes acceptance
• Major changes will be communicated via email and in-app notifications

13. FORCE MAJEURE
We are not liable for delays or failures due to events beyond our reasonable control, including natural disasters, strikes, government actions, or technical failures.

14. CONTACT INFORMATION
For questions about these Terms:
• Email: legal@quickzingo.co.ke
• Phone: +254 700 123 456
• Address: QuickZingo Ltd, Nairobi, Kenya

By using QuickZingo services, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.

Thank you for choosing QuickZingo - Your trusted delivery partner in Nairobi!""",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Decline",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: hasScrolledToBottom
                            ? [
                                const Color(0xFFFAC638),
                                const Color(0xFFFFD700),
                              ]
                            : [
                                Colors.grey[300]!,
                                Colors.grey[400]!,
                              ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: hasScrolledToBottom
                          ? () {
                             
                              _navigateToRegisterPage(context);
                            }
                          : null,
                      child: Text(
                        "Accept",
                        style: TextStyle(
                          color: hasScrolledToBottom ? Colors.black : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRegisterPage(BuildContext context) {
    // Replace with your actual RegisterPage navigation
     Navigator.push(
     context,
       MaterialPageRoute(builder: (context) => const UserTypePage()),
     );
    
  }
}