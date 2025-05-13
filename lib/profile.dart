import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _profileImage;
  String name = "Ardra";
  int age = 25;
  String dob = "01/01/1999";
  String bloodGroup = "O+";
  int _selectedIndex = 3;
  
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "Ardra";
      age = prefs.getInt('age') ?? 25;
      dob = prefs.getString('dob') ?? "01/01/1999";
      bloodGroup = prefs.getString('bloodGroup') ?? "O+";
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null && File(imagePath).existsSync()) {
        _profileImage = File(imagePath);
      }
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setInt('age', age);
    await prefs.setString('dob', dob);
    await prefs.setString('bloodGroup', bloodGroup);
    if (_profileImage != null) {
      await prefs.setString('profileImage', _profileImage!.path);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _saveProfileData();
    }
  }

  void _showEditInfoDialog() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController ageController = TextEditingController(text: age.toString());
    TextEditingController dobController = TextEditingController(text: dob);
    TextEditingController bloodGroupController = TextEditingController(text: bloodGroup);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Information"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dobController,
                  decoration: const InputDecoration(labelText: "Date of Birth (DD/MM/YYYY)"),
                ),
                TextField(
                  controller: bloodGroupController,
                  decoration: const InputDecoration(labelText: "Blood Group"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  name = nameController.text;
                  age = int.tryParse(ageController.text) ?? age;
                  dob = dobController.text;
                  bloodGroup = bloodGroupController.text;
                });
                await _saveProfileData();
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _onNavItemTapped(int index) {
    if (_selectedIndex == index) return; // Prevent navigating to the same screen

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home'); // Ensure route matches
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/notification'); // Ensure route matches
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/women'); // Ensure route matches
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile'); // Ensure route matches
        break;
      case 4:
        Navigator.of(context).pushReplacementNamed('/settings'); // Ensure route matches
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: ProfileCurveClipper(),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: const Color(0xFFFF6F91),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const NetworkImage(
                                  "https://i.pinimg.com/736x/8f/7a/da/8f7ada6d11a5a78c968c0afeff09c6e9.jpg") as ImageProvider,
                          backgroundColor: Colors.grey[300],
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/sub.png',
                      height: 250,
                      width: 200,
                    ),
                    const Text(
                      "Give the gift of Flo Premium",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Invite friends and family to join your plan",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 1),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6F91),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Get the Flo Family Plan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.purple,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: _showEditInfoDialog,
                            child: const Text(
                              "Edit Info",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F91),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Upgrade to Premium",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        backgroundColor: const Color(0xFFF5EBFB),
        selectedItemColor: const Color(0xFFFF6F91),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 0 ? const Color(0xFFFF6F91) : Colors.grey,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bell.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? const Color(0xFFFF6F91) : Colors.grey,
            ),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/women.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 2 ? const Color(0xFFFF6F91) : Colors.grey,
            ),
            label: "Women",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/profile.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? const Color(0xFFFF6F91) : Colors.grey,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/settings.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 4 ? const Color(0xFFFF6F91) : Colors.grey,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class ProfileCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}