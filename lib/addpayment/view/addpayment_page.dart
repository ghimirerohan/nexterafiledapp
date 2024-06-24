import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_bloc.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_event.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

import '../../custlist/view/custlist_screen.dart';
import '../../home/view/home_screen.dart';
import '../../res/widgets/InputField.dart';
import '../../res/widgets/MsgDialog.dart';
import '../bloc/addpayment_state.dart';

class AddPaymentPage extends StatefulWidget {
  final String? title;
  final CBpartner cBpartner;

  const AddPaymentPage({ this.title, required this.cBpartner});

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  _popBackCustList(){
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title:
          const Text("Get Back ?"),
          content: const Text("To Customer Listing \nAnd Discard Payment Posting ?",style:
          TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                if(widget.title != null){
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(CustListScreen.route(widget.title!));
                }else{
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      HomeScreen.route(prevGPCode: widget.title),
                          (route) => false);
                }

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value){
        _popBackCustList();
      },
      child:  BlocBuilder<AddPaymentBloc, AddPaymentState>(
          builder: (context, state) {
            return Stack(children: [
              Scaffold(
                  appBar: AppBar(
                    leading: BackButton(
                      color: Colors.white,
                      onPressed: () {
                        _popBackCustList();
                      },
                    ),
                    centerTitle: true,
                    title:  Text(
                      "New Payment" ,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF047857),
                  ),
                  body: AddPayBody(
                    cBpartner: widget.cBpartner,
                    title: widget.title,
                  )),
              if (state.isPostLoading)
                const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              if (state.isPostLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],);}),

    );
  }
}

class AddPayBody extends StatefulWidget {
  final String? title;
  final CBpartner cBpartner;

  const AddPayBody({ this.title, required this.cBpartner});

  @override
  State<AddPayBody> createState() => _AddPayBodyState();
}

class _AddPayBodyState extends State<AddPayBody> {
  @override
  void initState() {
    context
        .read<AddPaymentBloc>()
        .add(FetchAddPaymentData(c_bpartner_id: widget.cBpartner));
  }

  CPeriod? getPeriodModelFromName(String name) {
    for (CPeriod value in context.read<AddPaymentBloc>().state.response.data!) {
      if (value.name == name) {
        return value;
      }
    }
  }

  void finalDialogYesCallBack(BuildContext ctx , double payAmt) {
    Navigator.of(ctx).pop();
    context.read<AddPaymentBloc>().add(
        PostPaymentData(
        c_bpartner_id: widget.cBpartner.id!,
        fromPeriodID: widget.cBpartner.currentFromPeriodID!.id!,
        toPeriodID: context.read<AddPaymentBloc>().state.selectedDDCPeriod!.id!,
        payAmt: payAmt,
        context: context));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final addPayBloc = context.read<AddPaymentBloc>();

    return BlocListener<AddPaymentBloc, AddPaymentState>(
      listener: (context, state) {
        if (state.isPosted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('New Payment Added'),
                backgroundColor: Colors.green,
              ),
            );
          if(widget.title == null){
            Navigator.of(context).pushAndRemoveUntil(
                HomeScreen.route(prevGPCode: widget.title),
                    (route) => false);
          }else{
            Navigator.of(context).push(CustListScreen.route(widget.title!));
          }
          showDialog<void>(
              context: context,
              builder: (_) => MsgDialog(msg: "Payment Add Success"));
        }
      },
      child: BlocBuilder<AddPaymentBloc, AddPaymentState>(
        builder: (context, state) {
          switch (addPayBloc.state.response.status) {
            case Status.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case Status.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(addPayBloc.state.response.message ??
                        "Some Error Occured"),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          addPayBloc.add(FetchAddPaymentData(
                              c_bpartner_id: widget.cBpartner));
                        },
                        child: const Text("Retry"))
                  ],
                ),
              );
            case Status.completed:
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          editingController: TextEditingController(
                              text: widget.cBpartner.name ?? "No Name"),
                          textColor: const Color(0xFF047857),
                          labelText: "Name",
                          hintText: "Full Name",
                          icon: const Icon(
                            Icons.people_alt_sharp,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ), //Name
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          initalvalue:
                              widget.cBpartner.cBPGroupID?.identifier ??
                                  "No Group",
                          textColor: const Color(0xFF047857),
                          labelText: "Customer Group",
                          hintText: "Customer Type",
                          icon: const Icon(
                            Icons.group_add,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ), //Group
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          initalvalue:
                              "Rs. ${widget.cBpartner.ratePerMonth?.toString() ??
                                  "No Rate"}" ,
                          textColor: const Color(0xFF047857),
                          labelText: "Customer Rate/Month",
                          hintText: "Rate",
                          icon: const Icon(
                            Icons.monetization_on,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ), //Rate
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          initalvalue:
                              widget.cBpartner.toPeriodID?.identifier ??
                                  "No Payments",
                          textColor: const Color(0xFF047857),
                          labelText: "Last Paid Month",
                          hintText: "Paid Month",
                          icon: const Icon(
                            Icons.calendar_month,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ), //Last Month Paid Period
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          initalvalue: widget
                                  .cBpartner.currentFromPeriodID?.identifier ??
                              "No Record",
                          textColor: const Color(0xFF047857),
                          labelText: "Current Payment From",
                          hintText: "Next Pay From Month",
                          icon: const Icon(
                            Icons.calendar_month,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ), //Current Next Period To Pay From
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<AddPaymentBloc, AddPaymentState>(
                            buildWhen: (previous, current) =>
                                previous.selectedDDCPeriod !=
                                current.selectedDDCPeriod,
                            builder: (context, state) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: state.selectedDDCPeriod?.name,
                                    onChanged: (value) {
                                      context.read<AddPaymentBloc>().add(
                                          ChangeDDToPeriod(
                                              period: getPeriodModelFromName(
                                                  value!)!));
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return '* Required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xFF047857)),
                                            borderRadius:
                                                BorderRadius.circular(9)),
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(9)),
                                        hintText: 'Pay Till Period',
                                        labelText: 'Pay Till',
                                        labelStyle: const TextStyle(
                                            color: Color(0xFF047857),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        hintStyle: const TextStyle(
                                            color: Color(0xFF047857),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                        suffixIcon: const Icon(
                                          Icons.group_add,
                                          size: 25,
                                        ),
                                        suffixIconColor:
                                            const Color(0xFF047857)),
                                    items: addPayBloc.state.ddCperiodNames
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList()),
                              );
                            }), //DropDown of periods
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<AddPaymentBloc, AddPaymentState>(
                            buildWhen: (previous, current) =>
                                previous.selectedDDCPeriod !=
                                current.selectedDDCPeriod,
                            builder: (context, state) {
                              int selectedMonths = state.selectedDDCPeriod!.id!
                                  - widget.cBpartner.currentFromPeriodID!.id! + 1;
                              double ratePerMonth = widget.cBpartner.ratePerMonth!;
                              double totalPrice = selectedMonths * ratePerMonth;
                              return Column(
                                children: [
                                  Text("Total Months : $selectedMonths     Total Price : Rs. $totalPrice",
                                  style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 6,),
                                  if(selectedMonths >= 12)(
                                  Text("Discounted Total Price : Rs. ${totalPrice - ratePerMonth}",
                                    style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),)
                                  )
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 21,
                        ),
                        SizedBox(
                          height: 45,
                          width: 180,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF047857)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                int selectedMonths = state.selectedDDCPeriod!.id!
                                    - widget.cBpartner.currentFromPeriodID!.id! + 1;
                                double ratePerMonth = widget.cBpartner.ratePerMonth!;
                                double totalPrice = selectedMonths * ratePerMonth;
                                if(selectedMonths >= 12){
                                  totalPrice = totalPrice - ratePerMonth;
                                }
                                String selectedPeriod =
                                addPayBloc.state.selectedDDCPeriod!.name!;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title:
                                      const Text("Draft New Payment ?"),
                                      content: Text("Name : ${widget.cBpartner.name}\n"
                                          "From : ${widget.cBpartner.toPeriodID!.identifier}"
                                          " To $selectedPeriod\n"
                                          "Total Months  : $selectedMonths\n"
                                          "Total Amount : Rs. $totalPrice",style:
                                      const TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
                                      actions: [
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            finalDialogYesCallBack(ctx ,totalPrice );
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
                            },
                            child: const Text(
                              'PAY !',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            default:
              return const Center();
          }
        },
      ),
    );
  }
}
