import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:next_era_collector/custlist/bloc/custlist_events.dart';

import '../bloc/custlist_bloc.dart';
import '../bloc/custlist_states.dart';

class AddHouseOwner extends StatelessWidget {
  AddHouseOwner({super.key});

  final _formKey = GlobalKey<FormState>();

  String? ownerName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              onSaved: (value) {
                ownerName = value;
              },
              validator: ValidationBuilder().required("* required").build(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17),
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
                  hintText: "House Owner Name",
                  labelText: "Owner Name",
                  suffixIcon: const Icon(Icons.house_siding_outlined),
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
          ),
          const SizedBox(
            height: 12,
          ),
          BlocBuilder<CustListBloc, CustListState>(
              builder: (context, state) {
                if(state.isUpdateOwnerNameLoading){
                  return const CircularProgressIndicator();
                }else{
                  return SizedBox(
                    height: 45,
                    width: 111,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF047857)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<CustListBloc>().add(UpdateOwnerName(name: ownerName!));
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              }),

        ],
      ),
    );
  }
}
