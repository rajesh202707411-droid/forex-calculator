import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ForexCalculatorApp());
}

// Professional Color Themes
class AppColors {
  // Theme 1: Dark Navy & Gold
  static const theme1Primary = Color(0xFFCFBCFF);
  static const theme1Secondary = Color(0xFFE7C365);
  static const theme1Surface = Color(0xFF141218);
  static const theme1SurfaceContainer = Color(0xFF211F24);

  // Theme 2: Light Blue & White
  static const theme2Primary = Color(0xFF0D47A1);
  static const theme2Secondary = Color(0xFF1976D2);
  static const theme2Surface = Color(0xFFF5F5F5);
  static const theme2SurfaceContainer = Color(0xFFFFFFFF);

  // Theme 3: Dark Green & Lime
  static const theme3Primary = Color(0xFF4CAF50);
  static const theme3Secondary = Color(0xFF8BC34A);
  static const theme3Surface = Color(0xFF1B5E20);
  static const theme3SurfaceContainer = Color(0xFF2E7D32);

  // Theme 4: Purple & Neon
  static const theme4Primary = Color(0xFF9C27B0);
  static const theme4Secondary = Color(0xFF00E676);
  static const theme4Surface = Color(0xFF1A0033);
  static const theme4SurfaceContainer = Color(0xFF2D0052);

  // Theme 5: Black & Cyan
  static const theme5Primary = Color(0xFF00BCD4);
  static const theme5Secondary = Color(0xFF00E5FF);
  static const theme5Surface = Color(0xFF000000);
  static const theme5SurfaceContainer = Color(0xFF1A1A1A);
}

class ForexCalculatorApp extends StatefulWidget {
  const ForexCalculatorApp({Key? key}) : super(key: key);

  @override
  State<ForexCalculatorApp> createState() => _ForexCalculatorAppState();
}

class _ForexCalculatorAppState extends State<ForexCalculatorApp> {
  int _selectedThemeIndex = 0;
  int _selectedCalculator = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedThemeIndex = prefs.getInt('selectedTheme') ?? 0;
      _selectedCalculator = prefs.getInt('selectedCalculator') ?? 0;
    });
  }

  Future<void> _saveTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTheme', index);
  }

  ThemeData _getTheme(int themeIndex) {
    final themes = [
      _buildTheme(AppColors.theme1Primary, AppColors.theme1Secondary, AppColors.theme1Surface, AppColors.theme1SurfaceContainer),
      _buildTheme(AppColors.theme2Primary, AppColors.theme2Secondary, AppColors.theme2Surface, AppColors.theme2SurfaceContainer),
      _buildTheme(AppColors.theme3Primary, AppColors.theme3Secondary, AppColors.theme3Surface, AppColors.theme3SurfaceContainer),
      _buildTheme(AppColors.theme4Primary, AppColors.theme4Secondary, AppColors.theme4Surface, AppColors.theme4SurfaceContainer),
      _buildTheme(AppColors.theme5Primary, AppColors.theme5Secondary, AppColors.theme5Surface, AppColors.theme5SurfaceContainer),
    ];
    return themes[themeIndex % themes.length];
  }

  ThemeData _buildTheme(Color primary, Color secondary, Color surface, Color surfaceContainer) {
    return ThemeData(
      useMaterial3: true,
      brightness: surface.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
      colorScheme: ColorScheme(
        brightness: surface.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: surface.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
        background: surface,
        onBackground: surface.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ForexPro Calc',
      theme: _getTheme(_selectedThemeIndex),
      home: ForexCalculatorHome(
        selectedTheme: _selectedThemeIndex,
        onThemeChanged: (index) {
          setState(() => _selectedThemeIndex = index);
          _saveTheme(index);
        },
        selectedCalculator: _selectedCalculator,
        onCalculatorChanged: (index) {
          setState(() => _selectedCalculator = index);
        },
      ),
    );
  }
}

class ForexCalculatorHome extends StatefulWidget {
  final int selectedTheme;
  final Function(int) onThemeChanged;
  final int selectedCalculator;
  final Function(int) onCalculatorChanged;

  const ForexCalculatorHome({
    Key? key,
    required this.selectedTheme,
    required this.onThemeChanged,
    required this.selectedCalculator,
    required this.onCalculatorChanged,
  }) : super(key: key);

  @override
  State<ForexCalculatorHome> createState() => _ForexCalculatorHomeState();
}

class _ForexCalculatorHomeState extends State<ForexCalculatorHome> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> calculatorNames = [
    'Pip Value',
    'Position Size',
    'Margin',
    'Leverage',
    'Profit/Loss',
    'Risk/Reward',
    'Swap',
    'Currency Converter',
    'Pivot Points',
    'Fibonacci',
    'Compound Growth',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(ForexCalculatorHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCalculator != widget.selectedCalculator) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 12, crossAxisSpacing: 12),
          itemCount: 5,
          itemBuilder: (context, index) {
            final colors = [
              [AppColors.theme1Primary, AppColors.theme1Secondary],
              [AppColors.theme2Primary, AppColors.theme2Secondary],
              [AppColors.theme3Primary, AppColors.theme3Secondary],
              [AppColors.theme4Primary, AppColors.theme4Secondary],
              [AppColors.theme5Primary, AppColors.theme5Secondary],
            ];
            return GestureDetector(
              onTap: () {
                widget.onThemeChanged(index);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: widget.selectedTheme == index ? Border.all(color: colors[index][0], width: 3) : null,
                  gradient: LinearGradient(
                    colors: [colors[index][0], colors[index][1]],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.currency_exchange, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'ForexPro Calc',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: _showThemePicker,
            tooltip: 'Change Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calculator Selector
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: calculatorNames.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == widget.selectedCalculator;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(calculatorNames[index]),
                        selected: isSelected,
                        onSelected: (_) {
                          widget.onCalculatorChanged(index);
                        },
                        backgroundColor: isDark ? theme.colorScheme.surface : Colors.grey[200],
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Calculator Content
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildCalculator(widget.selectedCalculator, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculator(int index, ThemeData theme) {
    switch (index) {
      case 0:
        return PipValueCalculator(theme: theme);
      case 1:
        return PositionSizeCalculator(theme: theme);
      case 2:
        return MarginCalculator(theme: theme);
      case 3:
        return LeverageCalculator(theme: theme);
      case 4:
        return ProfitLossCalculator(theme: theme);
      case 5:
        return RiskRewardCalculator(theme: theme);
      case 6:
        return SwapCalculator(theme: theme);
      case 7:
        return CurrencyConverter(theme: theme);
      case 8:
        return PivotPointCalculator(theme: theme);
      case 9:
        return FibonacciCalculator(theme: theme);
      case 10:
        return CompoundGrowthCalculator(theme: theme);
      default:
        return Container();
    }
  }
}

// ==================== CALCULATOR WIDGETS ====================

class PipValueCalculator extends StatefulWidget {
  final ThemeData theme;
  const PipValueCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<PipValueCalculator> createState() => _PipValueCalculatorState();
}

class _PipValueCalculatorState extends State<PipValueCalculator> {
  final _currencyPairController = TextEditingController();
  final _lotSizeController = TextEditingController(text: '1');
  String _selectedCurrency = 'USD';
  String _result = '';

  @override
  void dispose() {
    _currencyPairController.dispose();
    _lotSizeController.dispose();
    super.dispose();
  }

  void _calculate() {
    final lotSize = double.tryParse(_lotSizeController.text) ?? 0;
    if (lotSize <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid lot size')));
      return;
    }

    double pipValue = lotSize * 10;
    setState(() {
      _result = '${_selectedCurrency} ${pipValue.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Pip Value Calculator',
      theme: widget.theme,
      children: [
        TextField(
          controller: _lotSizeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Lot Size',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCurrency,
          items: ['USD', 'EUR', 'GBP', 'JPY'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() => _selectedCurrency = value ?? 'USD'),
          decoration: InputDecoration(
            labelText: 'Account Currency',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pip Value', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text(_result, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class PositionSizeCalculator extends StatefulWidget {
  final ThemeData theme;
  const PositionSizeCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<PositionSizeCalculator> createState() => _PositionSizeCalculatorState();
}

class _PositionSizeCalculatorState extends State<PositionSizeCalculator> {
  final _balanceController = TextEditingController();
  final _riskController = TextEditingController(text: '2');
  final _stoplossController = TextEditingController(text: '50');
  String _result = '';

  @override
  void dispose() {
    _balanceController.dispose();
    _riskController.dispose();
    _stoplossController.dispose();
    super.dispose();
  }

  void _calculate() {
    final balance = double.tryParse(_balanceController.text) ?? 0;
    final riskPercent = double.tryParse(_riskController.text) ?? 0;
    final stoplossPips = double.tryParse(_stoplossController.text) ?? 0;

    if (balance <= 0 || riskPercent <= 0 || stoplossPips <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double positionSize = (balance * riskPercent / 100) / (stoplossPips * 10);
    setState(() {
      _result = positionSize.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Position Size Calculator',
      theme: widget.theme,
      children: [
        TextField(
          controller: _balanceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Account Balance',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _riskController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Risk %',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _stoplossController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Stop Loss (Pips)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recommended Position Size', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text('$_result Lots', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class MarginCalculator extends StatefulWidget {
  final ThemeData theme;
  const MarginCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<MarginCalculator> createState() => _MarginCalculatorState();
}

class _MarginCalculatorState extends State<MarginCalculator> {
  final _lotSizeController = TextEditingController(text: '1');
  final _leverageController = TextEditingController(text: '50');
  String _result = '';

  @override
  void dispose() {
    _lotSizeController.dispose();
    _leverageController.dispose();
    super.dispose();
  }

  void _calculate() {
    final lotSize = double.tryParse(_lotSizeController.text) ?? 0;
    final leverage = double.tryParse(_leverageController.text) ?? 0;

    if (lotSize <= 0 || leverage <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double margin = (lotSize * 100000) / leverage;
    setState(() {
      _result = margin.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Margin Calculator',
      theme: widget.theme,
      children: [
        TextField(
          controller: _lotSizeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Lot Size',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _leverageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Leverage',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Required Margin', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text('USD $_result', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class LeverageCalculator extends StatefulWidget {
  final ThemeData theme;
  const LeverageCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<LeverageCalculator> createState() => _LeverageCalculatorState();
}

class _LeverageCalculatorState extends State<LeverageCalculator> {
  final _balanceController = TextEditingController();
  final _positionController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _balanceController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _calculate() {
    final balance = double.tryParse(_balanceController.text) ?? 0;
    final position = double.tryParse(_positionController.text) ?? 0;

    if (balance <= 0 || position <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double leverage = position / balance;
    setState(() {
      _result = leverage.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Leverage Calculator',
      theme: widget.theme,
      children: [
        TextField(
          controller: _balanceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Account Balance',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _positionController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Position Size',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Effective Leverage', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text('1:$_result', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class ProfitLossCalculator extends StatefulWidget {
  final ThemeData theme;
  const ProfitLossCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<ProfitLossCalculator> createState() => _ProfitLossCalculatorState();
}

class _ProfitLossCalculatorState extends State<ProfitLossCalculator> {
  final _entryController = TextEditingController();
  final _exitController = TextEditingController();
  final _lotController = TextEditingController(text: '1');
  String _tradeType = 'Buy';
  String _result = '';

  @override
  void dispose() {
    _entryController.dispose();
    _exitController.dispose();
    _lotController.dispose();
    super.dispose();
  }

  void _calculate() {
    final entry = double.tryParse(_entryController.text) ?? 0;
    final exit = double.tryParse(_exitController.text) ?? 0;
    final lot = double.tryParse(_lotController.text) ?? 0;

    if (entry <= 0 || exit <= 0 || lot <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double pnl = _tradeType == 'Buy' ? (exit - entry) * lot * 100000 : (entry - exit) * lot * 100000;
    setState(() {
      _result = pnl.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Profit/Loss Calculator',
      theme: widget.theme,
      children: [
        DropdownButtonFormField<String>(
          value: _tradeType,
          items: ['Buy', 'Sell'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() => _tradeType = value ?? 'Buy'),
          decoration: InputDecoration(
            labelText: 'Trade Type',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _entryController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Entry Price',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _exitController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Exit Price',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _lotController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Lot Size',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (double.parse(_result) >= 0 ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('P&L', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text(_result, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: double.parse(_result) >= 0 ? Colors.green : Colors.red)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class RiskRewardCalculator extends StatefulWidget {
  final ThemeData theme;
  const RiskRewardCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<RiskRewardCalculator> createState() => _RiskRewardCalculatorState();
}

class _RiskRewardCalculatorState extends State<RiskRewardCalculator> {
  final _entryController = TextEditingController();
  final _stoplossController = TextEditingController();
  final _takeprofitController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _entryController.dispose();
    _stoplossController.dispose();
    _takeprofitController.dispose();
    super.dispose();
  }

  void _calculate() {
    final entry = double.tryParse(_entryController.text) ?? 0;
    final stoplos = double.tryParse(_stoplossController.text) ?? 0;
    final takeprofit = double.tryParse(_takeprofitController.text) ?? 0;

    if (entry <= 0 || stoplos <= 0 || takeprofit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double risk = (entry - stoplos).abs();
    double reward = (takeprofit - entry).abs();
    double ratio = reward / risk;

    setState(() {
      _result = 'Risk: ${risk.toStringAsFixed(2)} | Reward: ${reward.toStringAsFixed(2)} | Ratio: 1:${ratio.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Risk/Reward Ratio',
      theme: widget.theme,
      children: [
        TextField(
          controller: _entryController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Entry Price',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _stoplossController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Stop Loss Price',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _takeprofitController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Take Profit Price',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Risk/Reward Analysis', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text(_result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class SwapCalculator extends StatefulWidget {
  final ThemeData theme;
  const SwapCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<SwapCalculator> createState() => _SwapCalculatorState();
}

class _SwapCalculatorState extends State<SwapCalculator> {
  final _lotController = TextEditingController(text: '1');
  final _rateController = TextEditingController();
  final _nightsController = TextEditingController(text: '1');
  String _result = '';

  @override
  void dispose() {
    _lotController.dispose();
    _rateController.dispose();
    _nightsController.dispose();
    super.dispose();
  }

  void _calculate() {
    final lot = double.tryParse(_lotController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final nights = int.tryParse(_nightsController.text) ?? 0;

    if (lot <= 0 || rate == 0 || nights <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double swap = lot * 100000 * rate * nights / 100;
    setState(() {
      _result = swap.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Swap Calculator',
      theme: widget.theme,
      children: [
        TextField(
          controller: _lotController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Lot Size',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _rateController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Swap Rate (%)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nightsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of Nights',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Swap', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text('USD $_result', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  final ThemeData theme;
  const CurrencyConverter({Key? key, required this.theme}) : super(key: key);

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final _amountController = TextEditingController();
  final _rateController = TextEditingController(text: '1.0');
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  String _result = '';

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _calculate() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;

    if (amount <= 0 || rate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double converted = amount * rate;
    setState(() {
      _result = converted.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Currency Converter',
      theme: widget.theme,
      children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _fromCurrency,
                items: ['USD', 'EUR', 'GBP', 'JPY'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _fromCurrency = value ?? 'USD'),
                decoration: InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: widget.theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _toCurrency,
                items: ['USD', 'EUR', 'GBP', 'JPY'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _toCurrency = value ?? 'EUR'),
                decoration: InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _rateController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Exchange Rate',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Convert', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$_fromCurrency to $_toCurrency', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text('$_toCurrency $_result', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class PivotPointCalculator extends StatefulWidget {
  final ThemeData theme;
  const PivotPointCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<PivotPointCalculator> createState() => _PivotPointCalculatorState();
}

class _PivotPointCalculatorState extends State<PivotPointCalculator> {
  final _highController = TextEditingController();
  final _lowController = TextEditingController();
  final _closeController = TextEditingController();
  Map<String, String> _results = {};

  @override
  void dispose() {
    _highController.dispose();
    _lowController.dispose();
    _closeController.dispose();
    super.dispose();
  }

  void _calculate() {
    final high = double.tryParse(_highController.text) ?? 0;
    final low = double.tryParse(_lowController.text) ?? 0;
    final close = double.tryParse(_closeController.text) ?? 0;

    if (high <= 0 || low <= 0 || close <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double pivot = (high + low + close) / 3;
    double r1 = (2 * pivot) - low;
    double s1 = (2 * pivot) - high;
    double r2 = pivot + (high - low);
    double s2 = pivot - (high - low);

    setState(() {
      _results = {
        'Pivot': pivot.toStringAsFixed(4),
        'R1': r1.toStringAsFixed(4),
        'R2': r2.toStringAsFixed(4),
        'S1': s1.toStringAsFixed(4),
        'S2': s2.toStringAsFixed(4),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Pivot Point Calculator',
      theme: widget.theme,
      children: [
        TextField(
          controller: _highController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'High',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _lowController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Low',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _closeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Close',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var entry in _results.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                        Text(entry.value, style: TextStyle(fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class FibonacciCalculator extends StatefulWidget {
  final ThemeData theme;
  const FibonacciCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<FibonacciCalculator> createState() => _FibonacciCalculatorState();
}

class _FibonacciCalculatorState extends State<FibonacciCalculator> {
  final _highController = TextEditingController();
  final _lowController = TextEditingController();
  Map<String, String> _results = {};

  @override
  void dispose() {
    _highController.dispose();
    _lowController.dispose();
    super.dispose();
  }

  void _calculate() {
    final high = double.tryParse(_highController.text) ?? 0;
    final low = double.tryParse(_lowController.text) ?? 0;

    if (high <= 0 || low <= 0 || high <= low) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double diff = high - low;
    Map<String, String> levels = {
      '0%': high.toStringAsFixed(4),
      '23.6%': (high - diff * 0.236).toStringAsFixed(4),
      '38.2%': (high - diff * 0.382).toStringAsFixed(4),
      '50%': (high - diff * 0.5).toStringAsFixed(4),
      '61.8%': (high - diff * 0.618).toStringAsFixed(4),
      '78.6%': (high - diff * 0.786).toStringAsFixed(4),
      '100%': low.toStringAsFixed(4),
    };

    setState(() {
      _results = levels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Fibonacci Retracement',
      theme: widget.theme,
      children: [
        TextField(
          controller: _highController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Swing High',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _lowController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Swing Low',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fibonacci Levels', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7), fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                for (var entry in _results.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                        Text(entry.value, style: TextStyle(fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class CompoundGrowthCalculator extends StatefulWidget {
  final ThemeData theme;
  const CompoundGrowthCalculator({Key? key, required this.theme}) : super(key: key);

  @override
  State<CompoundGrowthCalculator> createState() => _CompoundGrowthCalculatorState();
}

class _CompoundGrowthCalculatorState extends State<CompoundGrowthCalculator> {
  final _balanceController = TextEditingController();
  final _returnController = TextEditingController(text: '5');
  final _periodsController = TextEditingController(text: '12');
  String _result = '';

  @override
  void dispose() {
    _balanceController.dispose();
    _returnController.dispose();
    _periodsController.dispose();
    super.dispose();
  }

  void _calculate() {
    final balance = double.tryParse(_balanceController.text) ?? 0;
    final returnPercent = double.tryParse(_returnController.text) ?? 0;
    final periods = int.tryParse(_periodsController.text) ?? 0;

    if (balance <= 0 || returnPercent == 0 || periods <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid values')));
      return;
    }

    double finalBalance = balance * pow(1 + (returnPercent / 100), periods) as double;
    double gain = finalBalance - balance;

    setState(() {
      _result = 'Final: \$${finalBalance.toStringAsFixed(2)} | Gain: \$${gain.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorCard(
      title: 'Compound Growth Calculator',
      theme: widget.theme,
      children: [
        TextField(
          controller: _balanceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Starting Balance',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _returnController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Return per Period (%)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _periodsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of Periods',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.theme.colorScheme.primary,
          ),
          child: Text('Calculate', style: TextStyle(color: widget.theme.colorScheme.onPrimary, fontSize: 16)),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Compound Growth', style: TextStyle(color: widget.theme.colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                Text(_result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ==================== REUSABLE CARD WIDGET ====================

class CalculatorCard extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final List<Widget> children;

  const CalculatorCard({
    Key? key,
    required this.title,
    required this.theme,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
