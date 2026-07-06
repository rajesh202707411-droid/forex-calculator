import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('calculationHistory');
  await Hive.openBox('favorites');
  runApp(const ForexCalculatorApp());
}

// Professional Color Scheme (ForexPro Style)
class AppColors {
  // Dark Navy & Gold Theme
  static const Color surface = Color(0xFF141218);
  static const Color surfaceContainer = Color(0xFF211F24);
  static const Color surfaceContainerHigh = Color(0xFF2B292F);
  static const Color primary = Color(0xFFCFBCFF);
  static const Color primaryContainer = Color(0xFF6750A4);
  static const Color tertiary = Color(0xFFE7C365); // Gold
  static const Color onSurface = Color(0xFFE6E0E9);
  static const Color onSurfaceVariant = Color(0xFFCBC4D2);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color outline = Color(0xFF948E9C);
}

class ForexCalculatorApp extends StatefulWidget {
  const ForexCalculatorApp({Key? key}) : super(key: key);

  @override
  State<ForexCalculatorApp> createState() => _ForexCalculatorAppState();
}

class _ForexCalculatorAppState extends State<ForexCalculatorApp> {
  int _selectedThemeIndex = 0;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedThemeIndex = prefs.getInt('selectedTheme') ?? 0;
      _selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _saveTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTheme', index);
  }

  Future<void> _saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  void _changeTheme(int index) {
    setState(() {
      _selectedThemeIndex = index;
    });
    _saveTheme(index);
  }

  void _changeLanguage(String lang) {
    setState(() {
      _selectedLanguage = lang;
    });
    _saveLanguage(lang);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ForexPro Calc',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.tertiary,
          surface: AppColors.surface,
          background: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
      ),
      home: ForexCalculatorHome(
        onThemeChanged: _changeTheme,
        currentThemeIndex: _selectedThemeIndex,
        selectedLanguage: _selectedLanguage,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}

class LanguageStrings {
  static const Map<String, Map<String, String>> strings = {
    'en': {
      'app_title': 'ForexPro Calc',
      'pip_value': 'Pip Value',
      'position_size': 'Position Size',
      'margin': 'Margin',
      'leverage': 'Leverage',
      'pnl': 'P&L',
      'risk_reward': 'Risk/Reward',
      'swap': 'Swap',
      'currency_convert': 'Currency Convert',
      'pivot_points': 'Pivot Points',
      'fibonacci': 'Fibonacci',
      'compound_growth': 'Compound Growth',
      'kelly_criterion': 'Kelly Criterion',
      'sharpe_ratio': 'Sharpe Ratio',
      'history': 'History',
      'favorites': 'Favorites',
      'calculate': 'Calculate',
      'clear': 'Clear',
      'exchange_rates': 'Markets',
      'advanced': 'Advanced',
      'settings': 'Settings',
      'calculators': 'Calculators',
    },
    'hi': {
      'app_title': 'फॉरेक्सप्रो कैल्क',
      'pip_value': 'पिप वैल्यू',
      'position_size': 'पोजीशन साइज',
      'margin': 'मार्जिन',
      'leverage': 'लीवरेज',
      'pnl': 'लाभ/हानि',
      'risk_reward': 'जोखिम/इनाम',
      'swap': 'स्वैप',
      'currency_convert': 'करेंसी कन्वर्ट',
      'pivot_points': 'पिवट पॉइंट्स',
      'fibonacci': 'फिबोनैचि',
      'compound_growth': 'चक्रवृद्धि वृद्धि',
      'kelly_criterion': 'केली मानदंड',
      'sharpe_ratio': 'शार्प अनुपात',
      'history': 'इतिहास',
      'favorites': 'पसंदीदा',
      'calculate': 'गणना करें',
      'clear': 'साफ़ करें',
      'exchange_rates': 'बाजार',
      'advanced': 'उन्नत',
      'settings': 'सेटिंग्स',
      'calculators': 'कैलकुलेटर',
    },
  };

  static String get(String key, String language) {
    return strings[language]?[key] ?? strings['en']?[key] ?? key;
  }
}

class ForexCalculatorHome extends StatefulWidget {
  final Function(int) onThemeChanged;
  final int currentThemeIndex;
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const ForexCalculatorHome({
    Key? key,
    required this.onThemeChanged,
    required this.currentThemeIndex,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<ForexCalculatorHome> createState() => _ForexCalculatorHomeState();
}

class _ForexCalculatorHomeState extends State<ForexCalculatorHome> with TickerProviderStateMixin {
  int _selectedCalculatorIndex = 0;
  int _currentNavIndex = 0;
  Map<String, dynamic> _exchangeRates = {};
  bool _ratesLoaded = false;
  late AnimationController _resultAnimationController;

  final calculators = [
    'pip_value',
    'position_size',
    'margin',
    'leverage',
    'pnl',
    'risk_reward',
    'swap',
    'currency_convert',
    'pivot_points',
    'fibonacci',
    'compound_growth',
    'kelly_criterion',
    'sharpe_ratio',
  ];

  @override
  void initState() {
    super.initState();
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    try {
      final response = await http.get(
        Uri.parse('https://open.er-api.com/v6/latest/USD'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _exchangeRates = data['rates'] ?? {};
          _ratesLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
    }
  }

  @override
  void dispose() {
    _resultAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.outline.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.currency_exchange, color: AppColors.tertiary, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        LanguageStrings.get('app_title', widget.selectedLanguage),
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.palette, color: AppColors.tertiary),
                        onPressed: _showThemePicker,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 0:
        return _buildCalculatorsTab();
      case 1:
        return _buildMarketsTab();
      case 2:
        return _buildHistoryTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildCalculatorsTab();
    }
  }

  Widget _buildCalculatorsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Calculator Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  calculators.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCalculatorIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedCalculatorIndex == index
                              ? AppColors.primaryContainer
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _selectedCalculatorIndex == index
                                ? AppColors.tertiary
                                : Colors.transparent,
                            width: 1,
                          ),
                          boxShadow: _selectedCalculatorIndex == index
                              ? [
                                  BoxShadow(
                                    color: AppColors.tertiary.withOpacity(0.3),
                                    blurRadius: 15,
                              )
                            ]
                              : [],
                        ),
                        child: Text(
                          LanguageStrings.get(calculators[index], widget.selectedLanguage),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedCalculatorIndex == index
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Calculator Card
            _buildGlassCard(
              child: _buildCalculator(_selectedCalculatorIndex),
            ),

            const SizedBox(height: 24),

            // Market Context (Volatility & Session)
            Row(
              children: [
                Expanded(
                  child: _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.bolt, color: AppColors.primary, size: 24),
                        const SizedBox(height: 12),
                        Text(
                          'Volatility',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Medium',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.schedule, color: AppColors.tertiary, size: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'CLOSED',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'London Session',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1h 12m',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: child,
        ),
      ),
    );
  }

  Widget _buildCalculator(int index) {
    switch (index) {
      case 0:
        return PipValueCalculator(
          language: widget.selectedLanguage,
          onResult: () {
            _resultAnimationController.reset();
            _resultAnimationController.forward();
          },
        );
      case 1:
        return PositionSizeCalculator(language: widget.selectedLanguage);
      case 2:
        return MarginCalculator(language: widget.selectedLanguage);
      case 3:
        return LeverageCalculator(language: widget.selectedLanguage);
      case 4:
        return PnLCalculator(language: widget.selectedLanguage);
      case 5:
        return RiskRewardCalculator(language: widget.selectedLanguage);
      case 6:
        return SwapCalculator(language: widget.selectedLanguage);
      case 7:
        return CurrencyConverterCalculator(
          language: widget.selectedLanguage,
          rates: _exchangeRates,
        );
      case 8:
        return PivotPointsCalculator(language: widget.selectedLanguage);
      case 9:
        return FibonacciCalculator(language: widget.selectedLanguage);
      case 10:
        return CompoundGrowthCalculator(language: widget.selectedLanguage);
      case 11:
        return KellyCriterionCalculator(language: widget.selectedLanguage);
      case 12:
        return SharpeRatioCalculator(language: widget.selectedLanguage);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMarketsTab() {
    if (!_ratesLoaded) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    final majorPairs = ['EUR', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'NZD', 'INR'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'USD Exchange Rates',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ...majorPairs.map((pair) {
              final rate = _exchangeRates[pair] ?? 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildGlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'USD/$pair',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        rate.toStringAsFixed(4),
                        style: GoogleFonts.jetbrainsMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    final historyBox = Hive.box('calculationHistory');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LanguageStrings.get('history', widget.selectedLanguage),
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            if (historyBox.isEmpty)
              _buildGlassCard(
                child: Center(
                  child: Text(
                    'No calculations yet',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...List.generate(historyBox.length, (index) {
                final item = historyBox.getAt(index) as Map;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['calculator'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['result'] ?? '',
                          style: GoogleFonts.jetbrainsMono(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['timestamp'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LanguageStrings.get('settings', widget.selectedLanguage),
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Theme',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildGlassCard(
              child: ListTile(
                title: Text(
                  'Dark Navy & Gold',
                  style: GoogleFonts.inter(color: AppColors.onSurface),
                ),
                trailing: Icon(
                  Icons.check_circle,
                  color: widget.currentThemeIndex == 0 ? AppColors.tertiary : Colors.transparent,
                ),
                onTap: () => widget.onThemeChanged(0),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Language',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildGlassCard(
              child: Column(
                children: [
                  ListTile(
                    title: Text('English', style: GoogleFonts.inter(color: AppColors.onSurface)),
                    trailing: Icon(
                      Icons.check_circle,
                      color: widget.selectedLanguage == 'en' ? AppColors.tertiary : Colors.transparent,
                    ),
                    onTap: () => widget.onLanguageChanged('en'),
                  ),
                  Divider(color: AppColors.outline.withOpacity(0.1)),
                  ListTile(
                    title: Text('हिंदी (Hindi)', style: GoogleFonts.inter(color: AppColors.onSurface)),
                    trailing: Icon(
                      Icons.check_circle,
                      color: widget.selectedLanguage == 'hi' ? AppColors.tertiary : Colors.transparent,
                    ),
                    onTap: () => widget.onLanguageChanged('hi'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.surface.withOpacity(0.8),
            currentIndex: _currentNavIndex,
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calculate),
                label: LanguageStrings.get('calculators', widget.selectedLanguage),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.query_stats),
                label: LanguageStrings.get('exchange_rates', widget.selectedLanguage),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.history),
                label: LanguageStrings.get('history', widget.selectedLanguage),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: LanguageStrings.get('settings', widget.selectedLanguage),
              ),
            ],
            selectedItemColor: AppColors.tertiary,
            unselectedItemColor: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppColors.outline.withOpacity(0.1)),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Theme',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                children: [
                  _buildThemeOption('Navy & Gold', 0),
                  _buildThemeOption('Blue & White', 1),
                  _buildThemeOption('Green & Lime', 2),
                  _buildThemeOption('Purple', 3),
                  _buildThemeOption('Black & Cyan', 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(String name, int index) {
    return GestureDetector(
      onTap: () {
        widget.onThemeChanged(index);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.currentThemeIndex == index ? AppColors.tertiary : AppColors.outline.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== CALCULATORS =====

class PipValueCalculator extends StatefulWidget {
  final String language;
  final VoidCallback? onResult;
  const PipValueCalculator({Key? key, required this.language, this.onResult}) : super(key: key);

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
    resultAnimationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
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
      double pipValue = pair.contains('JPY') ? (lotSize * 1000) / 100 : (lotSize * 10);

      _saveToHistory('Pip Value', pipValue.toStringAsFixed(2));

      setState(() {
        result = NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(pipValue);
        resultAnimationController.reset();
        resultAnimationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid input')));
    }
  }

  void _saveToHistory(String calculator, String result) {
    final historyBox = Hive.box('calculationHistory');
    historyBox.add({
      'calculator': calculator,
      'result': result,
      'timestamp': DateTime.now().toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pip Value Calculator',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            Icon(Icons.info_outline, color: AppColors.tertiary, size: 20),
          ],
        ),
        const SizedBox(height: 24),
        _InputField(label: 'Lot Size', controller: lotSizeController, hint: '1.00'),
        const SizedBox(height: 16),
        _InputField(label: 'Currency Pair', controller: pairController, hint: 'EURUSD'),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Calculate',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  lotSizeController.clear();
                  pairController.text = 'EURUSD';
                  setState(() => result = null);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.tertiary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Icon(Icons.refresh, color: AppColors.tertiary),
              ),
            ),
          ],
        ),
        if (result != null) ...[
          const SizedBox(height: 24),
          ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: resultAnimationController, curve: Curves.elasticOut),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Current Pip Value',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.tertiary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result!,
                    style: GoogleFonts.jetbrainsMono(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Other Calculators (Simplified for brevity - same pattern as PipValueCalculator)
class PositionSizeCalculator extends StatefulWidget {
  final String language;
  const PositionSizeCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<PositionSizeCalculator> createState() => _PositionSizeCalculatorState();
}

class _PositionSizeCalculatorState extends State<PositionSizeCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Position Size Calculator',
      style: GoogleFonts.inter(color: AppColors.onSurface),
    );
  }
}

class MarginCalculator extends StatefulWidget {
  final String language;
  const MarginCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<MarginCalculator> createState() => _MarginCalculatorState();
}

class _MarginCalculatorState extends State<MarginCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Margin Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class LeverageCalculator extends StatefulWidget {
  final String language;
  const LeverageCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<LeverageCalculator> createState() => _LeverageCalculatorState();
}

class _LeverageCalculatorState extends State<LeverageCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Leverage Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class PnLCalculator extends StatefulWidget {
  final String language;
  const PnLCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<PnLCalculator> createState() => _PnLCalculatorState();
}

class _PnLCalculatorState extends State<PnLCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('P&L Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class RiskRewardCalculator extends StatefulWidget {
  final String language;
  const RiskRewardCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<RiskRewardCalculator> createState() => _RiskRewardCalculatorState();
}

class _RiskRewardCalculatorState extends State<RiskRewardCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Risk/Reward Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class SwapCalculator extends StatefulWidget {
  final String language;
  const SwapCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<SwapCalculator> createState() => _SwapCalculatorState();
}

class _SwapCalculatorState extends State<SwapCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Swap Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class CurrencyConverterCalculator extends StatefulWidget {
  final String language;
  final Map<String, dynamic> rates;
  const CurrencyConverterCalculator({Key? key, required this.language, required this.rates}) : super(key: key);

  @override
  State<CurrencyConverterCalculator> createState() => _CurrencyConverterCalculatorState();
}

class _CurrencyConverterCalculatorState extends State<CurrencyConverterCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Currency Converter', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class PivotPointsCalculator extends StatefulWidget {
  final String language;
  const PivotPointsCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<PivotPointsCalculator> createState() => _PivotPointsCalculatorState();
}

class _PivotPointsCalculatorState extends State<PivotPointsCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Pivot Points Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class FibonacciCalculator extends StatefulWidget {
  final String language;
  const FibonacciCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<FibonacciCalculator> createState() => _FibonacciCalculatorState();
}

class _FibonacciCalculatorState extends State<FibonacciCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Fibonacci Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class CompoundGrowthCalculator extends StatefulWidget {
  final String language;
  const CompoundGrowthCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<CompoundGrowthCalculator> createState() => _CompoundGrowthCalculatorState();
}

class _CompoundGrowthCalculatorState extends State<CompoundGrowthCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Compound Growth Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class KellyCriterionCalculator extends StatefulWidget {
  final String language;
  const KellyCriterionCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<KellyCriterionCalculator> createState() => _KellyCriterionCalculatorState();
}

class _KellyCriterionCalculatorState extends State<KellyCriterionCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Kelly Criterion Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

class SharpeRatioCalculator extends StatefulWidget {
  final String language;
  const SharpeRatioCalculator({Key? key, required this.language}) : super(key: key);

  @override
  State<SharpeRatioCalculator> createState() => _SharpeRatioCalculatorState();
}

class _SharpeRatioCalculatorState extends State<SharpeRatioCalculator> {
  @override
  Widget build(BuildContext context) {
    return Text('Sharpe Ratio Calculator', style: GoogleFonts.inter(color: AppColors.onSurface));
  }
}

// ===== UI COMPONENTS =====

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.jetbrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.jetbrainsMono(color: AppColors.onSurfaceVariant),
            filled: true,
            fillColor: AppColors.surfaceContainerHigh.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outline.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
