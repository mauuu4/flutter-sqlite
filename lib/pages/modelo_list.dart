import 'package:flutter/material.dart';
import '../models/marca.dart';
import '../models/modelo.dart';
import '../services/modelo_service.dart';
import 'modelo_form.dart';

class ModeloListPage extends StatefulWidget {
  final Marca marca;
  const ModeloListPage({super.key, required this.marca});

  @override
  State<ModeloListPage> createState() => _ModeloListPageState();
}

class _ModeloListPageState extends State<ModeloListPage> {
  late Future<List<Modelo>> _modelosFuture;

  @override
  void initState() {
    super.initState();
    _modelosFuture = ModeloService.getModelosByMarca(widget.marca.id!);
  }

  Future<void> _loadModelos() async {
    setState(() {
      _modelosFuture = ModeloService.getModelosByMarca(widget.marca.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modelos de ${widget.marca.nombre}'),
      ),
      body: FutureBuilder<List<Modelo>>(
        future: _modelosFuture,
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
                  Icon(Icons.directions_car, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No hay modelos registrados.\nToca el botón + para crear uno.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          final modelos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: modelos.length,
            itemBuilder: (context, index) {
              final Modelo modelo = modelos[index];
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
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.directions_car,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    modelo.nombre,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text('${modelo.anio}'),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Chip(
                        label: Text('${modelo.cilindraje} cc'),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Chip(
                        label: Text('\$${modelo.precio.toStringAsFixed(0)}'),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () async {
                          final result = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => ModeloFormPage(
                                marcaId: widget.marca.id!,
                                modelo: modelo,
                              ),
                            ),
                          );
                          if (result == true) await _loadModelos();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar'),
                              content: Text('¿Eliminar el modelo ${modelo.nombre}?'),
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
                          if (confirm == true && modelo.id != null) {
                            await ModeloService.deleteModelo(modelo.id!);
                            await _loadModelos();
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
            MaterialPageRoute(
              builder: (_) => ModeloFormPage(marcaId: widget.marca.id!),
            ),
          );
          if (result == true) await _loadModelos();
        },
        icon: Icon(Icons.add),
        label: Text('Nuevo modelo'),
      ),
    );
  }
}
