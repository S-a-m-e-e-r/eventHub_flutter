import 'package:flutter/material.dart';

class CertificateCard extends StatelessWidget {
  final String name;
  final String eventName;
  final DateTime eventDate;
  final String clubName;

  const CertificateCard({
    super.key,
    required this.name,
    required this.eventName,
    required this.eventDate,
    required this.clubName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 350,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Border and corner decorations

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MUFFAKHAM JAH',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'COLLEGE OF ENGINEERING AND TECHNOLOGY',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'CERTIFICATE',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'OF PARTICIPATION',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This certificate is proudly presented to',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'GreatVibes',
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                  indent: 40.0,
                  endIndent: 40.0,
                ),
                const SizedBox(height: 8),
                Text(
                  'For participating in the $eventName',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'held by $clubName in collaboration with EventHub on ${eventDate.toLocal().toIso8601String().split('T').first}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_Vk9w8l-li1OzPmTfK2__3A0tJC0NnS4NOMYrXjCCzw&s',
                  height: 30,
                ),
                Column(
                  children: const [
                    Text(
                      'Mohammed Sameer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'CEO of EventHub',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
