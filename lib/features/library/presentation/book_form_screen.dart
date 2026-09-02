import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/library/domain/model/book.dart';
import 'package:tomora/features/library/presentation/bloc/library_cubit.dart';

/// Alta / edición de un libro. Portado de `CreateEditBook`:
///  - los `TextEditingController` se crean una vez en `initState` y se liberan
///    (antes se recreaban en cada `build` sin `dispose`);
///  - `int.parse` → `int.tryParse` (antes reventaba con campos vacíos / año no
///    numérico);
///  - la rama de edición ahora **actualiza** en vez de volver a insertar una
///    fila nueva (bug: duplicaba el libro y descartaba los cambios);
///  - persiste vía [LibraryCubit].
class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key, this.book});

  final Book? book;

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scroll = ScrollController();

  late final TextEditingController _titulo;
  late final TextEditingController _autor;
  late final TextEditingController _paginas;
  late final TextEditingController _year;
  late final TextEditingController _edicion;
  late final TextEditingController _editorial;
  late final TextEditingController _isbn;
  late final TextEditingController _genero;

  String _leido = 'No';
  int _tapa = 0;

  bool get _isEdit => widget.book?.id != null;

  @override
  void initState() {
    super.initState();
    final b = widget.book;
    _titulo = TextEditingController(text: b?.titulo ?? '');
    _autor = TextEditingController(text: b?.autor ?? '');
    _paginas = TextEditingController(text: b?.paginas?.toString() ?? '');
    _year = TextEditingController(
      text: b?.fechaPublicacion ?? DateTime.now().year.toString(),
    );
    _edicion = TextEditingController(text: b?.edicion ?? '');
    _editorial = TextEditingController(text: b?.editorial ?? '');
    _isbn = TextEditingController(text: b?.isbn ?? '');
    _genero = TextEditingController(text: b?.genero ?? '');
    _leido = b?.leido ?? 'No';
    _tapa = b?.tapa ?? 0;
  }

  @override
  void dispose() {
    for (final c in [
      _titulo,
      _autor,
      _paginas,
      _year,
      _edicion,
      _editorial,
      _isbn,
      _genero,
    ]) {
      c.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final pages = int.tryParse(_paginas.text.trim()) ?? 0;
    if (!_formKey.currentState!.validate() || pages <= 0) {
      Fluttertoast.showToast(msg: 'Rellena los datos correctamente');
      return;
    }

    final base = widget.book ?? const Book();
    final book = base.copyWith(
      titulo: _titulo.text.trim(),
      autor: _autor.text.trim(),
      editorial: _editorial.text.trim(),
      genero: _genero.text.trim(),
      isbn: _isbn.text.trim(),
      edicion: _edicion.text.trim(),
      fechaPublicacion:
          (int.tryParse(_year.text.trim()) ?? DateTime.now().year).toString(),
      paginas: pages,
      leido: _leido,
      tapa: _tapa,
      estado: base.estado ?? 1,
      valoracion: base.valoracion ?? 0,
      opinion: base.opinion ?? '',
      nombrePrestamo: base.nombrePrestamo ?? '',
    );

    final cubit = context.read<LibraryCubit>();
    if (_isEdit) {
      await cubit.updateBook(book);
    } else {
      await cubit.addBook(book);
    }
    if (!mounted) return;
    Fluttertoast.showToast(
        msg: _isEdit ? 'Libro actualizado' : 'Libro añadido');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        title: Text(
          _isEdit ? 'Editar libro' : 'Añadir libro',
          style: const TextStyle(color: white, fontFamily: Fonts.muliBold),
        ),
      ),
      body: Scrollbar(
        controller: _scroll,
        thumbVisibility: true,
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _field(_titulo, 'Título', Icons.title,
                validator: _required('Rellena el título')),
            _field(_autor, 'Autor', Icons.edit,
                validator: _required('Rellena el autor')),
            _field(_paginas, 'Páginas', Icons.find_in_page,
                keyboard: TextInputType.number),
            _RadioRow<String>(
              label: 'Leído',
              value: _leido,
              options: const {'No': 'No leído', 'Si': 'Leído'},
              onChanged: (v) => setState(() => _leido = v),
            ),
            _RadioRow<int>(
              label: 'Tapa',
              value: _tapa,
              options: const {0: 'Blanda', 1: 'Dura'},
              onChanged: (v) => setState(() => _tapa = v),
            ),
            _field(_year, 'Año', Icons.date_range,
                keyboard: TextInputType.number),
            _field(_edicion, 'Edición', Icons.explicit,
                keyboard: TextInputType.number),
            _field(_editorial, 'Editorial', Icons.book),
            _field(_isbn, 'ISBN', Icons.emoji_symbols, validator: (v) {
              if (v != null && v.isNotEmpty && v.length < 9) {
                return 'ISBN demasiado corto';
              }
              return null;
            }),
            _field(_genero, 'Género', Icons.texture),
            const SizedBox(height: 32),
            Center(
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(backgroundColor: primaryColor),
                child: Text(_isEdit ? 'Actualizar' : 'Añadir'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String? Function(String?) _required(String message) =>
      (v) => (v == null || v.trim().isEmpty) ? message : null;

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        cursorColor: primaryColor,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon, color: fillerGrey),
        ),
      ),
    );
  }
}

/// Fila de opciones con [RadioGroup] (API nueva de Flutter 3.32+).
class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontFamily: Fonts.muliBold, color: black)),
          RadioGroup<T>(
            groupValue: value,
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
            child: Row(
              children: [
                for (final entry in options.entries)
                  Expanded(
                    child: RadioListTile<T>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(entry.value),
                      value: entry.key,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
