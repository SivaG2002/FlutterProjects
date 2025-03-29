import 'package:flutter/material.dart';
import 'dart:math' as math;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 1;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  bool _isAM = true;
  bool _isAdjustingHour = true;
  List<Map<String, dynamic>> _activeAlarms = [
    {'time': const TimeOfDay(hour: 7, minute: 0), 'isAM': true, 'isActive': true},
  ];
  List<Map<String, dynamic>> _alarmHistory = [];

  Widget _buildNavItem(int index, String assetPath, String label, {double width = 24, double height = 24}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(assetPath, width: width, height: height, color: _selectedIndex == index ? Colors.pink : Colors.grey),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: _selectedIndex == index ? Colors.pink : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  void _updateTime(double angle) {
    if (_isAdjustingHour) {
      final hour = ((angle * 12 / (2 * math.pi)) + 6) % 12;
      final selectedHour = hour == 0 ? 12 : hour.toInt();
      setState(() {
        _selectedTime = TimeOfDay(hour: selectedHour, minute: _selectedTime.minute);
      });
    } else {
      final minute = ((angle * 60 / (2 * math.pi)) + 30) % 60;
      setState(() {
        _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: (minute / 5).round() * 5);
      });
    }
  }

  void _selectNumber(int index) {
    setState(() {
      if (_isAdjustingHour) {
        final selectedHour = index == 0 ? 12 : index;
        _selectedTime = TimeOfDay(hour: selectedHour, minute: _selectedTime.minute);
      } else {
        _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: index * 5);
      }
    });
  }

  void _addAlarm() {
    setState(() {
      _activeAlarms.add({'time': _selectedTime, 'isAM': _isAM, 'isActive': true});
      _alarmHistory.add({'time': _selectedTime, 'isAM': _isAM, 'addedAt': DateTime.now()});
    });
  }

  void _deleteAlarm(int index) {
    setState(() {
      _activeAlarms.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6F0),
      body: SafeArea(
        child: Column(
          children: [
            // Bell Reminder Container
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "PILL REMINDER",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF8B5A8B)),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Image.asset('assets/images/bellremainder.png', width: 60, height: 60),
                ),
              ],
            ),

            // Combined Digital and Analog Clock Tile
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  // Digital Time Display with Separate Containers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAdjustingHour = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isAdjustingHour ? const Color(0xFFF5A9B8).withOpacity(0.3) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedTime.hourOfPeriod.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _isAdjustingHour ? const Color(0xFF8B5A8B) : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(":", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF8B5A8B))),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAdjustingHour = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isAdjustingHour ? const Color(0xFFF5A9B8).withOpacity(0.3) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedTime.minute.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: !_isAdjustingHour ? const Color(0xFF8B5A8B) : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isAM = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _isAM ? const Color(0xFFF5A9B8) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text("AM", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => setState(() => _isAM = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: !_isAM ? const Color(0xFFF5A9B8) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text("PM", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Analog Clock with Highlighted Number
                  GestureDetector(
                    onPanUpdate: (details) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final Offset localPosition = box.globalToLocal(details.globalPosition);
                      final Offset center = Offset(box.size.width / 2, box.size.height / 2);
                      final double angle = math.atan2(localPosition.dy - center.dy, localPosition.dx - center.dx);
                      _updateTime(angle);
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Clock Numbers with Highlight
                          ...List.generate(12, (index) {
                            final double angle = (index * 30 - 90) * math.pi / 180;
                            final int displayedNumber = _isAdjustingHour ? (index == 0 ? 12 : index) : index * 5;
                            final bool isSelected = _isAdjustingHour
                                ? (displayedNumber == _selectedTime.hourOfPeriod)
                                : (displayedNumber == _selectedTime.minute);
                            return Transform.translate(
                              offset: Offset(80 * math.cos(angle), 80 * math.sin(angle)),
                              child: GestureDetector(
                                onTap: () => _selectNumber(index),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? const Color(0xFF8B5A8B) : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _isAdjustingHour ? "${index == 0 ? 12 : index}" : "${index * 5}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          // Single Clock Hand
                          Transform.rotate(
                            angle: (_isAdjustingHour
                                    ? (_selectedTime.hourOfPeriod == 12 ? 0 : _selectedTime.hourOfPeriod) * 30
                                    : _selectedTime.minute * 6) *
                                math.pi /
                                180,
                            child: Container(
                              width: 0, // Thicker needle to match the reference
                              height: 90, // Adjusted length to match the reference
                              color: const Color(0xFF8B5A8B),
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8B5A8B))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ),
                  const SizedBox(width: 32),
                  ElevatedButton(
                    onPressed: _addAlarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5A8B),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("OK", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),

            // Active Alarms and History
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF8B5A8B),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF8B5A8B),
                      tabs: [
                        Tab(text: "Active Alarms"),
                        Tab(text: "History"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Active Alarms
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: _activeAlarms.length,
                            itemBuilder: (context, index) {
                              final alarm = _activeAlarms[index];
                              final time = alarm['time'] as TimeOfDay;
                              final isAM = alarm['isAM'] as bool;
                              final isActive = alarm['isActive'] as bool;
                              return Dismissible(
                                key: ValueKey(alarm),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  _deleteAlarm(index);
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                child: Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Text(
                                      "${time.hourOfPeriod.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${isAM ? 'AM' : 'PM'}",
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5A8B)),
                                    ),
                                    trailing: Switch(
                                      value: isActive,
                                      onChanged: (value) => setState(() => _activeAlarms[index]['isActive'] = value),
                                      activeColor: const Color(0xFF8B5A8B),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Alarm History
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: _alarmHistory.length,
                            itemBuilder: (context, index) {
                              final history = _alarmHistory[index];
                              final time = history['time'] as TimeOfDay;
                              final isAM = history['isAM'] as bool;
                              final addedAt = history['addedAt'] as DateTime;
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    "${time.hourOfPeriod.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${isAM ? 'AM' : 'PM'}",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5A8B)),
                                  ),
                                  subtitle: Text("Added: ${addedAt.toString().substring(0, 16)}"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: const Color(0xFFF5E6F0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'assets/images/home.png', "Home"),
            _buildNavItem(1, 'assets/images/bell.png', "Notification"),
            _buildNavItem(2, 'assets/images/women.png', "Women", width: 20, height: 40),
            _buildNavItem(3, 'assets/images/profile.png', "Profile"),
            _buildNavItem(4, 'assets/images/settings.png', "Settings"),
          ],
        ),
      ),
    );
  }
}