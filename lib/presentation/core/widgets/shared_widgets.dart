import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    ),
  );
}

Widget buildTwoColumnRow(String label1, String value1, String label2, String value2) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value1, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value2, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          flex: 3,
          child: SelectableText(value.isEmpty ? '—' : value),
        ),
      ],
    ),
  );
}

Widget buildInfoCard(String title, String value) {
  return Card(
    elevation: 1,
    color: Colors.grey[50],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}