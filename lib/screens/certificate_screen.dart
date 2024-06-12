import 'package:flutter/material.dart';

class CertificateScreen extends StatefulWidget {
  final String name;
  final String eventName;
  final String eventDate;
  final String clubName;

  const CertificateScreen({
    super.key,
    required this.name,
    required this.eventName,
    required this.eventDate,
    required this.clubName,
  });

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certificates'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 278,
          padding: const EdgeInsets.all(16.0), // Padding inside the border
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Certificate1.jpg'),
              //fit: BoxFit.fill,
            ),
            color: Colors.white,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 85),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'GreatVibes',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'For participating in the ${widget.eventName} Workshop',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'held by ${widget.clubName} in collaboration with EventHub on ${widget.eventDate}',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 135),
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_Vk9w8l-li1OzPmTfK2__3A0tJC0NnS4NOMYrXjCCzw&s',
                        height: 30,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 150),
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_Vk9w8l-li1OzPmTfK2__3A0tJC0NnS4NOMYrXjCCzw&s',
                        height: 30,
                      ),
                    ],
                  ),
                ],
              )

              //const Text(
              //  'MUFFAKHAM JAH',
              //  style: TextStyle(
              //    fontSize: 20,
              //    fontWeight: FontWeight.bold,
              //    color: Colors.black,
              //  ),
              //),
              //const Text(
              //  'COLLEGE OF ENGINEERING AND TECHNOLOGY',
              //  style: TextStyle(
              //    fontSize: 8,
              //    fontWeight: FontWeight.bold,
              //    color: Colors.black,
              //  ),
              //),
              //const SizedBox(height: 8),
              //const Text(
              //  'CERTIFICATE',
              //  style: TextStyle(
              //    fontSize: 25,
              //    fontWeight: FontWeight.bold,
              //    color: Colors.black,
              //  ),
              //),
              //const Text(
              //  'OF PARTICIPATION',
              //  style: TextStyle(
              //    fontSize: 16,
              //    fontWeight: FontWeight.bold,
              //    color: Colors.black,
              //  ),
              //),
              //const SizedBox(height: 8),
              //const Text(
              //  'This certificate is proudly presented to',
              //  style: TextStyle(
              //    fontSize: 14,
              //    color: Colors.black,
              //  ),
              //),
              //const SizedBox(height: 0),
              //Text(
              //  widget.name,
              //  style: const TextStyle(
              //    fontSize: 24,
              //    fontWeight: FontWeight.bold,
              //    color: Colors.black,
              //    fontFamily: 'GreatVibes',
              //  ),
              //),
              //const Divider(
              //  color: Colors.black,
              //  thickness: 1.0,
              //  indent: 40.0,
              //  endIndent: 40.0,
              //),
              //const SizedBox(height: 8),
              //Text(
              //  'For participating in the ${widget.eventName} Workshop',
              //  style: const TextStyle(
              //    fontSize: 14,
              //    color: Colors.black,
              //  ),
              //  textAlign: TextAlign.center,
              //),
              //Text(
              //  'held by ${widget.clubName} in collaboration with EventHub on ${widget.eventDate.toLocal().toIso8601String().split('T').first}',
              //  style: const TextStyle(
              //    fontSize: 14,
              //    color: Colors.black,
              //  ),
              //  textAlign: TextAlign.center,
              //),
              //Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //  children: [
              //    Column(
              //      children: [
              //        const SizedBox(height: 16),
              //        Image.network(
              //          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_Vk9w8l-li1OzPmTfK2__3A0tJC0NnS4NOMYrXjCCzw&s',
              //          height: 30,
              //        ),
              //        const Text(
              //          'Mohammed Sameer',
              //          style: TextStyle(
              //            fontSize: 16,
              //            fontWeight: FontWeight.bold,
              //            color: Colors.black,
              //          ),
              //        ),
              //        const Text(
              //          'CEO of EventHub',
              //          style: TextStyle(
              //            fontSize: 12,
              //            color: Colors.black,
              //          ),
              //        ),
              //      ],
              //    ),
              //    Column(
              //      children: [
              //        const SizedBox(height: 16),
              //        Image.network(
              //          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_Vk9w8l-li1OzPmTfK2__3A0tJC0NnS4NOMYrXjCCzw&s',
              //          height: 30,
              //        ),
              //        const Text(
              //          'Mohammed Sameer',
              //          style: TextStyle(
              //            fontSize: 16,
              //            fontWeight: FontWeight.bold,
              //            color: Colors.black,
              //          ),
              //        ),
              //        const Text(
              //          'CEO of EventHub',
              //          style: TextStyle(
              //            fontSize: 12,
              //            color: Colors.black,
              //          ),
              //        ),
              //      ],
              //    ),
              //  ],
              //),
            ],
          ),
        ),
      ),
    );
  }
}
