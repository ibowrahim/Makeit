import 'package:flutter/material.dart';

class TastTitleField extends StatelessWidget {
  const TastTitleField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Görev Başlığı',
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        TextField(
          autofocus: true,

          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          decoration: InputDecoration(
            hintText: 'Yapılacak görevi yaz...',
            hintStyle: const TextStyle(color: Color(0xFFB0BCD4), fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF202B42),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF35435F)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF756BFF),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
