import 'package:flutter/material.dart';

class StoreSubscriptionScreen extends StatelessWidget {
  const StoreSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Subscription",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 350),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Standard',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '\$40',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '/mo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'See what your current plan can do',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Your current plan',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),
                const Text('Display your store in the app', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 8),
                const Text('User can join your store queue', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 8),
                const Text('Manage your store in the app', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 8),
                const Text('Get analytics and store history', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 8),
                const Text('business improvement.', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
