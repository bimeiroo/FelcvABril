import 'package:felcv/services/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final DenunciaService _denunciaService = DenunciaService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _verDetalleDenuncia(Denuncia denuncia) async{
    final Denuncia searchDenuncia = await _denunciaService.encontrarDenuncia(denuncia);

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => DetalleDenunciaScreen(denuncia: searchDenuncia),
      ),
    ).then((_) {
      // Recargar las denuncias al volver del detalle
      // _cargarDenuncias();
    });

  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>();
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
                          // _cargarDenuncias();
                        },
                      )
                    : null,
              ),
              onChanged:(valule)async{
                 await session.buscarDenununciados(valule);
              },
            ),
          ),
          Expanded(
            child: session.state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : session.state.denuncias.isEmpty
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
                        itemCount: session.state.denuncias.length,
                        itemBuilder: (context, index) {
                          final denuncia = session.state.denuncias[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                'Denuncia # ${denuncia.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Denunciante: ${denuncia.nombreDenunciante} ${denuncia.apellidoDenunciante}',
                                  ),
                                   Text(
                                    'Denunciado: ${denuncia.nombreDenunciado}',
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
