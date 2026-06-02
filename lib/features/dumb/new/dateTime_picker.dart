import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';

// ─────────────────────────────────────────────
//  CONTROLLER
// ─────────────────────────────────────────────

class DateTimePickerController extends ChangeNotifier {
  DateTime _selectedDateTime;

  DateTimePickerController({DateTime? initial})
      : _selectedDateTime = initial ?? DateTime.now();

  DateTime get selectedDateTime => _selectedDateTime;

  int get selectedHour {
    int h = _selectedDateTime.hour % 12;
    return h == 0 ? 12 : h;
  }

  int get selectedMinute => _selectedDateTime.minute;
  bool get isAm => _selectedDateTime.hour < 12;

  void updateDate(DateTime date) {
    _selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      _selectedDateTime.hour,
      _selectedDateTime.minute,
    );
    notifyListeners();
  }

  void updateHour(int hour12) {
    int hour24 = isAm
        ? (hour12 == 12 ? 0 : hour12)
        : (hour12 == 12 ? 12 : hour12 + 12);
    _selectedDateTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      hour24,
      _selectedDateTime.minute,
    );
    notifyListeners();
  }

  void updateMinute(int minute) {
    _selectedDateTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      _selectedDateTime.hour,
      minute,
    );
    notifyListeners();
  }

  void toggleAmPm(bool isAm) {
    int currentHour = _selectedDateTime.hour;
    int newHour;
    if (isAm) {
      newHour = currentHour >= 12 ? currentHour - 12 : currentHour;
    } else {
      newHour = currentHour < 12 ? currentHour + 12 : currentHour;
    }
    _selectedDateTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      newHour,
      _selectedDateTime.minute,
    );
    notifyListeners();
  }
}

// ─────────────────────────────────────────────
//  POPUP WIDGET
// ─────────────────────────────────────────────

class DateTimePickerPopup extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime>? onConfirm;

  const DateTimePickerPopup({
    super.key,
    this.initialDateTime,
    this.onConfirm,
  });

  static Future<DateTime?> show(
      BuildContext context, {
        DateTime? initialDateTime,
      }) {
    return showDialog<DateTime>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.15),
      builder: (_) => DateTimePickerPopup(
        initialDateTime: initialDateTime,
        onConfirm: (dt) => Navigator.of(context).pop(dt),
      ),
    );
  }

  @override
  State<DateTimePickerPopup> createState() => _DateTimePickerPopupState();
}

class _DateTimePickerPopupState extends State<DateTimePickerPopup>
    with SingleTickerProviderStateMixin {
  late DateTimePickerController _controller;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  // Scroll controllers
  late FixedExtentScrollController _dateScrollCtrl;
  late FixedExtentScrollController _hourScrollCtrl;
  late FixedExtentScrollController _minuteScrollCtrl;
  late FixedExtentScrollController _ampmScrollCtrl;

  // Date list: yesterday - 14 days ahead
  late List<DateTime> _dates;

  static const double _itemH = 44.0;

  @override
  void initState() {
    super.initState();
    _controller =
        DateTimePickerController(initial: widget.initialDateTime);
    _controller.addListener(() => setState(() {}));

    // Build date list
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _dates = List.generate(
        18, (i) => today.subtract(Duration(days: 4)).add(Duration(days: i)));

    // Find initial indices
    int dateIdx = _dates.indexWhere((d) =>
    d.year == _controller.selectedDateTime.year &&
        d.month == _controller.selectedDateTime.month &&
        d.day == _controller.selectedDateTime.day);
    if (dateIdx < 0) dateIdx = 4; // default to today

    _dateScrollCtrl =
        FixedExtentScrollController(initialItem: dateIdx);
    _hourScrollCtrl = FixedExtentScrollController(
        initialItem: _controller.selectedHour - 1);
    _minuteScrollCtrl = FixedExtentScrollController(
        initialItem: _controller.selectedMinute);
    _ampmScrollCtrl =
        FixedExtentScrollController(initialItem: _controller.isAm ? 0 : 1);

    // Animate in
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack)
        .drive(Tween(begin: 0.88, end: 1.0));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _dateScrollCtrl.dispose();
    _hourScrollCtrl.dispose();
    _minuteScrollCtrl.dispose();
    _ampmScrollCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${days[date.weekday - 1]} ${months[date.month - 1]} ${date.day}';
  }

  void _onConfirm() {
    widget.onConfirm?.call(_controller.selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPicker(),
                const SizedBox(height: 12),
                _buildConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPicker() {
    return SizedBox(
      height: _itemH * 7,
      child: Stack(
        children: [
          // Selection highlight band
          Center(
            child: Container(
              height: _itemH,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Top fade
          Positioned(
            top: 0, left: 0, right: 0,
            height: _itemH * 2.5,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom fade
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: _itemH * 2.5,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Columns
          Row(
            children: [
              // Date column
              Expanded(
                flex: 5,
                child: _buildDateColumn(),
              ),
              // Hour column
              Expanded(
                flex: 2,
                child: _buildHourColumn(),
              ),
              // Minute column
              Expanded(
                flex: 2,
                child: _buildMinuteColumn(),
              ),
              // AM/PM column
              Expanded(
                flex: 2,
                child: _buildAmPmColumn(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Date Column ──
  Widget _buildDateColumn() {
    return ListWheelScrollView.useDelegate(
      controller: _dateScrollCtrl,
      itemExtent: _itemH,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      onSelectedItemChanged: (i) => _controller.updateDate(_dates[i]),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: _dates.length,
        builder: (context, i) {
          final date = _dates[i];
          final label = _formatDate(date);
          final isToday = label == 'Today';
          return _buildDateItem(label, isToday, i == _dateScrollCtrl.selectedItem);
        },
      ),
    );
  }

  Widget _buildDateItem(String label, bool isToday, bool selected) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: selected ? 17 : 15,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? const Color(0xFF1A1A2E) : const Color(0xFF9E9E9E),
          fontStyle: isToday && !selected ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }

  // ── Hour Column ──
  Widget _buildHourColumn() {
    return ListWheelScrollView.useDelegate(
      controller: _hourScrollCtrl,
      itemExtent: _itemH,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      onSelectedItemChanged: (i) => _controller.updateHour(i + 1),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 12,
        builder: (context, i) {
          final hour = i + 1;
          final selected = _controller.selectedHour == hour;
          return _buildNumberItem('$hour', selected);
        },
      ),
    );
  }

  // ── Minute Column ──
  Widget _buildMinuteColumn() {
    return ListWheelScrollView.useDelegate(
      controller: _minuteScrollCtrl,
      itemExtent: _itemH,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      onSelectedItemChanged: (i) => _controller.updateMinute(i),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 60,
        builder: (context, i) {
          final selected = _controller.selectedMinute == i;
          return _buildNumberItem(i.toString().padLeft(2, '0'), selected);
        },
      ),
    );
  }

  // ── AM/PM Column ──
  Widget _buildAmPmColumn() {
    return ListWheelScrollView(
      controller: _ampmScrollCtrl,
      itemExtent: _itemH,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      onSelectedItemChanged: (i) => _controller.toggleAmPm(i == 0),
      children: ['AM', 'PM'].asMap().entries.map((e) {
        final selected = (e.key == 0) == _controller.isAm;
        return _buildAmPmItem(e.value, selected);
      }).toList(),
    );
  }

  Widget _buildNumberItem(String text, bool selected) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: selected ? 20 : 16,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? const Color(0xFF1A1A2E) : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  Widget _buildAmPmItem(String text, bool selected) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: selected ? 18 : 15,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? const Color(0xFF1A1A2E) : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  // ── Confirm Button ──
  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: _onConfirm,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF8D7E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Color(0xFFD05C8A),
          size: 26,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DEMO ENTRY POINT
// ─────────────────────────────────────────────

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  DateTime? _picked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5EA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_picked != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Selected: ${_picked!.toString().substring(0, 16)}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                final result = await DateTimePickerPopup.show(
                  context,
                  initialDateTime: _picked ?? DateTime.now(),
                );
                if (result != null) setState(() => _picked = result);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Open Date Time Picker'),
            ),
          ],
        ),
      ),
    );
  }
}
