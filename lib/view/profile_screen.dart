import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String userName = "";
  String mobileNumber = "";
  String city = "";
  String country = "";
  String collegeName = "";
  String joinDate = "";
  String endDate = "";
  String email = "";
  bool isLoading = false;

  getUserDetails() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("userName") ?? "";
    mobileNumber = prefs.getString("mobile") ?? "";
    email = prefs.getString("email") ?? "";
    city = prefs.getString("city") ?? "";
    country = prefs.getString("country") ?? "";
    collegeName = prefs.getString("collegeName") ?? "";
    joinDate = prefs.getString("joindate") ?? "";
    endDate = prefs.getString("enddate") ?? "";

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          "Profile", maxLines: 2,
          // textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : ListView(
              children: [
                Container(
                  height: getWidgetHeight(height: 100),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 20),
                      vertical: getWidgetHeight(height: 20)),
                  color: Colors.white,
                  child: Center(
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
                              SizedBox(width: getWidgetWidth(width: 15)),
                              Text(
                                " +91 $mobileNumber",
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
                              SizedBox(width: getWidgetWidth(width: 15)),
                              Text(
                                email,
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
                                backgroundColor: Color(0XFF47da6d),
                                child: Image.asset(
                                  "assets/images/hierarchical_profile.png",
                                  height: getWidgetHeight(height: 15),
                                  width: getWidgetWidth(width: 15),
                                ),
                              ),
                              SizedBox(width: getWidgetWidth(width: 15)),
                              Text(
                                collegeName,
                                style: TextStyle(
                                  fontFamily: Keys.fontFamily,
                                  color: Colors.black87,
                                  fontSize: 15,
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
                              SizedBox(width: getWidgetWidth(width: 15)),
                              Text(
                                "${toBeginningOfSentenceCase(city) ?? ''}, ${toBeginningOfSentenceCase(country) ?? ''}",
                                style: TextStyle(
                                  fontFamily: Keys.fontFamily,
                                  color: Colors.black87,
                                  fontSize: 15,
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              bottomRight: Radius.circular(7))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0XFFf66b5c),
                              child: Image.asset(
                                "assets/images/calendar_profile.png",
                                height: getWidgetHeight(height: 15),
                                width: getWidgetWidth(width: 15),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Active from $joinDate to  ",
                              style: TextStyle(
                                  fontFamily: Keys.fontFamily,
                                  color: Colors.black87,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(height: getWidgetHeight(height: 16)),
                Container(
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
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidgetWidth(width: 5),
                      vertical: getWidgetHeight(height: 5)),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7),
                          topLeft: Radius.circular(
                              7)), // Adjust the radius as needed
                    ),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        "Your login is tagged to this device, and you cannot use this login in any other mobile phone. If you need to change the mobile number or device, please raise a request through your trainer or manager.",
                        style: TextStyle(
                            fontFamily: Keys.fontFamily,
                            color: Colors.black87,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Container(
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
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(7),
                          bottomLeft: Radius.circular(
                              7)), // Adjust the radius as needed
                    ),
                    child: ListTile(
                      title: Text(
                        "Your access validity is presented based on the data shared by the institution. If you have any questions on your access validity, please contact your Lecturer or HOD.",
                        style: TextStyle(
                            fontFamily: Keys.fontFamily,
                            color: Colors.black87,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
