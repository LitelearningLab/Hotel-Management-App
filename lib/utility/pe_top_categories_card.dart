import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';

class PETopCategoriesCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final Color cardColor;

  /// Optional — can be null (safe)
  final double? height;
  final double? width;

  final bool isUnderConstruction;

  const PETopCategoriesCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    required this.cardColor,
    this.height,
    this.width,
    this.isUnderConstruction = false,
  });

  @override
  State<PETopCategoriesCard> createState() => _PETopCategoriesCardState();
}

class _PETopCategoriesCardState extends State<PETopCategoriesCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cardHeight = widget.height ??
        (kIsWeb
            ? getWidgetHeight(height: 310)
            : getWidgetHeight(height: 150));

    final cardWidth = widget.width ?? size.width;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (kIsWeb) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (kIsWeb) setState(() => _hovered = false);
      },
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: widget.onTap,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: _hovered
                  ? (Matrix4.identity()..translate(0.0, -4.0))
                  : Matrix4.identity(),
              height: cardHeight,
              width: cardWidth,
              padding: const EdgeInsets.only(left: 12, top: 14),
              decoration: BoxDecoration(
                color: widget.cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        )
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize:
                          displayWidth(context) > 500 ? 20 : 16,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: widget.height ??
                          (displayWidth(context) > 1200 ? 120 : 90),
                      child: Image.asset(
                        widget.imageUrl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // UNDER REVIEW OVERLAY (UNCHANGED LOGIC)
            // ==================================================
            if (widget.isUnderConstruction)
              Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Under Review",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
