import 'package:felcv/core/color_palette.dart';
import 'package:flutter/material.dart';

class SeleccionarUbicacionScreen extends StatefulWidget {
  const SeleccionarUbicacionScreen(
      {super.key,
      required this.direccion,
      required this.latitud,
      required this.longitud});
  final String direccion;
  final String latitud;
  final String longitud;
  @override
  State<SeleccionarUbicacionScreen> createState() =>
      _SeleccionarUbicacionScreenState();
}

class _SeleccionarUbicacionScreenState
    extends State<SeleccionarUbicacionScreen> {
  final _direccionController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  @override
  void initState() {
    _direccionController.text = widget.direccion;
    _latitudController.text = widget.latitud;
    _longitudController.text = widget.longitud;
    super.initState();
  }

  @override
  void dispose() {
    _direccionController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    super.dispose();
  }

  void _confirmarUbicacion() {
    if (_direccionController.text.isEmpty ||
        _latitudController.text.isEmpty ||
        _longitudController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    Navigator.pop(context, {
      'address': _direccionController.text,
      'lat': _latitudController.text,
      'lng': _longitudController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Dirección'),
        backgroundColor: palette.background,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Ingrese la dirección completa',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _latitudController,
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  prefixIcon: Icon(Icons.location_searching),
                  hintText: 'Ejemplo: -16.4897',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _longitudController,
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  prefixIcon: Icon(Icons.location_searching),
                  hintText: 'Ejemplo: -68.1193',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _confirmarUbicacion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundShawow,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirmar Ubicación'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
