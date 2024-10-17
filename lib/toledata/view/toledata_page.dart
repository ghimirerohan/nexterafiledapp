import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/toledata/bloc/toledata_bloc.dart';
import 'package:next_era_collector/toledata/bloc/toledata_event.dart';
import 'package:next_era_collector/toledata/bloc/toledata_state.dart';

import '../../home/view/home_screen.dart';
import '../../res/utils/OpenQRScanner.dart';
import '../../res/widgets/InputField.dart';
import '../../res/widgets/MsgDialog.dart';
import '../../res/widgets/QRError.dart';

class ToledataPage extends StatefulWidget {
  final int toleID;

  const ToledataPage({super.key, required this.toleID});

  @override
  State<ToledataPage> createState() => _ToledataPageState();
}

class _ToledataPageState extends State<ToledataPage> {
  @override
  void initState() {
    _fetchToleData();
    super.initState();
  }

  _fetchToleData() {
    context.read<ToleDataBloc>().add(FetchToleDataEvent(toleID: widget.toleID));
  }

  _popBackHome() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Get Back ?"),
          content: const Text(
            "To Home Screen \nFrom Customer Listing",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    HomeScreen.route(prevGPCode: null), (route) => false);
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

  _onScanNewData() async {
    String? data = await openQRScanner();
    if (data != null) {
      if (!data.contains("https://nexteraportal.com/location") &&
          !data.contains("https://www.google.com/maps/place/") &&
          !data.contains("https://nexteraportal.com/customer")) {
        showDialog<void>(
          context: context,
          builder: (_) => const QRErrorDialog(),
        );
      } else {
        if (data.contains("https://nexteraportal.com/customer")) {
          data = data.substring(data.lastIndexOf("=") + 1);
          context.read<ToleDataBloc>().add(LinkNewBuildingEvent(
              ne_qrcustomer_id: int.parse(data), ne_tole_id: widget.toleID));
        } else if (data.contains("https://nexteraportal.com/location")) {
          data = data.substring(data.lastIndexOf("=") + 1);
          context.read<ToleDataBloc>().add(LinkNewBuildingEvent(
              ne_qrlocation_id: int.parse(data), ne_tole_id: widget.toleID));
        } else if (data.contains("https://www.google.com/maps/place/")) {
          data = data.substring(0, data.length - 1);
          data = data.substring(data.lastIndexOf('/') + 1);
          context.read<ToleDataBloc>().add(
              LinkNewBuildingEvent(gpCode: data, ne_tole_id: widget.toleID));
        }
      }
    }
  }

  _openAlertDialog(String msg) {
    showDialog<void>(context: context, builder: (_) => MsgDialog(msg: msg));
    _fetchToleData();
  }

  _confrimLinkToTole(
      {required int c_location_id,
      required String price,
      required int noOfCustomers}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Confirm To Link"),
          content: Text(
            "Total Customers Of This Building : $noOfCustomers"
            "\nTotal Price/Month From This Building : $price"
            "\nYes to make house member of the tole",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(ctx).pop();
                context.read<ToleDataBloc>().add(LinkNewBuildingEvent(
                    ne_tole_id: widget.toleID, c_location_id: c_location_id));
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop();
                _fetchToleData();
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
            _popBackHome();
          }
        },
        child: BlocListener<ToleDataBloc, ToleDataState>(
          listener: (context, state) {
            if (state is AlertErrorDialogState) {
              _openAlertDialog(state.msg);
            } else if (state is OpenConfirmationDialogueState) {
              _confrimLinkToTole(
                  c_location_id: state.c_location_id,
                  price: state.price,
                  noOfCustomers: state.numberOfCustomers);
            } else if (state is ToleUpdateSuccessState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('House Linked With Tole'),
                    backgroundColor: Colors.green,
                  ),
                );
              _openAlertDialog("Success Tole Linked With House");
            }
          },
          child: BlocBuilder<ToleDataBloc, ToleDataState>(
              builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    leading: BackButton(
                      color: Colors.white,
                      onPressed: () {
                        _popBackHome();
                      },
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            _onScanNewData();
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
                    centerTitle: true,
                    title: Text(
                      "Tole : ${widget.toleID}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF047857),
                  ),
                  body: BlocBuilder<ToleDataBloc, ToleDataState>(
                      builder: (context, state) {
                    if (state is LoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is errorState) {
                      return Center(
                        child: Text("error"),
                      );
                    } else if (state is dataFetchedState) {
                      return Padding(
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
                                    text: state.toleData.name ?? "No Name"),
                                textColor: const Color(0xFF047857),
                                labelText: "Tole Name",
                                hintText: "Tole Name",
                                icon: const Icon(
                                  Icons.people_rounded,
                                  size: 25,
                                ),
                                inputType: TextInputType.text,
                              ), //Tole Name
//Name
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                enabled: false,
                                editingController: TextEditingController(
                                    text: state.toleData.ward?.id ?? "No Ward"),
                                textColor: const Color(0xFF047857),
                                labelText: "Tole Ward No.",
                                hintText: "Ward No",
                                icon: const Icon(
                                  Icons.location_city,
                                  size: 25,
                                ),
                                inputType: TextInputType.text,
                              ), //Tole Ward
//Name
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                enabled: false,
                                editingController: TextEditingController(
                                    text: state.toleData.neToleheadName ??
                                        "No Name"),
                                textColor: const Color(0xFF047857),
                                labelText: "Tole Head Name",
                                hintText: "Tole Adakshya Name",
                                icon: const Icon(
                                  Icons.person,
                                  size: 25,
                                ),
                                inputType: TextInputType.text,
                              ), //Tole HeadName
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                enabled: false,
                                editingController: TextEditingController(
                                    text: state.toleData.neToleheadPhoneno ??
                                        "No Phone"),
                                textColor: const Color(0xFF047857),
                                labelText: "Tole Head Phone No.",
                                hintText: "Tole Adakshya Phone",
                                icon: const Icon(
                                  Icons.phone,
                                  size: 25,
                                ),
                                inputType: TextInputType.text,
                              ), //Tole Head Phone
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                enabled: false,
                                editingController: TextEditingController(
                                    text: state.toleData.neToleNoofhouses
                                            ?.toString() ??
                                        "0"),
                                textColor: const Color(0xFF047857),
                                labelText: "Total Houses",
                                hintText: "Tole Total Houses",
                                icon: const Icon(
                                  Icons.house_siding_outlined,
                                  size: 25,
                                ),
                                inputType: TextInputType.text,
                              ), //Tole No. Of Buildings
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                enabled: false,
                                editingController: TextEditingController(
                                    text: state.toleData.neToleNoofcustomers
                                            ?.toString() ??
                                        "0"),
                                textColor: const Color(0xFF047857),
                                labelText: "No of Customers",
                                hintText: "Total Customers",
                                icon: const Icon(
                                  Icons.people_rounded,
                                  size: 25,
                                ),
                                inputType: TextInputType.text,
                              ), //Tole No of Customer
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                enabled: false,
                                editingController: TextEditingController(
                                    text: state.toleData.price?.toString() ??
                                        "0"),
                                textColor: const Color(0xFF047857),
                                labelText: "Total Rate/Month",
                                hintText: "Tole Total Price",
                                icon: const Icon(
                                  Icons.people_rounded,
                                  size: 25,
                                ),
                                inputType: TextInputType.text,
                              ), //Tole Rate/Month
                            ],
                          )));
                    } else {
                      return Center();
                    }
                    return Center();
                  }),
                ),
                if (state is ScreenDisabledLoadingState)
                  const Opacity(
                    opacity: 0.8,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                if (state is ScreenDisabledLoadingState)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }),
        ));
  }
}
