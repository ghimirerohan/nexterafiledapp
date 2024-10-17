import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_bloc.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_event.dart';
import 'package:next_era_collector/addpayment/widget/addPanNoandBusinessNo.dart';
import 'package:next_era_collector/addpayment/widget/submitAsDefaulter.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

import '../../custlist/view/custlist_screen.dart';
import '../../home/view/home_screen.dart';
import '../../res/utils/OpenQRScanner.dart';
import '../../res/widgets/InputField.dart';
import '../../res/widgets/MsgDialog.dart';
import '../../res/widgets/QRError.dart';
import '../bloc/addpayment_state.dart';

class AddPaymentPage extends StatefulWidget {
  final String? title;
  final CBpartner cBpartner;

  const AddPaymentPage({this.title, required this.cBpartner});

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final TextEditingController _newRate = TextEditingController();
  final TextEditingController _newPANNO = TextEditingController();
  final TextEditingController _newBusinessNO = TextEditingController();
  final TextEditingController _newPhoneNo = TextEditingController();

  int newQRToUpdateID = 0;





  _popBackCustList() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        if(context
            .read<AddPaymentBloc>().state.isReportingCustomer){
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
                  _closeDefaultReportinPage();
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
        }
        return AlertDialog(
          title: const Text("Get Back ?"),
          content: const Text(
            "To Customer Listing \nAnd Discard Payment Posting ?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                if (widget.title != null) {
                  Navigator.of(ctx).pop();
                  Navigator.of(context)
                      .push(CustListScreen.route(widget.title!));
                } else {
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

  //QRUpdate Of Customer
  _QRUpdateConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Confirm Update QR ?"),
          content: Text(
            "Update QR "
            "From : ${widget.cBpartner.value} TO $newQRToUpdateID",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();

                context.read<AddPaymentBloc>().add(ConfirmUpdateQREvent(
                    c_bpartner_id: widget.cBpartner.id!,
                    ne_qrcustomeradd_id: newQRToUpdateID));
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
  _onScanNewDataForQrUpdate() async {
    String? data = await openQRScanner();
    if (data != null) {
      if (!data.contains("https://nexteraportal.com/customer")) {
        showDialog<void>(
          context: context,
          builder: (_) => const QRErrorDialog(),
        );
      } else {
        data = data.substring(data.lastIndexOf("=") + 1);
        newQRToUpdateID = int.parse(data);
        if (data! == widget.cBpartner.value!) {
          showDialog<void>(
              context: context,
              builder: (_) => MsgDialog(
                  msg: "Current Same QR Scanned , Scan Different One"));
        } else {
          context.read<AddPaymentBloc>().add(UpdateQREvent(
              c_bpartner_id: widget.cBpartner.id!,
              ne_qrcustomeradd_id: newQRToUpdateID));
        }
      }
    }
  }

  //Rate Pan And Business No Edit/Update
  _postDataOfRateUpdate() {
    context
        .read<AddPaymentBloc>()
        .add(UpdateRateEvent(c_bpartner_id: widget.cBpartner.id!,
        rate: _newRate.text , businessNo: _newBusinessNO.text , pan: _newPANNO.text));
  }
  _openRateChangeConfirmDialog() {
    if(widget.cBpartner.ratePerMonth.toString() == _newRate.text){
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return MsgDialog(msg: "Same rate as Previous , Not Updated");
          });
    }else if(_newRate.text == "" && _newPANNO.text == "" && _newBusinessNO.text == ""){
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return MsgDialog(msg: "Nothing To Update");
          });
    }else{
      String msg = "";
      if(_newRate.text != ""){
        msg = "${msg}Rate From ${widget.cBpartner.ratePerMonth} TO ${_newRate.text}";
      }
      if(_newPANNO.text != ""){
        msg = "$msg\nPANNO From ${widget.cBpartner.taxId ?? "NULL"} TO ${_newPANNO.text}";
      }
      if(_newBusinessNO.text != ""){
        msg = "$msg\nBusinessNO From ${widget.cBpartner.businessNo ?? "NULL"} TO ${_newBusinessNO.text}";
      }
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Confirm Change ?"),
            content: Text(
              msg,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();

                  _postDataOfRateUpdate();
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

  }
  _openRateChangerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("UPDATE"),
          content: const Text(
            "Rate/PAN/Business No",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _newRate,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                  decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(9)),
                      contentPadding: const EdgeInsets.all(20),
                      hintText: "New Rate",
                      labelText: "Enter Rate/Month",
                      suffixIcon: const Icon(Icons.money),
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
                  height: 18,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _newPANNO,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                  decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(9)),
                      contentPadding: const EdgeInsets.all(20),
                      hintText: "PAN NO",
                      labelText: "Enter PAN NO",
                      suffixIcon: const Icon(Icons.document_scanner),
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
                  height: 18,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _newBusinessNO,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                  decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(9)),
                      contentPadding: const EdgeInsets.all(20),
                      hintText: "Business No",
                      labelText: "Enter Business No",
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
                  height: 18,
                ),
                SizedBox(
                  height: 36,
                  width: 96,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF047857)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _openRateChangeConfirmDialog();
                    },
                    child: const Text(
                      'OKAY',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //Phone Update/Edit of customer
  _postDataOfPhoneUpdate() {
    context
        .read<AddPaymentBloc>()
        .add(UpdatePhoneEvent(c_bpartner_id: widget.cBpartner.id!,
        phone : _newPhoneNo.text));
  }
  _openPhoneChangeConfirmDialog() {
    if(widget.cBpartner.phone == _newPhoneNo.text){
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return MsgDialog(msg: "Same Phone Number as Previous , Not Updated");
          });
    }else{
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Confirm Update ?"),
            content: Text(
              "Phone Number : ${_newPhoneNo.text}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();

                  _postDataOfPhoneUpdate();
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


  }
  _openPhoneChangerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("UPDATE"),
          content: const Text(
            "Phone No",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _newPhoneNo,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                  decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                          borderRadius: BorderRadius.circular(9)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(9)),
                      contentPadding: const EdgeInsets.all(20),
                      hintText: "Phone No",
                      labelText: "Phone No",
                      suffixIcon: const Icon(Icons.phone),
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
                  height: 18,
                ),
                SizedBox(
                  height: 36,
                  width: 96,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF047857)),
                    ),
                    onPressed: () {
                      if (_newPhoneNo.text == "" ||
                          _newPhoneNo.text == "0" ||
                          _newPhoneNo.text.length < 10 ||
                          _newPhoneNo.text.length > 10) {
                        Navigator.of(context).pop();
                        showDialog<void>(
                            context: context,
                            builder: (_) =>
                                MsgDialog(msg: "Empty/Invalid Phone No"));
                      } else {
                        Navigator.of(context).pop();

                        _openPhoneChangeConfirmDialog();
                      }
                    },
                    child: const Text(
                      'OKAY',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //SetTrueToOpenDefaulReporingForm
  _openDefaultReportinPage(){
    context
        .read<AddPaymentBloc>()
        .add(OpenCustomerReportingForm(isOpen: true));
  }
  //SetFalseToOpenDefaulReporingForm
  _closeDefaultReportinPage(){
    context
        .read<AddPaymentBloc>()
        .add(OpenCustomerReportingForm(isOpen: false));
  }

  //Menu In Customer payment for edit/update
  _openCustomerEditMenu() {
    showDialog<void>(
      context: context,
      builder: (_) => Center(
        child: SizedBox(
          width: 333,
          height: 273,
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _openDefaultReportinPage();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Report Customer"),
                        Icon(Icons.report)
                      ],
                    )), //Change Phone
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _onScanNewDataForQrUpdate();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Update New QR"),
                        Icon(Icons.qr_code_scanner_outlined)
                      ],
                    )), //NEWQR
                const SizedBox(
                  height: 12,
                ),
                if (context.read<AddPaymentBloc>().state.isUserAdmin)
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                        _openRateChangerDialog();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Edit Rate/PAN/Business No"),
                          Icon(Icons.price_change)
                        ],
                      )),
                  const SizedBox(
                  height: 12,
                ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _openPhoneChangerDialog();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Change Phone Number"),
                        Icon(Icons.phone)
                      ],
                    )), //Change Phone
                  const SizedBox(
                  height: 12,
                ),
                if (context.read<AddPaymentBloc>().state.isUserAdmin)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Deactivate This Customer"),
                        Icon(Icons.cancel)
                      ],
                    )), //Deactivate Customer
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        _popBackCustList();
      },
      child: BlocListener<AddPaymentBloc, AddPaymentState>(
        listener: (BuildContext context, AddPaymentState state) {
          if (state.askQRToUpdate) {
            _QRUpdateConfirmDialog();
          }
          if (state.isCustomerQRUpdated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('QR Updated'),
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
                builder: (_) => MsgDialog(msg: state.processMsg ?? "Success"));
          }

          if (state.isCustomerPhoneUpdated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Phone Updated'),
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
                builder: (_) => MsgDialog(msg: state.processMsg ?? "Success"));
          }

          if (state.isCustomerRateUpdated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Rate/Pan/Business Updated'),
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
                builder: (_) => MsgDialog(msg: state.processMsg ?? "Success"));
          }

          if (state.isCustomerQRUpdateFailed) {
            showDialog<void>(
                context: context,
                builder: (_) => MsgDialog(msg: state.processMsg ?? "Failed"));
          }

          if (state.isCustomerRateUpdateFailed) {
            showDialog<void>(
                context: context,
                builder: (_) => MsgDialog(msg: state.processMsg ?? "Failed"));
          }

          if (state.isCustomerPhoneUpdateFailed) {
            showDialog<void>(
                context: context,
                builder: (_) => MsgDialog(msg: state.processMsg ?? "Failed"));
          }
        },
        child: BlocBuilder<AddPaymentBloc, AddPaymentState>(
            builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                  appBar: AppBar(
                    leading: BackButton(
                      color: Colors.white,
                      onPressed: () {
                        _popBackCustList();
                      },
                    ),
                    centerTitle: true,
                    title: Text(
                    state.isReportingCustomer ?
                    "Reorting ${widget.cBpartner.value ?? ""}"
                    :
                      "New Payment ${widget.cBpartner.value ?? ""}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF047857),
                    actions: [
                      IconButton(
                          onPressed: () {
                            _openCustomerEditMenu();
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
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
            ],
          );
        }),
      ),
    );
  }
}

class AddPayBody extends StatefulWidget {
  final String? title;
  final CBpartner cBpartner;

  const AddPayBody({this.title, required this.cBpartner});

  @override
  State<AddPayBody> createState() => _AddPayBodyState();
}

class _AddPayBodyState extends State<AddPayBody> {
  @override
  void initState() {
    context
        .read<AddPaymentBloc>()
        .add(FetchAddPaymentData(c_bpartner_id: widget.cBpartner));
    if (((widget.cBpartner.taxId == null || widget.cBpartner.taxId == "0" || widget.cBpartner.taxId == "")
        && (widget.cBpartner.businessNo == null || widget.cBpartner.businessNo == "0" || widget.cBpartner.businessNo == "")
    && widget.cBpartner.cBPGroupID!.id != 1000090)
    || (widget.cBpartner.phone == null || widget.cBpartner.phone!.contains("9800000000")||
            widget.cBpartner.phone == "0" || widget.cBpartner.phone == "")
    ) {
      context.read<AddPaymentBloc>().add(OpenAddPanNoBusinessNo());
    }
  }

  CPeriod? getPeriodModelFromName(String name) {
    for (CPeriod value in context.read<AddPaymentBloc>().state.response.data!) {
      if (value.name == name) {
        return value;
      }
    }
  }

  void finalDialogYesCallBack(BuildContext ctx, double payAmt) {
    Navigator.of(ctx).pop();
    context.read<AddPaymentBloc>().add(PostPaymentData(
        c_bpartner_id: widget.cBpartner.id!,
        fromPeriodID:
            context.read<AddPaymentBloc>().state.selectedDDFromPeriod!.id!,
        toPeriodID: context.read<AddPaymentBloc>().state.selectedDDCPeriod!.id!,
        payAmt: payAmt,
        isDiscountEnabled: context.read<AddPaymentBloc>().state.isDiscountEnabled,
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
          if (widget.title == null) {
            Navigator.of(context).pushAndRemoveUntil(
                HomeScreen.route(prevGPCode: widget.title), (route) => false);
          } else {
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
                              c_bpartner_id: addPayBloc.state.model!));
                        },
                        child: const Text("Retry"))
                  ],
                ),
              );
            case Status.completed:
              if (state.isAddPanBusinessNeeded && !state.isUserAdmin) {
                return AddPanNoNusinessNo(model: addPayBloc.state.model!);
              }
              if(state.isReportingCustomer){
                return SubmitAsDefaulter(title : widget.title,
                    c_bpartner_id: widget.cBpartner.id!);
              }
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
                              text: addPayBloc.state.model?.name ?? "No Name"),
                          textColor: const Color(0xFF047857),
                          labelText: "Name",
                          hintText: "Full Name",
                          icon: const Icon(
                            Icons.people_alt_sharp,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ),
                        //Name
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          initalvalue:
                              addPayBloc.state.model?.cBPGroupID?.identifier ??
                                  "No Group",
                          textColor: const Color(0xFF047857),
                          labelText: "Customer Group",
                          hintText: "Customer Type",
                          icon: const Icon(
                            Icons.group_add,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ),
                        //Group
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          initalvalue:
                              "Rs. ${addPayBloc.state.model?.ratePerMonth?.toString() ?? "No Rate"}",
                          textColor: const Color(0xFF047857),
                          labelText: "Customer Rate/Month",
                          hintText: "Rate",
                          icon: const Icon(
                            Icons.monetization_on,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ),
                        //Rate
                          const SizedBox(
                            height: 20,
                          ),
                          InputField(
                          enabled: false,
                          initalvalue:
                              addPayBloc.state.model?.phone ?? "No Phone Number",
                          textColor: const Color(0xFF047857),
                          labelText: "Phone",
                          hintText: "Phone No.",
                          icon: const Icon(
                            Icons.phone,
                            size: 25,
                          ),
                          inputType: TextInputType.number,
                        ), //Phone

                        if (state.isUserAdmin)
                          InputField(
                          enabled: false,
                          initalvalue:
                              addPayBloc.state.model?.taxId ?? "No PAN Number",
                          textColor: const Color(0xFF047857),
                          labelText: "PAN",
                          hintText: "PAN No.",
                          icon: const Icon(
                            Icons.document_scanner,
                            size: 25,
                          ),
                          inputType: TextInputType.number,
                        ),//PANNO
                        if (state.isUserAdmin)
                        //PAN NO.
                          const SizedBox(
                          height: 20,
                        ),
                        if (state.isUserAdmin)
                          InputField(
                          enabled: false,
                          initalvalue: addPayBloc.state.model?.businessNo ??
                              "No Business Number",
                          textColor: const Color(0xFF047857),
                          labelText: "Business No",
                          hintText: "Business No.",
                          icon: const Icon(
                            Icons.business_sharp,
                            size: 25,
                          ),
                          inputType: TextInputType.number,
                        ),//BUSINESS NO
                        //Business NO.
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          enabled: false,
                          initalvalue:
                              addPayBloc.state.model?.toPeriodID?.identifier ??
                                  "No Payments",
                          textColor: const Color(0xFF047857),
                          labelText: "Last Paid Month",
                          hintText: "Paid Month",
                          icon: const Icon(
                            Icons.calendar_month,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                        ),
                        //Last Month Paid Period
                        const SizedBox(
                          height: 20,
                        ),
                        // InputField(
                        //   enabled: false,
                        //   initalvalue: widget
                        //           .cBpartner.currentFromPeriodID?.identifier ??
                        //       "No Record",
                        //   textColor: const Color(0xFF047857),
                        //   labelText: "Current Payment From",
                        //   hintText: "Next Pay From Month",
                        //   icon: const Icon(
                        //     Icons.calendar_month,
                        //     size: 25,
                        //   ),
                        //   inputType: TextInputType.text,
                        // ), //Current Next Period To Pay From
                        BlocBuilder<AddPaymentBloc, AddPaymentState>(
                            buildWhen: (previous, current) =>
                                previous.selectedDDFromPeriod !=
                                current.selectedDDFromPeriod,
                            builder: (context, state) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: state.selectedDDFromPeriod?.name,
                                    onChanged: (value) {
                                      context.read<AddPaymentBloc>().add(
                                          ChangeDDFromPeriod(
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
                                        labelText: "Current Payment From",
                                        hintText: "Next Pay From Month",
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
                            }),
                        //DropDown of From periods
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
                            }),
                        //DropDown of To periods
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<AddPaymentBloc, AddPaymentState>(
                            builder: (context, state) {
                          int selectedMonths = state.selectedDDCPeriod!.id! -
                              (state.selectedDDFromPeriod?.id ?? 0) +
                              1;
                          double ratePerMonth = addPayBloc.state.model!.ratePerMonth!;
                          double totalPrice = selectedMonths * ratePerMonth;
                          return Column(
                            children: [
                              Text(
                                "Total Months : $selectedMonths     Total Price : Rs. $totalPrice",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              if (selectedMonths >= 12)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Checkbox(
                                    value: state.isDiscountEnabled ?? false,
                                    onChanged: (value){
                                      context.read<AddPaymentBloc>().add(
                                          ChangeDiscountEnabledEvent(
                                              enableDiscount: value  ?? false));
                                    }) ,
                                  const Text("Enable Discount" ,
                                    style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w700),)
                                ],),
                              if (selectedMonths >= 12 && (state.isDiscountEnabled ?? false))
                                Text(
                                  "Discounted Total Price : Rs. ${totalPrice - ratePerMonth}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                if (state.selectedDDCPeriod!.id! <
                                    state.selectedDDFromPeriod!.id!) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return MsgDialog(
                                          msg: "To Period Before From Period");
                                    },
                                  );
                                } else {
                                  _formKey.currentState!.save();
                                  int selectedMonths =
                                      state.selectedDDCPeriod!.id! -
                                          state.selectedDDFromPeriod!.id! +
                                          1;
                                  double ratePerMonth =
                                      addPayBloc.state.model!.ratePerMonth!;
                                  double totalPrice =
                                      selectedMonths * ratePerMonth;
                                  if (selectedMonths >= 12 && (state.isDiscountEnabled ?? false)) {
                                    totalPrice = totalPrice - ratePerMonth;
                                  }
                                  String selectedPeriod =
                                      addPayBloc.state.selectedDDCPeriod!.name!;
                                  String selectedFromperiod = addPayBloc
                                      .state.selectedDDFromPeriod!.name!;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return AlertDialog(
                                        title:
                                            const Text("Draft New Payment ?"),
                                        content: Text(
                                          "Name : ${addPayBloc.state.model!.name}\n"
                                          "From : $selectedFromperiod"
                                          " To $selectedPeriod\n"
                                          "Total Months  : $selectedMonths\n"
                                          "Total Amount : Rs. $totalPrice",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () {
                                              finalDialogYesCallBack(
                                                  ctx, totalPrice);
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
