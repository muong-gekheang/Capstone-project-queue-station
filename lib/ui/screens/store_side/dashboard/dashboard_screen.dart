import 'package:flutter/material.dart';
import 'package:queue_station_app/data/queue_repository.dart';
import 'package:queue_station_app/model/dashboard_stats.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store_profile_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final QueueService _queueService = QueueService(QueueRepository());
  DashboardStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
    // Refresh stats every 30 seconds
    _startPeriodicRefresh();
  }

  void _loadDashboardStats() async {
    try {
      final stats = await _queueService.getDashboardStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startPeriodicRefresh() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _loadDashboardStats();
        _startPeriodicRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.description, color: Color(0xFF0D47A1)),
            SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          // Store Profile Image
          _buildStoreProfileImage(),
          // Notification Icon
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard Stats Cards
                  _buildStatCard(
                    'Queue Status',
                    '${_stats?.queueEntries ?? 0}',
                    'entries',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'People Waiting',
                    '${_stats?.peopleWaiting ?? 0}',
                    '',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Active Tables',
                    '${_stats?.activeTables ?? 0}',
                    '',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Average Wait Time',
                    '${_stats?.averageWaitTimeMinutes ?? 0}',
                    'min',
                  ),
                  const SizedBox(height: 24),
                  // Manage Queue Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to manage queue page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Manage Queue feature coming soon"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Manage Queue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreProfileImage() {
    final storeService = StoreProfileService();
    final profileImage = storeService.storeProfileImage;
    final storeName = storeService.storeName;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: profileImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                profileImage,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6835).withAlpha((255 * 0.1).toInt()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  storeName.isNotEmpty ? storeName[0].toUpperCase() : 'S',
                  style: const TextStyle(
                    color: Color(0xFFFF6835),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
    );
  }
}
