// ignore_for_file: deprecated_member_use, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

void main() {
  runApp(const GeoSketchApp());
}

/// Global ValueNotifiers to manage app state reactively and offline
final ValueNotifier<Set<String>> favoritesNotifier = ValueNotifier<Set<String>>({});
late final ValueNotifier<List<HousePlan>> housePlansNotifier;

/// Main Application Widget managing Theme Mode
class GeoSketchApp extends StatefulWidget {
  const GeoSketchApp({super.key});

  @override
  State<GeoSketchApp> createState() => _GeoSketchAppState();
}

class _GeoSketchAppState extends State<GeoSketchApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    // Initialize mutable plans list
    housePlansNotifier = ValueNotifier<List<HousePlan>>(List.from(initialHousePlans));
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo-Sketch Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF9F6), // Creamy blueprint paper
        primaryColor: const Color(0xFF0F2C59), // Blueprint Navy
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F2C59),
          brightness: Brightness.light,
          primary: const Color(0xFF0F2C59),
          secondary: const Color(0xFF1F618D),
          surface: const Color(0xFFFAF9F6),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Color(0xFF0F2C59)),
          titleMedium: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          bodyMedium: TextStyle(fontFamily: 'Courier', color: Color(0xFF2C3E50)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020813), // Deep Midnight Blueprint Blue
        primaryColor: const Color(0xFF00E5FF), // Glowing Cyan
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.dark,
          primary: const Color(0xFF00E5FF),
          secondary: const Color(0xFF1D2A44),
          surface: const Color(0xFF020813),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Color(0xFF00E5FF)),
          titleMedium: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Color(0xFFE0E6ED)),
          bodyMedium: TextStyle(fontFamily: 'Courier', color: Color(0xFFE0E6ED)),
        ),
      ),
      themeMode: _themeMode,
      home: BlueprintSplashScreen(onThemeToggle: toggleTheme),
    );
  }
}

// ==========================================
// 1. DATA MODEL & MOCK DATA
// ==========================================

enum VectorDraftType { fiveMarla, tenMarla, rendering3D }

class HousePlan {
  final String id;
  final String title;
  final String category; // '5 Marla Plans', '10 Marla Plans', '3D Exterior Renderings'
  final String description;
  final double areaSqFt;
  final String dimensions;
  final int bedrooms;
  final int bathrooms;
  final int floors;
  final String style;
  final String imageUrl;
  final VectorDraftType vectorDraftType;
  final double estimatedCostLakhs;
  final String draftsman;
  final List<String> spaceBreakdown;

  HousePlan({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.areaSqFt,
    required this.dimensions,
    required this.bedrooms,
    required this.bathrooms,
    required this.floors,
    required this.style,
    required this.imageUrl,
    required this.vectorDraftType,
    required this.estimatedCostLakhs,
    required this.draftsman,
    required this.spaceBreakdown,
  });
}

final List<HousePlan> initialHousePlans = [
  // 5 Marla Plans
  HousePlan(
    id: '5m_modern',
    title: '5 Marla Modern Double Story',
    category: '5 Marla Plans',
    description: 'A compact and highly efficient contemporary design optimized for urban living. Features an open-concept living area, double-height lobby, and premium finishes. Perfect for small families seeking modern style.',
    areaSqFt: 1125,
    dimensions: '25\' x 45\'',
    bedrooms: 3,
    bathrooms: 3,
    floors: 2,
    style: 'Modern',
    imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.fiveMarla,
    estimatedCostLakhs: 85.0,
    draftsman: 'Ar. Sarah Khan, Senior Architect',
    spaceBreakdown: [
      'Ground Floor: Car Porch, Small Lawn, Drawing Room, TV Lounge, Open Kitchen, Bed with Attached Bath, Back Ventilation Area.',
      'First Floor: 2 Bedrooms with attached Baths, Family Lobby, Front Terrace, Open Balcony.',
      'Rooftop: Mumty/Stair Tower, Open Roof Deck, Servant Quarter/Bath.'
    ],
  ),
  HousePlan(
    id: '5m_minimalist',
    title: '5 Marla Minimalist Townhouse',
    category: '5 Marla Plans',
    description: 'Clean straight lines, flat concrete planes, and functional spaces define this minimalist design. Uses natural light shafts to illuminate the interior spaces and create a feeling of spaciousness.',
    areaSqFt: 1125,
    dimensions: '25\' x 45\'',
    bedrooms: 3,
    bathrooms: 4,
    floors: 2,
    style: 'Minimalist',
    imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.fiveMarla,
    estimatedCostLakhs: 78.0,
    draftsman: 'Ar. Sarah Khan, Senior Architect',
    spaceBreakdown: [
      'Ground Floor: Single Car Porch, Drawing Room, Dining, Central Courtyard/Light Well, Kitchen, Toilet, Store Room.',
      'First Floor: Master Bed (Attached Bath/Dresser), Kid\'s Bed (Attached Bath), TV Lounge, Front Balcony.',
      'Rooftop: Utility Room, Open Roof.'
    ],
  ),
  HousePlan(
    id: '5m_smart',
    title: '5 Marla Compact Smart Home',
    category: '5 Marla Plans',
    description: 'A 3-story high-density modern layout designed to maximize vertical space. Features integrated smart home automation, built-in wardrobes, energy-efficient insulation, and a solar roof setup.',
    areaSqFt: 1500,
    dimensions: '25\' x 45\'',
    bedrooms: 4,
    bathrooms: 4,
    floors: 3,
    style: 'Hi-Tech Modern',
    imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.fiveMarla,
    estimatedCostLakhs: 105.0,
    draftsman: 'Ar. Daniyal Ahmed, Tech Lead',
    spaceBreakdown: [
      'Ground Floor: Car Porch, Sitting Area, Kitchen, Powder Room, Under-stairs Storage, Open Yard.',
      'First Floor: 2 Bedrooms with attached Baths, Central Study Alcove, Balcony.',
      'Second Floor: 2 Bedrooms, 2 Baths, Laundry Area, Mini Terrace.'
    ],
  ),
  HousePlan(
    id: '5m_contemporary',
    title: '5 Marla Contemporary Duplex',
    category: '5 Marla Plans',
    description: 'A clean and neat single-floor design ideal for retired couples or young professionals. Combines contemporary brick accents with grey rendering for an appealing and low-maintenance facade.',
    areaSqFt: 1125,
    dimensions: '25\' x 45\'',
    bedrooms: 2,
    bathrooms: 2,
    floors: 1,
    style: 'Contemporary',
    imageUrl: 'https://images.unsplash.com/photo-1613977257363-707ba9348227?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.fiveMarla,
    estimatedCostLakhs: 60.0,
    draftsman: 'Ar. Sarah Khan, Senior Architect',
    spaceBreakdown: [
      'Ground Floor: Porch, Small Lawn, Drawing Room, TV Lounge, Kitchen, 2 Bed Rooms with 2 attached Baths, Rear Yard.'
    ],
  ),

  // 10 Marla Plans
  HousePlan(
    id: '10m_spanish',
    title: '10 Marla Spanish Villa',
    category: '10 Marla Plans',
    description: 'Inspired by traditional Spanish Mediterranean architecture, this villa features red terracotta roof tiles, arches, stucco walls, and wrought iron balconies. Spacious interior layouts offer luxurious living.',
    areaSqFt: 2250,
    dimensions: '35\' x 65\'',
    bedrooms: 5,
    bathrooms: 6,
    floors: 2,
    style: 'Spanish',
    imageUrl: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.tenMarla,
    estimatedCostLakhs: 165.0,
    draftsman: 'Ar. Sarah Khan, Senior Architect',
    spaceBreakdown: [
      'Ground Floor: Double Car Porch, Green Lawn, Drawing Room with Bath, Dining Room, Spacious TV Lounge, Main Kitchen, Dirty Kitchen, Master Bed (Bath & Dresser), Open Back Passage.',
      'First Floor: 3 Bedrooms with Attached Baths and Dressers, Family Lounge, Kitchenette, Front Large Terrace, Study Room.',
      'Rooftop: 1 Servant Bedroom with Bath, Laundry Room, Open Roof Terrace.'
    ],
  ),
  HousePlan(
    id: '10m_classical',
    title: '10 Marla Classical Estate',
    category: '10 Marla Plans',
    description: 'A stately design featuring majestic classical Greek columns, symmetrical window designs, and ornate moldings. The interior focuses on grand spaces, double-height ceilings, and formal dining.',
    areaSqFt: 2250,
    dimensions: '35\' x 65\'',
    bedrooms: 4,
    bathrooms: 5,
    floors: 2,
    style: 'Classical',
    imageUrl: 'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.tenMarla,
    estimatedCostLakhs: 180.0,
    draftsman: 'Ar. Maria Bello, Design Director',
    spaceBreakdown: [
      'Ground Floor: Portico, Car Porch, Front Garden, Double-height Lobby with Curved Staircase, Formal Drawing Room, Dining, TV Lounge, Kitchen, Powder Room, Guest Bed (Attached Bath).',
      'First Floor: 3 Bedrooms with attached Baths (Master has Walk-in Closet and Jacuzzi), Study Room, Balcony facing lawn.'
    ],
  ),
  HousePlan(
    id: '10m_modern',
    title: '10 Marla Modern Executive',
    category: '10 Marla Plans',
    description: 'An architectural masterpiece featuring massive glass panels, sharp cubic geometries, and steel structures. Designed for executives with high-end requirements like home theaters, gyms, and home offices.',
    areaSqFt: 2400,
    dimensions: '35\' x 65\'',
    bedrooms: 6,
    bathrooms: 7,
    floors: 3,
    style: 'Modern',
    imageUrl: 'https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.tenMarla,
    estimatedCostLakhs: 210.0,
    draftsman: 'Ar. Daniyal Ahmed, Tech Lead',
    spaceBreakdown: [
      'Ground Floor: Double Car Porch, Lawn, Drawing Room, TV Lounge, Kitchen, Servant Quarter with Bath, Master Bed with Bath, Powder Room.',
      'First Floor: 3 Bedrooms with Attached Baths, Lounge, Gym/Office Room, Terrace.',
      'Second Floor: Home Theater/Media Room, Guest Room, Bath, Laundry, Open Roof Deck.'
    ],
  ),
  HousePlan(
    id: '10m_scandinavian',
    title: '10 Marla Scandinavian Duplex',
    category: '10 Marla Plans',
    description: 'Combines rustic brick textures with light wood highlights and white walls. Features huge floor-to-ceiling glass windows and open plan living, focusing on organic textures and cozy spaces.',
    areaSqFt: 2250,
    dimensions: '35\' x 65\'',
    bedrooms: 4,
    bathrooms: 4,
    floors: 2,
    style: 'Scandinavian',
    imageUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.tenMarla,
    estimatedCostLakhs: 155.0,
    draftsman: 'Ar. Maria Bello, Design Director',
    spaceBreakdown: [
      'Ground Floor: Car Porch, Front Yard, Double-height Entry, Drawing Room, Dining, Kitchen, Store Room, Bed Room (Attached Bath).',
      'First Floor: Master Bed Room, 2 Kids Bedrooms with Attached Baths, TV Lounge, Open Terrace, Rear Deck.'
    ],
  ),

  // 3D Exterior Renderings
  HousePlan(
    id: '3d_elev_a',
    title: 'Modern Elevation A - Wireframe',
    category: '3D Exterior Renderings',
    description: 'High-definition 3D visualization showing a modern facade option for a double-story house. Focuses on concrete finishes, wooden screen panels, and a sleek cantilevered structural slab.',
    areaSqFt: 2250,
    dimensions: '35\' x 65\'',
    bedrooms: 5,
    bathrooms: 5,
    floors: 2,
    style: 'Modern',
    imageUrl: 'https://images.unsplash.com/photo-1602941525421-8f8b81d3edbb?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.rendering3D,
    estimatedCostLakhs: 175.0,
    draftsman: 'Ar. Daniyal Ahmed, Tech Lead',
    spaceBreakdown: [
      '3D Isometric Facade Wireframe showing structural slabs, glass partitions, concrete pillars, and wooden screens.',
      'Includes accurate level markers (+0.45m Plinth, +3.0m First Floor Slab, +6.5m Roof Slab).',
      'Cantilever slab extends 2.4m out to shade the car porch below.'
    ],
  ),
  HousePlan(
    id: '3d_elev_b',
    title: 'Spanish Elevation B - Render',
    category: '3D Exterior Renderings',
    description: '3D architectural visualization of a Spanish Mediterranean villa facade. Shows terracotta roof styling, arched windows, and beautiful decorative stucco columns with outdoor garden lighting.',
    areaSqFt: 2250,
    dimensions: '35\' x 65\'',
    bedrooms: 5,
    bathrooms: 6,
    floors: 2,
    style: 'Spanish',
    imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.rendering3D,
    estimatedCostLakhs: 190.0,
    draftsman: 'Ar. Sarah Khan, Senior Architect',
    spaceBreakdown: [
      '3D Exterior Rendering highlighting decorative stucco moldings, Spanish round arches, and natural terracotta color palettes.',
      'Symmetrical structural pillars define the front portico.',
      'Balcony uses wrought-iron safety grills with decorative scrolls.'
    ],
  ),
  HousePlan(
    id: '3d_eco_green',
    title: 'Eco-Green Residence - Facade',
    category: '3D Exterior Renderings',
    description: 'A 3D model of a sustainable, eco-friendly house. Showcases solar-panel roof integrations, green vertical gardens on walls, and local stone facade detailing.',
    areaSqFt: 1125,
    dimensions: '25\' x 45\'',
    bedrooms: 3,
    bathrooms: 3,
    floors: 2,
    style: 'Eco-Friendly',
    imageUrl: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.rendering3D,
    estimatedCostLakhs: 95.0,
    draftsman: 'Ar. Daniyal Ahmed, Tech Lead',
    spaceBreakdown: [
      '3D facade wireframe showing green wall planting modules, integrated rain harvesting pipes, and solar panel arrays.',
      'Ventilation shafts detailed in the middle of the structure for passive cooling.',
      'Recycled local timber screens on the first-floor balcony.'
    ],
  ),
  HousePlan(
    id: '3d_brutalist',
    title: 'Brutalist Concrete Villa - 3D',
    category: '3D Exterior Renderings',
    description: 'Raw concrete finishes, large cantilevers, and bold architectural blocks form the visual identity of this Brutalist concept. Features open courtyards and modular windows.',
    areaSqFt: 2500,
    dimensions: '40\' x 60\'',
    bedrooms: 4,
    bathrooms: 5,
    floors: 2,
    style: 'Brutalist',
    imageUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1200&q=80',
    vectorDraftType: VectorDraftType.rendering3D,
    estimatedCostLakhs: 185.0,
    draftsman: 'Ar. Maria Bello, Design Director',
    spaceBreakdown: [
      '3D Facade layout showing exposed raw formwork board-marked concrete patterns.',
      'Recessed windows to prevent direct solar glare in harsh summers.',
      'Spacious double-volume internal heights visible from front structural glass walls.'
    ],
  ),
];

// ==========================================
// 2. BLUEPRINT GRID & COMPASS PAINTERS
// ==========================================

class GridBackgroundPainter extends CustomPainter {
  final Color lineColor;
  final double gridSpacing;

  GridBackgroundPainter({required this.lineColor, this.gridSpacing = 24.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withOpacity(0.06)
      ..strokeWidth = 0.5;

    final majorPaint = Paint()
      ..color = lineColor.withOpacity(0.14)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += gridSpacing) {
      final isMajor = (x ~/ gridSpacing) % 5 == 0;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), isMajor ? majorPaint : paint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      final isMajor = (y ~/ gridSpacing) % 5 == 0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), isMajor ? majorPaint : paint);
    }

    final borderMargin = 16.0;
    if (size.width > borderMargin * 2 && size.height > borderMargin * 2) {
      final borderPaint = Paint()
        ..color = lineColor.withOpacity(0.25)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawRect(
        Rect.fromLTRB(borderMargin, borderMargin, size.width - borderMargin, size.height - borderMargin),
        borderPaint,
      );

      if (size.width > 200 && size.height > 200) {
        final textPainter = TextPainter(textDirection: TextDirection.ltr);
        final textStyle = TextStyle(
          color: lineColor.withOpacity(0.4),
          fontSize: 8.0,
          fontFamily: 'Courier',
          fontWeight: FontWeight.bold,
        );

        double idx = 0;
        for (double x = borderMargin + gridSpacing * 2; x < size.width - borderMargin - 20; x += gridSpacing * 4) {
          final label = String.fromCharCode(65 + (idx.toInt() % 26));
          textPainter.text = TextSpan(text: label, style: textStyle);
          textPainter.layout();
          textPainter.paint(canvas, Offset(x, borderMargin + 2));
          textPainter.paint(canvas, Offset(x, size.height - borderMargin - 10));
          idx++;
        }

        idx = 1;
        for (double y = borderMargin + gridSpacing * 2; y < size.height - borderMargin - 20; y += gridSpacing * 4) {
          final label = idx.toInt().toString();
          textPainter.text = TextSpan(text: label, style: textStyle);
          textPainter.layout();
          textPainter.paint(canvas, Offset(borderMargin + 2, y));
          textPainter.paint(canvas, Offset(size.width - borderMargin - 12, y));
          idx++;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridBackgroundPainter oldDelegate) => false;
}

class SplashDraftingPainter extends CustomPainter {
  final double angle;
  final double progress;
  final Color lineColor;

  SplashDraftingPainter({
    required this.angle,
    required this.progress,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);

    final compassPaint = Paint()
      ..color = lineColor.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = lineColor.withOpacity(0.15)
      ..strokeWidth = 1.0;

    final drawPaint = Paint()
      ..color = lineColor.withOpacity(0.7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final maxRadius = size.width * 0.35;
    if (maxRadius <= 0) return;

    if (progress > 0) {
      canvas.drawCircle(center, maxRadius * progress, circlePaint..style = PaintingStyle.stroke);
      canvas.drawCircle(center, maxRadius * 0.7 * progress, circlePaint..style = PaintingStyle.stroke);
    }

    if (progress > 0.4) {
      final linesPaint = Paint()
        ..color = lineColor.withOpacity(0.1)
        ..strokeWidth = 0.5;
      for (int i = 0; i < 360; i += 15) {
        final rad = i * math.pi / 180;
        final start = Offset(cx + math.cos(rad) * maxRadius * 0.5 * progress, cy + math.sin(rad) * maxRadius * 0.5 * progress);
        final end = Offset(cx + math.cos(rad) * maxRadius * progress, cy + math.sin(rad) * maxRadius * progress);
        canvas.drawLine(start, end, linesPaint);
      }
    }

    if (progress > 0.2) {
      final rectPath = Path()
        ..addRect(Rect.fromCenter(center: center, width: maxRadius * 1.5 * progress, height: maxRadius * 0.9 * progress));
      canvas.drawPath(rectPath, compassPaint);
      
      canvas.drawLine(Offset(cx - maxRadius * 1.1, cy), Offset(cx + maxRadius * 1.1, cy), circlePaint);
      canvas.drawLine(Offset(cx, cy - maxRadius * 1.1), Offset(cx, cy + maxRadius * 1.1), circlePaint);
    }

    final compassRadius = maxRadius * 0.8;
    final tipX = cx + math.cos(angle) * compassRadius;
    final tipY = cy + math.sin(angle) * compassRadius;
    final tip = Offset(tipX, tipY);

    if (progress > 0.5) {
      final arcRect = Rect.fromCircle(center: center, radius: compassRadius);
      canvas.drawArc(
        arcRect,
        -math.pi / 4,
        angle + math.pi / 4,
        false,
        drawPaint,
      );
    }

    final hinge = Offset(cx - 30 * math.sin(angle * 0.1), cy - 180);
    canvas.drawLine(hinge, center, compassPaint..strokeWidth = 3.0);
    canvas.drawLine(hinge, tip, compassPaint..strokeWidth = 3.0);
    canvas.drawCircle(hinge, 8.0, compassPaint..style = PaintingStyle.fill);
    canvas.drawCircle(tip, 3.0, drawPaint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant SplashDraftingPainter oldDelegate) =>
      oldDelegate.angle != angle || oldDelegate.progress != progress;
}

// ==========================================
// 3. ARCHITECTURAL VECTOR DRAFT PAINTER
// ==========================================

class ArchitecturalPainter extends CustomPainter {
  final VectorDraftType type;
  final String planId;
  final String style;
  final Color lineColor;

  ArchitecturalPainter({
    required this.type,
    required this.planId,
    required this.style,
    required this.lineColor,
  });

  Offset project3D(double x, double y, double z, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.65;
    final scale = size.width * 0.35;
    
    final cos30 = math.cos(30 * math.pi / 180);
    final sin30 = math.sin(30 * math.pi / 180);
    
    final px = cx + (x * cos30 - y * cos30) * scale;
    final py = cy + (x * sin30 + y * sin30) * scale - z * scale;
    
    return Offset(px, py);
  }

  Offset normalizeOffset(Offset offset) {
    final distance = offset.distance;
    if (distance == 0) return Offset.zero;
    return Offset(offset.dx / distance, offset.dy / distance);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final wallPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final thinPaint = Paint()
      ..color = lineColor.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashedPaint = Paint()
      ..color = lineColor.withOpacity(0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final doorPaint = Paint()
      ..color = lineColor.withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    void drawRoom(String name, String dims, double x1, double y1, double x2, double y2) {
      final rect = Rect.fromLTRB(
        x1 * size.width / 100,
        y1 * size.height / 100,
        x2 * size.width / 100,
        y2 * size.height / 100,
      );
      canvas.drawRect(rect, wallPaint);
      canvas.drawRect(rect.deflate(2.0), thinPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: '$name\n$dims',
          style: TextStyle(
            color: lineColor,
            fontSize: size.width > 200 ? 9.5 : 7.0,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(rect.center.dx - tp.width / 2, rect.center.dy - tp.height / 2));
    }

    void drawDoor(double hx, double hy, double ox, double oy, bool clockwise) {
      final h = Offset(hx * size.width / 100, hy * size.height / 100);
      final o = Offset(ox * size.width / 100, oy * size.height / 100);
      canvas.drawLine(h, o, doorPaint);
      final radius = (o - h).distance;
      final rect = Rect.fromCircle(center: h, radius: radius);
      final startAngle = math.atan2(o.dy - h.dy, o.dx - h.dx);
      final sweepAngle = clockwise ? math.pi / 2 : -math.pi / 2;
      canvas.drawArc(rect, startAngle, sweepAngle, false, doorPaint);
    }

    void drawWindow(double x1, double y1, double x2, double y2) {
      final start = Offset(x1 * size.width / 100, y1 * size.height / 100);
      final end = Offset(x2 * size.width / 100, y2 * size.height / 100);
      
      canvas.drawLine(start, end, thinPaint);
      final direction = end - start;
      final dist = direction.distance;
      if (dist > 0) {
        final normal = Offset(-direction.dy / dist, direction.dx / dist) * 2.5;
        canvas.drawLine(start + normal, end + normal, thinPaint);
        canvas.drawLine(start - normal, end - normal, thinPaint);
      }
    }

    void drawDashedLine(double x1, double y1, double x2, double y2) {
      final start = Offset(x1 * size.width / 100, y1 * size.height / 100);
      final end = Offset(x2 * size.width / 100, y2 * size.height / 100);
      final direction = end - start;
      final dist = direction.distance;
      if (dist == 0) return;
      final steps = (dist / 6.0).floor();
      final stepOffset = direction / math.max(1, steps).toDouble();
      
      for (int i = 0; i < steps; i += 2) {
        canvas.drawLine(start + stepOffset * i.toDouble(), start + stepOffset * (i + 1).toDouble(), dashedPaint);
      }
    }

    void drawStairs(double x1, double y1, double x2, double y2, int numSteps) {
      final start = Offset(x1 * size.width / 100, y1 * size.height / 100);
      final end = Offset(x2 * size.width / 100, y2 * size.height / 100);
      
      final diff = end - start;
      final dist = diff.distance;
      if (dist == 0) return;
      
      final stepVec = diff / numSteps.toDouble();
      final norm = Offset(-diff.dy / dist, diff.dx / dist) * (size.width * 0.08);
      
      canvas.drawLine(start, end, thinPaint);
      canvas.drawLine(start + norm, end + norm, thinPaint);
      
      for (int i = 0; i <= numSteps; i++) {
        final stepPos = start + stepVec * i.toDouble();
        canvas.drawLine(stepPos, stepPos + norm, thinPaint);
      }
      
      final arrowStart = start + norm * 0.5;
      final arrowEnd = end + norm * 0.5;
      canvas.drawLine(arrowStart, arrowEnd, thinPaint);
      
      final tp = TextPainter(
        text: TextSpan(
          text: 'UP',
          style: TextStyle(color: lineColor, fontSize: 8.0, fontFamily: 'monospace', fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(arrowStart.dx + 2, arrowStart.dy - 10));
    }

    if (type == VectorDraftType.fiveMarla) {
      canvas.drawRect(Rect.fromLTRB(10 * size.width / 100, 10 * size.height / 100, 90 * size.width / 100, 90 * size.height / 100), thinPaint);
      
      drawRoom('DRAWING\nROOM', '10\'x12\'', 12, 12, 50, 38);
      drawRoom('TV LOUNGE', '14\'x18\'', 12, 38, 88, 62);
      drawRoom('BEDROOM', '12\'x14\'', 12, 62, 55, 88);
      drawRoom('KITCHEN', '8\'x10\'', 55, 62, 88, 88);
      drawRoom('BATH', '6\'x8\'', 12, 74, 32, 88); 

      drawDashedLine(10, 10, 90, 10);
      drawDashedLine(50, 12, 88, 38);
      canvas.drawCircle(Offset(88 * size.width / 100, 38 * size.height / 100), 4.0, wallPaint..style = PaintingStyle.fill);

      drawWindow(20, 12, 40, 12);
      drawWindow(20, 88, 30, 88);
      drawWindow(40, 88, 50, 88);
      drawWindow(70, 88, 80, 88);
      drawWindow(88, 45, 88, 55);

      drawDoor(50, 20, 45, 20, false);
      drawDoor(35, 38, 35, 43, true);
      drawDoor(12, 65, 17, 65, false);
      drawDoor(32, 76, 32, 81, true);
      drawDoor(55, 70, 60, 70, true);
      
      drawStairs(15, 42, 15, 58, 8);
      drawDashedLine(8, 12, 8, 88);
      drawDashedLine(12, 92, 88, 92);

    } else if (type == VectorDraftType.tenMarla) {
      canvas.drawRect(Rect.fromLTRB(5 * size.width / 100, 5 * size.height / 100, 95 * size.width / 100, 95 * size.height / 100), thinPaint);
      drawDashedLine(5, 5, 95, 5);
      
      drawRoom('DRAWING', '12\'x16\'', 8, 8, 45, 30);
      drawRoom('DINING', '10\'x12\'', 8, 30, 45, 48);
      drawRoom('KITCHEN', '10\'x14\'', 70, 30, 92, 52);
      drawRoom('TV LOUNGE', '20\'x22\'', 8, 48, 70, 72);
      drawRoom('M. BEDROOM', '14\'x16\'', 8, 72, 50, 92);
      drawRoom('BEDROOM 2', '12\'x14\'', 50, 72, 92, 92);
      drawRoom('M. BATH', '8\'x10\'', 8, 82, 28, 92);
      drawRoom('BATH 2', '8\'x8\'', 76, 82, 92, 92);

      drawDashedLine(45, 8, 92, 30);
      canvas.drawCircle(Offset(45 * size.width / 100, 30 * size.height / 100), 5.0, wallPaint..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(92 * size.width / 100, 30 * size.height / 100), 5.0, wallPaint..style = PaintingStyle.fill);

      drawWindow(15, 8, 30, 8);
      drawWindow(15, 92, 25, 92);
      drawWindow(35, 92, 45, 92);
      drawWindow(60, 92, 70, 92);
      drawWindow(82, 92, 88, 92);
      drawWindow(92, 38, 92, 46);

      drawDoor(45, 15, 40, 15, false);
      drawDoor(45, 36, 45, 41, true);
      drawDoor(70, 40, 65, 40, false);
      drawDoor(8, 75, 13, 75, false);
      drawDoor(28, 85, 28, 89, true);
      drawDoor(50, 75, 55, 75, true);
      drawDoor(76, 85, 76, 89, false);

      drawStairs(52, 48, 68, 48, 8);

    } else if (type == VectorDraftType.rendering3D) {
      Offset project(double x, double y, double z) {
        return project3D(x, y, z, size);
      }

      final isDark = lineColor.computeLuminance() > 0.5;

      void drawQuad(double x1, double y1, double z1,
                    double x2, double y2, double z2,
                    double x3, double y3, double z3,
                    double x4, double y4, double z4,
                    Color fillCol, {bool stroke = true}) {
        final path = Path()
          ..moveTo(project(x1, y1, z1).dx, project(x1, y1, z1).dy)
          ..lineTo(project(x2, y2, z2).dx, project(x2, y2, z2).dy)
          ..lineTo(project(x3, y3, z3).dx, project(x3, y3, z3).dy)
          ..lineTo(project(x4, y4, z4).dx, project(x4, y4, z4).dy)
          ..close();
        canvas.drawPath(path, Paint()..style = PaintingStyle.fill..color = fillCol);
        if (stroke) {
          canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..color = lineColor.withOpacity(0.35)..strokeWidth = 0.8);
        }
      }

      void drawTri(double x1, double y1, double z1,
                   double x2, double y2, double z2,
                   double x3, double y3, double z3,
                   Color fillCol, {bool stroke = true}) {
        final path = Path()
          ..moveTo(project(x1, y1, z1).dx, project(x1, y1, z1).dy)
          ..lineTo(project(x2, y2, z2).dx, project(x2, y2, z2).dy)
          ..lineTo(project(x3, y3, z3).dx, project(x3, y3, z3).dy)
          ..close();
        canvas.drawPath(path, Paint()..style = PaintingStyle.fill..color = fillCol);
        if (stroke) {
          canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..color = lineColor.withOpacity(0.35)..strokeWidth = 0.8);
        }
      }

      final gridPaint = Paint()
        ..color = lineColor.withOpacity(0.08)
        ..strokeWidth = 0.5;
      
      for (double i = -1.5; i <= 1.5; i += 0.3) {
        canvas.drawLine(project(i, -1.5, 0), project(i, 1.5, 0), gridPaint);
        canvas.drawLine(project(-1.5, i, 0), project(1.5, i, 0), gridPaint);
      }

      if (style.toLowerCase().contains('modern') || style.toLowerCase().contains('hi-tech')) {
        // ------------------------------------------
        // 1. MODERN STYLE FACADE (Slate, Wood, Glass)
        // ------------------------------------------
        // Base Lawn
        drawQuad(-1.3, -1.3, 0.0,  1.3, -1.3, 0.0,  1.3, 1.3, 0.0, -1.3, 1.3, 0.0, const Color(0xFF2ECC71).withOpacity(0.18));

        // Ground Floor Structure (Slate Grey Concrete)
        final greyCol = isDark ? const Color(0xFF1E2E3F) : const Color(0xFFBDC3C7);
        drawQuad(-0.8, -0.6, 0.0,  0.8, -0.6, 0.0,  0.8, -0.6, 0.45, -0.8, -0.6, 0.45, greyCol); // Front
        drawQuad(0.8, -0.6, 0.0,  0.8, 0.6, 0.0,  0.8, 0.6, 0.45,  0.8, -0.6, 0.45, greyCol.withOpacity(0.85)); // Side

        // Ground Floor Glass Openings
        final glassCol = const Color(0xFF00E5FF).withOpacity(0.25);
        drawQuad(-0.6, -0.61, 0.08, -0.1, -0.61, 0.08, -0.1, -0.61, 0.38, -0.6, -0.61, 0.38, glassCol); // Window L
        drawQuad(0.1, -0.61, 0.08,  0.6, -0.61, 0.08,  0.6, -0.61, 0.38,  0.1, -0.61, 0.38, glassCol); // Window R
        
        // Front Entrance Door (Warm Walnut Wood)
        final woodCol = const Color(0xFF5D4037);
        drawQuad(-0.08, -0.61, 0.0,  0.08, -0.61, 0.0,  0.08, -0.61, 0.38, -0.08, -0.61, 0.38, woodCol);

        // Ground Floor Ceiling / First Floor Slab (White Cantilever Slab)
        final slabCol = isDark ? const Color(0xFFECEFF1) : Colors.white;
        drawQuad(-0.9, -0.8, 0.45,  0.9, -0.8, 0.45,  0.9, 0.8, 0.45, -0.9, 0.8, 0.45, slabCol);

        // First Floor Structure (Warm Cedar Wood cladding)
        final cedarCol = isDark ? const Color(0xFF795548) : const Color(0xFFE0F7FA);
        drawQuad(-0.7, -0.5, 0.45,  0.7, -0.5, 0.45,  0.7, -0.5, 0.9, -0.7, -0.5, 0.9, cedarCol); // Front
        drawQuad(0.7, -0.5, 0.45,  0.7, 0.5, 0.45,  0.7, 0.5, 0.9,  0.7, -0.5, 0.9, cedarCol.withOpacity(0.85)); // Side

        // First Floor Glass Balustrade
        drawQuad(-0.6, -0.51, 0.52,  0.6, -0.51, 0.52,  0.6, -0.51, 0.72, -0.6, -0.51, 0.72, glassCol);

        // Roof Slab
        drawQuad(-0.8, -0.6, 0.9,  0.8, -0.6, 0.9,  0.8, 0.6, 0.9, -0.8, 0.6, 0.9, slabCol);

        // Architectural Level Markers
        final cp101 = project(0.9, -0.8, 0.45);
        final leaderPaint = Paint()..color = lineColor..strokeWidth = 0.8;
        final textPos = Offset(cp101.dx + 40, cp101.dy - 30);
        canvas.drawLine(cp101, Offset(cp101.dx + 20, cp101.dy - 15), leaderPaint);
        canvas.drawLine(Offset(cp101.dx + 20, cp101.dy - 15), textPos, leaderPaint);
        
        final tp = TextPainter(
          text: TextSpan(
            text: '2.4m CANTILEVER SLAB\nEL: +6.50m',
            style: TextStyle(color: lineColor, fontSize: 8.5, fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(textPos.dx + 4, textPos.dy - 8));

      } else if (style.toLowerCase().contains('spanish')) {
        // ------------------------------------------
        // 2. SPANISH MEDITERRANEAN VILLA (Arch, Tile)
        // ------------------------------------------
        // Base Lawn
        drawQuad(-1.3, -1.3, 0.0,  1.3, -1.3, 0.0,  1.3, 1.3, 0.0, -1.3, 1.3, 0.0, const Color(0xFF27AE60).withOpacity(0.16));

        // Soft Cream Stucco Walls
        final creamCol = isDark ? const Color(0xFFFDFEFE) : const Color(0xFFF4F6F7);
        drawQuad(-0.8, -0.6, 0.0,  0.8, -0.6, 0.0,  0.8, -0.6, 0.85, -0.8, -0.6, 0.85, creamCol); // Front
        drawQuad(0.8, -0.6, 0.0,  0.8, 0.6, 0.0,  0.8, 0.6, 0.85,  0.8, -0.6, 0.85, creamCol.withOpacity(0.92)); // Side

        // Ground Floor Spanish Arches (Doorway)
        final archCol = const Color(0xFF2C3E50);
        drawQuad(-0.16, -0.61, 0.0,  0.16, -0.61, 0.0,  0.16, -0.61, 0.5, -0.16, -0.61, 0.5, archCol);
        final archTop = project(0.0, -0.61, 0.5);
        canvas.drawCircle(archTop, size.width * 0.045, Paint()..color = archCol);

        // Symmetrical Arched Windows
        drawQuad(-0.55, -0.61, 0.2, -0.38, -0.61, 0.2, -0.38, -0.61, 0.58, -0.55, -0.61, 0.58, const Color(0xFF5D4037).withOpacity(0.4));
        drawQuad(0.38, -0.61, 0.2,  0.55, -0.61, 0.2,  0.55, -0.61, 0.58,  0.38, -0.61, 0.58, const Color(0xFF5D4037).withOpacity(0.4));

        // Red Slanted Terracotta Tile Roof
        final roofCol = isDark ? const Color(0xFFC0392B) : const Color(0xFFD35400);
        drawQuad(-0.9, -0.7, 0.85,  0.9, -0.7, 0.85,  0.9, 0.7, 0.85, -0.9, 0.7, 0.85, creamCol); // Base slab
        
        // Draw slanted roofs meeting at peak (0.0, 0.0, 1.2)
        drawTri(-0.9, -0.7, 0.85,  0.9, -0.7, 0.85,  0.0, 0.0, 1.2, roofCol); // Front
        drawTri(0.9, -0.7, 0.85,   0.9, 0.7, 0.85,   0.0, 0.0, 1.2, roofCol.withOpacity(0.85)); // Right Side
        
        // Fine tile strip detailing
        final pPeak = project(0.0, 0.0, 1.2);
        final tilePaint = Paint()..color = Colors.black.withOpacity(0.12)..strokeWidth = 1.0;
        for (double f = -0.8; f <= 0.8; f += 0.2) {
          final pBase = project(f, -0.7, 0.85);
          canvas.drawLine(pPeak, pBase, tilePaint);
        }

        final cp101 = project(0.9, -0.7, 0.85);
        final leaderPaint = Paint()..color = lineColor..strokeWidth = 0.8;
        final textPos = Offset(cp101.dx + 40, cp101.dy - 30);
        canvas.drawLine(cp101, Offset(cp101.dx + 20, cp101.dy - 15), leaderPaint);
        canvas.drawLine(Offset(cp101.dx + 20, cp101.dy - 15), textPos, leaderPaint);
        
        final tp = TextPainter(
          text: TextSpan(
            text: 'TERRACOTTA ROOF\nEL: +8.20m',
            style: TextStyle(color: lineColor, fontSize: 8.5, fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(textPos.dx + 4, textPos.dy - 8));

      } else if (style.toLowerCase().contains('eco') || style.toLowerCase().contains('green')) {
        // ------------------------------------------
        // 3. ECO-GREEN / SCANDINAVIAN (Wood, Solar)
        // ------------------------------------------
        // Base Lawn
        drawQuad(-1.3, -1.3, 0.0,  1.3, -1.3, 0.0,  1.3, 1.3, 0.0, -1.3, 1.3, 0.0, const Color(0xFF2ECC71).withOpacity(0.25));

        // Light Pine Wood Slabs
        final pineCol = const Color(0xFFFAD7A0);
        drawQuad(-0.8, -0.6, 0.0,  0.8, -0.6, 0.0,  0.8, -0.6, 0.8, -0.8, -0.6, 0.8, pineCol); // Front
        drawQuad(0.8, -0.6, 0.0,  0.8, 0.6, 0.0,  0.8, 0.6, 0.8,  0.8, -0.6, 0.8, pineCol.withOpacity(0.9)); // Side

        // Vertical Green Planting Panel
        final greenCol = const Color(0xFF27AE60);
        drawQuad(-0.7, -0.61, 0.1, -0.2, -0.61, 0.1, -0.2, -0.61, 0.7, -0.7, -0.61, 0.7, greenCol);

        // Big Glazed Glass panels (Blue)
        drawQuad(0.1, -0.61, 0.15, 0.65, -0.61, 0.15, 0.65, -0.61, 0.65, 0.1, -0.61, 0.65, const Color(0xFF00E5FF).withOpacity(0.2));

        // Slanted Eco Solar Roof (Deep slate blue)
        final solarCol = const Color(0xFF212F3D);
        drawQuad(-0.9, -0.7, 0.8,  0.9, -0.7, 0.8,  0.9, 0.7, 0.8, -0.9, 0.7, 0.8, pineCol); // Base
        drawQuad(-0.85, -0.5, 0.8, 0.85, -0.5, 0.8, 0.85, 0.5, 1.0, -0.85, 0.5, 1.0, solarCol); // Solar panel slab

        // Grid lines on Solar array
        final gridPaintSolar = Paint()..color = Colors.cyan.withOpacity(0.35)..strokeWidth = 0.6;
        for (double x = -0.6; x <= 0.6; x += 0.25) {
          canvas.drawLine(project(x, -0.5, 0.8), project(x, 0.5, 1.0), gridPaintSolar);
        }
        for (double y = -0.3; y <= 0.3; y += 0.3) {
          canvas.drawLine(project(-0.85, y, 0.8 + (y+0.5)*0.2), project(0.85, y, 0.8 + (y+0.5)*0.2), gridPaintSolar);
        }

        final cp101 = project(0.85, 0.5, 1.0);
        final leaderPaint = Paint()..color = lineColor..strokeWidth = 0.8;
        final textPos = Offset(cp101.dx + 40, cp101.dy - 30);
        canvas.drawLine(cp101, Offset(cp101.dx + 20, cp101.dy - 15), leaderPaint);
        canvas.drawLine(Offset(cp101.dx + 20, cp101.dy - 15), textPos, leaderPaint);
        
        final tp = TextPainter(
          text: TextSpan(
            text: 'SOLAR PANEL ARRAY\nEL: +7.20m',
            style: TextStyle(color: lineColor, fontSize: 8.5, fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(textPos.dx + 4, textPos.dy - 8));

      } else {
        // ------------------------------------------
        // 4. BRUTALIST CONCRETE / DEFAULT (Exposed Concrete Blocks)
        // ------------------------------------------
        // Base Lawn
        drawQuad(-1.3, -1.3, 0.0,  1.3, -1.3, 0.0,  1.3, 1.3, 0.0, -1.3, 1.3, 0.0, const Color(0xFF95A5A6).withOpacity(0.12));

        // Heavy concrete base walls (Raw cement grey)
        final concCol = isDark ? const Color(0xFF566573) : const Color(0xFFBDC3C7);
        drawQuad(-0.8, -0.6, 0.0,  0.8, -0.6, 0.0,  0.8, -0.6, 0.45, -0.8, -0.6, 0.45, concCol); // Front
        drawQuad(0.8, -0.6, 0.0,  0.8, 0.6, 0.0,  0.8, 0.6, 0.45,  0.8, -0.6, 0.45, concCol.withOpacity(0.85)); // Side

        // Heavy middle slab (White concrete)
        final slabCol = isDark ? const Color(0xFFECEFF1) : Colors.white;
        drawQuad(-0.9, -0.7, 0.45,  0.9, -0.7, 0.45,  0.9, 0.7, 0.45, -0.9, 0.7, 0.45, slabCol);

        // First Floor cantilevered block (Extends forward)
        drawQuad(-0.6, -0.8, 0.45, 0.6, -0.8, 0.45, 0.6, -0.8, 0.9, -0.6, -0.8, 0.9, concCol.withOpacity(0.9)); // Front
        drawQuad(0.6, -0.8, 0.45, 0.6, 0.4, 0.45,  0.6, 0.4, 0.9,  0.6, -0.8, 0.9, concCol); // Side

        // Deep recessed windows (Black void)
        drawQuad(-0.35, -0.81, 0.55, 0.35, -0.81, 0.55, 0.35, -0.81, 0.8, -0.35, -0.81, 0.8, const Color(0xFF111111));

        final cp101 = project(0.6, -0.8, 0.9);
        final leaderPaint = Paint()..color = lineColor..strokeWidth = 0.8;
        final textPos = Offset(cp101.dx + 40, cp101.dy - 30);
        canvas.drawLine(cp101, Offset(cp101.dx + 20, cp101.dy - 15), leaderPaint);
        canvas.drawLine(Offset(cp101.dx + 20, cp101.dy - 15), textPos, leaderPaint);
        
        final tp = TextPainter(
          text: TextSpan(
            text: 'RAW BRUTALIST CONCRETE\nEL: +6.80m',
            style: TextStyle(color: lineColor, fontSize: 8.5, fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(textPos.dx + 4, textPos.dy - 8));
      }
    }
  }

  @override
  bool shouldRepaint(covariant ArchitecturalPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.lineColor != lineColor;
  }
}

// ==========================================
// 4. OFFLINE / ONLINE FALLBACK IMAGE WIDGET
// ==========================================

class BlueprintImage extends StatelessWidget {
  final HousePlan plan;
  final bool forceVector;
  final bool showOfflineBadge;

  const BlueprintImage({
    super.key,
    required this.plan,
    this.forceVector = false,
    this.showOfflineBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? const Color(0xFF00E5FF) : const Color(0xFF0F2C59);
    final paperColor = isDark ? const Color(0xFF0A1128) : const Color(0xFFFAF9F6);

    if (forceVector) {
      return Container(
        color: paperColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GridBackgroundPainter(lineColor: lineColor),
              ),
            ),
            Center(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: ArchitecturalPainter(
                      type: plan.vectorDraftType,
                      planId: plan.id,
                      style: plan.style,
                      lineColor: lineColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Image.network(
      plan.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildVectorFallback(lineColor, paperColor, isProgress: true);
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildVectorFallback(lineColor, paperColor, isProgress: false);
      },
    );
  }

  Widget _buildVectorFallback(Color lineColor, Color paperColor, {required bool isProgress}) {
    return Container(
      color: paperColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridBackgroundPainter(lineColor: lineColor),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: ArchitecturalPainter(
                    type: plan.vectorDraftType,
                    planId: plan.id,
                    style: plan.style,
                    lineColor: lineColor,
                  ),
                ),
              ),
            ),
          ),
          if (isProgress)
            Positioned(
              bottom: 12,
              right: 12,
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(lineColor.withOpacity(0.5)),
                ),
              ),
            ),
          if (showOfflineBadge)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: lineColor.withOpacity(0.1),
                  border: Border.all(color: lineColor.withOpacity(0.3), width: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  isProgress ? 'LOADING RENDER...' : 'OFFLINE VECTOR DRAFT',
                  style: TextStyle(
                    color: lineColor.withOpacity(0.8),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. HOVER CARD UX COMPONENT
// ==========================================

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const HoverCard({super.key, required this.child, required this.onTap});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -6, 0)..scale(1.02))
            : Matrix4.identity(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}

// ==========================================
// 6. SPLASH SCREEN WIDGET (WITH APP ICON)
// ==========================================

class BlueprintSplashScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const BlueprintSplashScreen({super.key, required this.onThemeToggle});

  @override
  State<BlueprintSplashScreen> createState() => _BlueprintSplashScreenState();
}

class _BlueprintSplashScreenState extends State<BlueprintSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _compassAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _compassAnimation = Tween<double>(begin: -math.pi / 4, end: math.pi * 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DashboardScreen(onThemeToggle: widget.onThemeToggle),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? const Color(0xFF00E5FF) : const Color(0xFF0F2C59);
    final paperColor = isDark ? const Color(0xFF0A1128) : const Color(0xFFFAF9F6);

    return Scaffold(
      backgroundColor: paperColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridBackgroundPainter(lineColor: lineColor),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: SplashDraftingPainter(
                  angle: _compassAnimation.value,
                  progress: _controller.value,
                  lineColor: lineColor,
                ),
              );
            },
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon Frame
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: lineColor, width: 2),
                      color: paperColor,
                    ),
                    child: Image.asset(
                      'assets/app_icon.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.architecture, size: 72, color: lineColor);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: lineColor, width: 2.0),
                      color: paperColor.withOpacity(0.9),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'GEO-SKETCH VIEWER',
                          style: TextStyle(
                            color: lineColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courier',
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 1,
                          width: 180,
                          color: lineColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '2D/3D HOUSE MAP SHOWCASE',
                          style: TextStyle(
                            color: lineColor.withOpacity(0.8),
                            fontSize: 10,
                            fontFamily: 'Courier',
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 32,
            right: 32,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SCALE: 1:100\nPROJECT: AP-2026\nSHEET: S-01',
                    style: TextStyle(
                      color: lineColor.withOpacity(0.6),
                      fontSize: 8.5,
                      fontFamily: 'Courier',
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'DRAFTED BY: ANTIGRAVITY\nSYSTEM: OFFLINE STABLE\nSTATUS: INITIALIZING...',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: lineColor.withOpacity(0.6),
                      fontSize: 8.5,
                      fontFamily: 'Courier',
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 7. DASHBOARD SCREEN WIDGET
// ==========================================

class DashboardScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const DashboardScreen({super.key, required this.onThemeToggle});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = "";
  int? _filterBeds;
  int? _filterFloors;
  String? _filterStyle;
  bool _showOnlyFavorites = false;

  final List<String> _stylesList = ['All', 'Modern', 'Minimalist', 'Hi-Tech Modern', 'Contemporary', 'Spanish', 'Classical', 'Scandinavian', 'Eco-Friendly', 'Brutalist'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = "";
      _filterBeds = null;
      _filterFloors = null;
      _filterStyle = null;
      _showOnlyFavorites = false;
    });
  }

  List<HousePlan> _getFilteredPlans(List<HousePlan> allPlans, String category, Set<String> favorites) {
    return allPlans.where((plan) {
      if (plan.category != category) return false;
      if (_showOnlyFavorites && !favorites.contains(plan.id)) return false;

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = plan.title.toLowerCase().contains(query);
        final matchDesc = plan.description.toLowerCase().contains(query);
        final matchStyle = plan.style.toLowerCase().contains(query);
        final matchDraftsman = plan.draftsman.toLowerCase().contains(query);
        if (!matchTitle && !matchDesc && !matchStyle && !matchDraftsman) return false;
      }

      if (_filterBeds != null) {
        if (_filterBeds == 5) {
          if (plan.bedrooms < 5) return false;
        } else {
          if (plan.bedrooms != _filterBeds) return false;
        }
      }

      if (_filterFloors != null && plan.floors != _filterFloors) return false;
      if (_filterStyle != null && plan.style != _filterStyle) return false;

      return true;
    }).toList();
  }

  void _openAddDialog() {
    final activeCategory = _tabController.index == 0
        ? '5 Marla Plans'
        : _tabController.index == 1
            ? '10 Marla Plans'
            : '3D Exterior Renderings';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DraftFormDialog(defaultCategory: activeCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? const Color(0xFF00E5FF) : const Color(0xFF0F2C59);
    final paperColor = isDark ? const Color(0xFF020813) : const Color(0xFFFAF9F6);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0B1426) : const Color(0xFF0F2C59),
        elevation: 4,
        shadowColor: lineColor.withOpacity(0.3),
        title: Row(
          children: [
            Image.asset(
              'assets/app_icon.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.architecture, color: lineColor, size: 26),
            ),
            const SizedBox(width: 10),
            Text(
              screenWidth < 600 ? 'GEO-SKETCH' : 'GEO-SKETCH // DRAFTING ROOM',
              style: TextStyle(
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
                fontSize: screenWidth < 600 ? 13.5 : 14.5,
                color: isDark ? const Color(0xFFE0E6ED) : Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? const Color(0xFF00E5FF) : Colors.white,
            ),
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            tooltip: 'Toggle Bookmarks',
            icon: Icon(
              _showOnlyFavorites ? Icons.bookmark : Icons.bookmark_border,
              color: _showOnlyFavorites ? const Color(0xFF00E5FF) : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showOnlyFavorites = !_showOnlyFavorites;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: lineColor,
          labelColor: lineColor,
          unselectedLabelColor: isDark ? Colors.grey[500] : Colors.grey[300],
          labelStyle: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 12),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: '5 MARLA PLANS'),
            Tab(text: '10 MARLA PLANS'),
            Tab(text: '3D ELEVATIONS'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridBackgroundPainter(lineColor: lineColor),
            ),
          ),
          Column(
            children: [
              _buildSearchFilterPanel(theme, lineColor, isDark),
              _buildCategoryInfoBar(lineColor),
              Expanded(
                child: ValueListenableBuilder<List<HousePlan>>(
                  valueListenable: housePlansNotifier,
                  builder: (context, allPlans, _) {
                    return ValueListenableBuilder<Set<String>>(
                      valueListenable: favoritesNotifier,
                      builder: (context, favorites, _) {
                        final currentTabName = _tabController.index == 0
                            ? '5 Marla Plans'
                            : _tabController.index == 1
                                ? '10 Marla Plans'
                                : '3D Exterior Renderings';

                        final filteredPlans = _getFilteredPlans(allPlans, currentTabName, favorites);

                        if (filteredPlans.isEmpty) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.all(24),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                border: Border.all(color: lineColor.withOpacity(0.3), width: 1),
                                color: paperColor.withOpacity(0.85),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_off, color: lineColor.withOpacity(0.5), size: 48),
                                  const SizedBox(height: 16),
                                  Text(
                                    'NO TECHNICAL SHEETS FOUND',
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: lineColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try clearing filters or adding a new draft sheet.',
                                    style: TextStyle(fontFamily: 'Courier', fontSize: 11, color: lineColor.withOpacity(0.7)),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: lineColor,
                                      foregroundColor: paperColor,
                                      shape: const RoundedRectangleBorder(),
                                    ),
                                    onPressed: _clearFilters,
                                    child: const Text('RESET SYSTEM FILTERS', style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final double width = constraints.maxWidth;
                            final int crossAxisCount = width < 600
                                ? 1
                                : width < 950
                                    ? 2
                                    : width < 1400
                                        ? 3
                                        : 4;

                            // Responsive aspect ratio (Landscape banners on mobile, catalog cards on desktop)
                            final double childAspectRatio = width < 600 ? 1.3 : 0.85;

                            return GridView.builder(
                              padding: const EdgeInsets.all(16.0),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: childAspectRatio,
                              ),
                              itemCount: filteredPlans.length,
                              itemBuilder: (context, index) {
                                final plan = filteredPlans[index];
                                final isFavorite = favorites.contains(plan.id);

                                return TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: Duration(milliseconds: 100 + (index * 40)),
                                  builder: (context, anim, child) {
                                    return Opacity(
                                      opacity: anim,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - anim)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: HoverCard(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 350),
                                          reverseTransitionDuration: const Duration(milliseconds: 250),
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return DetailViewerScreen(plan: plan);
                                          },
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            return FadeTransition(opacity: animation, child: child);
                                          },
                                        ),
                                      );
                                    },
                                    child: _buildBlueprintCard(plan, isFavorite, lineColor, paperColor, width < 600),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDialog,
        backgroundColor: lineColor,
        foregroundColor: paperColor,
        shape: const RoundedRectangleBorder(),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('NEW DRAFT', style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildSearchFilterPanel(ThemeData theme, Color lineColor, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1224) : Colors.white,
        border: Border(bottom: BorderSide(color: lineColor.withOpacity(0.2), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: TextStyle(fontFamily: 'Courier', fontSize: 13, color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'SEARCH PLANS (e.g. Modern, Spanish, Sarah...)',
                    hintStyle: TextStyle(fontFamily: 'Courier', fontSize: 10, color: lineColor.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search, size: 18, color: lineColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: lineColor.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: lineColor, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty || _filterBeds != null || _filterFloors != null || _filterStyle != null || _showOnlyFavorites)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      foregroundColor: Colors.redAccent,
                    ),
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('RESET', style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterDropdown<int>(
                  label: 'BEDROOMS',
                  value: _filterBeds,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Any Beds')),
                    const DropdownMenuItem(value: 2, child: Text('2 Bed')),
                    const DropdownMenuItem(value: 3, child: Text('3 Bed')),
                    const DropdownMenuItem(value: 4, child: Text('4 Bed')),
                    const DropdownMenuItem(value: 5, child: Text('5+ Bed')),
                  ],
                  onChanged: (val) => setState(() => _filterBeds = val),
                  lineColor: lineColor,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown<int>(
                  label: 'FLOORS',
                  value: _filterFloors,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Any Story')),
                    const DropdownMenuItem(value: 1, child: Text('1 Story')),
                    const DropdownMenuItem(value: 2, child: Text('2 Story')),
                    const DropdownMenuItem(value: 3, child: Text('3 Story')),
                  ],
                  onChanged: (val) => setState(() => _filterFloors = val),
                  lineColor: lineColor,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown<String>(
                  label: 'STYLE',
                  value: _filterStyle,
                  items: _stylesList.map((style) {
                    return DropdownMenuItem(
                      value: style == 'All' ? null : style,
                      child: Text(style),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _filterStyle = val),
                  lineColor: lineColor,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required Color lineColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: lineColor.withOpacity(0.3)),
        color: isDark ? const Color(0xFF020813) : Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: lineColor, size: 16),
          style: TextStyle(fontFamily: 'Courier', fontSize: 11, fontWeight: FontWeight.bold, color: lineColor),
          items: items,
          onChanged: onChanged,
          dropdownColor: isDark ? const Color(0xFF0B1426) : Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryInfoBar(Color lineColor) {
    final currentCategoryText = _tabController.index == 0
        ? '5 MARLA (25\' x 45\') DRAFT SHEETS - 1125 SQ FT PLOT AREA'
        : _tabController.index == 1
            ? '10 MARLA (35\' x 65\') DRAFT SHEETS - 2250 SQ FT PLOT AREA'
            : '3D WIREFRAME FACADES & RENDERINGS - VISUALIZATION MODE';

    return Container(
      width: double.infinity,
      color: lineColor.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Text(
        currentCategoryText,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          color: lineColor.withOpacity(0.8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBlueprintCard(HousePlan plan, bool isFavorite, Color lineColor, Color paperColor, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: paperColor,
        border: Border.all(color: lineColor.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: lineColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: plan.id,
                    child: BlueprintImage(plan: plan, showOfflineBadge: false),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      final current = Set<String>.from(favoritesNotifier.value);
                      if (current.contains(plan.id)) {
                        current.remove(plan.id);
                      } else {
                        current.add(plan.id);
                      }
                      favoritesNotifier.value = current;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: paperColor.withOpacity(0.85),
                        border: Border.all(color: lineColor.withOpacity(0.4), width: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        color: isFavorite ? Colors.amber : lineColor.withOpacity(0.7),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    color: lineColor.withOpacity(0.9),
                    child: Text(
                      '${plan.areaSqFt.toInt()} SQFT',
                      style: TextStyle(
                        color: paperColor,
                        fontFamily: 'Courier',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Style Badge (instead of overlapping inside details text)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: paperColor.withOpacity(0.9),
                      border: Border.all(color: lineColor.withOpacity(0.3), width: 0.5),
                    ),
                    child: Text(
                      plan.style.toUpperCase(),
                      style: TextStyle(
                        color: lineColor,
                        fontFamily: 'Courier',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: lineColor.withOpacity(0.4), width: 1.5)),
              color: lineColor.withOpacity(0.04),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  plan.title,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: lineColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      plan.dimensions,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 9.5,
                        color: lineColor.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '|',
                      style: TextStyle(color: lineColor.withOpacity(0.3), fontSize: 9.5),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.bed, size: 11, color: lineColor.withOpacity(0.7)),
                    const SizedBox(width: 2),
                    Text(
                      '${plan.bedrooms}',
                      style: TextStyle(fontFamily: 'Courier', fontSize: 9.5, color: lineColor.withOpacity(0.8), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.bathtub, size: 11, color: lineColor.withOpacity(0.7)),
                    const SizedBox(width: 2),
                    Text(
                      '${plan.bathrooms}',
                      style: TextStyle(fontFamily: 'Courier', fontSize: 9.5, color: lineColor.withOpacity(0.8), fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      'Est. ${plan.estimatedCostLakhs.toInt()} Lacs',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 10.5,
                        color: lineColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 8. INTERACTIVE DETAIL VIEWER SCREEN
// ==========================================

class DetailViewerScreen extends StatefulWidget {
  final HousePlan plan;
  const DetailViewerScreen({super.key, required this.plan});

  @override
  State<DetailViewerScreen> createState() => _DetailViewerScreenState();
}

class _DetailViewerScreenState extends State<DetailViewerScreen> with TickerProviderStateMixin {
  late HousePlan _currentPlan;
  final TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  
  bool _showVector = false;
  late AnimationController _zoomAnimationController;
  Animation<Matrix4>? _zoomAnimation;

  int _mobileSelectedTab = 0; // 0 for Canvas, 1 for Specs
  int _activeSpecTab = 0; // 0: Space, 1: Materials, 2: Drafts

  @override
  void initState() {
    super.initState();
    _currentPlan = widget.plan;
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformationController.value = _zoomAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _zoomAnimationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final currentMatrix = _transformationController.value;
    final Matrix4 endMatrix;

    if (currentMatrix != Matrix4.identity()) {
      endMatrix = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      const scaleFactor = 2.5;
      final dx = position.dx;
      final dy = position.dy;
      endMatrix = Matrix4.identity()
        ..translate(-dx * (scaleFactor - 1), -dy * (scaleFactor - 1))
        ..scale(scaleFactor);
    }

    _zoomAnimation = Matrix4Tween(
      begin: currentMatrix,
      end: endMatrix,
    ).animate(CurvedAnimation(
      parent: _zoomAnimationController,
      curve: Curves.easeInOutCubic,
    ));

    _zoomAnimationController.forward(from: 0.0);
  }

  void _resetZoom() {
    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _zoomAnimationController,
      curve: Curves.easeOutCubic,
    ));
    _zoomAnimationController.forward(from: 0.0);
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DraftFormDialog(
        plan: _currentPlan,
        defaultCategory: _currentPlan.category,
        onUpdate: (updatedPlan) {
          setState(() {
            _currentPlan = updatedPlan;
          });
        },
      ),
    );
  }

  void _confirmDelete() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? const Color(0xFF00E5FF) : const Color(0xFF0F2C59);
    final paperColor = isDark ? const Color(0xFF020813) : const Color(0xFFFAF9F6);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: paperColor,
        shape: RoundedRectangleBorder(side: BorderSide(color: lineColor, width: 2)),
        title: Text(
          'DELETE SHEET',
          style: TextStyle(fontFamily: 'Courier', color: lineColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to permanently delete S-${_currentPlan.id.toUpperCase()} from the active project list?',
          style: TextStyle(fontFamily: 'Courier', color: lineColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: TextStyle(fontFamily: 'Courier', color: lineColor)),
          ),
          TextButton(
            onPressed: () {
              final list = List<HousePlan>.from(housePlansNotifier.value);
              list.removeWhere((p) => p.id == _currentPlan.id);
              housePlansNotifier.value = list;

              final favs = Set<String>.from(favoritesNotifier.value);
              favs.remove(_currentPlan.id);
              favoritesNotifier.value = favs;

              Navigator.pop(context); // Pop dialog
              Navigator.pop(context); // Pop detail screen
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    'SHEET S-${_currentPlan.id.toUpperCase()} DELETED SUCCESSFULLY',
                    style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              );
            },
            child: const Text('DELETE', style: TextStyle(fontFamily: 'Courier', color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _exportMockDraft() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final lineColor = isDark ? const Color(0xFF00E5FF) : const Color(0xFF0F2C59);
        final paperColor = isDark ? const Color(0xFF020813) : const Color(0xFFFAF9F6);

        Timer(const Duration(milliseconds: 1800), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: lineColor,
                content: Text(
                  'DRAFT SHEET EXPORTED SUCCESSFULLY (CAD/PDF Format Simulated)',
                  style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: paperColor),
                ),
              ),
            );
          }
        });

        return AlertDialog(
          backgroundColor: paperColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: lineColor, width: 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(lineColor),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'EXPORTING DRAFT SHEETS...',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                  color: lineColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Generating vector CAD files and high-res layout plans.',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: lineColor.withOpacity(0.7),
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? const Color(0xFF00E5FF) : const Color(0xFF0F2C59);
    final paperColor = isDark ? const Color(0xFF020813) : const Color(0xFFFAF9F6);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = screenWidth >= 800;

    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0B1426) : const Color(0xFF0F2C59),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        shadowColor: lineColor.withOpacity(0.3),
        title: Text(
          'SHEET: S-${_currentPlan.id.toUpperCase()}',
          style: const TextStyle(
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '2D DRAFT',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _showVector ? lineColor : Colors.grey[400],
                ),
              ),
              Switch(
                value: !_showVector,
                activeColor: lineColor,
                inactiveThumbColor: lineColor,
                inactiveTrackColor: lineColor.withOpacity(0.2),
                onChanged: (val) {
                  setState(() {
                    _showVector = !val;
                  });
                },
              ),
              Text(
                '3D RENDER',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: !_showVector ? lineColor : Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Edit Plan Details',
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _openEditDialog,
          ),
          IconButton(
            tooltip: 'Delete Draft Sheet',
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: _confirmDelete,
          ),
          ValueListenableBuilder<Set<String>>(
            valueListenable: favoritesNotifier,
            builder: (context, favorites, _) {
              final isFavorite = favorites.contains(_currentPlan.id);
              return IconButton(
                tooltip: 'Bookmark Design',
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: isFavorite ? Colors.amber : Colors.white,
                ),
                onPressed: () {
                  final current = Set<String>.from(favorites);
                  if (current.contains(_currentPlan.id)) {
                    current.remove(_currentPlan.id);
                  } else {
                    current.add(_currentPlan.id);
                  }
                  favoritesNotifier.value = current;
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridBackgroundPainter(lineColor: lineColor),
            ),
          ),
          // Split layout on tablet/desktop, Tabbed layout on mobile
          isLandscape
              ? Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildVisualCanvas(lineColor, paperColor),
                    ),
                    VerticalDivider(color: lineColor.withOpacity(0.3), width: 1),
                    Expanded(
                      flex: 4,
                      child: _buildSpecificationPanel(lineColor, paperColor),
                    ),
                  ],
                )
              : (_mobileSelectedTab == 0
                  ? _buildVisualCanvas(lineColor, paperColor)
                  : _buildSpecificationPanel(lineColor, paperColor)),
        ],
      ),
      bottomNavigationBar: isLandscape
          ? null
          : BottomNavigationBar(
              currentIndex: _mobileSelectedTab,
              onTap: (index) {
                setState(() {
                  _mobileSelectedTab = index;
                });
              },
              backgroundColor: isDark ? const Color(0xFF0B1426) : const Color(0xFF0F2C59),
              selectedItemColor: lineColor,
              unselectedItemColor: Colors.grey[500],
              selectedLabelStyle: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 10),
              unselectedLabelStyle: const TextStyle(fontFamily: 'Courier', fontSize: 10),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.architecture),
                  label: '2D/3D CANVAS',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description_outlined),
                  label: 'SPEC SHEET',
                ),
              ],
            ),
    );
  }

  Widget _buildVisualCanvas(Color lineColor, Color paperColor) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRect(
            child: GestureDetector(
              onDoubleTapDown: (details) => _doubleTapDetails = details,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 6.0,
                child: Center(
                  child: Hero(
                    tag: _currentPlan.id,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: lineColor.withOpacity(0.2)),
                        ),
                        child: BlueprintImage(
                          plan: _currentPlan,
                          forceVector: _showVector,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: paperColor.withOpacity(0.85),
              border: Border.all(color: lineColor.withOpacity(0.3), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.explore_outlined, size: 14, color: lineColor),
                    const SizedBox(width: 4),
                    Text(
                      'NORTH N↑',
                      style: TextStyle(
                        color: lineColor,
                        fontFamily: 'Courier',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'SCALE: 1:100\nUNIT: FT/INCH',
                  style: TextStyle(
                    color: lineColor.withOpacity(0.8),
                    fontFamily: 'Courier',
                    fontSize: 8,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: paperColor.withOpacity(0.85),
              border: Border.all(color: lineColor.withOpacity(0.4), width: 0.8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Reset Zoom (1:1)',
                  icon: Icon(Icons.zoom_out_map, size: 16, color: lineColor),
                  onPressed: _resetZoom,
                ),
                Container(height: 1, width: 28, color: lineColor.withOpacity(0.3)),
                IconButton(
                  tooltip: 'Technical Sketch',
                  icon: Icon(
                    _showVector ? Icons.view_in_ar : Icons.crop_free,
                    size: 16,
                    color: lineColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _showVector = !_showVector;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: lineColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pinch, size: 12, color: lineColor),
                const SizedBox(width: 4),
                Text(
                  'PINCH / DRAG TO DETECT DETAILED MARKS',
                  style: TextStyle(
                    color: lineColor,
                    fontFamily: 'Courier',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificationPanel(Color lineColor, Color paperColor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title/Header Block
          Container(
            padding: const EdgeInsets.all(16.0),
            color: lineColor.withOpacity(0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: lineColor.withOpacity(0.15),
                      child: Text(
                        _currentPlan.style.toUpperCase(),
                        style: TextStyle(
                          color: lineColor,
                          fontFamily: 'Courier',
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'EST. BUDGET: ~${_currentPlan.estimatedCostLakhs.toInt()} LACS',
                      style: TextStyle(
                        color: lineColor,
                        fontFamily: 'Courier',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _currentPlan.title,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: lineColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentPlan.description,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11,
                    color: lineColor.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          // Metrics Row (Replaces GridView to avoid height constraints)
          _buildMetricsGrid(lineColor),
          
          // Custom Tab Selection Header (Replaces TabController/TabBarView height dependencies)
          _buildSpecsTabBar(lineColor),
          
          // Render Active Spec Tab Content
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _activeSpecTab == 0
                ? _buildSpaceMatrixTab(lineColor)
                : _activeSpecTab == 1
                    ? _buildGreyStructureEstimates(lineColor)
                    : _buildDraftsmanDetails(lineColor),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: lineColor.withOpacity(0.2))),
              color: lineColor.withOpacity(0.03),
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: lineColor,
                foregroundColor: paperColor,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.download, size: 18),
              label: const Text(
                'EXPORT CAD / PDF PLANS',
                style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 12),
              ),
              onPressed: _exportMockDraft,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(Color lineColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: lineColor.withOpacity(0.2)),
          bottom: BorderSide(color: lineColor.withOpacity(0.2)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildMetricCell('PLOT AREA', '${_currentPlan.areaSqFt.toInt()} SF', lineColor),
          _buildMetricCell('DIMENSIONS', _currentPlan.dimensions, lineColor),
          _buildMetricCell('BED/BATH', '${_currentPlan.bedrooms}B/${_currentPlan.bathrooms}B', lineColor),
          _buildMetricCell('FLOORS', '${_currentPlan.floors} STORY', lineColor),
        ],
      ),
    );
  }

  Widget _buildMetricCell(String label, String value, Color lineColor) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: lineColor.withOpacity(0.15))),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: lineColor.withOpacity(0.5),
                fontFamily: 'Courier',
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: lineColor,
                fontFamily: 'Courier',
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecsTabBar(Color lineColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: lineColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'SPACE', lineColor),
          _buildTabButton(1, 'MATERIAL', lineColor),
          _buildTabButton(2, 'DRAFT', lineColor),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, Color lineColor) {
    final isActive = _activeSpecTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeSpecTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: isActive ? lineColor.withOpacity(0.15) : Colors.transparent,
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? lineColor : lineColor.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpaceMatrixTab(Color lineColor) {
    if (_currentPlan.spaceBreakdown.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'NO SPACE DETAILS SPECIFIED',
            style: TextStyle(fontFamily: 'Courier', fontSize: 10, color: lineColor.withOpacity(0.5)),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _currentPlan.spaceBreakdown.length,
      itemBuilder: (context, index) {
        final line = _currentPlan.spaceBreakdown[index];
        final parts = line.split(':');
        final header = parts.length > 1 ? parts[0] : '';
        final body = parts.length > 1 ? parts[1] : line;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Icon(Icons.arrow_right, size: 14, color: lineColor),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Courier', fontSize: 11, color: lineColor.withOpacity(0.9), height: 1.3),
                    children: [
                      if (header.isNotEmpty)
                        TextSpan(
                          text: '$header:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      TextSpan(text: body),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreyStructureEstimates(Color lineColor) {
    final double area = _currentPlan.areaSqFt;
    final int bricksCount = (area * 32).toInt();
    final int cementBags = (area * 0.4).toInt();
    final double sandCFT = area * 1.5;
    final double steelTons = area * 0.002;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APPROXIMATE MATERIAL BILL (GREY STRUCTURE):',
            style: TextStyle(fontFamily: 'Courier', fontSize: 10, fontWeight: FontWeight.bold, color: lineColor),
          ),
          const SizedBox(height: 12),
          _buildMaterialEstimateRow('BRICKS (ESTIMATED):', '$bricksCount Units', lineColor),
          _buildMaterialEstimateRow('CEMENT BAGS (EST.):', '$cementBags Bags (OPC)', lineColor),
          _buildMaterialEstimateRow('SAND (ESTIMATED):', '${sandCFT.toInt()} CFT', lineColor),
          _buildMaterialEstimateRow('REBAR STEEL TONS:', '${steelTons.toStringAsFixed(2)} Tons', lineColor),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            color: lineColor.withOpacity(0.05),
            child: Text(
              '⚠️ DISCLAIMER: Values are estimates generated programmatically based on average building codes. Contact structural engineers for actual bill of quantities (BOQ).',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 8.5,
                color: lineColor.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialEstimateRow(String label, String value, Color lineColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Courier', fontSize: 10.5, color: lineColor.withOpacity(0.75))),
          Text(value, style: TextStyle(fontFamily: 'Courier', fontSize: 11, fontWeight: FontWeight.bold, color: lineColor)),
        ],
      ),
    );
  }

  Widget _buildDraftsmanDetails(Color lineColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoMetaBlock('LEAD DRAFTSMAN', _currentPlan.draftsman, lineColor),
          _buildInfoMetaBlock('SHEET ID CODE', 'GS-${_currentPlan.id.toUpperCase()}-2026', lineColor),
          _buildInfoMetaBlock('CAD STANDARD', 'ISO-128 (Architectural Drafting)', lineColor),
          _buildInfoMetaBlock('COMPATIBILITY', 'Autodesk AutoCAD / SketchUp Pro / Blender Vector format', lineColor),
        ],
      ),
    );
  }

  Widget _buildInfoMetaBlock(String label, String value, Color lineColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: lineColor.withOpacity(0.5),
              fontFamily: 'Courier',
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: lineColor,
              fontFamily: 'Courier',
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 9. DRAFT ADD/EDIT DIALOG FORM
// ==========================================

class DraftFormDialog extends StatefulWidget {
  final HousePlan? plan;
  final String defaultCategory;
  final ValueChanged<HousePlan>? onUpdate;

  const DraftFormDialog({
    super.key,
    this.plan,
    required this.defaultCategory,
    this.onUpdate,
  });

  @override
  State<DraftFormDialog> createState() => _DraftFormDialogState();
}

class _DraftFormDialogState extends State<DraftFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dimensionsController;
  late TextEditingController _areaController;
  late TextEditingController _bedsController;
  late TextEditingController _bathsController;
  late TextEditingController _floorsController;
  late TextEditingController _costController;
  late TextEditingController _draftsmanController;
  late TextEditingController _imageUrlController;
  late TextEditingController _spaceBreakdownController;

  late String _selectedCategory;
  late String _selectedStyle;
  late VectorDraftType _selectedVectorType;

  final List<String> _categories = ['5 Marla Plans', '10 Marla Plans', '3D Exterior Renderings'];
  final List<String> _styles = ['Modern', 'Minimalist', 'Hi-Tech Modern', 'Contemporary', 'Spanish', 'Classical', 'Scandinavian', 'Eco-Friendly', 'Brutalist'];

  @override
  void initState() {
    super.initState();
    final p = widget.plan;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _dimensionsController = TextEditingController(text: p?.dimensions ?? '');
    _areaController = TextEditingController(text: p?.areaSqFt != null ? p!.areaSqFt.toInt().toString() : '');
    _bedsController = TextEditingController(text: p?.bedrooms.toString() ?? '');
    _bathsController = TextEditingController(text: p?.bathrooms.toString() ?? '');
    _floorsController = TextEditingController(text: p?.floors.toString() ?? '');
    _costController = TextEditingController(text: p?.estimatedCostLakhs != null ? p!.estimatedCostLakhs.toInt().toString() : '');
    _draftsmanController = TextEditingController(text: p?.draftsman ?? '');
    _imageUrlController = TextEditingController(text: p?.imageUrl ?? '');
    _spaceBreakdownController = TextEditingController(text: p?.spaceBreakdown.join('\n') ?? '');

    _selectedCategory = p?.category ?? widget.defaultCategory;
    _selectedStyle = p?.style ?? 'Modern';
    _selectedVectorType = p?.vectorDraftType ?? VectorDraftType.fiveMarla;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dimensionsController.dispose();
    _areaController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _floorsController.dispose();
    _costController.dispose();
    _draftsmanController.dispose();
    _imageUrlController.dispose();
    _spaceBreakdownController.dispose();
    super.dispose();
  }

  void _saveDraft() {
    if (!_formKey.currentState!.validate()) return;

    final isNew = widget.plan == null;
    final id = widget.plan?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}';

    final updatedPlan = HousePlan(
      id: id,
      title: _titleController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      areaSqFt: double.tryParse(_areaController.text) ?? 1125,
      dimensions: _dimensionsController.text.trim().isEmpty ? "25' x 45'" : _dimensionsController.text.trim(),
      bedrooms: int.tryParse(_bedsController.text) ?? 3,
      bathrooms: int.tryParse(_bathsController.text) ?? 3,
      floors: int.tryParse(_floorsController.text) ?? 2,
      style: _selectedStyle,
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? (_selectedCategory == '3D Exterior Renderings'
              ? 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80'
              : 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80')
          : _imageUrlController.text.trim(),
      vectorDraftType: _selectedVectorType,
      estimatedCostLakhs: double.tryParse(_costController.text) ?? 85.0,
      draftsman: _draftsmanController.text.trim().isEmpty ? 'Ar. Sarah Khan, Senior Architect' : _draftsmanController.text.trim(),
      spaceBreakdown: _spaceBreakdownController.text.trim().split('\n').where((s) => s.isNotEmpty).toList(),
    );

    final list = List<HousePlan>.from(housePlansNotifier.value);
    if (isNew) {
      list.add(updatedPlan);
    } else {
      final index = list.indexWhere((p) => p.id == id);
      if (index != -1) {
        list[index] = updatedPlan;
      }
    }
    housePlansNotifier.value = list;

    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedPlan);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(
          isNew ? 'NEW DRAFT SHEET ADDED' : 'DRAFT DETAILS UPDATED',
          style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? const Color(0xFF00E5FF) : const Color(0xFF0F2C59);
    final paperColor = isDark ? const Color(0xFF020813) : const Color(0xFFFAF9F6);

    return AlertDialog(
      backgroundColor: paperColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(side: BorderSide(color: lineColor, width: 2)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: lineColor.withOpacity(0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.plan == null ? 'FORM // NEW DRAFT' : 'FORM // EDIT DRAFT',
              style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 14, color: lineColor),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 18, color: lineColor),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: math.min(MediaQuery.of(context).size.width * 0.9, 580),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                _buildTextField('TITLE', _titleController, 'e.g. 5 Marla Modern Double Story', lineColor, isDark, required: true),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField<String>(
                        label: 'CATEGORY',
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (val) => setState(() => _selectedCategory = val!),
                        lineColor: lineColor,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField<String>(
                        label: 'ARCH. STYLE',
                        value: _selectedStyle,
                        items: _styles,
                        onChanged: (val) => setState(() => _selectedStyle = val!),
                        lineColor: lineColor,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('AREA (SQFT)', _areaController, 'e.g. 1125', lineColor, isDark, isNumber: true, required: true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField('DIMENSIONS', _dimensionsController, 'e.g. 25\' x 45\'', lineColor, isDark, required: true),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('BEDS', _bedsController, 'e.g. 3', lineColor, isDark, isNumber: true, required: true),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField('BATHS', _bathsController, 'e.g. 3', lineColor, isDark, isNumber: true, required: true),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField('STORIES', _floorsController, 'e.g. 2', lineColor, isDark, isNumber: true, required: true),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('EST. BUDGET (LACS)', _costController, 'e.g. 85', lineColor, isDark, isNumber: true, required: true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField<VectorDraftType>(
                        label: 'VECTOR DRAFT MAP',
                        value: _selectedVectorType,
                        items: VectorDraftType.values,
                        itemLabels: const {
                          VectorDraftType.fiveMarla: '5 Marla Vector',
                          VectorDraftType.tenMarla: '10 Marla Vector',
                          VectorDraftType.rendering3D: '3D Facade Wireframe',
                        },
                        onChanged: (val) => setState(() => _selectedVectorType = val!),
                        lineColor: lineColor,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField('LEAD DRAFTSMAN', _draftsmanController, 'e.g. Ar. Sarah Khan, Senior Architect', lineColor, isDark),
                const SizedBox(height: 12),
                _buildTextField('IMAGE URL (OPTIONAL)', _imageUrlController, 'Leave empty for default architectural sketch fallbacks', lineColor, isDark),
                const SizedBox(height: 12),
                _buildTextField('DESCRIPTION', _descriptionController, 'Provide architectural design features...', lineColor, isDark, maxLines: 2),
                const SizedBox(height: 12),
                _buildTextField(
                  'SPACE BREAKDOWN MATRIX (ONE ROOM PER LINE)',
                  _spaceBreakdownController,
                  'Ground Floor: Car Porch, Drawing, Lounge...\nFirst Floor: 2 Bedrooms...',
                  lineColor,
                  isDark,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
            side: BorderSide(color: lineColor.withOpacity(0.5)),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL', style: TextStyle(fontFamily: 'Courier', color: lineColor, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: lineColor,
            foregroundColor: paperColor,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: _saveDraft,
          child: const Text('SAVE DRAFT', style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
    Color lineColor,
    bool isDark, {
    int maxLines = 1,
    bool isNumber = false,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Courier', fontSize: 9.5, fontWeight: FontWeight.bold, color: lineColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  if (isNumber && double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                }
              : null,
          style: TextStyle(fontFamily: 'Courier', fontSize: 11.5, color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontFamily: 'Courier', fontSize: 10, color: lineColor.withOpacity(0.4)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: lineColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: lineColor, width: 1.5),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<T> items,
    Map<T, String>? itemLabels,
    required ValueChanged<T?> onChanged,
    required Color lineColor,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Courier', fontSize: 9.5, fontWeight: FontWeight.bold, color: lineColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: lineColor.withOpacity(0.3)),
            color: isDark ? const Color(0xFF020813) : Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              style: TextStyle(fontFamily: 'Courier', fontSize: 11, color: lineColor),
              dropdownColor: isDark ? const Color(0xFF0B1426) : Colors.white,
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabels != null ? itemLabels[item]! : item.toString()),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
