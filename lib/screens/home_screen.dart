import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/dashboard_card.dart';
import '../services/user_service.dart';
import 'admin_screen.dart';
import 'membership_screen.dart';
import 'training_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();
  String? _userRole;
  bool _isLoadingRole = true;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      final role = await _userService.getUserRole(user.uid);
      if (mounted) {
        setState(() {
          _userRole = role;
          _isLoadingRole = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    // Extract name from email for greeting (mock logic for now)
    final String displayName = user?.email?.split('@')[0] ?? 'Atleta';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hola,',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      displayName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoadingRole
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        children: [
                          if (_userRole == 'admin')
                            DashboardCard(
                              title: 'Panel Admin',
                              description: 'Gestionar Box',
                              icon: Icons.admin_panel_settings,
                              gradientColors: [Colors.redAccent, Colors.red],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AdminScreen()),
                                );
                              },
                            ),
                          DashboardCard(
                            title: 'Membresía',
                            description: 'Estado: ACTIVA\nVence: 15 Oct',
                            icon: Icons.card_membership,
                            gradientColors: [Colors.blue, Colors.blueAccent],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MembershipScreen()),
                              );
                            },
                          ),
                          DashboardCard(
                            title: 'Entrenamiento',
                            description: 'WOD: "Murph"\nRegistra tus marcas',
                            icon: Icons.fitness_center,
                            gradientColors: [Colors.orange, Colors.deepOrange],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TrainingScreen()),
                              );
                            },
                          ),
                          DashboardCard(
                            title: 'Comunidad',
                            description: 'Próximamente\nNoticias y Eventos',
                            icon: Icons.groups,
                            gradientColors: [Colors.purple, Colors.deepPurple],
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Esta sección estará lista pronto!')),
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
    );
  }
}
