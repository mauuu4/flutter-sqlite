import 'package:flutter/material.dart';
import '../models/marca.dart';
import '../services/marca_service.dart';
import 'marca_form.dart';
import 'modelo_list.dart';

class MarcaListPage extends StatefulWidget {
  const MarcaListPage({super.key});

  @override
  State<MarcaListPage> createState() => _MarcaListPageState();
}

class _MarcaListPageState extends State<MarcaListPage> {
  late Future<List<Marca>> _marcasFuture;

  @override
  void initState() {
    super.initState();
    _marcasFuture = MarcaService.getMarcas();
  }

  Future<void> _loadMarcas() async {
    setState(() {
      _marcasFuture = MarcaService.getMarcas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcas de motos/autos'),
      ),
      body: FutureBuilder<List<Marca>>(
        future: _marcasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.two_wheeler, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No hay marcas registradas.\nToca el botón + para crear una.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          final marcas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: marcas.length,
            itemBuilder: (context, index) {
              final Marca marca = marcas[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.two_wheeler,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    marca.nombre,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${marca.pais} · Ver modelos'),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ModeloListPage(marca: marca)),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () async {
                          final result = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(builder: (_) => MarcaFormPage(marca: marca)),
                          );
                          if (result == true) await _loadMarcas();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar'),
                              content: Text(
                                '¿Eliminar la marca ${marca.nombre}? También se eliminarán sus modelos.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Eliminar'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && marca.id != null) {
                            await MarcaService.deleteMarca(marca.id!);
                            await _loadMarcas();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => MarcaFormPage()),
          );
          if (result == true) await _loadMarcas();
        },
        icon: Icon(Icons.add),
        label: Text('Nueva marca'),
      ),
    );
  }
}
