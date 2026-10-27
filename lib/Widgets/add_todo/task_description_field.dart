
import 'package:flutter/material.dart';

class TaskDescriptionField extends StatelessWidget {
  const TaskDescriptionField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Açıklama (opsiyonel)',
          style: TextStyle(
            color:  Color(0xFFB9C5E3),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),

        TextField(
          controller: controller,
          maxLines: 4,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF202B42),
            hintText: 'İş Açıklaması',
            hintStyle: const TextStyle(color: Color(0xFFB0BCD4), fontSize: 13),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
