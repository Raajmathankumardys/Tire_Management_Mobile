import 'package:flutter/material.dart';

class TireStatusScreen extends StatelessWidget {
  const TireStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(Icons.search),
        ],
        title: const Align(alignment: Alignment.centerLeft,child: Text("Tires",style: TextStyle(fontSize: 20),)),
      ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //Tabs section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 13, top: 16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF0D7CF2),
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 13, top: 16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Low Pressure',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF49719C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Recently Added Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recently added',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.grey[50],
                            width: double.infinity,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fleet 3, Vehicle 1',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Status: In Service',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF49719C),
                                  ),
                                ),
                                Text(
                                  '235/45ZR18',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF49719C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Pressure Card Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFCEDBE8)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pressure',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          '30PSI',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Row(
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF49719C),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '+2%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF078838),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 148,
                          child: CustomPaint(
                            size: const Size(double.infinity, 148),
                            painter: GraphPainter(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '1D',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF49719C),
                              ),
                            ),
                            Text(
                              '1W',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF49719C),
                              ),
                            ),
                            Text(
                              '1M',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF49719C),
                              ),
                            ),
                            Text(
                              '3M',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF49719C),
                              ),
                            ),
                            Text(
                              '1Y',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF49719C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // All Tires Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'All tires',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.grey[50],
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fleet 2, Vehicle 1',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Status: In Service',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF49719C),
                                      ),
                                    ),
                                    Text(
                                      '235/45ZR18',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF49719C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

// Custom Painter for the Graph
class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF49719C)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.73)
      ..lineTo(size.width * 0.08, size.height * 0.14)
      ..lineTo(size.width * 0.16, size.height * 0.14)
      ..lineTo(size.width * 0.24, size.height * 0.27)
      ..lineTo(size.width * 0.32, size.height * 0.62)
      ..lineTo(size.width * 0.40, size.height * 0.22)
      ..lineTo(size.width * 0.48, size.height * 0.67)
      ..lineTo(size.width * 0.56, size.height * 0.41)
      ..lineTo(size.width * 0.64, size.height * 0.81)
      ..lineTo(size.width * 0.72, size.height * 0.81)
      ..lineTo(size.width * 0.80, size.height * 0.99)
      ..lineTo(size.width * 0.88, size.height * 0.01)
      ..lineTo(size.width * 0.96, size.height * 0.54)
      ..lineTo(size.width, size.height * 0.17);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}