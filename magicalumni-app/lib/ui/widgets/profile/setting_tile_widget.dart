import 'package:flutter/material.dart';

class SettingTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;
  const SettingTileWidget({super.key, required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45,),
    );
  }
}