import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/screens/add_edit_task_screen.dart';
import 'package:task_management_app/screens/loginPage.dart';
import 'package:task_management_app/screens/task_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 35, color: Colors.indigo),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Task Manager",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Logout", style: TextStyle(fontSize: 16)),
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
            ],
          ),
        ),

        appBar: AppBar(
          elevation: 0,
          title: Text(
            "My Tasks",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
              ),
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Pending"),
              Tab(text: "Completed"),
            ],
          ),
        ),

        body: TabBarView(
          children: [TaskList(type: 0), TaskList(type: 1), TaskList(type: 2)],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF3949AB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditTaskScreen()),
            );
          },
          child: Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
