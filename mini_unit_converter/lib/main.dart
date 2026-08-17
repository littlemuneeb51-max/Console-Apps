import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MiniUnitConverterApp());
}

/// The root widget of the application, managing Light/Dark themes.
class MiniUnitConverterApp extends StatefulWidget {
  const MiniUnitConverterApp({super.key});

  @override
  State<MiniUnitConverterApp> createState() => _MiniUnitConverterAppState();
}

class _MiniUnitConverterAppState extends State<MiniUnitConverterApp> {
  // Default theme mode is light
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construction-themed light theme
    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: const Color(0xFFF4F7F6), // Clean off-white
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
        primary: const Color(0xFF00796B),    // Engineering Teal
        secondary: const Color(0xFFFFB300),  // Safety Amber
        
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Color(0xFF1F3A41)),
        titleLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, color: Color(0xFF1F3A41)),
        bodyLarge: TextStyle(fontFamily: 'Roboto', color: Color(0xFF333333)),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF00796B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFFB2DFDB),
        indicatorColor: Color(0xFFFFB300),
      ),
    );

    // Construction-themed dark theme
    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F1B20), // Dark Blueprint Slate
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
        primary: const Color(0xFF26A69A),    // Neon Teal
        secondary: const Color(0xFFFFCA28),  // Neon Amber
        
        surface: const Color(0xFF17262D),    // Deep blueprint card
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: TextStyle(fontFamily: 'Roboto', color: Color(0xFFECEFF1)),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF17262D),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF17262D),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Color(0xFF26A69A),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFFFFCA28),
      ),
    );

    return MaterialApp(
      title: 'Mini Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: SplashScreen(toggleTheme: _toggleTheme),
    );
  }
}

/// A modern minimalist Splash Screen showing the professional App Icon asset,
/// falling back gracefully to the canvas-drawn measuring tape/ruler icon,
/// and transitioning to the home screen after 2.5 seconds.
class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SplashScreen({super.key, required this.toggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rulerTicksAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack)),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeIn)),
    );

    _rulerTicksAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();

    // Transition to main screen after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ConverterHomeScreen(toggleTheme: widget.toggleTheme),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
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
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background engineering grid
          Positioned.fill(
            child: CustomPaint(
              painter: GridBackgroundPainter(
                gridColor: isDarkMode
                    ? Colors.teal.withValues(alpha: 0.04)
                    : Colors.teal.withValues(alpha: 0.08),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated measuring tape/ruler icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(21),
                        child: Image.asset(
                          'assets/icon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Graced fallback to custom canvas-painted vector icon
                            return Center(
                              child: AnimatedBuilder(
                                animation: _rulerTicksAnimation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: const Size(100, 100),
                                    painter: RulerLogoPainter(
                                      color: theme.colorScheme.primary,
                                      accentColor: theme.colorScheme.secondary,
                                      animationValue: _rulerTicksAnimation.value,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'MINI UNIT CONVERTER',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          fontSize: 24,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Construction & Land Mapping Edition',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w500,
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Offline Indicator at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 16,
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '100% Offline Technical Tool',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
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

/// Custom painter to draw the animated measuring tape logo on the Splash Screen (Fallback).
class RulerLogoPainter extends CustomPainter {
  final Color color;
  final Color accentColor;
  final double animationValue;

  RulerLogoPainter({
    required this.color,
    required this.accentColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final tapeFill = Paint()
      ..color = accentColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final tapeBorder = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw tape body (curled/coiled measuring tape shape)
    final Path tapePath = Path();
    tapePath.moveTo(size.width * 0.1, size.height * 0.5);
    tapePath.quadraticBezierTo(
      size.width * 0.25, size.height * 0.2,
      size.width * 0.5, size.height * 0.25,
    );
    tapePath.quadraticBezierTo(
      size.width * 0.75, size.height * 0.3,
      size.width * 0.9, size.height * 0.65,
    );
    tapePath.quadraticBezierTo(
      size.width * 0.95, size.height * 0.85,
      size.width * 0.7, size.height * 0.9,
    );
    tapePath.quadraticBezierTo(
      size.width * 0.45, size.height * 0.95,
      size.width * 0.3, size.height * 0.75,
    );
    tapePath.close();

    // Draw background highlight matching the path
    canvas.drawPath(tapePath, tapeFill);
    canvas.drawPath(tapePath, tapeBorder);

    // Draw straight engineering ruler passing through it
    final double rulerTop = size.height * 0.42;
    final double rulerHeight = 22.0;
    final Rect rulerRect = Rect.fromLTWH(
      size.width * 0.05,
      rulerTop,
      size.width * 0.9 * animationValue,
      rulerHeight,
    );

    final Paint rectFill = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rulerRect, const Radius.circular(4)),
      rectFill,
    );

    // Draw tick marks on ruler
    final double animatedWidth = size.width * 0.9 * animationValue;
    if (animatedWidth > 10) {
      final tickPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.2;

      double xStart = size.width * 0.05;
      double xEnd = xStart + animatedWidth;
      double step = 8.0;

      for (double x = xStart + 4; x < xEnd - 4; x += step) {
        int index = ((x - xStart) / step).round();
        double tickLength = (index % 4 == 0) ? 9.0 : ((index % 2 == 0) ? 6.0 : 4.0);

        canvas.drawLine(
          Offset(x, rulerTop),
          Offset(x, rulerTop + tickLength),
          tickPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant RulerLogoPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.animationValue != animationValue;
  }
}

/// Custom painter to draw faint blueprint-style graph grids.
class GridBackgroundPainter extends CustomPainter {
  final Color gridColor;
  GridBackgroundPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8;

    const double step = 32.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridBackgroundPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor;
  }
}

/// The main application screen that hosts the unit conversion widgets inside a two-tab view layout.
class ConverterHomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const ConverterHomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/icon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.architecture, color: theme.colorScheme.secondary);
                },
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mini Unit Converter',
                style: theme.appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ) ?? const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
              const Text(
                'Construction & Land Mapping',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Color(0xFFB2DFDB),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Toggle Theme Mode',
              onPressed: toggleTheme,
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.layers_outlined),
                text: 'Land Area',
              ),
              Tab(
                icon: Icon(Icons.architecture_outlined),
                text: 'Length',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Area conversion Tab
            UnitConverterBody(
              category: ConversionCategory.area,
            ),
            // Length conversion Tab
            UnitConverterBody(
              category: ConversionCategory.length,
            ),
          ],
        ),
      ),
    );
  }
}

enum ConversionCategory { area, length }

/// A model representing a saved unit conversion calculation.
class SavedCalculation {
  final String id;
  String label;
  final double value;
  final String fromUnit;
  final String toUnit;
  final double result;
  final ConversionCategory category;
  final DateTime timestamp;

  SavedCalculation({
    required this.id,
    required this.label,
    required this.value,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
    required this.category,
    required this.timestamp,
  });
}

/// The core widget containing the state and layout for doing conversions in either Area or Length.
class UnitConverterBody extends StatefulWidget {
  final ConversionCategory category;

  const UnitConverterBody({
    super.key,
    required this.category,
  });

  @override
  State<UnitConverterBody> createState() => _UnitConverterBodyState();
}

class _UnitConverterBodyState extends State<UnitConverterBody> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  String _fromUnit = '';
  String _toUnit = '';
  double _convertedValue = 0.0;
  String? _errorMessage;
  bool _hasInput = false;

  // Shared memory storage for conversion records (persists during active session)
  static final List<SavedCalculation> _savedCalculations = [];

  // Configuration sets
  late List<String> _units;
  late Map<String, double> _factors; // Factors relative to base unit (Sq Ft for Area, Feet for Length)

  // Quick Preset values
  late List<double> _presets;

  @override
  void initState() {
    super.initState();
    _setupUnits();
    _inputController.addListener(_onInputChanged);
  }

  @override
  void didUpdateWidget(covariant UnitConverterBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _setupUnits();
      _inputController.clear();
      _labelController.clear();
      setState(() {
        _convertedValue = 0.0;
        _errorMessage = null;
        _hasInput = false;
      });
    }
  }

  @override
  void dispose() {
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    _labelController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _setupUnits() {
    if (widget.category == ConversionCategory.area) {
      _units = ['Marla', 'Kanal', 'Square Feet', 'Square Yards', 'Square Meters'];
      _fromUnit = 'Marla';
      _toUnit = 'Square Feet';
      _presets = [1.0, 5.0, 10.0, 20.0]; // Typical land divisions in Marlas/Kanals
      // Base Unit: Square Feet (1.0)
      _factors = {
        'Square Feet': 1.0,
        'Marla': 225.0, // 1 Marla = 225 Sq Ft
        'Kanal': 4500.0, // 1 Kanal = 20 Marla = 4500 Sq Ft
        'Square Yards': 9.0, // 1 Sq Yd = 9 Sq Ft
        'Square Meters': 10.7639104, // 1 Sq Meter = 10.7639104 Sq Ft
      };
    } else {
      _units = ['Feet', 'Inches', 'Yards', 'Meters', 'Centimeters'];
      _fromUnit = 'Feet';
      _toUnit = 'Meters';
      _presets = [10.0, 50.0, 100.0, 500.0]; // Typical lengths in Feet
      // Base Unit: Feet (1.0)
      _factors = {
        'Feet': 1.0,
        'Inches': 1.0 / 12.0, // 1 Inch = 1/12 Foot
        'Yards': 3.0, // 1 Yard = 3 Feet
        'Meters': 3.280839895, // 1 Meter = 3.280839895 Feet
        'Centimeters': 0.03280839895, // 1 Centimeter = 0.03280839895 Feet
      };
    }
  }

  void _onInputChanged() {
    final text = _inputController.text;
    if (text.isEmpty) {
      setState(() {
        _convertedValue = 0.0;
        _errorMessage = null;
        _hasInput = false;
      });
      return;
    }

    final parsed = double.tryParse(text);
    if (parsed == null) {
      setState(() {
        _errorMessage = 'Please enter a valid number';
        _convertedValue = 0.0;
        _hasInput = false;
      });
    } else {
      setState(() {
        _errorMessage = null;
        _hasInput = true;
        _convertedValue = _calculateConversion(parsed, _fromUnit, _toUnit);
      });
    }
  }

  double _calculateConversion(double value, String from, String to) {
    if (from == to) return value;
    final factorFrom = _factors[from]!;
    final factorTo = _factors[to]!;
    final baseValue = value * factorFrom;
    return baseValue / factorTo;
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _onInputChanged(); // Trigger recalculation
    });
  }

  void _applyPreset(double value) {
    String formattedValue = value.toString();
    if (formattedValue.endsWith('.0')) {
      formattedValue = formattedValue.substring(0, formattedValue.length - 2);
    }
    _inputController.text = formattedValue;
    _inputFocusNode.unfocus();
  }

  void _saveCurrentCalculation() {
    final value = double.tryParse(_inputController.text);
    if (value == null || !_hasInput) return;

    final label = _labelController.text.trim().isNotEmpty
        ? _labelController.text.trim()
        : 'Calculation #${_savedCalculations.where((c) => c.category == widget.category).length + 1}';

    setState(() {
      _savedCalculations.insert(
        0,
        SavedCalculation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          label: label,
          value: value,
          fromUnit: _fromUnit,
          toUnit: _toUnit,
          result: _convertedValue,
          category: widget.category,
          timestamp: DateTime.now(),
        ),
      );
      _labelController.clear();
      _inputFocusNode.unfocus();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved: "$label"'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _editLabel(SavedCalculation item) {
    final controller = TextEditingController(text: item.label);
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Edit Description', style: theme.textTheme.titleLarge),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Description Label',
              hintText: 'e.g. Plot boundary line',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    item.label = controller.text.trim();
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(String id) {
    setState(() {
      _savedCalculations.removeWhere((item) => item.id == id);
    });
  }

  void _clearAllCategoryHistory() {
    setState(() {
      _savedCalculations.removeWhere((item) => item.category == widget.category);
    });
  }

  String _getFormulaDescription() {
    if (widget.category == ConversionCategory.area) {
      if (_fromUnit == 'Kanal' && _toUnit == 'Marla') {
        return 'Formula: 1 Kanal = 20 Marla. Multiply Kanal value by 20.';
      }
      if (_fromUnit == 'Marla' && _toUnit == 'Kanal') {
        return 'Formula: 1 Kanal = 20 Marla. Divide Marla value by 20.';
      }
      if (_fromUnit == 'Marla' && _toUnit == 'Square Feet') {
        return 'Formula: 1 Marla = 225 Square Feet. Multiply Marla value by 225.';
      }
      if (_fromUnit == 'Square Feet' && _toUnit == 'Marla') {
        return 'Formula: 1 Marla = 225 Square Feet. Divide Square Feet value by 225.';
      }
      if (_fromUnit == 'Kanal' && _toUnit == 'Square Feet') {
        return 'Formula: 1 Kanal = 20 Marla = 4,500 Square Feet. Multiply Kanal value by 4,500.';
      }
      if (_fromUnit == 'Square Feet' && _toUnit == 'Kanal') {
        return 'Formula: 1 Kanal = 20 Marla = 4,500 Square Feet. Divide Square Feet value by 4,500.';
      }
      return 'Formula: Convert $_fromUnit to Base Unit (Sq Ft) using factor ${_factors[_fromUnit]}, then convert to $_toUnit using factor ${_factors[_toUnit]}.';
    } else {
      if (_fromUnit == 'Yards' && _toUnit == 'Feet') {
        return 'Formula: 1 Yard = 3 Feet. Multiply Yards by 3.';
      }
      if (_fromUnit == 'Feet' && _toUnit == 'Yards') {
        return 'Formula: 1 Yard = 3 Feet. Divide Feet by 3.';
      }
      if (_fromUnit == 'Feet' && _toUnit == 'Inches') {
        return 'Formula: 1 Foot = 12 Inches. Multiply Feet by 12.';
      }
      if (_fromUnit == 'Inches' && _toUnit == 'Feet') {
        return 'Formula: 1 Foot = 12 Inches. Divide Inches by 12.';
      }
      if (_fromUnit == 'Meters' && _toUnit == 'Centimeters') {
        return 'Formula: 1 Meter = 100 Centimeters. Multiply Meters by 100.';
      }
      if (_fromUnit == 'Centimeters' && _toUnit == 'Meters') {
        return 'Formula: 1 Meter = 100 Centimeters. Divide Centimeters by 100.';
      }
      return 'Formula: Convert $_fromUnit to Base Unit (Feet) using factor ${_factors[_fromUnit]}, then convert to $_toUnit using factor ${_factors[_toUnit]}.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Grid background representing engineering drafting sheets
        Positioned.fill(
          child: CustomPaint(
            painter: GridBackgroundPainter(
              gridColor: isDarkMode
                  ? Colors.teal.withValues(alpha: 0.02)
                  : Colors.teal.withValues(alpha: 0.04),
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;
              final maxContentWidth = isWide ? 850.0 : double.infinity;

              return Center(
                child: Container(
                  width: maxContentWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        // Top Badge / Header Card
                        _buildCategoryHeaderCard(theme),
                        const SizedBox(height: 16),

                        // Form & Conversion Logic block
                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: _buildConverterInputsCard(theme)),
                                  const SizedBox(width: 16),
                                  Expanded(flex: 4, child: _buildResultsCard(theme)),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildConverterInputsCard(theme),
                                  const SizedBox(height: 16),
                                  _buildResultsCard(theme),
                                ],
                              ),

                        const SizedBox(height: 16),
                        // Quick Reference / Cheat Sheet Card
                        _buildCheatSheetCard(theme),

                        const SizedBox(height: 16),
                        // Saved Calculations History list with edit and delete options
                        _buildSavedHistoryCard(theme),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryHeaderCard(ThemeData theme) {
    final isArea = widget.category == ConversionCategory.area;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 1.5),
      ),
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isArea ? Icons.layers : Icons.straighten,
                color: theme.colorScheme.onPrimary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArea ? 'Land Area Calculator' : 'Dimensional Length Calculator',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArea
                        ? 'Convert local mapping units (Marla, Kanal) to international standards.'
                        : 'Translate between imperial measurements and metric structures.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConverterInputsCard(ThemeData theme) {
    final isArea = widget.category == ConversionCategory.area;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CONVERSION PARAMETERS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.0,
                color: theme.colorScheme.primary,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 10),

            // Dropdowns (From & To)
            LayoutBuilder(
              builder: (context, dropdownConstraints) {
                final isDropdownWide = dropdownConstraints.maxWidth > 400;

                Widget fromDropdown = _buildDropdown(
                  label: 'FROM UNIT',
                  value: _fromUnit,
                  items: _units,
                  onChanged: (val) {
                    setState(() {
                      _fromUnit = val!;
                      _onInputChanged();
                    });
                  },
                  theme: theme,
                );

                Widget toDropdown = _buildDropdown(
                  label: 'TO UNIT',
                  value: _toUnit,
                  items: _units,
                  onChanged: (val) {
                    setState(() {
                      _toUnit = val!;
                      _onInputChanged();
                    });
                  },
                  theme: theme,
                );

                Widget swapButton = Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.secondary, width: 1.5),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isDropdownWide ? Icons.swap_horiz : Icons.swap_vert,
                        color: theme.colorScheme.primary,
                      ),
                      tooltip: 'Swap Units',
                      onPressed: _swapUnits,
                    ),
                  ),
                );

                if (isDropdownWide) {
                  return Row(
                    children: [
                      Expanded(child: fromDropdown),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: swapButton,
                      ),
                      Expanded(child: toDropdown),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      fromDropdown,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: swapButton,
                      ),
                      toDropdown,
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // Input Field
            Text(
              'ENTER VALUE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 0.8,
                color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _inputController,
              focusNode: _inputFocusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.edit_road, color: theme.colorScheme.primary),
                suffixIcon: _inputController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _inputController.clear();
                        },
                      )
                    : null,
                hintText: 'e.g. 10.5',
                errorText: _errorMessage,
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.black26
                    : Colors.grey.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Presets/Quick Toggle Buttons
            Text(
              'QUICK PRESETS (${isArea ? "Marla/Kanal" : "Feet"})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 0.8,
                color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets.map((preset) {
                String label;
                if (isArea) {
                  if (preset == 20.0) {
                    label = '1 Kanal (20 Marla)';
                  } else {
                    label = '${preset.toInt()} Marla';
                  }
                } else {
                  label = '${preset.toInt()} Ft';
                }

                return ActionChip(
                  label: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                  side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  onPressed: () {
                    if (isArea && preset == 20.0) {
                      setState(() {
                        _fromUnit = 'Kanal';
                      });
                      _applyPreset(1.0);
                    } else {
                      if (isArea) {
                        setState(() {
                          _fromUnit = 'Marla';
                        });
                      } else {
                        setState(() {
                          _fromUnit = 'Feet';
                        });
                      }
                      _applyPreset(preset);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),
            // Convert Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  _onInputChanged();
                  _inputFocusNode.unfocus();
                  if (_hasInput) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Calculated: ${_inputController.text} $_fromUnit = ${_convertedValue.toStringAsFixed(4)} $_toUnit',
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.calculate),
                label: const Text(
                  'CONVERT NOW',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 0.8,
            color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.4),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
              style: TextStyle(
                color: theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              items: items.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsCard(ThemeData theme) {
    final double value = double.tryParse(_inputController.text) ?? 0.0;
    final String formattedResult = _hasInput ? _convertedValue.toStringAsFixed(4) : '0.0000';
    String displayResult = formattedResult;
    if (_hasInput && displayResult.contains('.')) {
      while (displayResult.endsWith('0')) {
        displayResult = displayResult.substring(0, displayResult.length - 1);
      }
      if (displayResult.endsWith('.')) {
        displayResult = displayResult.substring(0, displayResult.length - 1);
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.secondary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'REAL-TIME RESULT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.0,
                color: theme.colorScheme.secondary,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 10),

            // Big calculation box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.black45
                    : Colors.grey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _hasInput ? '$value $_fromUnit =' : 'ENTER INPUT',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    displayResult,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _toUnit,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.secondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Live formula representation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getFormulaDescription(),
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                        color: theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Custom Label TextField (Optional Description for History Saving)
            Text(
              'MEASUREMENT TAG (OPTIONAL)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.8,
                color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                hintText: 'e.g. West wall, Main plot',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // Save to History Button
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton.icon(
                onPressed: _hasInput ? _saveCurrentCalculation : null,
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                label: const Text(
                  'SAVE TO HISTORY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: _hasInput
                        ? theme.colorScheme.primary
                        : theme.disabledColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheatSheetCard(ThemeData theme) {
    final isArea = widget.category == ConversionCategory.area;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grid_on, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  isArea ? 'LAND AREA QUICK REFERENCE SHEET' : 'LENGTH QUICK REFERENCE SHEET',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 8),

            isArea
                ? _buildAreaTable(theme)
                : _buildLengthTable(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaTable(ThemeData theme) {
    return Table(
      border: TableBorder.all(
        color: theme.dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
      },
      children: [
        _buildTableRowHeader(theme, ['Unit', 'Value in Sq Feet', 'Relative Proportion']),
        _buildTableRow(theme, ['1 Kanal', '4,500 Sq Ft', '20 Marla']),
        _buildTableRow(theme, ['1 Marla', '225 Sq Ft', '1 / 20 Kanal']),
        _buildTableRow(theme, ['1 Sq Yard', '9.0 Sq Ft', '0.04 Marla']),
        _buildTableRow(theme, ['1 Sq Meter', '10.7639 Sq Ft', '0.0478 Marla']),
        _buildTableRow(theme, ['1 Sq Foot', '1.0 Sq Ft', '1 / 225 Marla']),
      ],
    );
  }

  Widget _buildLengthTable(ThemeData theme) {
    return Table(
      border: TableBorder.all(
        color: theme.dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
      },
      children: [
        _buildTableRowHeader(theme, ['Unit', 'Value in Feet', 'Metric Standard']),
        _buildTableRow(theme, ['1 Yard', '3.0 Feet', '0.9144 Meters']),
        _buildTableRow(theme, ['1 Meter', '3.2808 Feet', '1.0 Meter']),
        _buildTableRow(theme, ['1 Foot', '1.0 Foot', '0.3048 Meters']),
        _buildTableRow(theme, ['1 Inch', '0.0833 Feet', '2.54 Centimeters']),
        _buildTableRow(theme, ['1 Centimeter', '0.0328 Feet', '0.01 Meters']),
      ],
    );
  }

  TableRow _buildTableRowHeader(ThemeData theme, List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
      ),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            cell,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildTableRow(ThemeData theme, List<String> cells) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            cell,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  /// History section card containing the saved items with Edit and Delete options.
  Widget _buildSavedHistoryCard(ThemeData theme) {
    final categoryItems = _savedCalculations.where((item) => item.category == widget.category).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'SAVED CALCULATIONS HISTORY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                if (categoryItems.isNotEmpty)
                  TextButton.icon(
                    onPressed: _clearAllCategoryHistory,
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('CLEAR ALL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red[400],
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            if (categoryItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.history_toggle_off, size: 40, color: theme.disabledColor),
                      const SizedBox(height: 8),
                      Text(
                        'No calculations saved in this category yet.',
                        style: TextStyle(color: theme.disabledColor, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter a value and tap "SAVE TO HISTORY" to persist.',
                        style: TextStyle(color: theme.disabledColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryItems.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = categoryItems[index];

                  String formattedVal = item.value.toStringAsFixed(4);
                  if (formattedVal.contains('.')) {
                    while (formattedVal.endsWith('0')) {
                      formattedVal = formattedVal.substring(0, formattedVal.length - 1);
                    }
                    if (formattedVal.endsWith('.')) {
                      formattedVal = formattedVal.substring(0, formattedVal.length - 1);
                    }
                  }

                  String formattedRes = item.result.toStringAsFixed(4);
                  if (formattedRes.contains('.')) {
                    while (formattedRes.endsWith('0')) {
                      formattedRes = formattedRes.substring(0, formattedRes.length - 1);
                    }
                    if (formattedRes.endsWith('.')) {
                      formattedRes = formattedRes.substring(0, formattedRes.length - 1);
                    }
                  }

                  final String timeString =
                      '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Text(
                          timeString,
                          style: TextStyle(fontSize: 11, color: theme.disabledColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '$formattedVal ${item.fromUnit} = $formattedRes ${item.toUnit}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'Edit Tag Description',
                          onPressed: () => _editLabel(item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 18, color: Colors.red[300]),
                          tooltip: 'Delete Entry',
                          onPressed: () => _deleteItem(item.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
