import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quickzingo/pages/login_page.dart';
import 'package:quickzingo/pages/main_page.dart';

class IndividualRegisterPage extends StatefulWidget {
  const IndividualRegisterPage({super.key});

  @override
  State<IndividualRegisterPage> createState() => _IndividualRegisterPageState();
}

class _IndividualRegisterPageState extends State<IndividualRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Separate loading states for each button
  bool _isGoogleLoading = false;
  bool _isRegisterLoading = false;

  // Google Sign-In instance
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // API endpoint - replace with your actual endpoint URL
  final String apiBaseUrl = 'https://api.quickzingo.com/client';

  @override
  void dispose() {
    // Properly dispose controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Enhanced validation methods
  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter $fieldName";
    }
    if (value.trim().length < 2) {
      return "$fieldName must be at least 2 characters";
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter mobile number";
    }
    // Remove any spaces or special characters for validation
    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanValue.length < 10) {
      return "Please enter a valid mobile number";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // Individual Registration API method
Future<void> _registerIndividual() async {
  setState(() {
    _isRegisterLoading = true;
  });

  try {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String accountName = "$firstName $lastName"; // combine as account_name
    final String mobileNumber = _mobileController.text.trim();
    final String password = _passwordController.text.trim(); // if you want to store password

    // Prepare request body to match PHP API
    Map<String, dynamic> requestBody = {
      'account_name': accountName,
      'account_type': 'individual',
      'mobile_number': mobileNumber,
      'password': password, // optional if backend supports
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('$apiBaseUrl/register_individual.php'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(requestBody),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      // Registration successful
      final userData = responseData['user'] as Map<String, dynamic>;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome ${userData['account_name'] ?? accountName}!"),
            backgroundColor: const Color(0xFFFAC638),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );

        Map<String, String> userDataString = {
          'account_name': userData['account_name']?.toString() ?? accountName,
          'account_type': userData['account_type']?.toString() ?? 'individual',
          'mobile_number': userData['mobile_number']?.toString() ?? mobileNumber,
          'created_at': userData['created_at']?.toString() ?? '',
          'updated_at': userData['updated_at']?.toString() ?? '',
        };

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(userData: userDataString),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      }
    }
  } catch (error) {
    print('Registration Error: $error');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Network error: ${error.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isRegisterLoading = false;
      });
    }
  }
}

 // Google Sign-In with Firebase
Future<User?> signUpWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    // Reset any existing sessions
    await googleSignIn.signOut();
    await _auth.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null; // User cancelled

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  } catch (e) {
    print('Google Sign-Up error: $e');
    rethrow;
  }
}

// Google button press handler
Future<void> _signUpWithGoogle() async {
  setState(() {
    _isGoogleLoading = true;
  });

  try {
    final User? user = await signUpWithGoogle();

    if (user != null && mounted) {
      // Call your backend API (gregister_individual.php)
      final response = await http.post(
        Uri.parse('$apiBaseUrl/gregister_individual.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': user.displayName ?? 'User',
          'email': user.email ?? '',
        }),
      );

      print('Google Register API Response: ${response.body}');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final userData = responseData['user'] as Map<String, dynamic>;

        // Show welcome message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome ${userData['account_name'] ?? 'User'}!"),
            backgroundColor: const Color(0xFFFAC638),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );

        // Convert to Map<String, String> for MainPage
        Map<String, String> userDataString = {
          
        };

        // Navigate to main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(userData: userDataString),
          ),
        );
      } else {
        // API returned failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? "Google registration failed"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      }
    }
  } catch (error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign-up failed: $error"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.12; // 25% of screen height

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Image container taking 25% of screen height
              Container(
                height: imageHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/ireg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                
              ),
              
              // Form container with top border radius - positioned to overlap image
              Expanded(
                child: Container(
                  width: double.infinity,
                  transform: Matrix4.translationValues(0, -30, 0), // Move up by 30 pixels
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24), // Extra top padding to account for overlap
                    child: Column(
                      children: [
                        // Title
                        const Text(
                          "Individual Registration",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Google Sign-Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: _isGoogleLoading ? null : _signUpWithGoogle,
                            icon: _isGoogleLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/google_logo.png',
                                    width: 20,
                                    height: 20,
                                  ),
                            label: Text(
                              _isGoogleLoading ? "Signing up..." : "Continue with Google",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // OR Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _firstNameController,
                                label: "First Name",
                                icon: Icons.person_outline,
                                validator: (value) => _validateName(value, "first name"),
                              ),
                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _lastNameController,
                                label: "Last Name",
                                icon: Icons.person_outline,
                                validator: (value) => _validateName(value, "last name"),
                              ),
                              const SizedBox(height: 16),

                              _buildTextField(
                                controller: _mobileController,
                                label: "Mobile Number",
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: _validateMobile,
                              ),
                              const SizedBox(height: 16),

                              _buildPasswordField(
                                controller: _passwordController,
                                label: "Password",
                                obscureText: _obscurePassword,
                                toggle: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: 16),

                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                label: "Confirm Password",
                                obscureText: _obscureConfirmPassword,
                                toggle: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                                validator: _validateConfirmPassword,
                              ),
                              const SizedBox(height: 32),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFAC638),
                                    foregroundColor: Colors.black87,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: _isRegisterLoading ? null : () {
                                    // Remove focus from text fields to hide keyboard
                                    FocusScope.of(context).unfocus();
                                    
                                    if (_formKey.currentState!.validate()) {
                                      _registerIndividual();
                                    }
                                  },
                                  child: _isRegisterLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                                          ),
                                        )
                                      : const Text(
                                          "Register",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              
                              // Already have an account section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to login page
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                    },
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Color(0xFFFAC638),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xFFFAC638),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24), // Extra padding at bottom
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFAC638), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      textInputAction: label.contains("Confirm") ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFAC638), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}