import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime(2025, 3, 13); // March 13, 2025
  DateTime? _selectedDay = DateTime(2025, 3, 13);
  List<Widget> _symptomCards = [];
  final String userName = "Advika";
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Cubic(0.4, 0.0, 0.2, 1)),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addSymptomCard() {
    setState(() {
      _symptomCards.add(
        Padding(
          padding: const EdgeInsets.only(left: 10), // Add padding to the left of new cards
          child: _buildInsightCard(label: "Symptoms", value: "😊😊"),
        ),
      );
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/notification');
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
    final greeting = userName.isNotEmpty ? "Good Morning, $userName!" : "Good Morning!";
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBFB),
      body: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Delm Medium',
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCalendar(),
                      const SizedBox(height: 40), // Increased spacing to push insights lower
                      const Text(
                        "Your Daily Insights",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Delm Medium',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: const Color(0xFF8C588C).withOpacity(0.6),
                      ),
                      const SizedBox(height: 30),
                      _buildInsights(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * .48, // Reduced height to prevent overflow
        width: MediaQuery.of(context).size.width * 0.88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFF8C588C), width: 2),
        ),
        padding: const EdgeInsets.fromLTRB(35, 20, 35, 10), // Adjusted padding
        child: Column(
          children: [
            const Text(
              "CALENDAR-MARCH",
              style: TextStyle(
                color: Color(0xFF8C588C),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Delm Medium',
                
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: TableCalendar(
                firstDay: DateTime(2025, 3, 1),
                lastDay: DateTime(2025, 3, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(color: Color(0xFF8C588C), fontWeight: FontWeight.bold, fontSize: 10),
                  weekendTextStyle: const TextStyle(color: Color(0xFF8C588C), fontWeight: FontWeight.bold, fontSize: 10),
                  outsideTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF8C588C),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFF8C588C).withOpacity(1),
                    shape: BoxShape.circle,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                  weekendStyle: TextStyle(color: Colors.red, fontSize: 10),
                ),
                headerVisible: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsights() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildInsightCard(label: "Cycle Day", value: "18"),
          const SizedBox(width: 10),
          _buildInsightCard(label: "Ovulation", value: "03"),
          const SizedBox(width: 10),
          _buildInsightCard(label: "Symptoms", value: "😊😔😣"),
          ..._symptomCards, // Dynamically added cards with left padding
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _addSymptomCard,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.29,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFF8C588C),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF8C588C), width: 2),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              padding: const EdgeInsets.all(15),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Info",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Delm Medium',
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "⊕",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({required String label, required String value}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.29,
      height: 84,
      decoration: BoxDecoration(
        color: const Color(0xFF8C588C),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF8C588C), width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Delm Medium',
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
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
          _buildNavItem(1, 'assets/images/bell.png', "Notification"),
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