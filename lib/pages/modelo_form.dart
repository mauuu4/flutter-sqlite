import 'package:flutter/material.dart';
import '../models/modelo.dart';
import '../services/modelo_service.dart';

class ModeloFormPage extends StatefulWidget {
  final int marcaId;
  final Modelo? modelo;
  const ModeloFormPage({super.key, required this.marcaId, this.modelo});

  @override
  State<ModeloFormPage> createState() => _ModeloFormPageState();
}

class _ModeloFormPageState extends State<ModeloFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _anioController;
  late TextEditingController _cilindrajeController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.modelo?.nombre ?? '');
    _anioController = TextEditingController(text: widget.modelo?.anio.toString() ?? '');
    _cilindrajeController =
        TextEditingController(text: widget.modelo?.cilindraje.toString() ?? '');
    _precioController = TextEditingController(text: widget.modelo?.precio.toString() ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _anioController.dispose();
    _cilindrajeController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final nombre = _nombreController.text.trim();
    final anio = int.parse(_anioController.text.trim());
    final cilindraje = int.parse(_cilindrajeController.text.trim());
    final precio = double.parse(_precioController.text.trim());
    if (widget.modelo == null) {
      await ModeloService.createModelo(
        Modelo(
          marcaId: widget.marcaId,
          nombre: nombre,
          anio: anio,
          cilindraje: cilindraje,
          precio: precio,
        ),
      );
    } else {
      await ModeloService.updateModelo(
        Modelo(
          id: widget.modelo!.id,
          marcaId: widget.marcaId,
          nombre: nombre,
          anio: anio,
          cilindraje: cilindraje,
          precio: precio,
        ),
      );
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.modelo != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar modelo' : 'Nuevo modelo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  hintText: 'Ej. FZ25, CBR600, Corolla',
                  prefixIcon: Icon(Icons.directions_car),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ingresa un modelo' : null,
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _anioController,
                      decoration: InputDecoration(
                        labelText: 'Año',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Requerido';
                        if (int.tryParse(v.trim()) == null) return 'Inválido';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cilindrajeController,
                      decoration: InputDecoration(
                        labelText: 'Cilindraje (cc)',
                        prefixIcon: Icon(Icons.speed),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Requerido';
                        if (int.tryParse(v.trim()) == null) return 'Inválido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa un precio';
                  if (double.tryParse(v.trim()) == null) return 'Precio inválido';
                  return null;
                },
              ),
              SizedBox(height: 28),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(Icons.check),
                  label: Text(isEditing ? 'Guardar cambios' : 'Crear modelo'),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
