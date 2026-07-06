import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ForexCalculatorApp());
}

class ForexCalculatorApp extends StatefulWidget {
  const ForexCalculatorApp({Key? key}) : super(key: key);

  @override
  State<ForexCalculatorApp> createState() => _ForexCalculatorAppState();
}

class _ForexCalculatorAppState extends State<ForexCalculatorApp> {
  int _selectedThemeIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedThemeIndex = prefs.getInt('selectedTheme') ?? 0;
    });
  }

  Future<void> _saveTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTheme', index);
  }

  void _changeTheme(int index) {
    setState(() {
      _selectedThemeIndex = index;
    });
    _saveTheme(index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forex Calculator',
      theme: AppThemes.getTheme(_selectedThemeIndex),
      home: ForexCalculatorHome(
        onThemeChanged: _changeTheme,
        currentThemeIndex: _selectedThemeIndex,
      ),
    );
  }
}

class AppThemes {
  static final themes = [
    // Theme 0: Dark Navy & Gold
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF1A3A52),
        secondary: const Color(0xFFD4AF37),
        surface: const Color(0xFF0F1419),
        background: const Color(0xFF0F1419),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A3A52),
        elevation: 0,
      ),
    ),
    // Theme 1: Light Blue & White
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF4A90E2),
        secondary: const Color(0xFF50E3C2),
        surface: const Color(0xFFF5F7FA),
        background: const Color(0xFFFFFFFF),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4A90E2),
        elevation: 0,
      ),
    ),
    // Theme 2: Dark Green & Lime
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF1B5E20),
        secondary: const Color(0xFF76FF03),
        surface: const Color(0xFF0D3410),
        background: const Color(0xFF0D3410),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1B5E20),
        elevation: 0,
      ),
    ),
    // Theme 3: Purple & Neon
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF6A1B9A),
        secondary: const Color(0xFF00E5FF),
        surface: const Color(0xFF2D1B4E),
        background: const Color(0xFF2D1B4E),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6A1B9A),
        elevation: 0,
      ),
    ),
    // Theme 4: Dark/Black & Cyan
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF000000),
        secondary: const Color(0xFF00BCD4),
        surface: const Color(0xFF1A1A1A),
        background: const Color(0xFF000000),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF000000),
        elevation: 0,
      ),
    ),
  ];

  static ThemeData getTheme(int index) => themes[index.clamp(0, themes.length - 1)];
}

class ForexCalculatorHome extends StatefulWidget {
  final Function(int) onThemeChanged;
  final int currentThemeIndex;

  const ForexCalculatorHome({
    Key? key,
    required this.onThemeChanged,
    required this.currentThemeIndex,
  }) : super(key: key);

  @override
  State<ForexCalculatorHome> createState() => _ForexCalculatorHomeState();
}

class _ForexCalculatorHomeState extends State<ForexCalculatorHome> with TickerProviderStateMixin {
  int _selectedCalculatorIndex = 0;

  final calculators = [
    'Pip Value',
    'Position Size',
    'Margin',
    'Leverage',
    'P&L',
    'Risk/Reward',
    'Swap',
    'Currency Convert',
    'Pivot Points',
    'Fibonacci',
    'Compound Growth',
  ];

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _selectCalculator(int index) {
    setState(() {
      _selectedCalculatorIndex = index;
      _fadeController.reset();
      _fadeController.forward();
    });
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Theme',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                final themeNames = [
                  'Navy & Gold',
                  'Blue & White',
                  'Green & Lime',
                  'Purple & Neon',
                  'Black & Cyan',
                ];
                final colors = [
                  [const Color(0xFF1A3A52), const Color(0xFFD4AF37)],
                  [const Color(0xFF4A90E2), const Color(0xFF50E3C2)],
                  [const Color(0xFF1B5E20), const Color(0xFF76FF03)],
                  [const Color(0xFF6A1B9A), const Color(0xFF00E5FF)],
                  [const Color(0xFF000000), const Color(0xFF00BCD4)],
                ];

                return GestureDetector(
                  onTap: () {
                    widget.onThemeChanged(index);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.currentThemeIndex == index
                            ? Colors.white
                            : Colors.grey,
                        width: widget.currentThemeIndex == index ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: colors[index][0] as Color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: colors[index][1] as Color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          themeNames[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forex Calculator',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: _showThemePicker,
            tooltip: 'Change Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    calculators.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(calculators[index]),
                        selected: _selectedCalculatorIndex == index,
                        onSelected: (_) => _selectCalculator(index),
                        labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: _selectedCalculatorIndex == index
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeController,
              child: _buildCalculator(_selectedCalculatorIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculator(int index) {
    switch (index) {
      case 0:
        return const PipValueCalculator();
      case 1:
        return const PositionSizeCalculator();
      case 2:
        return const MarginCalculator();
      case 3:
        return const LeverageCalculator();
      case 4:
        return const PnLCalculator();
      case 5:
        return const RiskRewardCalculator();
      case 6:
        return const SwapCalculator();
      case 7:
        return const CurrencyConverterCalculator();
      case 8:
        return const PivotPointsCalculator();
      case 9:
        return const FibonacciCalculator();
      case 10:
        return const CompoundGrowthCalculator();
      default:
        return const SizedBox.shrink();
    }
  }
}

class CalculatorBase extends StatefulWidget {
  final String title;
  const CalculatorBase({Key? key, required this.title}) : super(key: key);

  @override
  State<CalculatorBase> createState() => CalculatorBaseState();
}

class CalculatorBaseState extends State<CalculatorBase> {
  Map<String, TextEditingController> controllers = {};
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this as TickerProvider,
    );
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    resultAnimationController.dispose();
    super.dispose();
  }

  void showResult(String value) {
    setState(() {
      result = value;
      resultAnimationController.reset();
      resultAnimationController.forward();
    });
  }

  void clearAll() {
    for (var controller in controllers.values) {
      controller.clear();
    }
    setState(() {
      result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class PipValueCalculator extends StatefulWidget {
  const PipValueCalculator({Key? key}) : super(key: key);

  @override
  State<PipValueCalculator> createState() => _PipValueCalculatorState();
}

class _PipValueCalculatorState extends State<PipValueCalculator> with TickerProviderStateMixin {
  late TextEditingController lotSizeController;
  late TextEditingController pairController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    lotSizeController = TextEditingController();
    pairController = TextEditingController(text: 'EURUSD');
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    lotSizeController.dispose();
    pairController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double lotSize = double.parse(lotSizeController.text);
      String pair = pairController.text.toUpperCase();

      // Pip value formula: for most pairs, 1 standard lot (100,000 units) = 10 USD per pip
      // For JPY pairs, it's different
      double pipValue = pair.contains('JPY') ? (lotSize * 1000) / 100 : (lotSize * 10);

      setState(() {
        result = NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(pipValue);
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Lot Size', controller: lotSizeController, hint: '1.0'),
          _InputField(label: 'Currency Pair', controller: pairController, hint: 'EURUSD'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  lotSizeController.clear();
                  pairController.text = 'EURUSD';
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Pip Value',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PositionSizeCalculator extends StatefulWidget {
  const PositionSizeCalculator({Key? key}) : super(key: key);

  @override
  State<PositionSizeCalculator> createState() => _PositionSizeCalculatorState();
}

class _PositionSizeCalculatorState extends State<PositionSizeCalculator> with TickerProviderStateMixin {
  late TextEditingController balanceController;
  late TextEditingController riskController;
  late TextEditingController stopLossController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    balanceController = TextEditingController();
    riskController = TextEditingController();
    stopLossController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    balanceController.dispose();
    riskController.dispose();
    stopLossController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double balance = double.parse(balanceController.text);
      double riskPercent = double.parse(riskController.text);
      double stopLossPips = double.parse(stopLossController.text);

      double riskAmount = (balance * riskPercent) / 100;
      double lotSize = riskAmount / (stopLossPips * 10);

      setState(() {
        result = lotSize.toStringAsFixed(2);
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Account Balance (\$)', controller: balanceController, hint: '10000'),
          _InputField(label: 'Risk %', controller: riskController, hint: '2'),
          _InputField(label: 'Stop Loss (pips)', controller: stopLossController, hint: '50'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  balanceController.clear();
                  riskController.clear();
                  stopLossController.clear();
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Lot Size',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MarginCalculator extends StatefulWidget {
  const MarginCalculator({Key? key}) : super(key: key);

  @override
  State<MarginCalculator> createState() => _MarginCalculatorState();
}

class _MarginCalculatorState extends State<MarginCalculator> with TickerProviderStateMixin {
  late TextEditingController lotSizeController;
  late TextEditingController leverageController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    lotSizeController = TextEditingController();
    leverageController = TextEditingController(text: '100');
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    lotSizeController.dispose();
    leverageController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double lotSize = double.parse(lotSizeController.text);
      double leverage = double.parse(leverageController.text);

      // 1 standard lot = 100,000 units at ~1.10 per unit = 110,000
      // Margin = (lot size * 100000 * 1.1) / leverage
      double margin = (lotSize * 100000 * 1.1) / leverage;

      setState(() {
        result = NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(margin);
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Lot Size', controller: lotSizeController, hint: '1.0'),
          _InputField(label: 'Leverage', controller: leverageController, hint: '100'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  lotSizeController.clear();
                  leverageController.text = '100';
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Required Margin',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LeverageCalculator extends StatefulWidget {
  const LeverageCalculator({Key? key}) : super(key: key);

  @override
  State<LeverageCalculator> createState() => _LeverageCalculatorState();
}

class _LeverageCalculatorState extends State<LeverageCalculator> with TickerProviderStateMixin {
  late TextEditingController balanceController;
  late TextEditingController positionController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    balanceController = TextEditingController();
    positionController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    balanceController.dispose();
    positionController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double balance = double.parse(balanceController.text);
      double position = double.parse(positionController.text);

      double leverage = position / balance;

      setState(() {
        result = '${leverage.toStringAsFixed(2)}x';
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Account Balance (\$)', controller: balanceController, hint: '10000'),
          _InputField(label: 'Position Size (\$)', controller: positionController, hint: '100000'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  balanceController.clear();
                  positionController.clear();
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Effective Leverage',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PnLCalculator extends StatefulWidget {
  const PnLCalculator({Key? key}) : super(key: key);

  @override
  State<PnLCalculator> createState() => _PnLCalculatorState();
}

class _PnLCalculatorState extends State<PnLCalculator> with TickerProviderStateMixin {
  late TextEditingController entryController;
  late TextEditingController exitController;
  late TextEditingController lotSizeController;
  String _direction = 'Buy';
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    entryController = TextEditingController();
    exitController = TextEditingController();
    lotSizeController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    entryController.dispose();
    exitController.dispose();
    lotSizeController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double entry = double.parse(entryController.text);
      double exit = double.parse(exitController.text);
      double lotSize = double.parse(lotSizeController.text);

      double priceDifference = (_direction == 'Buy') ? (exit - entry) : (entry - exit);
      double pnl = priceDifference * lotSize * 100000;

      setState(() {
        result = NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(pnl);
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Entry Price', controller: entryController, hint: '1.1000'),
          _InputField(label: 'Exit Price', controller: exitController, hint: '1.1100'),
          _InputField(label: 'Lot Size', controller: lotSizeController, hint: '1.0'),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Direction: '),
              const SizedBox(width: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(label: Text('Buy'), value: 'Buy'),
                  ButtonSegment(label: Text('Sell'), value: 'Sell'),
                ],
                selected: {_direction},
                onSelectionChanged: (value) {
                  setState(() => _direction = value.first);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  entryController.clear();
                  exitController.clear();
                  lotSizeController.clear();
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Profit / Loss',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RiskRewardCalculator extends StatefulWidget {
  const RiskRewardCalculator({Key? key}) : super(key: key);

  @override
  State<RiskRewardCalculator> createState() => _RiskRewardCalculatorState();
}

class _RiskRewardCalculatorState extends State<RiskRewardCalculator> with TickerProviderStateMixin {
  late TextEditingController entryController;
  late TextEditingController stopLossController;
  late TextEditingController takeProfitController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    entryController = TextEditingController();
    stopLossController = TextEditingController();
    takeProfitController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    entryController.dispose();
    stopLossController.dispose();
    takeProfitController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double entry = double.parse(entryController.text);
      double stopLoss = double.parse(stopLossController.text);
      double takeProfit = double.parse(takeProfitController.text);

      double risk = (entry - stopLoss).abs();
      double reward = (takeProfit - entry).abs();

      double ratio = reward / risk;

      setState(() {
        result = '1:${ratio.toStringAsFixed(2)}';
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Entry Price', controller: entryController, hint: '1.1000'),
          _InputField(label: 'Stop Loss', controller: stopLossController, hint: '1.0950'),
          _InputField(label: 'Take Profit', controller: takeProfitController, hint: '1.1100'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  entryController.clear();
                  stopLossController.clear();
                  takeProfitController.clear();
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Risk/Reward Ratio',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SwapCalculator extends StatefulWidget {
  const SwapCalculator({Key? key}) : super(key: key);

  @override
  State<SwapCalculator> createState() => _SwapCalculatorState();
}

class _SwapCalculatorState extends State<SwapCalculator> with TickerProviderStateMixin {
  late TextEditingController lotSizeController;
  late TextEditingController swapRateController;
  late TextEditingController nightsController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    lotSizeController = TextEditingController();
    swapRateController = TextEditingController();
    nightsController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    lotSizeController.dispose();
    swapRateController.dispose();
    nightsController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double lotSize = double.parse(lotSizeController.text);
      double swapRate = double.parse(swapRateController.text);
      double nights = double.parse(nightsController.text);

      double totalSwap = (lotSize * 100000 * swapRate / 10000) * nights;

      setState(() {
        result = NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(totalSwap);
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Lot Size', controller: lotSizeController, hint: '1.0'),
          _InputField(label: 'Swap Rate', controller: swapRateController, hint: '0.5'),
          _InputField(label: 'Number of Nights', controller: nightsController, hint: '1'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  lotSizeController.clear();
                  swapRateController.clear();
                  nightsController.clear();
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Total Swap Cost/Credit',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CurrencyConverterCalculator extends StatefulWidget {
  const CurrencyConverterCalculator({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterCalculator> createState() => _CurrencyConverterCalculatorState();
}

class _CurrencyConverterCalculatorState extends State<CurrencyConverterCalculator> with TickerProviderStateMixin {
  late TextEditingController amountController;
  late TextEditingController rateController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    rateController = TextEditingController(text: '1.0');
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    rateController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double amount = double.parse(amountController.text);
      double rate = double.parse(rateController.text);

      double converted = amount * rate;

      setState(() {
        result = converted.toStringAsFixed(2);
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Amount', controller: amountController, hint: '1000'),
          _InputField(label: 'Exchange Rate', controller: rateController, hint: '1.1200'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  amountController.clear();
                  rateController.text = '1.0';
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Converted Amount',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PivotPointsCalculator extends StatefulWidget {
  const PivotPointsCalculator({Key? key}) : super(key: key);

  @override
  State<PivotPointsCalculator> createState() => _PivotPointsCalculatorState();
}

class _PivotPointsCalculatorState extends State<PivotPointsCalculator> with TickerProviderStateMixin {
  late TextEditingController highController;
  late TextEditingController lowController;
  late TextEditingController closeController;
  Map<String, String>? results;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    highController = TextEditingController();
    lowController = TextEditingController();
    closeController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    highController.dispose();
    lowController.dispose();
    closeController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double high = double.parse(highController.text);
      double low = double.parse(lowController.text);
      double close = double.parse(closeController.text);

      double pivot = (high + low + close) / 3;
      double r1 = (2 * pivot) - low;
      double r2 = pivot + (high - low);
      double r3 = r1 + (high - low);
      double s1 = (2 * pivot) - high;
      double s2 = pivot - (high - low);
      double s3 = s1 - (high - low);

      setState(() {
        results = {
          'Pivot': pivot.toStringAsFixed(5),
          'R1': r1.toStringAsFixed(5),
          'R2': r2.toStringAsFixed(5),
          'R3': r3.toStringAsFixed(5),
          'S1': s1.toStringAsFixed(5),
          'S2': s2.toStringAsFixed(5),
          'S3': s3.toStringAsFixed(5),
        };
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'High (Previous Day)', controller: highController, hint: '1.1200'),
          _InputField(label: 'Low (Previous Day)', controller: lowController, hint: '1.1000'),
          _InputField(label: 'Close (Previous Day)', controller: closeController, hint: '1.1100'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  highController.clear();
                  lowController.clear();
                  closeController.clear();
                  setState(() => results = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (results != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _PivotResultsCard(results: results!),
            ),
          ],
        ],
      ),
    );
  }
}

class FibonacciCalculator extends StatefulWidget {
  const FibonacciCalculator({Key? key}) : super(key: key);

  @override
  State<FibonacciCalculator> createState() => _FibonacciCalculatorState();
}

class _FibonacciCalculatorState extends State<FibonacciCalculator> with TickerProviderStateMixin {
  late TextEditingController highController;
  late TextEditingController lowController;
  Map<String, String>? results;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    highController = TextEditingController();
    lowController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    highController.dispose();
    lowController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double high = double.parse(highController.text);
      double low = double.parse(lowController.text);
      double range = high - low;

      setState(() {
        results = {
          '0%': high.toStringAsFixed(5),
          '23.6%': (high - (range * 0.236)).toStringAsFixed(5),
          '38.2%': (high - (range * 0.382)).toStringAsFixed(5),
          '50%': (high - (range * 0.5)).toStringAsFixed(5),
          '61.8%': (high - (range * 0.618)).toStringAsFixed(5),
          '78.6%': (high - (range * 0.786)).toStringAsFixed(5),
          '100%': low.toStringAsFixed(5),
        };
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Swing High', controller: highController, hint: '1.1200'),
          _InputField(label: 'Swing Low', controller: lowController, hint: '1.1000'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  highController.clear();
                  lowController.clear();
                  setState(() => results = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (results != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _FibonacciResultsCard(results: results!),
            ),
          ],
        ],
      ),
    );
  }
}

class CompoundGrowthCalculator extends StatefulWidget {
  const CompoundGrowthCalculator({Key? key}) : super(key: key);

  @override
  State<CompoundGrowthCalculator> createState() => _CompoundGrowthCalculatorState();
}

class _CompoundGrowthCalculatorState extends State<CompoundGrowthCalculator> with TickerProviderStateMixin {
  late TextEditingController startingBalanceController;
  late TextEditingController returnPercentController;
  late TextEditingController periodsController;
  String? result;
  late AnimationController resultAnimationController;

  @override
  void initState() {
    super.initState();
    startingBalanceController = TextEditingController();
    returnPercentController = TextEditingController();
    periodsController = TextEditingController();
    resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    startingBalanceController.dispose();
    returnPercentController.dispose();
    periodsController.dispose();
    resultAnimationController.dispose();
    super.dispose();
  }

  void calculate() {
    try {
      double startingBalance = double.parse(startingBalanceController.text);
      double returnPercent = double.parse(returnPercentController.text);
      double periods = double.parse(periodsController.text);

      double finalBalance = startingBalance * (pow(1 + (returnPercent / 100), periods) as double);
      double growth = finalBalance - startingBalance;

      setState(() {
        result = 'Final: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(finalBalance)}\nGrowth: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(growth)}';
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _InputField(label: 'Starting Balance (\$)', controller: startingBalanceController, hint: '10000'),
          _InputField(label: 'Return % per Period', controller: returnPercentController, hint: '5'),
          _InputField(label: 'Number of Periods', controller: periodsController, hint: '12'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  startingBalanceController.clear();
                  returnPercentController.clear();
                  periodsController.clear();
                  setState(() => result = null);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
              ),
              child: _ResultCard(
                title: 'Compound Growth',
                value: result!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Helper widgets
class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _InputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String value;

  const _ResultCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PivotResultsCard extends StatelessWidget {
  final Map<String, String> results;

  const _PivotResultsCard({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Pivot Points',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            ...results.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: GoogleFonts.poppins(fontSize: 12)),
                  Text(e.value, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _FibonacciResultsCard extends StatelessWidget {
  final Map<String, String> results;

  const _FibonacciResultsCard({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Fibonacci Levels',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            ...results.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: GoogleFonts.poppins(fontSize: 12)),
                  Text(e.value, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
