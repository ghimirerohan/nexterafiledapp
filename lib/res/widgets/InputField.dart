import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class InputField extends StatefulWidget {
  TextEditingController? editingController;
  ValidationBuilder? validationBuilder;
  String? hintText;
  String? labelText;
  Icon? icon;
  FocusNode? focusNode;
  TextInputType? inputType;
  String? initalvalue;
  bool? enabled;
  Color? textColor;
   InputField({
     this.editingController,
     this.validationBuilder,
     this.hintText,
     this.labelText,
     this.icon,
     this.inputType,
     this.focusNode,
     this.initalvalue,
     this.enabled,
     this.textColor
});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6)), //Customer Name
      child: TextFormField(
        style: TextStyle(fontWeight: FontWeight.bold , color:  widget.textColor ?? Colors.black ,fontSize: 17),
        initialValue: widget.initalvalue ,
        enabled: widget.enabled ?? true,
        textInputAction: TextInputAction.next,
        focusNode: widget.focusNode,
        keyboardType: widget.inputType,
        controller: widget.editingController,
        onTap: () {

        },
        onFieldSubmitted: (value) => widget.editingController?.text = value ??"",
        onSaved: (value){
          widget.editingController?.text = value ??"";
        },
        validator: widget.validationBuilder?.build() ,
        onChanged: (value) {
          if(widget.editingController != null){
            widget.editingController?.text = value;
          }
        },
        decoration: InputDecoration(

          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF047857)),
              borderRadius: BorderRadius.circular(9)),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF047857)),
                borderRadius: BorderRadius.circular(9)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(9)),
            contentPadding: const EdgeInsets.all(20),
            hintText: widget.hintText,
            labelText: widget.labelText,
            suffixIcon: widget.icon,
            labelStyle: const TextStyle(
                color: Color(0xFF047857),
                fontSize: 18,
                fontWeight: FontWeight.w600),
            hintStyle: const TextStyle(
                color: Color(0xFF047857),
                fontSize: 15,
                fontWeight: FontWeight.w300),
            suffixIconColor: const Color(0xFF047857)),
      ),
    );
  }
}
