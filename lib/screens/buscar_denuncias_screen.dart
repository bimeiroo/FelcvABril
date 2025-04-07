import 'package:flutter/material.dart';
import '../models/denuncia.dart';
import '../services/denuncia_service.dart';
import 'detalle_denuncia_screen.dart';

class BuscarDenunciasScreen extends StatefulWidget {
  const BuscarDenunciasScreen({super.key});

  @override
  State<BuscarDenunciasScreen> createState() => _BuscarDenunciasScreenState();
}

class _BuscarDenunciasScreenState extends State<BuscarDenunciasScreen> {
  final _searchController = TextEditingController();
  List<Denuncia> _denuncias = [];
  bool _isLoading = false;
  final DenunciaService _denunciaService = DenunciaService();

  @override
  void initState() {
    super.initState();
    _cargarDenuncias();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarDenuncias() async {
    setState(() => _isLoading = true);

    try {
      final denuncias = await _denunciaService.getDenuncias();
      if (mounted) {
        setState(() {
          _denuncias = denuncias;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar denuncias: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _buscarDenuncias(String query) async {
    setState(() => _isLoading = true);

    try {
      final denuncias = await _denunciaService.buscarDenuncias(query);
      if (mounted) {
        setState(() {
          _denuncias = denuncias;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al buscar denuncias: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _verDetalleDenuncia(Denuncia denuncia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleDenunciaScreen(denuncia: denuncia),
      ),
    ).then((_) {
      // Recargar las denuncias al volver del detalle
      _cargarDenuncias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Denuncias'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar denuncias',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _cargarDenuncias();
                        },
                      )
                    : null,
              ),
              onChanged: _buscarDenuncias,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _denuncias.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No hay denuncias registradas'
                                  : 'No se encontraron denuncias',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _denuncias.length,
                        itemBuilder: (context, index) {
                          final denuncia = _denuncias[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                'Denuncia ${denuncia.numeroDenuncia}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${denuncia.nombreDenunciante} ${denuncia.apellidoDenunciante}',
                                  ),
                                  Text(
                                    'Estado: ${denuncia.estado}',
                                    style: TextStyle(
                                      color: denuncia.estado == 'Pendiente'
                                          ? Colors.orange
                                          : denuncia.estado == 'En Proceso'
                                              ? Colors.blue
                                              : denuncia.estado == 'Resuelta'
                                                  ? Colors.green
                                                  : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _verDetalleDenuncia(denuncia),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
