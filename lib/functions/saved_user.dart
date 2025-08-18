import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserPreferences {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Save user from API response to SharedPreferences
  /// Takes the complete API response and extracts user data
  static Future<bool> saveUserFromResponse(Map<String, dynamic> apiResponse) async {
    try {
      // Check if the response is successful
      if (apiResponse['success'] != true) {
        print('API response indicates failure: ${apiResponse['message']}');
        return false;
      }

      // Extract user data from the response
      final userData = apiResponse['user'] as Map<String, dynamic>?;
      
      if (userData == null) {
        print('No user data found in API response');
        return false;
      }

      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();
      
      // Convert user data to JSON string and save
      final userJson = json.encode(userData);
      await prefs.setString(_userKey, userJson);
      await prefs.setBool(_isLoggedInKey, true);
      
      print('User saved successfully: ${userData['account_name']}');
      return true;
      
    } catch (e) {
      print('Error saving user from response: $e');
      return false;
    }
  }

  /// Alternative function that takes just the user object directly
  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert user data to JSON string and save
      final userJson = json.encode(userData);
      await prefs.setString(_userKey, userJson);
      await prefs.setBool(_isLoggedInKey, true);
      
      print('User data saved successfully: ${userData['account_name']}');
      return true;
      
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  /// Get user data from SharedPreferences
  static Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        return json.decode(userJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Clear user data (logout)
  static Future<bool> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.setBool(_isLoggedInKey, false);
      
      print('User data cleared successfully');
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  /// Get specific user field
  static Future<String?> getUserField(String field) async {
    final userData = await getUser();
    return userData?[field]?.toString();
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    return await getUserField('user_id');
  }

  /// Get account name
  static Future<String?> getAccountName() async {
    return await getUserField('account_name');
  }

  /// Get email
  static Future<String?> getEmail() async {
    return await getUserField('email');
  }

  /// Get account type
  static Future<String?> getAccountType() async {
    return await getUserField('account_type');
  }
}

// Example usage in your registration method:
/*
Future<void> _registerCompany() async {
  setState(() {
    _isRegisterLoading = true;
  });

  try {
    // Your existing API call code...
    final response = await http.post(
      Uri.parse('$apiBaseUrl/register_company.php'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(requestBody),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      // Save user data using the new function
      bool savedSuccessfully = await UserPreferences.saveUserFromResponse(responseData);
      
      if (savedSuccessfully) {
        print('User data saved to SharedPreferences successfully');
        
        // Get the saved user data for navigation
        final userData = await UserPreferences.getUser();
        
        if (mounted && userData != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Welcome ${userData['account_name']}!"),
              backgroundColor: const Color(0xFFFAC638),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          );

          // Convert to String map for MainPage compatibility
          Map<String, String> userDataString = {};
          userData.forEach((key, value) {
            userDataString[key] = value?.toString() ?? '';
          });

          // Navigate to main page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(userData: userDataString),
            ),
          );
        }
      } else {
        print('Failed to save user data to SharedPreferences');
      }
    } else {
      // Handle registration failure...
    }
  } catch (error) {
    // Handle error...
  } finally {
    if (mounted) {
      setState(() {
        _isRegisterLoading = false;
      });
    }
  }
}
*/