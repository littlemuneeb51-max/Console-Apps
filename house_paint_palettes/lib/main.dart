import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations (portrait & landscape are supported)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

// ==========================================
// DATA MODELS
// ==========================================

class PaintColor {
  final String name;
  final String hex;

  const PaintColor({required this.name, required this.hex});

  Color get color {
    final hexVal = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexVal', radix: 16));
  }
}

class PaintPalette {
  final String id;
  final String name;
  final String description;
  final List<String> tags;
  final List<PaintColor> colors;

  const PaintPalette({
    required this.id,
    required this.name,
    required this.description,
    required this.tags,
    required this.colors,
  });
}

// Curated architectural palettes
const List<PaintPalette> kArchitecturalPalettes = [
  PaintPalette(
    id: "modern_minimalist",
    name: "Modern Minimalist",
    description: "A clean, sleek selection of neutral grays and stark whites. Ideal for contemporary urban apartments and spacious lofts.",
    tags: ["Interior", "Modern", "Neutrals"],
    colors: [
      PaintColor(name: "Alabaster White", hex: "#F5F5F7"),
      PaintColor(name: "Cool Platinum", hex: "#E5E5EA"),
      PaintColor(name: "Soft Slate", hex: "#D1D1D6"),
      PaintColor(name: "Architectural Gray", hex: "#8E8E93"),
      PaintColor(name: "Obsidian Accent", hex: "#1C1C1E"),
    ],
  ),
  PaintPalette(
    id: "warm_cozy_cottage",
    name: "Warm Cozy Cottage",
    description: "Earthy creams and warm, sun-kissed beiges that evoke comfort, hearth, and rustic country living.",
    tags: ["Interior", "Warm", "Rustic"],
    colors: [
      PaintColor(name: "Warm Cream", hex: "#FAF6F0"),
      PaintColor(name: "Toasted Almond", hex: "#F3EAE0"),
      PaintColor(name: "Soft Sandstone", hex: "#E8D8C8"),
      PaintColor(name: "Muted Clay", hex: "#C7B198"),
      PaintColor(name: "Weathered Oak", hex: "#8A7968"),
    ],
  ),
  PaintPalette(
    id: "scandinavian_clean",
    name: "Scandinavian Clean",
    description: "A balance of crisp whites, light ash woods, and cool Nordic blues. Creates open, light-filled, tranquil spaces.",
    tags: ["Interior", "Bright", "Nordic"],
    colors: [
      PaintColor(name: "Snowdrift White", hex: "#F8F9FA"),
      PaintColor(name: "Glacier Mist", hex: "#E9ECEF"),
      PaintColor(name: "Nordic Sage", hex: "#D8E2DC"),
      PaintColor(name: "Pale Peach", hex: "#FFE5D9"),
      PaintColor(name: "Powder Blue", hex: "#90E0EF"),
    ],
  ),
  PaintPalette(
    id: "royal_exterior",
    name: "Royal Exterior",
    description: "Classic and stately combination of deep navy, clean cream trims, and rich brass accents for high-end residential facades.",
    tags: ["Exterior", "Classic", "Stately"],
    colors: [
      PaintColor(name: "Imperial Navy", hex: "#1D2A44"),
      PaintColor(name: "Manor Cream", hex: "#F4F1EA"),
      PaintColor(name: "Antique Gold", hex: "#C5A059"),
      PaintColor(name: "Slate Blue", hex: "#7D84B2"),
      PaintColor(name: "Charcoal Shingle", hex: "#31363F"),
    ],
  ),
  PaintPalette(
    id: "vintage_terracotta",
    name: "Vintage Terracotta",
    description: "Rich clays, burnt oranges, and warm olive tones inspired by Mediterranean villas and mid-century brickwork.",
    tags: ["Exterior", "Mediterranean", "Warm"],
    colors: [
      PaintColor(name: "Burnt Terracotta", hex: "#E76F51"),
      PaintColor(name: "Warm Apricot", hex: "#F4A261"),
      PaintColor(name: "Ochre Yellow", hex: "#E9C46A"),
      PaintColor(name: "Verdigris Teal", hex: "#2A9D8F"),
      PaintColor(name: "Deep Ocean Blue", hex: "#264653"),
    ],
  ),
  PaintPalette(
    id: "industrial_loft",
    name: "Industrial Loft",
    description: "Raw concrete tones, deep iron blacks, and warm rust accents. Perfect for converting warehouses or structural steel designs.",
    tags: ["Interior", "Raw", "Urban"],
    colors: [
      PaintColor(name: "Iron Black", hex: "#2B2D42"),
      PaintColor(name: "Concrete Gray", hex: "#8D99AE"),
      PaintColor(name: "Brushed Steel", hex: "#EDF2F4"),
      PaintColor(name: "Crimson Accent", hex: "#EF233C"),
      PaintColor(name: "Deep Rust", hex: "#D90429"),
    ],
  ),
  PaintPalette(
    id: "coastal_breeze",
    name: "Coastal Breeze",
    description: "Airy seafoam greens, ocean blues, and sandy beiges that invite the tranquility of beachside living indoors.",
    tags: ["Interior", "Bright", "Coastal"],
    colors: [
      PaintColor(name: "Sea Salt", hex: "#E0F2F1"),
      PaintColor(name: "Soft Aqua", hex: "#B2DFDB"),
      PaintColor(name: "Coastal Sage", hex: "#80CBC4"),
      PaintColor(name: "Sunny Dunes", hex: "#FFECB3"),
      PaintColor(name: "Ocean Depths", hex: "#4DB6AC"),
    ],
  ),
  PaintPalette(
    id: "mediterranean_villa",
    name: "Mediterranean Villa",
    description: "Sun-baked plaster whites, brilliant blue accents, and deep olive groves. Captures the spirit of coastal Greece and Italy.",
    tags: ["Exterior", "Bright", "Mediterranean"],
    colors: [
      PaintColor(name: "Santorini White", hex: "#FFFFFF"),
      PaintColor(name: "Cobalt Dome", hex: "#0080FF"),
      PaintColor(name: "Warm Plaster", hex: "#FDF6E2"),
      PaintColor(name: "Olive Grove", hex: "#556B2F"),
      PaintColor(name: "Tuscan Clay", hex: "#CD853F"),
    ],
  ),
  PaintPalette(
    id: "japandi_harmony",
    name: "Japandi Harmony",
    description: "The perfect fusion of Japanese wabi-sabi simplicity and Scandinavian functionality, featuring muted warm earth tones.",
    tags: ["Interior", "Minimalist", "Warm"],
    colors: [
      PaintColor(name: "Oatmeal", hex: "#F4F1EA"),
      PaintColor(name: "Raw Linen", hex: "#E6DFD3"),
      PaintColor(name: "Warm Stone", hex: "#D3C5B5"),
      PaintColor(name: "Soft Walnut", hex: "#8C7B6C"),
      PaintColor(name: "Charcoal Accent", hex: "#2C2C2C"),
    ],
  ),
  PaintPalette(
    id: "muted_earthy_forest",
    name: "Muted Earthy Forest",
    description: "Mossy greens, tree bark browns, and soft woodland mist. Designed for organic architecture and eco-friendly homes.",
    tags: ["Exterior", "Organic", "Calm"],
    colors: [
      PaintColor(name: "Woodland Mist", hex: "#E8ECE9"),
      PaintColor(name: "Soft Fern", hex: "#C2D5C6"),
      PaintColor(name: "Forest Moss", hex: "#7D9D82"),
      PaintColor(name: "Bark Brown", hex: "#8C705F"),
      PaintColor(name: "Rich Soil", hex: "#5C4A3E"),
    ],
  ),
];

// All tag categories for filtering
const List<String> kFilterTags = [
  "All",
  "Interior",
  "Exterior",
  "Modern",
  "Warm",
  "Bright",
  "Minimalist",
  "Mediterranean",
  "Rustic",
  "Nordic",
  "Classic",
  "Raw",
];

// ==========================================
// APP ROOT WITH STATE
// ==========================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;
  ThemeMode _themeMode = ThemeMode.light;
  final List<String> _favoritePaletteIds = [];
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    // Transition out of Splash Screen after 2.5 seconds
    _splashTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoritePaletteIds.contains(id)) {
        _favoritePaletteIds.remove(id);
      } else {
        _favoritePaletteIds.add(id);
      }
    });
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF264653),
      scaffoldBackgroundColor: const Color(0xFFFAF9F6), // Warm Alabaster/Cream
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF264653),
        brightness: Brightness.light,
        surface: const Color(0xFFFAF9F6),
        primary: const Color(0xFF264653),
        secondary: const Color(0xFF2A9D8F),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF264653)),
        titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF264653)),
        bodyMedium: TextStyle(color: Color(0xFF2D3748)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAF9F6),
        foregroundColor: Color(0xFF264653),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF2A9D8F),
      scaffoldBackgroundColor: const Color(0xFF121212), // Sleek Obsidian
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2A9D8F),
        brightness: Brightness.dark,
        surface: const Color(0xFF121212),
        primary: const Color(0xFF2A9D8F),
        secondary: const Color(0xFFF4A261),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        bodyMedium: TextStyle(color: Colors.grey),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Paint Palettes',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _showSplash
            ? const SplashScreen(key: ValueKey('splash'))
            : HomeScreen(
                key: const ValueKey('home'),
                themeMode: _themeMode,
                onThemeToggle: _toggleTheme,
                favoritePaletteIds: _favoritePaletteIds,
                onFavoriteToggle: _toggleFavorite,
              ),
      ),
    );
  }
}

// ==========================================
// SPLASH SCREEN WIDGET
// ==========================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _strokeHeight;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Stroke height grows matching the roller movement
    _strokeHeight = Tween<double>(begin: 0.0, end: 90.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
      ),
    );

    // Text fades in afterwards
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A2630), // Deep Slate
              Color(0xFF0D1318), // Dark Charcoal
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Paint Roller & Stroke
                  SizedBox(
                    height: 190,
                    width: 140,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // The paint stroke
                        Positioned(
                          bottom: 50, // Base offset
                          child: Container(
                            width: 55,
                            height: _strokeHeight.value,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE76F51), // Coral Terracotta
                                  Color(0xFFF4A261), // Warm Peach
                                  Color(0xFFE9C46A), // Ochre
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE76F51).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                          ),
                        ),
                        // The roller icon riding on top of the stroke
                        Positioned(
                          bottom: 50 + _strokeHeight.value - 24,
                          child: Transform.rotate(
                            angle: -0.08,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.format_paint_rounded,
                                size: 36,
                                color: Color(0xFF264653),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Opacity(
                    opacity: _textOpacity.value,
                    child: Column(
                      children: [
                        const Text(
                          "House Paint Palettes",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "ARCHITECTURAL COLOR PALETTES",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.5),
                            letterSpacing: 4.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==========================================
// HOME SCREEN WIDGET
// ==========================================

class HomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;
  final List<String> favoritePaletteIds;
  final ValueChanged<String> onFavoriteToggle;

  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
    required this.favoritePaletteIds,
    required this.onFavoriteToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeTab = 0; // 0 for Explorer, 1 for Favorites
  String _searchQuery = "";
  String _selectedTag = "All";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter logic applied to the list
  List<PaintPalette> getFilteredPalettes(bool onlyFavorites) {
    List<PaintPalette> list = kArchitecturalPalettes;
    
    if (onlyFavorites) {
      list = list.where((p) => widget.favoritePaletteIds.contains(p.id)).toList();
    }

    // Apply Tag filter
    if (_selectedTag != "All") {
      list = list.where((p) => p.tags.contains(_selectedTag)).toList();
    }

    // Apply Search Query filter (matches Name, Description, Tags, and Color Hex/Names)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((p) {
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesDesc = p.description.toLowerCase().contains(query);
        final matchesTags = p.tags.any((t) => t.toLowerCase().contains(query));
        final matchesColors = p.colors.any((c) =>
            c.name.toLowerCase().contains(query) ||
            c.hex.toLowerCase().contains(query));
        return matchesName || matchesDesc || matchesTags || matchesColors;
      }).toList();
    }

    return list;
  }

  void _copyColorToClipboard(BuildContext context, PaintColor paintColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Clipboard.setData(ClipboardData(text: paintColor.hex));

    // Custom beautifully styled SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF222222) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: paintColor.color.withValues(alpha: 0.6),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                // Circle preview of the color
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: paintColor.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.black12,
                      width: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Color Copied!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF264653),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${paintColor.name} (${paintColor.hex}) copied to clipboard.",
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle_rounded,
                  color: paintColor.color,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    
    // Determine grid columns based on screen width
    int crossAxisCount = 1;
    if (size.width > 1100) {
      crossAxisCount = 3;
    } else if (size.width > 700) {
      crossAxisCount = 2;
    }

    final double gridPadding = size.width > 600 ? 24.0 : 16.0;
    final double spacing = size.width > 600 ? 24.0 : 16.0;
    final double cardWidth = (size.width - (gridPadding * 2) - (spacing * (crossAxisCount - 1))) / crossAxisCount;
    // Calculate aspect ratio dynamically so card stays roughly 310px tall
    final double childAspectRatio = cardWidth / 310.0;

    final filteredPalettes = getFilteredPalettes(_activeTab == 1);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.palette_rounded,
              color: isDark ? const Color(0xFF2A9D8F) : const Color(0xFF264653),
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              "House Paint Palettes",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          ThemeToggleButton(
            themeMode: widget.themeMode,
            onTap: widget.onThemeToggle,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Search and Tab Selection Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gridPadding, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Architectural Themes Finder",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF264653),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Curated complementary swatches for home painters & interior designers.",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Field & Tab Selector layout row/column depending on width
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 700) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildSearchBox(isDark),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: CustomTabSelector(
                                selectedIndex: _activeTab,
                                favoritesCount: widget.favoritePaletteIds.length,
                                onTabChanged: (index) {
                                  setState(() {
                                    _activeTab = index;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _buildSearchBox(isDark),
                            const SizedBox(height: 12),
                            CustomTabSelector(
                              selectedIndex: _activeTab,
                              favoritesCount: widget.favoritePaletteIds.length,
                              onTabChanged: (index) {
                                setState(() {
                                  _activeTab = index;
                                });
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Tags Horizontal List
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: kFilterTags.length,
                      itemBuilder: (context, index) {
                        final tag = kFilterTags[index];
                        return TagChip(
                          label: tag,
                          isSelected: _selectedTag == tag,
                          onTap: () {
                            setState(() {
                              _selectedTag = tag;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Grid / List of Palettes
            Expanded(
              child: filteredPalettes.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: EdgeInsets.only(
                        left: gridPadding,
                        right: gridPadding,
                        bottom: 32,
                        top: 8,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: filteredPalettes.length,
                      itemBuilder: (context, index) {
                        final palette = filteredPalettes[index];
                        final isFav = widget.favoritePaletteIds.contains(palette.id);
                        return PaletteCard(
                          key: ValueKey(palette.id),
                          palette: palette,
                          isFavorited: isFav,
                          onFavoriteTap: () => widget.onFavoriteToggle(palette.id),
                          onColorTap: (color) => _copyColorToClipboard(context, color),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: "Search palettes, colors, tags...",
          hintStyle: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
            fontSize: 14,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = "";
                    });
                  },
                  child: Icon(
                    Icons.clear_rounded,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_activeTab == 1 && widget.favoritePaletteIds.isEmpty) {
      return EmptyFavoritesView(
        onExploreTap: () {
          setState(() {
            _activeTab = 0;
            _selectedTag = "All";
            _searchQuery = "";
            _searchController.clear();
          });
        },
      );
    }
    
    // Default search empty state
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "No Matches Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn't find any palettes matching \"$_searchQuery\" under category \"$_selectedTag\". Try a different search term.",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = "";
                  _selectedTag = "All";
                });
              },
              child: const Text("Clear Search Filters"),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ROTATING THEME TOGGLE BUTTON
// ==========================================

class ThemeToggleButton extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onTap;

  const ThemeToggleButton({
    super.key,
    required this.themeMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey<bool>(isDark),
          color: isDark ? const Color(0xFFF4A261) : const Color(0xFF264653),
          size: 24,
        ),
      ),
      onPressed: onTap,
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}

// ==========================================
// CUSTOM SLIDING TAB SELECTOR
// ==========================================

class CustomTabSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final int favoritesCount;

  const CustomTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.favoritesCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / 2;
            return Stack(
              children: [
                // Sliding indicator background
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  left: selectedIndex * tabWidth,
                  top: 2,
                  bottom: 2,
                  child: Container(
                    width: tabWidth - 4,
                    decoration: BoxDecoration(
                      color: isDark ? theme.colorScheme.primaryContainer : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                ),
                // Tab labels clickable
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTabChanged(0),
                        child: Center(
                          child: Text(
                            "Explorer",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: selectedIndex == 0
                                  ? (isDark ? theme.colorScheme.onPrimaryContainer : const Color(0xFF264653))
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTabChanged(1),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Favorites",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: selectedIndex == 1
                                      ? (isDark ? theme.colorScheme.onPrimaryContainer : const Color(0xFF264653))
                                      : Colors.grey,
                                ),
                              ),
                              if (favoritesCount > 0) ...[
                                const SizedBox(width: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE76F51),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$favoritesCount",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// TAG CHIP WIDGET
// ==========================================

class TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TagChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? theme.colorScheme.primaryContainer : const Color(0xFF264653))
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? theme.colorScheme.primaryContainer : const Color(0xFF264653))
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isDark ? theme.colorScheme.onPrimaryContainer : Colors.white)
                : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// PALETTE CARD WIDGET
// ==========================================

class PaletteCard extends StatelessWidget {
  final PaintPalette palette;
  final bool isFavorited;
  final VoidCallback onFavoriteTap;
  final ValueChanged<PaintColor> onColorTap;

  const PaletteCard({
    super.key,
    required this.palette,
    required this.isFavorited,
    required this.onFavoriteTap,
    required this.onColorTap,
  });

  void _copyAllColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hexList = palette.colors.map((c) => c.hex).join(', ');
    Clipboard.setData(ClipboardData(text: hexList));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF222222) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF2A9D8F).withValues(alpha: 0.6),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.collections_bookmark_rounded, color: Color(0xFF2A9D8F), size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Theme Copied!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF264653),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "All 5 colors copied: $hexList",
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title, Copy Palette, and Favorite
            Row(
              children: [
                Expanded(
                  child: Text(
                    palette.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF264653),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Copy entire palette action
                IconButton(
                  icon: const Icon(Icons.copy_all_rounded, size: 20),
                  onPressed: () => _copyAllColors(context),
                  tooltip: 'Copy all 5 hex codes',
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                FavoriteButton(
                  isFavorited: isFavorited,
                  onTap: onFavoriteTap,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              palette.description,
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // Tags Row
            SizedBox(
              height: 22,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: palette.tags.length,
                itemBuilder: (context, index) {
                  final tag = palette.tags[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF4A5568),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            // Color Swatches Row (styled like physical swatches)
            SizedBox(
              height: 125, // Height containing the swatches
              child: Row(
                children: palette.colors.map((color) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SwatchWidget(
                        paintColor: color,
                        onTap: () => onColorTap(color),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SWATCH WIDGET (PHYSICAL SWATCH CARD)
// ==========================================

class SwatchWidget extends StatefulWidget {
  final PaintColor paintColor;
  final VoidCallback onTap;

  const SwatchWidget({
    super.key,
    required this.paintColor,
    required this.onTap,
  });

  @override
  State<SwatchWidget> createState() => _SwatchWidgetState();
}

class _SwatchWidgetState extends State<SwatchWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedPhysicalModel(
            duration: const Duration(milliseconds: 150),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: isDark ? const Color(0xFF262626) : Colors.white,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            elevation: _isHovered ? 6.0 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Color Swatch Block
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.paintColor.color,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                // Bottom Text Area (simulate physical paint chip)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.paintColor.name,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade900,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          widget.paintColor.hex,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontFamily: 'monospace',
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// BOUNCING FAVORITE HEART BUTTON
// ==========================================

class FavoriteButton extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onTap,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate when transitions from not favorited -> favorited
    if (widget.isFavorited && !oldWidget.isFavorited) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          widget.isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: widget.isFavorited ? const Color(0xFFE76F51) : Colors.grey,
        ),
        onPressed: () {
          widget.onTap();
          if (!widget.isFavorited) {
            _controller.forward(from: 0.0);
          }
        },
      ),
    );
  }
}

// ==========================================
// EMPTY STATE FOR FAVORITES VIEW
// ==========================================

class EmptyFavoritesView extends StatelessWidget {
  final VoidCallback onExploreTap;

  const EmptyFavoritesView({super.key, required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Artistic Graphic Stack
              SizedBox(
                height: 160,
                width: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow background
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFE76F51).withValues(alpha: isDark ? 0.25 : 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Paint droplets (decorations)
                    Positioned(
                      top: 25,
                      left: 30,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2A9D8F),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 25,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF4A261),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 35,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE9C46A),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Big Heart outline icon
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 78,
                      color: const Color(0xFFE76F51).withValues(alpha: 0.85),
                    ),
                    // Cross brush icon
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Transform.rotate(
                        angle: -0.4,
                        child: const Icon(
                          Icons.brush_rounded,
                          size: 42,
                          color: Color(0xFF264653),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "No Favorite Palettes Yet",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white.withValues(alpha: 0.95) : const Color(0xFF264653),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Save your architectural color schemes for quick access. Browse the explorer tab and click the heart icon on any palette that inspires you.",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onExploreTap,
                icon: const Icon(Icons.palette_rounded, size: 20),
                label: const Text("Explore Palettes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF264653),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 3,
                  shadowColor: const Color(0xFF264653).withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
