import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String searchTerm = "";

  final List<Map<String, dynamic>> demoData = [
    {
      "path":
          "Core Department > Front Office Management > Classification of Hotels",
      "types": ["eLearning", "Glossary"],
      "content": "Business Guest"
    },
    {
      "path": "Core Department > Front Office Management > Guest Cycle",
      "types": ["eLearning"],
      "content": "Business Guest"
    },
    {
      "path":
          "Core Department > Food & Beverage Service Management > Mise-en-place & Mise-en-scene",
      "types": ["eLearning", "Glossary", "Pronunciation Lab"],
      "content": "Mise-en-place"
    },
    {
      "path": "Language Lab > French Pronunciation > Food & Beverage Service",
      "types": ["List 6"],
      "content": "Mise-en-place"
    },
    {
      "path": "Core Department > Tourism Management > Adventure Tourism",
      "types": ["eLearning"],
      "content": "Adventure"
    },
  ];
  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: source, style: TextStyle(color: Colors.black))];
    }

    final matches = <TextSpan>[];
    final lcSource = source.toLowerCase();
    final lcQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lcSource.indexOf(lcQuery, start);
      if (index < 0) {
        matches.add(TextSpan(
            text: source.substring(start),
            style: const TextStyle(color: Colors.black)));
        break;
      }

      if (index > start) {
        matches.add(TextSpan(
            text: source.substring(start, index),
            style: const TextStyle(color: Colors.black)));
      }

      matches.add(TextSpan(
          text: source.substring(index, index + query.length),
          style: TextStyle(fontWeight: FontWeight.bold, color: linearColor)));

      start = index + query.length;
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = demoData
        .where((item) => item['content']
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          "Search",
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(vertical: getWidgetHeight(height: 8)),
          child: IconButton(
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      // backgroundColor: Color.fromARGB(255, 248, 248, 248),
      body: Column(
        children: [
          Divider(
            color: Color.fromARGB(255, 248, 248, 248),
          ),
          Container(
            color: Colors.white,
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              style: const TextStyle(color: Colors.black), // Black input text
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: InputBorder.none, // 🚫 No border
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false, // No filled decoration style
                isDense: true, // Optional: reduce height a bit
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 248, 248, 248),
          ),
          if (_controller.text.isNotEmpty)
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 12)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Search Results for: $searchTerm",
                    style: TextStyle(
                      fontSize: kText.scale(15),
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          Expanded(
            child: filteredResults.isEmpty
                ? const Center(child: Text("No results found"))

                // : _controller.text.isEmpty
                //     ? Center(
                //         child: Text("Search"),
                //       )
                : ListView.builder(
                    itemCount: filteredResults.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidgetHeight(height: 12)),
                    itemBuilder: (context, index) {
                      final item = filteredResults[index];
                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "in slide",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: kText.scale(14),
                                    fontWeight: FontWeight.w500),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: highlightOccurrences(
                                      item['content'], searchTerm),
                                ),
                              ),
                              Text(
                                item['path'],
                                style: TextStyle(
                                  fontSize: kText.scale(12),
                                  fontFamily: Keys.fontFamily,
                                ),
                              ),
                              SizedBox(height: getWidgetHeight(height: 6)),
                              Divider(
                                color: Color.fromARGB(255, 248, 248, 248),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
