import 'package:felcv/core/color_palette.dart';
import 'package:flutter/material.dart';

Widget customTextFormField(
    {required TextEditingController controller,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      hintText: hintText,
      filled: true,
      fillColor: AppColors.white,
      floatingLabelStyle: const TextStyle(
        color: AppColors.black87,
      ),
    ),
    keyboardType: keyboardType,
    validator: validator,
  );
}


  Widget customButton({required void Function() onPressed, required String label}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundShawow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onPressed: onPressed,
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        icon: const Icon(
          Icons.arrow_forward,
          color: Color.fromARGB(255, 33, 243, 40),
        ),
      ),
    );
  }

// TextFormField(
//                 controller: _horaController,
//                 decoration: const InputDecoration(
//                   labelText: 'Hora',
//                   prefixIcon: Icon(Icons.access_time),
//                   hintText: 'Hora generada automáticamente',
//                   filled: true,
//                   fillColor: Color(0xFFEEEEEE),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor ingrese la hora';
//                   }
//                   return null;
//                 },
//               ),
