import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final bool isCustomerSelected;

  final VoidCallback onCustomerSelected;
  final VoidCallback onWorkerSelected;

  const ToggleButton({
    required this.isCustomerSelected,
    required this.onCustomerSelected,
    required this.onWorkerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Customer Button
          Expanded(
            child: GestureDetector(
              onTap: onCustomerSelected,
              child: Container(
                decoration: BoxDecoration(
                  color: isCustomerSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Customer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCustomerSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Worker Button
          Expanded(
            child: GestureDetector(
              onTap: onWorkerSelected,
              child: Container(
                decoration: BoxDecoration(
                  color: isCustomerSelected ? Colors.transparent : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Worker',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCustomerSelected ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
