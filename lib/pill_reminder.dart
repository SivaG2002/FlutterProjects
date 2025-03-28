import 'package:flutter/material.dart';

class PillReminder extends StatefulWidget {
  const PillReminder({super.key});

  @override
  State<PillReminder> createState() => _PillReminderState();
}

class _PillReminderState extends State<PillReminder> {
  int _selectedHour = 7;
  int _selectedMinute = 0;
  bool _isAM = true;
  int _selectedIndex = 1; // Notifications tab is selected

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/notifications');
        break;
      case 2:
        Navigator.pushNamed(context, '/women');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildTimePicker(),
                    const SizedBox(height: 20),
                    _buildClock(),
                    const SizedBox(height: 20),
                    _buildButtons(),
                  ],
                ),
              ),
              _buildNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "PILL REMINDER",
                style: TextStyle(
                  color: Color(0xFF8C588C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Delm Medium',
                ),
              ),
            ),
            Positioned(
              left: -10,
              top: -10,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select time",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontFamily: 'Delm Medium',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeDigit(_selectedHour.toString().padLeft(2, '0')),
              const Text(
                ":",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTimeDigit(_selectedMinute.toString().padLeft(2, '0')),
              const SizedBox(width: 10),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAM = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isAM ? const Color(0xFFF5EBFB) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFF8C588C)),
                      ),
                      child: const Text(
                        "AM",
                        style: TextStyle(
                          color: Color(0xFF8C588C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAM = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: !_isAM ? const Color(0xFFF5EBFB) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFF8C588C)),
                      ),
                      child: const Text(
                        "PM",
                        style: TextStyle(
                          color: Color(0xFF8C588C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDigit(String digit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        digit,
        style: const TextStyle(
          color: Color(0xFF8C588C),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClock() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Clock numbers
              for (int i = 1; i <= 12; i++)
                Positioned(
                  left: 100 + 80 * (i % 3 == 0 ? 0 : i % 3 == 1 ? 0.866 : -0.866) * (i <= 3 || i >= 9 ? 1 : -1),
                  top: 100 + 80 * (i <= 6 ? -1 : 1) * (i % 3 == 0 ? 1 : i % 3 == 1 ? 0.5 : 0.5),
                  child: Text(
                    i.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Hour hand
              Transform.rotate(
                angle: (_selectedHour % 12) * 30 * 3.14159 / 180,
                child: Container(
                  width: 2,
                  height: 80,
                  color: const Color(0xFF8C588C),
                ),
              ),
              // Center dot
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF8C588C),
                ),
              ),
            ],
          ),
        ),
        // Hour selection dots
        for (int i = 1; i <= 12; i++)
          Positioned(
            left: 100 + 90 * (i % 3 == 0 ? 0 : i % 3 == 1 ? 0.866 : -0.866) * (i <= 3 || i >= 9 ? 1 : -1) - 15,
            top: 100 + 90 * (i <= 6 ? -1 : 1) * (i % 3 == 0 ? 1 : i % 3 == 1 ? 0.5 : 0.5) - 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedHour = i;
                });
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedHour == i ? const Color(0xFF8C588C) : Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Color(0xFF8C588C),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Delm Medium',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Save the selected time and navigate back or perform an action
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8C588C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Delm Medium',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFFF5EBFB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/images/home.png', "Home"),
          _buildNavItem(1, 'assets/images/bell.png', "Notifications"),
          _buildNavItem(2, 'assets/images/women.png', "Women", width: 20, height: 40),
          _buildNavItem(3, 'assets/images/profile.png', "Profile"),
          _buildNavItem(4, 'assets/images/settings.png', "Settings"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label, {double width = 30, double height = 30}) {
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_selectedIndex == index)
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF6A3B6A),
                shape: BoxShape.circle,
              ),
            ),
          Image.asset(
            iconPath,
            width: width,
            height: height,
            color: _selectedIndex == index ? null : Colors.grey,
          ),
        ],
      ),
    );
  }
}