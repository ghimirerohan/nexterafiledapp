import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_bloc.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_event.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_state.dart';
import 'package:next_era_collector/addnewlocation/bloc/addlocation_event.dart';
import 'package:next_era_collector/home/view/home_screen.dart';
import 'package:next_era_collector/res/widgets/InputField.dart';
import 'package:next_era_collector/app.dart';
import 'package:next_era_collector/custlist/view/custlist_screen.dart';
import 'package:next_era_collector/res/widgets/MsgDialog.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

import '../../res/widgets/OverlayLoading.dart';
import '../bloc/addlocation_bloc.dart';
import '../bloc/addlocation_state.dart';

class AddLocationPage extends StatefulWidget {
  final int ne_qrlocationadd_id;

  const AddLocationPage(
      {super.key,required this.ne_qrlocationadd_id});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  _popBackCustList(){
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title:
          const Text("Get Back ?"),
          content: const Text("Discard Location Addition ?",style:
          TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
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
      onPopInvoked: (value){
        if(value){
          _popBackCustList();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                _popBackCustList();
              },
            ),
            centerTitle: true,
            title:  Text(
              "New Location ${widget.ne_qrlocationadd_id}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF047857),
          ),
          body: AddLocationBody(
            ne_qrlocationadd_id: widget.ne_qrlocationadd_id,
          )),
    );
  }
}

class AddLocationBody extends StatefulWidget {
  final int ne_qrlocationadd_id;

  const AddLocationBody(
      {super.key, required this.ne_qrlocationadd_id});

  @override
  State<AddLocationBody> createState() => _AddLocationBodyState();
}

class _AddLocationBodyState extends State<AddLocationBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tole = TextEditingController();

  final TextEditingController _street = TextEditingController();

  final TextEditingController _owner = TextEditingController();

  final TextEditingController _lat = TextEditingController();

  final TextEditingController _long = TextEditingController();


  @override
  void initState() {
  }


  void finalDialogYesCallBack(BuildContext ctx) {
    Navigator.of(ctx).pop();
    context.read<AddLocationBloc>().add(DraftLocationAdditionEvent(
        ne_qrlocationadd_id: widget.ne_qrlocationadd_id,
        ward: context.read<AddLocationBloc>().state.selectedWard!, tole:
    _tole.text , street: _street.text ,owner: _owner.text ));
  }

  final _toleFocusNode = FocusNode();
  final _streetFocusNode = FocusNode();
  final _wardFocusNode = FocusNode();
  final _ownerFocusNode = FocusNode();
  final _latFocusNode = FocusNode();
  final _longFocusNode = FocusNode();
  final _listWard = ['1' ,'2' , '3' ,'4' , '5' , '6' , '7' , '8' , '9' , '10'];

  @override
  Widget build(BuildContext context) {
    final addCustBloc = context.read<AddLocationBloc>();
    return BlocListener<AddLocationBloc, AddLocationState>(
      listener: (context, state) {
        if (state.isPostLoading) {
          showDialog<void>(
              context: context,
              builder: (_) => const Overlayloading());
        }else{
          if(Navigator.of(context).canPop()){
            Navigator.of(context).pop();
          }
        }
        if (state.isPosted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('New Location Drafted'),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.of(context).push(HomeScreen.route());
          showDialog<void>(
              context: context,
              builder: (_) =>  MsgDialog(msg: "Location Add Success"));
          
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
                    editingController: _owner,
                    labelText: "Owner Name",
                    hintText: "Full Name",
                    icon: const Icon(
                      Icons.people_alt_sharp,
                      size: 25,
                    ),
                    inputType: TextInputType.text,
                    validationBuilder: ValidationBuilder()
                        .minLength(1, '*Required')
                        .maxLength(50, 'Long Expression'),
                    focusNode: _ownerFocusNode,
                  ), //Name
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<AddLocationBloc, AddLocationState>(
                      buildWhen: (previous, current) =>
                      previous.selectedWard !=
                          current.selectedWard,
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
                                context.read<AddLocationBloc>().add(
                                    ChangeWardEvent(ward: value!));
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
                                  suffixIconColor:
                                  const Color(0xFF047857)),
                              items: _listWard
                                  .map<DropdownMenuItem<String>>(
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
                    editingController: _tole,
                    labelText: "Tole ",
                    hintText: "Tole Name",
                    icon: const Icon(
                      Icons.reduce_capacity_outlined,
                      size: 25,
                    ),
                    inputType: TextInputType.text,
                    validationBuilder: ValidationBuilder()
                        .required("Tole Name Needed"),
                    focusNode: _toleFocusNode,
                  ), //Phone
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    editingController: _street,
                    labelText: "Street",
                    hintText: "Street name",
                    icon: const Icon(
                      Icons.streetview,
                      size: 25,
                    ),
                    inputType: TextInputType.text,
                    focusNode: _streetFocusNode,
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
                          _formKey.currentState!.save();
                          showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title:
                                const Text("Post New Location ?"),
                                content: Text("Ward : ${addCustBloc.state.selectedWard}\n"
                                    "Tole : ${_tole.text}\n"),
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
