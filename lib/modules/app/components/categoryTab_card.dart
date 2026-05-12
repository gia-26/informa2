import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';

Widget categoryTab(String title, String selectedCategory, Function(String) onTap) {
  bool isSelected = selectedCategory == title;
  return GestureDetector(
    onTap: () => onTap(title),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? secundaryColor : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        boxShadow: isSelected 
          ? [BoxShadow(color: secundaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] 
          : [],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    ),
  );
}