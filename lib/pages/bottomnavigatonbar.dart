import 'package:flutter/material.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool isSelected;
  final int badgeCount;

  const CustomBottomNavigationBarItem({
    required this.iconData,
    required this.label,
    this.isSelected = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
    
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            if (isSelected)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              )
            else
              Icon(
                iconData,
                color: Colors.grey,
              ),
            if (badgeCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4),  // Spacing between icon and text
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}
