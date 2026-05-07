import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String mobileNumber = "";
  String city = "";
  String country = "";
  String collegeName = "";
  String joinDate = "";
  String endDate = "";
  String email = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("userName") ?? "";
    mobileNumber = prefs.getString("mobile") ?? "";
    email = prefs.getString("email") ?? "";
    city = prefs.getString("city") ?? "";
    country = prefs.getString("country") ?? "";
    collegeName = prefs.getString("collegeName") ?? "";
    joinDate = prefs.getString("joindate") ?? "";
    endDate = prefs.getString("enddate") ?? "";
    setState(() => isLoading = false);
  }

  // --------------------------------------------------
  // UI HELPERS
  // --------------------------------------------------
  Widget _infoTile({
    required IconData icon,
    required Color color,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: Keys.fontFamily,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: Keys.fontFamily,
          fontSize: 14,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  String _formatDateRange(String start, String end) {
    if (start.isEmpty || end.isEmpty) return "Active period not set";
    try {
      final startDate = DateTime.tryParse(start);
      final endDate = DateTime.tryParse(end);
      if (startDate == null || endDate == null) return "Invalid date format";

      final formatter = DateFormat('dd-MM-yyyy');
      return "Active from ${formatter.format(startDate)} to ${formatter.format(endDate)}";
    } catch (e) {
      return "Error formatting dates";
    }
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  children: [
                    // -------------------------------
                    // USER NAME
                    // -------------------------------
                    Center(
                      child: Text(
                        userName.isNotEmpty ? userName : "User Name",
                        style: TextStyle(
                          fontFamily: Keys.fontFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // -------------------------------
                    // PROFILE INFO
                    // -------------------------------
                    _infoTile(
                      icon: Icons.phone,
                      color: Colors.indigo,
                      value: "+91 $mobileNumber",
                    ),
                    const SizedBox(height: 12),

                    _infoTile(
                      icon: Icons.email,
                      color: Colors.cyan,
                      value: email,
                    ),
                    const SizedBox(height: 12),

                    _infoTile(
                      icon: Icons.school,
                      color: Colors.green,
                      value: collegeName,
                    ),
                    const SizedBox(height: 12),

                    _infoTile(
                      icon: Icons.location_on,
                      color: Colors.orange,
                      value: "$city, $country",
                    ),
                    const SizedBox(height: 12),

                    _infoTile(
                      icon: Icons.calendar_today,
                      color: Colors.redAccent,
                      value: _formatDateRange(joinDate, endDate),
                    ),

                    const SizedBox(height: 24),

                    // -------------------------------
                    // NOTES
                    // -------------------------------
                    _noteCard(
                      "Your login is tagged to this device, and you cannot use this login in any other mobile phone. "
                      "If you need to change the mobile number or device, please raise a request through your trainer or manager.",
                    ),
                    const SizedBox(height: 12),
                    _noteCard(
                      "Your access validity is presented based on the data shared by the institution. "
                      "If you have any questions on your access validity, please contact your Lecturer or HOD.",
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
