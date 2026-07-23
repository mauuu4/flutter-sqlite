import 'package:flutter/material.dart';
import '../models/marca.dart';
import '../services/marca_service.dart';

class MarcaFormPage extends StatefulWidget {
  final Marca? marca;
  const MarcaFormPage({super.key, this.marca});

  @override
  State<MarcaFormPage> createState() => _MarcaFormPageState();
}

class _MarcaFormPageState extends State<MarcaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _paisController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.marca?.nombre ?? '');
    _paisController = TextEditingController(text: widget.marca?.pais ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _paisController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final nombre = _nombreController.text.trim();
    final pais = _paisController.text.trim();
    if (widget.marca == null) {
      await MarcaService.createMarca(Marca(nombre: nombre, pais: pais));
    } else {
      await MarcaService.updateMarca(
        Marca(id: widget.marca!.id, nombre: nombre, pais: pais),
      );
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.marca != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar marca' : 'Nueva marca')),
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
                  labelText: 'Marca',
                  hintText: 'Ej. Yamaha, Honda, Toyota',
                  prefixIcon: Icon(Icons.two_wheeler),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ingresa una marca' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _paisController,
                decoration: InputDecoration(
                  labelText: 'País de origen',
                  hintText: 'Ej. Japón, Estados Unidos',
                  prefixIcon: Icon(Icons.public),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ingresa un país' : null,
              ),
              SizedBox(height: 28),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(Icons.check),
                  label: Text(isEditing ? 'Guardar cambios' : 'Crear marca'),
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
