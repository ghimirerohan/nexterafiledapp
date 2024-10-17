import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_event.dart';

import '../../custlist/view/custlist_screen.dart';
import '../../home/view/home_screen.dart';
import '../../res/widgets/MsgDialog.dart';
import '../bloc/addpayment_bloc.dart';
import '../bloc/addpayment_state.dart';

class SubmitAsDefaulter extends StatefulWidget {
  String? title;
  int c_bpartner_id;

  SubmitAsDefaulter({this.title, required this.c_bpartner_id});

  @override
  State<SubmitAsDefaulter> createState() => _SubmitAsDefaulterState();
}

class _SubmitAsDefaulterState extends State<SubmitAsDefaulter> {
  List<String> reasonsIdentifiers = ["D", "N", "O"];
  int _selectedValue = 0;

  _remarkNotSetForOthers() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return MsgDialog(msg: "Remarks Needed For Others");
        });
  }

  _setIsCustomerReport() {
    context
        .read<AddPaymentBloc>()
        .add(OpenCustomerReportingForm(isOpen: false));
  }

  _returnBackToPaymentPage() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Back To Payment Page ?"),
          content: Text(
            "Reporting wont be done",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _setIsCustomerReport();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        );
      },
    );
  }

  _confirmReportOfCustomer({required int c_bpartner_id}) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Confirm Report ?"),
          content: Text(
            "Yes To Report",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _postDefaulter(c_bpartner_id: c_bpartner_id);
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        );
      },
    );
  }

  _postDefaulter({required int c_bpartner_id}) {
    context.read<AddPaymentBloc>().add(ReportCustomerAsDefaulter(
        c_bpartner_id: c_bpartner_id,
        reason_type: reasonsIdentifiers[_selectedValue],
        remark: _remark.text));
  }

  final TextEditingController _remark = TextEditingController();

  _changeSelected(int? sel) {
    setState(() {
      _selectedValue = sel ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPaymentBloc, AddPaymentState>(
      listener: (BuildContext context, AddPaymentState state) {
        if(state.isCustomerReported != null){
          if(state.isCustomerReported!){
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Customer Reported'),
                  backgroundColor: Colors.green,
                ),
              );
            if (widget.title == null) {
              Navigator.of(context).pushAndRemoveUntil(
                  HomeScreen.route(prevGPCode: widget.title), (route) => false);
            } else {
              Navigator.of(context).push(CustListScreen.route(widget.title!));
            }
            showDialog<void>(
                context: context,
                builder: (_) => MsgDialog(msg: "Customer Report Success"));
          }else{
            showDialog<void>(
                context: context,
                builder: (_) => MsgDialog(msg: "Something Went Wrong"));
          }
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 21,
            ),
            Text('Customer Reporting For Defaulting' , style:
              TextStyle(fontSize: 21 , fontWeight: FontWeight.bold),),
            SizedBox(
              height: 21,
            ),
            RadioListTile(
              title: Text('Disagree To Pay'),
              value: 0,
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _changeSelected(value);
                });
              },
            ),
            RadioListTile(
              title: Text('Pay Next Time'),
              value: 1,
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _changeSelected(value);
                });
              },
            ),
            RadioListTile(
              title: Text('Others'),
              value: 2,
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _changeSelected(value);
                });
              },
            ),
            SizedBox(
              height: 12,
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 12)
            ,child: TextField(
                  controller: _remark,
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
                      hintText: "Remarks",
                      labelText: "Reason Remark",
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
                ),),
            SizedBox(
              height: 27,
            ),
            SizedBox(
              height: 45,
              width: 111,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF047857)),
                ),
                onPressed: () {
                  if (_selectedValue == 2 && _remark.text == "") {
                    _remarkNotSetForOthers();
                  } else {
                    _confirmReportOfCustomer(c_bpartner_id: widget.c_bpartner_id);
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 21,
            ),
            SizedBox(
              height: 45,
              width: 111,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black87),
                ),
                onPressed: () {
                  _returnBackToPaymentPage();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
