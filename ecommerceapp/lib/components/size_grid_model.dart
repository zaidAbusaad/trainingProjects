import 'package:flutter/material.dart';

class SizeGrid extends StatefulWidget {
  final Function(String) onSizeSelected; // Added callback function to send size back

  const SizeGrid({required this.onSizeSelected, Key? key}) : super(key: key);

  @override
  _SizeGridState createState() => _SizeGridState();
}

class _SizeGridState extends State<SizeGrid> {
  // List of sizes
  final List<String> sizes = ['6', '6.5', '7', '7.5', '8', '8.5', '9', '9.5', '10', '10.5'];

  // Selected size
  String selectedSize = '6.5';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Size',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true, // Ensures the GridView does not scroll
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // Number of items per row
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 2, // Adjust the aspect ratio to control the size of the boxes
            ),
            itemCount: sizes.length,
            itemBuilder: (context, index) {
              String size = sizes[index];
              bool isSelected = size == selectedSize;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = size; // Update selected size
                  });
                  widget.onSizeSelected(size); // Send the selected size back to the parent
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
