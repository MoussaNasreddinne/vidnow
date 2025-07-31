import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 16, 0, 61),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: const Color.fromARGB(255, 145, 0, 0),
          title: Text(
            "VidNow",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 35),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 145, 0, 0),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/images/profile.jpg",
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "User Name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "user@example.com",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),
              
              
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 85, 53, 53),
                      Color.fromARGB(255, 145, 0, 0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.person,
                      title: "Edit Profile",
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.settings,
                      title: "Settings",
                      onTap: () {},
                    ),
                    
                    _buildProfileOption(
                      icon: Icons.history,
                      title: "Watch History",
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications,
                      title: "Notifications",
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.help,
                      title: "Help & Support",
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            color: Colors.black,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}