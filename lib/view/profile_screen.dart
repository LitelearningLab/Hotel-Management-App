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

  String formatDateSafely(String dateStr) {
    if (dateStr.isEmpty) return "N/A";
    
    final trimmed = dateStr.trim();
    if (trimmed.isEmpty) return "N/A";

    if (trimmed.startsWith('Timestamp(')) {
      final match = RegExp(r'seconds=(\d+)').firstMatch(trimmed);
      if (match != null) {
        final seconds = int.tryParse(match.group(1) ?? '');
        if (seconds != null) {
          final dt = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
          return DateFormat('dd-MM-yyyy').format(dt);
        }
      }
    }

    DateTime? parsed = DateTime.tryParse(trimmed);
    if (parsed != null) {
      return DateFormat('dd-MM-yyyy').format(parsed);
    }

    List<String> formats = [
      'dd-MM-yyyy',
      'dd/MM/yyyy',
      'yyyy/MM/dd',
      'yyyy-MM-dd',
      'MM-dd-yyyy',
      'MM/dd/yyyy',
    ];

    for (String format in formats) {
      try {
        final dt = DateFormat(format).parseStrict(trimmed);
        return DateFormat('dd-MM-yyyy').format(dt);
      } catch (_) {}
    }

    return trimmed;
  }

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
                          color: Colors.black87,
                          fontSize: 25),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      height: getWidgetHeight(height: 50),
                      decoration: BoxDecoration(
                        // color: Color(0XFF314162),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0XFF5248fe),
                                child: Image.asset(
                                  "assets/images/mobile_profile.png",
                                  height: getWidgetHeight(height: 20),
                                  width: getWidgetWidth(width: 20),
                                ),
                              ),
                              SizedBox(width: getWidgetWidth(width: 4)),
                              Text(
                                "+91 $mobileNumber",
                                style: TextStyle(
                                    fontFamily: Keys.fontFamily,
                                    color: Colors.black87,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                SizedBox(height: getWidgetHeight(height: 3)),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 10)),
                  child: Container(
                      height: getWidgetHeight(height: 50),
                      decoration: BoxDecoration(
                        // color: Color(0XFF314162),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0XFF47bad0),
                                child: Image.asset(
                                  "assets/images/arroba_profile.png",
                                  height: getWidgetHeight(height: 15),
                                  width: getWidgetWidth(width: 15),
                                ),
                              ),
                              SizedBox(width: getWidgetWidth(width: 4)),
                              Expanded(
                                child: Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: Keys.fontFamily,
                                      color: Colors.black87,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                SizedBox(height: getWidgetHeight(height: 3)),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 10)),
                  child: Container(
                      height: getWidgetHeight(height: 50),
                      decoration: BoxDecoration(
                        // color: Color(0XFF314162),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0XFF47da6d),
                                child: Image.asset(
                                  "assets/images/hierarchical_profile.png",
                                  height: getWidgetHeight(height: 15),
                                  width: getWidgetWidth(width: 15),
                                ),
                              ),
                              SizedBox(
                                width: getWidgetWidth(width: 4),
                              ),
                              Expanded(
                                child: Text(
                                  collegeName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Keys.fontFamily,
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                SizedBox(height: getWidgetHeight(height: 3)),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 10)),
                  child: Container(
                      height: getWidgetHeight(height: 50),
                      decoration: BoxDecoration(
                        // color: Color(0XFF314162)
                        // ,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0XFFf5a716),
                                child: Image.asset(
                                  "assets/images/maps_flags_profile.png",
                                  height: getWidgetHeight(height: 15),
                                  width: getWidgetWidth(width: 15),
                                ),
                              ),
                              SizedBox(
                                width: getWidgetWidth(width: 4),
                              ),
                              Expanded(
                                child: Text(
                                  "${toBeginningOfSentenceCase(city) ?? ''}, ${toBeginningOfSentenceCase(country) ?? ''}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Keys.fontFamily,
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                SizedBox(height: getWidgetHeight(height: 3)),
                Container(
                  decoration: BoxDecoration(
                    // color: Color(0XFF314162)
                    // ,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 10)),
                  child: Container(
                    height: getWidgetHeight(height: 50),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0XFFf66b5c),
                          child: Image.asset(
                            "assets/images/calendar_profile.png",
                            height: getWidgetHeight(height: 15),
                            width: getWidgetWidth(width: 15),
                          ),
                        ),
                        SizedBox(
                          width: getWidgetWidth(width: 4),
                        ),
                        Expanded(
                          child: Text(
                            "Active from ${formatDateSafely(joinDate)} "
                            "to ${formatDateSafely(endDate)}",
                            maxLines: 2,
                            softWrap: true,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: Keys.fontFamily,
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
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
