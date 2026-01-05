import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/styles.dart';

class AppInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final bool disableNumbers;
  final int maxLines;
  final IconData? icon;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppInput({
    Key? key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.disableNumbers = false,
    this.maxLines = 1,
    this.icon,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            
            inputFormatters: disableNumbers 
              ? [FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))] 
              : [],

            validator: (v) {
              if (isRequired && (v == null || v.isEmpty)) {
                return "$label wajib diisi";
              }
              if (disableNumbers && v != null && v.contains(RegExp(r'[0-9]'))) {
                return "$label tidak boleh mengandung angka";
              }
              return null;
            },

            decoration: InputDecoration(
              hintText: "Masukkan ${label.toLowerCase()}",
              suffixIcon: icon != null ? Icon(icon, color: AppColors.muted) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border)
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}