import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_event.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_state.dart';
import 'package:next_era_collector/custlist/bloc/custlist_events.dart';
import 'package:server_repository/models.dart';

import '../../addpayment/bloc/addpayment_bloc.dart';
import '../../res/widgets/MsgDialog.dart';

class AddPanNoNusinessNo extends StatelessWidget {
  AddPanNoNusinessNo({super.key, required this.model});

  final CBpartner model;

  final TextEditingController _panNo = TextEditingController();
  final TextEditingController _businessNo = TextEditingController();
  final TextEditingController _phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (model.taxId != null) {
      _panNo.text = model.taxId!;
    }
    if (model.businessNo != null) {
      _businessNo.text = model.businessNo.toString();
    }
    if(model.phone != null){
      _phoneNo.text = model.phone!.toString();
    }
    final paymentBloc = context.read<AddPaymentBloc>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(model.phone == null  || model.phone == "9800000000")
            TextField(
              keyboardType: TextInputType.number,
              controller: _phoneNo,
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
                  hintText: "Phone Number",
                  labelText: "Contact Number",
                  suffixIcon: const Icon(Icons.business),
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
          const SizedBox(
            height: 12,
          ),
          if ((model.businessNo == null || model.businessNo == "0")
              && (model.taxId == null || model.taxId == "0") && model.cBPGroupID!.id != 1000090)
            TextField(
              keyboardType: TextInputType.number,
              controller: _businessNo,
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
                  hintText: "Business Number",
                  labelText: "Nagarpalika Business Number",
                  suffixIcon: const Icon(Icons.business),
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
          if ((model.businessNo == null || model.businessNo == "0")
              && (model.taxId == null || model.taxId == "0")&& model.cBPGroupID!.id != 1000090)
            const SizedBox(
              height: 12,
            ),
          if ((model.businessNo == null || model.businessNo == "0")
              && (model.taxId == null || model.taxId == "0")&& model.cBPGroupID!.id != 1000090)
            TextField(
              readOnly: true,
              controller: _panNo,
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
                  hintText: "PAN NO.",
                  labelText: "PAN Number",
                  suffixIcon: const Icon(Icons.business),
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
          //   TextField(
          //   readOnly: true,
          //   controller: _panNo,
          //   style: const TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black,
          //       fontSize: 17),
          //   decoration: InputDecoration(
          //       disabledBorder: OutlineInputBorder(
          //           borderSide: const BorderSide(color: Color(0xFF047857)),
          //           borderRadius: BorderRadius.circular(9)),
          //       focusColor: Colors.white,
          //       focusedBorder: OutlineInputBorder(
          //           borderSide: const BorderSide(color: Color(0xFF047857)),
          //           borderRadius: BorderRadius.circular(9)),
          //       border: OutlineInputBorder(
          //           borderSide: const BorderSide(color: Colors.red),
          //           borderRadius: BorderRadius.circular(9)),
          //       contentPadding: const EdgeInsets.all(20),
          //       hintText: "PAN NO.",
          //       labelText: "PAN Number",
          //       suffixIcon: const Icon(Icons.business),
          //       labelStyle: const TextStyle(
          //           color: Color(0xFF047857),
          //           fontSize: 18,
          //           fontWeight: FontWeight.w600),
          //       hintStyle: const TextStyle(
          //           color: Color(0xFF047857),
          //           fontSize: 15,
          //           fontWeight: FontWeight.w300),
          //       suffixIconColor: const Color(0xFF047857)),
          // ),
          // if (model.businessNo != null)
          //   TextField(
          //     readOnly: true,
          //     controller: _businessNo,
          //     style: const TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //         fontSize: 17),
          //     decoration: InputDecoration(
          //         disabledBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Color(0xFF047857)),
          //             borderRadius: BorderRadius.circular(9)),
          //         focusColor: Colors.white,
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Color(0xFF047857)),
          //             borderRadius: BorderRadius.circular(9)),
          //         border: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Colors.red),
          //             borderRadius: BorderRadius.circular(9)),
          //         contentPadding: const EdgeInsets.all(20),
          //         hintText: "Business Number",
          //         labelText: "Nagarpalika Business Number",
          //         suffixIcon: const Icon(Icons.business),
          //         labelStyle: const TextStyle(
          //             color: Color(0xFF047857),
          //             fontSize: 18,
          //             fontWeight: FontWeight.w600),
          //         hintStyle: const TextStyle(
          //             color: Color(0xFF047857),
          //             fontSize: 15,
          //             fontWeight: FontWeight.w300),
          //         suffixIconColor: const Color(0xFF047857)),
          //   ),
          // const SizedBox(
          //   height: 12,
          // ),
          // if (model.taxId == null)
          //   TextField(
          //     keyboardType: TextInputType.number,
          //     controller: _panNo,
          //     style: const TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //         fontSize: 17),
          //     decoration: InputDecoration(
          //         disabledBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Color(0xFF047857)),
          //             borderRadius: BorderRadius.circular(9)),
          //         focusColor: Colors.white,
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Color(0xFF047857)),
          //             borderRadius: BorderRadius.circular(9)),
          //         border: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Colors.red),
          //             borderRadius: BorderRadius.circular(9)),
          //         contentPadding: const EdgeInsets.all(20),
          //         hintText: "PAN NO.",
          //         labelText: "PAN Number",
          //         suffixIcon: const Icon(Icons.business),
          //         labelStyle: const TextStyle(
          //             color: Color(0xFF047857),
          //             fontSize: 18,
          //             fontWeight: FontWeight.w600),
          //         hintStyle: const TextStyle(
          //             color: Color(0xFF047857),
          //             fontSize: 15,
          //             fontWeight: FontWeight.w300),
          //         suffixIconColor: const Color(0xFF047857)),
          //   ),
          // if (model.taxId != null)
          //   TextField(
          //     readOnly: true,
          //     controller: _panNo,
          //     style: const TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //         fontSize: 17),
          //     decoration: InputDecoration(
          //         disabledBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Color(0xFF047857)),
          //             borderRadius: BorderRadius.circular(9)),
          //         focusColor: Colors.white,
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Color(0xFF047857)),
          //             borderRadius: BorderRadius.circular(9)),
          //         border: OutlineInputBorder(
          //             borderSide: const BorderSide(color: Colors.red),
          //             borderRadius: BorderRadius.circular(9)),
          //         contentPadding: const EdgeInsets.all(20),
          //         hintText: "PAN NO.",
          //         labelText: "PAN Number",
          //         suffixIcon: const Icon(Icons.business),
          //         labelStyle: const TextStyle(
          //             color: Color(0xFF047857),
          //             fontSize: 18,
          //             fontWeight: FontWeight.w600),
          //         hintStyle: const TextStyle(
          //             color: Color(0xFF047857),
          //             fontSize: 15,
          //             fontWeight: FontWeight.w300),
          //         suffixIconColor: const Color(0xFF047857)),
          //   ),
          const SizedBox(
            height: 12,
          ),
          BlocBuilder<AddPaymentBloc, AddPaymentState>(
              builder: (context, state) {
            if (state.isAddPanBusinessLoading) {
              return const CircularProgressIndicator();
            } else {
              return SizedBox(
                height: 45,
                width: 111,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF047857)),
                  ),
                  onPressed: () {
                    if((model.phone == null || model.phone == "9800000000")
                        && (_phoneNo.text == "" || _phoneNo.text == "9800000000")
                    || _phoneNo.text.length != 10 ){
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return MsgDialog(
                                msg: "Please Enter Correct Phone Number");
                          });
                    }
                    else if ((model.businessNo == null || model.businessNo == "0")
                    && (model.taxId == null || model.taxId == "0") &&
                    _businessNo.text == "" && _panNo.text == "" && model.cBPGroupID!.id != 1000090) {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return MsgDialog(
                                msg: "Either PAN No. or Business No is needed");
                          });
                    } else {
                      if (_businessNo.text != "" && _panNo.text != "") {
                        paymentBloc.add(UpdatePanNoandBusinessNo(
                          phoneNo: _phoneNo.text,
                            businessNo :_businessNo.text ,
                            panNo: _panNo.text,
                            model: model));
                      }else if(_businessNo.text != ""){
                        paymentBloc.add(UpdatePanNoandBusinessNo(
                            phoneNo: _phoneNo.text,
                            businessNo :_businessNo.text ,
                            model: model));
                      }else if(_panNo.text != ""){
                        paymentBloc.add(UpdatePanNoandBusinessNo(
                            phoneNo: _phoneNo.text,
                            panNo: _panNo.text,
                            model: model));
                      }else{
                        paymentBloc.add(UpdatePanNoandBusinessNo(
                            phoneNo: _phoneNo.text,
                            model: model));
                      }
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
