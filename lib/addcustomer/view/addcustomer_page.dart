import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_bloc.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_event.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_state.dart';
import 'package:next_era_collector/res/widgets/InputField.dart';
import 'package:next_era_collector/app.dart';
import 'package:next_era_collector/custlist/view/custlist_screen.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

import '../../res/widgets/MsgDialog.dart';

class AddCustomerPage extends StatefulWidget {
  final String title;
  final int c_location_id;
  final int ne_qrcustomeradd_id;

  const AddCustomerPage(
      {super.key,
      required this.title,
      required this.c_location_id,
      required this.ne_qrcustomeradd_id});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  _popBackCustList() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Get Back ?"),
          content: const Text(
            "To Customer Listing \nAnd Discard Customer Addition ?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(CustListScreen.route(widget.title));
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
    final addCustBloc = context.read<AddCustomerBloc>();

    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (value) {
          _popBackCustList();
        }
      },
      child: Stack(
        children: [
          Scaffold(
          body: AddCustBody(
            c_location_id: widget.c_location_id,
            title: widget.title,
            ne_qrcustomeradd_id: widget.ne_qrcustomeradd_id,
          ),
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                _popBackCustList();
              },
            ),
            centerTitle: true,
            title: Text(
              "New Customer ${widget.ne_qrcustomeradd_id}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF047857),
          ),
        ),
          if (addCustBloc.state.isPostLoading)
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (addCustBloc.state.isPostLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),]
      ),
    );
  }
}

class AddCustBody extends StatefulWidget {
  final String title;
  final int c_location_id;
  final int ne_qrcustomeradd_id;

  const AddCustBody(
      {super.key,
      required this.title,
      required this.c_location_id,
      required this.ne_qrcustomeradd_id});

  @override
  State<AddCustBody> createState() => _AddCustBodyState();
}

class _AddCustBodyState extends State<AddCustBody> {
  late SingleValueDropDownController _cnt;

  @override
  void dispose() {
    _cnt.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _cbpGroupFocusNode.dispose();
    _emailFocusNode.dispose();
    _houseStorNoFocusNode.dispose();
    _panNoFocusNode.dispose();
    _name.dispose();

    _mobile.dispose();

    _email.dispose();

    _housestory.dispose();

    _taxId.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();

  final TextEditingController _mobile = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _housestory = TextEditingController();

  final TextEditingController _taxId = TextEditingController();
  final TextEditingController _billNameCnt = TextEditingController();

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    context.read<AddCustomerBloc>().add(FetchCBPGroupEvent());
  }

  CBPGroup? getGroupModelFromName(String name) {
    for (CBPGroup value
        in context.read<AddCustomerBloc>().state.response.data!) {
      if (value.englishName == name) {
        return value;
      }
    }
  }

  void finalDialogYesCallBack(BuildContext ctx) {
    Navigator.of(ctx).pop();
    context.read<AddCustomerBloc>().add(PostCustomerEvents(
      billName: _billNameCnt.text,
        name: _name.text,
        phone: _mobile.text,
        email: _email.text == "" ? null : _email.text,
        housestory:
            _housestory.text == "" ? null : double.parse(_housestory.text),
        c_bp_group_id: context.read<AddCustomerBloc>().state.cbGroupIdNameMap[
            context.read<AddCustomerBloc>().state.selectedDDCBPGroup!.englishName]!,
        c_location_id: widget.c_location_id,
        taxID: _taxId.text == "" ? null : _taxId.text,
        ne_qrcustomeradd_id: widget.ne_qrcustomeradd_id,
        context: context));
  }

  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _billName = FocusNode();
  final _cbpGroupFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _houseStorNoFocusNode = FocusNode();
  final _panNoFocusNode = FocusNode();

  _unFocusAllFieldAfterSubitButtonPressed() {
    _nameFocusNode.unfocus();
    _phoneFocusNode.unfocus();
    _cbpGroupFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _houseStorNoFocusNode.unfocus();
    _panNoFocusNode.unfocus();
    _billName.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final addCustBloc = context.read<AddCustomerBloc>();
    return BlocListener<AddCustomerBloc, AddCustomerState>(
      listener: (context, state) {
        if (state.isPosted) {
          Navigator.of(context).push(CustListScreen.route(widget.title));
          showDialog<void>(
              context: context,
              builder: (_) =>  MsgDialog(msg: "Customer Add Success"));
        }
      },
      child: BlocBuilder<AddCustomerBloc, AddCustomerState>(
          builder: (context, state) {
        switch (addCustBloc.state.response.status) {
          case Status.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case Status.error:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(addCustBloc.state.response.message ??
                      "Some Error Occurred"),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        addCustBloc.add(FetchCBPGroupEvent());
                      },
                      child: const Text("Retry"))
                ],
              ),
            );
          case Status.completed:
            return Form(
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
                          editingController: _name,
                          labelText: "Name",
                          hintText: "Full Name",
                          icon: const Icon(
                            Icons.people_alt_sharp,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                          validationBuilder: ValidationBuilder()
                              .minLength(1, '*Required')
                              .maxLength(50, 'Long Expression'),
                          focusNode: _nameFocusNode,
                        ),
                        //Name
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<AddCustomerBloc, AddCustomerState>(
                            buildWhen: (previous, current) =>
                            previous.selectedDDCBPGroup !=
                                current.selectedDDCBPGroup,
                            builder: (context, state) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropDownTextField(
                                  searchKeyboardType: TextInputType.text,
                                  searchShowCursor: true,
                                  textFieldFocusNode: _cbpGroupFocusNode,
                                  clearOption: true,
                                  enableSearch: true,
                                  clearIconProperty:
                                  IconProperty(color: Color(0xFF047857)),
                                  searchTextStyle:
                                  const TextStyle(color: Color(0xFF047857)),
                                  searchDecoration: const InputDecoration(
                                      hintText: "Group Name"),
                                  textFieldDecoration: InputDecoration(
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
                                      hintText: 'Customer Type',
                                      labelText: 'Customer Group',
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
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return "Required field";
                                    } else {
                                      return null;
                                    }
                                  },
                                  dropDownItemCount:
                                  addCustBloc.state.ddCBGNames.length,
                                  dropDownList: addCustBloc.state.ddCBGNames
                                      .map<DropDownValueModel>((String value) {
                                    return DropDownValueModel(
                                        name: value, value: value);
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      if (value != "") {
                                        context.read<AddCustomerBloc>().add(
                                            ChangeCBPGroupDDEvent(
                                                value: getGroupModelFromName(
                                                    value.name)!));
                                      }
                                    }
                                  },
                                ),
                              );
                            }),
                        // BlocBuilder<AddCustomerBloc, AddCustomerState>(
                        //     buildWhen: (previous, current) =>
                        //         previous.selectedDDCBPGroup !=
                        //         current.selectedDDCBPGroup,
                        //     builder: (context, state) {
                        //       return Container(
                        //         decoration: BoxDecoration(
                        //           color: Colors.grey.shade100,
                        //           borderRadius: BorderRadius.circular(6),
                        //         ),
                        //         child: DropdownButtonFormField<String>(
                        //             isExpanded: true,
                        //             focusNode: _cbpGroupFocusNode,
                        //             value: state.selectedDDCBPGroup?.name,
                        //             onChanged: (value) {
                        //               context.read<AddCustomerBloc>().add(
                        //                   ChangeCBPGroupDDEvent(
                        //                       value: getGroupModelFromName(
                        //                           value!)!));
                        //             },
                        //             validator: (value) {
                        //               if (value == null) {
                        //                 return '* Required';
                        //               }
                        //               return null;
                        //             },
                        //             decoration: InputDecoration(
                        //                 focusColor: Colors.white,
                        //                 focusedBorder: OutlineInputBorder(
                        //                     borderSide: const BorderSide(
                        //                         color: Color(0xFF047857)),
                        //                     borderRadius:
                        //                         BorderRadius.circular(9)),
                        //                 border: OutlineInputBorder(
                        //                     borderSide: const BorderSide(
                        //                         color: Colors.red),
                        //                     borderRadius:
                        //                         BorderRadius.circular(9)),
                        //                 hintText: 'Customer Type',
                        //                 labelText: 'Customer Group',
                        //                 labelStyle: const TextStyle(
                        //                     color: Color(0xFF047857),
                        //                     fontSize: 18,
                        //                     fontWeight: FontWeight.w600),
                        //                 hintStyle: const TextStyle(
                        //                     color: Color(0xFF047857),
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.w300),
                        //                 suffixIcon: const Icon(
                        //                   Icons.group_add,
                        //                   size: 25,
                        //                 ),
                        //                 suffixIconColor:
                        //                     const Color(0xFF047857)),
                        //             items: addCustBloc.state.ddCBGNames
                        //                 .map<DropdownMenuItem<String>>(
                        //                     (String value) {
                        //               return DropdownMenuItem<String>(
                        //                   value: value, child: Text(value));
                        //             }).toList()),
                        //       );
                        //     }),
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          editingController: _mobile,
                          labelText: "Phone",
                          hintText: "Mobile No",
                          icon: const Icon(
                            Icons.phone_android,
                            size: 25,
                          ),
                          inputType: TextInputType.number,
                          validationBuilder: ValidationBuilder()
                              .minLength(10, "10 Digit")
                              .maxLength(10, "10 Digit"),
                          focusNode: _phoneFocusNode,
                        ),
                        //Phone
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          editingController: _billNameCnt,
                          labelText: "Bill Name",
                          hintText: "Bills Name",
                          icon: const Icon(
                            Icons.newspaper,
                            size: 25,
                          ),
                          inputType: TextInputType.text,
                          validationBuilder: ValidationBuilder()
                              .minLength(1, '*Required')
                              .maxLength(50, 'Long Expression'),
                          focusNode: _billName,
                        ),
                        //Name

                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          editingController: _email,
                          labelText: "Email",
                          hintText: "email@address.domain",
                          icon: const Icon(
                            Icons.email,
                            size: 25,
                          ),
                          inputType: TextInputType.emailAddress,
                          focusNode: _emailFocusNode,
                        ),
                        //Email
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<AddCustomerBloc, AddCustomerState>(
                            buildWhen: (previous, current) =>
                            previous.selectedDDCBPGroup !=
                                current.selectedDDCBPGroup,
                            builder: (context, state) {
                              return InputField(
                                editingController: _housestory,
                                labelText: "House Story Number",
                                hintText: "1,2,3",
                                icon: const Icon(
                                  Icons.house_siding_outlined,
                                  size: 25,
                                ),
                                inputType: TextInputType.number,
                                focusNode: _houseStorNoFocusNode,
                                validationBuilder: context
                                    .read<AddCustomerBloc>()
                                    .state
                                    .selectedDDCBPGroup
                                    ?.isStoryBased ==
                                    true
                                    ? ValidationBuilder().required(
                                    "Need House Story Number For This Group")
                                    : null,
                              ); //House Storey No
                            }),

                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          editingController: _taxId,
                          labelText: "PAN NO.",
                          hintText: "Pan No",
                          icon: const Icon(
                            Icons.integration_instructions,
                            size: 25,
                          ),
                          inputType: TextInputType.number,
                          focusNode: _panNoFocusNode,
                        ),
                        //taxId
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: addCustBloc.state.hasCard,
                              onChanged: (value) {
                                addCustBloc.add(
                                    ChangeHasCardStatus(changedValue: value!));
                              },
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              "Has Card ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 21),
                            )
                          ],
                        ),
                        // HasCardCheck()
                        BlocBuilder<AddCustomerBloc, AddCustomerState>(
                            builder: (context, state) {
                              if (!state.hasCard) {
                                return const SizedBox();
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 33,
                                      width: 144,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blueGrey),
                                        ),
                                        onPressed: () {
                                          addCustBloc.add(OpenCameraForCard());
                                        },
                                        child: Text(
                                          state.cardBase64 == null
                                              ? 'Upload'
                                              : 'Re-Upload',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    if (state.cardBase64 != null)
                                      const Text(
                                        'Uploaded !',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ],
                                );
                              }
                            }),

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
                              _unFocusAllFieldAfterSubitButtonPressed();

                              if (_formKey.currentState!.validate()) {
                                if (state.hasCard &&
                                    state.cardBase64 == null) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return MsgDialog(
                                            msg: "Card Picture Needed !");
                                      });
                                } else {
                                  _formKey.currentState!.save();
                                  String groupCBPToShow = addCustBloc
                                      .state.selectedDDCBPGroup!.englishName!;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Post New Customer ?"),
                                        content:
                                        Text("Name : ${_name.text}\n"
                                            "Group : $groupCBPToShow\n"
                                            "Phone : ${_mobile.text}"),
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
            );
          default:
            return const Center();
        }
      }),
    );
  }
}

