import 'package:flutter/material.dart';

class CatalogWidget extends StatefulWidget {
  const CatalogWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CatalogWidgetState createState() => _CatalogWidgetState();
}

class _CatalogWidgetState extends State<CatalogWidget> {
  List<CatalogItem> catalog = [
    CatalogItem('Science', ['Physics', 'Chemistry', 'Biology']),
    CatalogItem('Technology', ['AI', 'Blockchain', 'IoT']),
    CatalogItem('Arts', ['Painting', 'Sculpture', 'Music']),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineConnectorPainter(catalog),
      child: ListView.builder(
        itemCount: catalog.length,
        itemBuilder: (context, index) {
          final item = catalog[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    item.expanded = !item.expanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        item.expanded ? Icons.remove : Icons.add,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 8),
                      Text(
                        item.title,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: item.expanded ? item.subtopics.length * 48.0 : 0,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: item.subtopics.length,
                  itemBuilder: (context, subIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
                      child: Text(
                        item.subtopics[subIndex],
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CatalogItem {
  final String title;
  final List<String> subtopics;
  bool expanded;

  CatalogItem(this.title, this.subtopics, {this.expanded = false});
}

class LineConnectorPainter extends CustomPainter {
  final List<CatalogItem> catalog;

  LineConnectorPainter(this.catalog);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2.0;

    double y = 30;
    for (var item in catalog) {
      canvas.drawCircle(Offset(10, y), 3, paint);
      if (y < size.height - 30) {
        canvas.drawLine(Offset(10, y), Offset(10, y + 60), paint);
      }
      y += item.expanded ? (item.subtopics.length * 48 + 60) : 60;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
