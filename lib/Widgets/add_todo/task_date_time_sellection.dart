import 'package:flutter/material.dart';
import 'package:make_it/Provider/Todo_Provider.dart';
import 'package:make_it/Widgets/appSvgIcon.dart';
import 'package:make_it/gen/assets.gen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class TaskDateTimeSellection extends StatefulWidget {
  const TaskDateTimeSellection({
    super.key,
    required this.onDateSelect,
    required this.onTimeSelect,
  });

  final ValueChanged<DateTime> onDateSelect;
  final ValueChanged<TimeOfDay> onTimeSelect;

  @override
  State<TaskDateTimeSellection> createState() => _TaskDateTimeSellectionState();
}

class _TaskDateTimeSellectionState extends State<TaskDateTimeSellection> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  static const Color _cardColor = Color(0xFF1F2937);
  static const Color _borderColor = Color(0xFF374151);
  static const Color _iconColor = Color(0xFFC4B5FD);
  static const Color _primaryText = Color(0xFFF9FAFB);
  static const Color _secondaryText = Color(0xFF9CA3AF);
  static const Color _doneColor = Color(0xFF34D399);

  // ===== DEĞİŞTİRİLEN BÖLÜM BAŞLANGIÇ (tarih seçimi: Syncfusion takvim) =====
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Takvimde nokta göstermek için mevcut görevler
    final todos = context.read<TodoProvider>().todos;

    DateTime? temp = _selectedDate;

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tarih seç',
                      style: TextStyle(
                        color: _primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 330,
                      child: SfCalendar(
                        view: CalendarView.month,
                        firstDayOfWeek: 1,
                        minDate: today,
                        maxDate: DateTime(2999),
                        initialDisplayDate: temp ?? today,
                        initialSelectedDate: temp,
                        backgroundColor: Colors.transparent,
                        cellBorderColor: Colors.transparent,
                        todayHighlightColor: _iconColor,
                        showNavigationArrow: true,
                        headerStyle: const CalendarHeaderStyle(
                          textStyle: TextStyle(
                            color: _primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        viewHeaderStyle: const ViewHeaderStyle(
                          dayTextStyle: TextStyle(
                            color: _secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        selectionDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        monthCellBuilder: (context, details) =>
                            _buildMonthCell(details, todos, temp, today),
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.none,
                        ),
                        onTap: (details) {
                          if (details.targetElement !=
                                  CalendarElement.calendarCell ||
                              details.date == null) {
                            return;
                          }
                          final d = details.date!;
                          if (d.isBefore(today)) return;
                          setSheetState(() => temp = d);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Seçili günün görevleri
                    _buildDayTasks(todos, temp),
                    const SizedBox(height: 10),
                    // Açıklama: noktaların ne anlama geldiği
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _LegendDot(color: _iconColor, label: 'Bekleyen görev'),
                        SizedBox(width: 16),
                        _LegendDot(color: _doneColor, label: 'Tamamlandı'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _secondaryText,
                              side: const BorderSide(color: _borderColor),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Vazgeç'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: temp == null
                                ? null
                                : () => Navigator.pop(ctx, temp),
                            style: FilledButton.styleFrom(
                              backgroundColor: _iconColor,
                              foregroundColor: const Color(0xFF111827),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Tamam'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = picked;
    });

    widget.onDateSelect(picked);
  }

  // Seçili günün görev başlıklarını listeler.
  Widget _buildDayTasks(List todos, DateTime? day) {
    const hintStyle = TextStyle(color: _secondaryText, fontSize: 12);

    if (day == null) {
      return const Text(
        'Bir güne dokun, o günün görevlerini gör',
        style: hintStyle,
      );
    }

    final dayTodos = todos
        .where((t) => DateUtils.isSameDay(t.dueDate, day))
        .toList();

    if (dayTodos.isEmpty) {
      return const Text('Bu günde görev yok', style: hintStyle);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 110),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: dayTodos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 6),
        itemBuilder: (_, i) {
          final t = dayTodos[i];
          final DateTime due = t.dueDate;
          final bool done = t.isCompleted;
          final hasTime = due.hour != 0 || due.minute != 0;

          return Row(
            children: [
              Icon(
                done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 18,
                color: done ? _doneColor : _iconColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: done ? _secondaryText : _primaryText,
                    fontSize: 14,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (hasTime)
                Text(
                  '${due.hour.toString().padLeft(2, '0')}:${due.minute.toString().padLeft(2, '0')}',
                  style: hintStyle,
                ),
            ],
          );
        },
      ),
    );
  }

  // Takvimdeki gün hücresi: sayı + görev varsa nokta
  // (bekleyen varsa mor, hepsi tamamsa yeşil).
  Widget _buildMonthCell(
    MonthCellDetails details,
    List todos,
    DateTime? selected,
    DateTime today,
  ) {
    final date = details.date;
    final isPast = date.isBefore(today);
    final isToday = DateUtils.isSameDay(date, today);
    final isSelected = selected != null && DateUtils.isSameDay(selected, date);

    final dayTodos = todos
        .where((t) => DateUtils.isSameDay(t.dueDate, date))
        .toList();
    final hasTodo = dayTodos.isNotEmpty;
    final allDone = hasTodo && dayTodos.every((t) => t.isCompleted);

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isSelected
            ? _iconColor.withValues(alpha: 0.30)
            : isToday
            ? _iconColor.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: (isToday || isSelected) ? Border.all(color: _iconColor) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              color: isPast
                  ? _secondaryText.withValues(alpha: 0.35)
                  : _primaryText,
              fontWeight: (isToday || isSelected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          hasTodo
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: allDone ? _doneColor : _iconColor,
                    shape: BoxShape.circle,
                  ),
                )
              : const SizedBox(height: 6),
        ],
      ),
    );
  }
  // ===== DEĞİŞTİRİLEN BÖLÜM BİTİŞ =====

  Future<void> _selectTime() async {
    final initial = _selectedTime ?? TimeOfDay.now();
    final now = DateTime.now();
    DateTime temp = DateTime(
      now.year,
      now.month,
      now.day,
      initial.hour,
      initial.minute,
    );

    final picked = await showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Saat seç',
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Seçili satırın arkasındaki vurgu bandı
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: _iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _iconColor.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                    TimePickerSpinner(
                      time: temp,
                      is24HourMode: true,
                      isForce2Digits: true,
                      itemHeight: 52,
                      spacing: 40,
                      normalTextStyle: const TextStyle(
                        fontSize: 24,
                        color: _secondaryText,
                      ),
                      highlightedTextStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _primaryText,
                      ),
                      onTimeChange: (t) => temp = t,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _secondaryText,
                          side: const BorderSide(color: _borderColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Vazgeç'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(
                          ctx,
                          TimeOfDay(hour: temp.hour, minute: temp.minute),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: _iconColor,
                          foregroundColor: const Color(0xFF111827),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Tamam'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedTime = picked;
    });

    widget.onTimeSelect(picked);
  }

  // ===== EKLENEN BÖLÜM BAŞLANGIÇ (yardımcılar) =====
  static const _aylar = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];
  static const _gunler = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _mediumDate(DateTime d) => '${d.day} ${_aylar[d.month - 1]}';

  String _fullDate(DateTime d) =>
      '${d.day} ${_aylar[d.month - 1]} ${d.year}, ${_gunler[d.weekday - 1]}';

  String _dateText() {
    final date = _selectedDate;
    if (date == null) return 'Tarih seç';
    if (_isToday(date)) return 'Bugün';
    return _mediumDate(date);
  }

  String _timeText(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  // ===== EKLENEN BÖLÜM BİTİŞ =====

  Widget _buildSelectorCard({
    required String title,
    required String value,
    required String description,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: icon,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _secondaryText,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: _secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _secondaryText, fontSize: 11),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectorCard(
          title: 'TARİH',
          value: _dateText(),
          description: _selectedDate == null
              ? 'Görev gününü seç'
              : _fullDate(_selectedDate!),
          icon: AppSvgIcon(icon: Assets.icons.date, size: 22),
          onTap: _selectDate,
        ),
        const SizedBox(width: 12),
        _buildSelectorCard(
          title: 'SAAT',
          value: _selectedTime == null ? 'Saat seç' : _timeText(_selectedTime!),
          description: _selectedTime == null
              ? 'İsteğe bağlı'
              : 'Hatırlatma saati',
          icon: AppSvgIcon(icon: Assets.icons.time, size: 22),
          onTap: _selectTime,
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
        ),
      ],
    );
  }
}
