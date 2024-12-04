import 'package:flutter/material.dart';

enum FieldType { text, password, num }

class CustomTextField extends StatefulWidget {
  final String hint;
  final controller;
  final FieldType type;
  final String? Function(String?)? validator;

  const CustomTextField(
      {super.key,
        required this.controller,
        required this.hint,
        required this.type,
        required this.validator});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure = false;
  late String _hint;
  late TextEditingController _controller;
  late FieldType _type;
  late String? Function(String?)? _validator;

  @override
  void initState() {
    this._hint = widget.hint;
    this._controller = widget.controller;
    this._type = widget.type;
    this._validator = widget.validator;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TextFormField(
        keyboardType: _type == FieldType.num
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        controller: _controller,
        autocorrect: false,
        validator: _validator,
        autofocus: true,
        obscureText: _type == FieldType.password ? !_obscure : _obscure,
        decoration: InputDecoration(
            labelText: _hint,
            alignLabelWithHint: true,
            labelStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon: _type == FieldType.password ?
            IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState((){_obscure = !_obscure;});
                })
                : null
        ),
        //inputFormatters: _type == FieldType.num ? numFormatter() : null,
      ),
    );
  }
}
