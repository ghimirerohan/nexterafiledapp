import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:next_era_collector/addnewtole/bloc/addnewtole_bloc.dart';

import '../../home/view/home_screen.dart';
import '../../res/widgets/InputField.dart';
import '../../res/widgets/MsgDialog.dart';

class AddNewTolePage extends StatefulWidget {
  final int ne_qrtoleadd_id;

  const AddNewTolePage({super.key, required this.ne_qrtoleadd_id});

  @override
  State<AddNewTolePage> createState() => _AddNewTolePageState();
}

class _AddNewTolePageState extends State<AddNewTolePage> {
  _popBackCustList() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Get Back ?"),
          content: const Text(
            "Discard Tole Addition ?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(HomeScreen.route());
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
        onPopInvoked: (value) {
          if (value) {
            _popBackCustList();
          }
        },
        child:
        BlocBuilder<AddNewToleBloc, AddnewtoleState>(
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
                      title: Text(
                        "New Tole ${widget.ne_qrtoleadd_id}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF047857),
                    ),
                    body: AddNewToleBody(
                      ne_qrtoleadd_id: widget.ne_qrtoleadd_id,
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
              ]);
            })
    );
  }
}

class AddNewToleBody extends StatefulWidget {
  final int ne_qrtoleadd_id;

  const AddNewToleBody({super.key, required this.ne_qrtoleadd_id});

  @override
  State<AddNewToleBody> createState() => _AddNewToleBodyState();
}

class _AddNewToleBodyState extends State<AddNewToleBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _toleName = TextEditingController();

  final TextEditingController _toleHeadName = TextEditingController();

  final TextEditingController _toleHeadPhone = TextEditingController();



  @override
  void initState() {}

  void finalDialogYesCallBack(BuildContext ctx) {
    Navigator.of(ctx).pop();
    context.read<AddNewToleBloc>().add(DraftToleAdditionEvent(
        ne_qrtoleadd_id: widget.ne_qrtoleadd_id,
        ward: context.read<AddNewToleBloc>().state.selectedWard!,
        toleName: _toleName.text,
        toleHeadName: _toleHeadName.text,
        toleHeadPhone: _toleHeadPhone.text));
  }

  _unFocusonSubmit(){
    _toleNameFocusNode.unfocus();
    _toleHeadNameFocusNode.unfocus();
    _wardFocusNode.unfocus();
    _toleHeadPhoneFocusNode.unfocus();
  }
  final _toleNameFocusNode = FocusNode();
  final _toleHeadNameFocusNode = FocusNode();
  final _wardFocusNode = FocusNode();
  final _toleHeadPhoneFocusNode = FocusNode();

  final _listWard = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  @override
  Widget build(BuildContext context) {
    final addNewToleBloc = context.read<AddNewToleBloc>();
    return BlocListener<AddNewToleBloc, AddnewtoleState>(
        listener: (context, state) {
          if (state.isPosted) {
            Navigator.of(context).push(HomeScreen.route());
            showDialog<void>(
                context: context,
                builder: (_) => MsgDialog(msg: "Tole Add Success"));
          }
        },
        child: Form(
          key: _formKey,
          child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                      editingController: _toleName,
                      labelText: "Tole Name",
                      hintText: "Tole Full Name",
                      icon: const Icon(
                        Icons.home,
                        size: 25,
                      ),
                      inputType: TextInputType.text,
                      validationBuilder: ValidationBuilder()
                          .minLength(1, '*Required')
                          .maxLength(50, 'Long Expression'),
                      focusNode: _toleNameFocusNode,
                    ), //Name
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AddNewToleBloc, AddnewtoleState>(
                        buildWhen: (previous, current) =>
                        previous.selectedWard != current.selectedWard,
                        builder: (context, state) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                focusNode: _wardFocusNode,
                                value: state.selectedWard,
                                onChanged: (value) {
                                  context
                                      .read<AddNewToleBloc>()
                                      .add(ChangeWardEvent(ward: value!));
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
                                        borderRadius: BorderRadius.circular(9)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(9)),
                                    hintText: 'Ward No',
                                    labelText: 'Ward ?',
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
                                    suffixIconColor: const Color(0xFF047857)),
                                items: _listWard.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList()),
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                      editingController: _toleHeadName,
                      labelText: "Tole Aadashya Ko Name",
                      hintText: "Tole Aadashya Ko Name",
                      icon: const Icon(
                        Icons.reduce_capacity_outlined,
                        size: 25,
                      ),
                      inputType: TextInputType.text,
                      validationBuilder:
                      ValidationBuilder().required("Tole Aadashya Ko Name Needed"),
                      focusNode: _toleHeadNameFocusNode,
                    ), //Phone
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                      editingController: _toleHeadPhone,
                      labelText: "Aadashya Ko Phone No.",
                      hintText: "Aadashya Ko Phone No.",
                      icon: const Icon(
                        Icons.streetview,
                        size: 25,
                      ),
                      inputType: TextInputType.number,
                      validationBuilder:
                      ValidationBuilder().required("Tole Aadashya Ko Phone Icoccrect").
                      maxLength(10).minLength(10),
                      focusNode: _toleHeadPhoneFocusNode,
                    ), //Email
                    const SizedBox(
                      height: 20,
                    ),

                    const SizedBox(height: 27),
                    SizedBox(
                      height: 45,
                      width: 222,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF047857)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _unFocusonSubmit();
                            _formKey.currentState!.save();
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text("Post New Tole ?"),
                                  content: Text(
                                      "Ward : ${addNewToleBloc.state.selectedWard}\n"
                                          "Tole : ${_toleName.text}\n"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Yes"),
                                      onPressed: () {
                                        finalDialogYesCallBack(ctx);
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
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        )
    );
  }
}