import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addnewlocation/view/addlocation_screen.dart';
import 'package:next_era_collector/custlist/view/custlist_screen.dart';
import 'package:next_era_collector/home/bloc/home_bloc/home_bloc.dart';
import 'package:next_era_collector/home/bloc/home_bloc/home_events.dart';
import 'package:next_era_collector/home/bloc/home_bloc/home_states.dart';
import 'package:next_era_collector/login/view/login_page.dart';
import 'package:next_era_collector/map/view/NextEraMapScreen.dart';
import 'package:next_era_collector/res/widgets/OverlayLoading.dart';
import 'package:next_era_collector/toledata/view/toledata_screen.dart';


import '../../../authentication/bloc/auth_bloc.dart';
import '../../addnewtole/view/addnewtole_screen.dart';
import '../../addpayment/view/addpayment_screen.dart';
import '../../res/utils/OpenQRScanner.dart';
import '../../res/widgets/MsgDialog.dart';
import '../../res/widgets/QRError.dart';

class HomePage extends StatefulWidget {
  final String? prevGPCode;

  const HomePage({super.key, this.prevGPCode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<HomeBloc>().add(FetchTotalCollectionAmount());
    super.initState();
  }

  bool isQRDataValid(String data) {
    if (data.contains("https://www.google.com/maps/place/") ||
        data.contains("https://nexteraportal.com/customer") ||
        data.contains("https://nexteraportal.com/location")||
        data.contains("https://nexteraportal.com/tole/?id="))
    {
      return true;
    } else {
      return false;
    }
  }

  _onOpenPreviousData(BuildContext ctx) {
    Navigator.of(ctx).pop();
    Navigator.of(context).push(CustListScreen.route(widget.prevGPCode!));
  }

  _onScanNewData(BuildContext? ctx) async {
    if (ctx != null) {
      Navigator.of(ctx).pop();
    }
    String? data = await openQRScanner();
    if (data != null) {
      if (!isQRDataValid(data)) {
        showDialog<void>(
          context: context,
          builder: (_) => const QRErrorDialog(),
        );
      } else {
        if (data.contains("https://nexteraportal.com/customer")) {
          context.read<HomeBloc>().add(QRScannedEvent(
              qrData: data, isDirectPayment: true, isQRValid: true));
        } else {
          context.read<HomeBloc>().add(QRScannedEvent(
              qrData: data, isDirectPayment: false, isQRValid: true));
        }
      }
    }
  }

  _popBackExitCallBack() {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext ctx) {
    //     return AlertDialog(
    //       title: const Text("Exit"),
    //       content: const Text(
    //         "Sure To Exit The App ?",
    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    //       ),
    //       actions: [
    //         TextButton(
    //           child: const Text("Yes"),
    //           onPressed: () {
    //             SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //           },
    //         ),
    //         TextButton(
    //           child: const Text("No"),
    //           onPressed: () {
    //             Navigator.of(ctx).pop();
    //           },
    //         )
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();
    final homeBloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) async {
        if(state.optionBeforeDirectPay){
          showDialog<void>(
            context: context,
            builder: (_) => Center(
              child: Container(
                width: 333,
                height: 333,
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            homeBloc.add(OpenCustListAfterDirectPayScanned());
                          },
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Open This Tole's Data"),
                              Icon(Icons.location_city)
                            ],
                          )),
                      const SizedBox(
                        height: 6,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            homeBloc.add(OpenCustListAfterDirectPayScanned());
                          },
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Open This Location's List"),
                              Icon(Icons.location_city)
                            ],
                          )),
                      const SizedBox(
                        height: 6,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            homeBloc.add(OpenDirectAfterDirectPayScanned());
                          },
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Open Direct Payment"),
                              Icon(Icons.person)
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (state.isQRValid) {
          if (state.isDirectPayment) {
            if (state.custModel == null) {
              showDialog<void>(
                context: context,
                builder: (_) => const QRErrorDialog(),
              );
            } else {
              Navigator.of(context)
                  .push(AddPaymentScreen.route(cBpartner: state.custModel!));
            }
          } else {
            if(state.qrData.contains('Tole')){
              String data = state.qrData.substring(state.qrData.lastIndexOf(":")+1);
              Navigator.of(context).push(
                  ToleDataScreen.route(toleID: int.parse(data)));

            }else{
              Navigator.of(context).push(
                  CustListScreen.route(state.qrData.replaceAll("%2B", "+")));
            }

          }
        }
        if (state.logOutRequested) {
          Navigator.of(context)
              .pushAndRemoveUntil(LoginPage.route(), (route) => false);
        }
        if (state.newLocationAddInProgressOrTaken) {
          showDialog<void>(
            context: context,
            builder: (_) => MsgDialog(msg: state.locationAddMsg),
          );
        } else if (state.isAddLocationOkay) {
          Navigator.of(context).push(AddLocationScreen.route(
              ne_qrlocationadd_id: int.parse(state.locationAddMsg)));
        }
        else if (state.isAddToleOkay) {
          Navigator.of(context).push(AddNewToleScreen.route(
              ne_qrtoleadd_id: int.parse(state.locationAddMsg)));
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (value) {
          if (value) {
            _popBackExitCallBack();
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, HomeState state) {
            return Stack(
                children: [
                  Scaffold(
                    extendBody: true,
                    body: Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage("assets/images/damakCover.jpg"),
                              fit: BoxFit.cover),
                          color: Colors.green.shade100),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 36,
                          ),
                          topArea(authBloc.userName, context),
                          const SizedBox(
                            height: 33,
                          ),
                          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                            return getMidScreen(state.selection, context);
                          }),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.black.withOpacity(.7),
                      elevation: 11,
                      focusColor: Colors.black.withOpacity(.3),
                      focusElevation: 22,
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.white,
                        size: 51,
                      ),
                      onPressed: () async {
                        if (widget.prevGPCode != null && widget.prevGPCode != "") {
                          showDialog<void>(
                            context: context,
                            builder: (_) => Center(
                              child: Container(
                                width: 333,
                                height: 222,
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            _onOpenPreviousData(context);
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text("Open Previous Scanned Data"),
                                              Icon(Icons.history)
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            _onScanNewData(context);
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text("Scan New Data"),
                                              Icon(Icons.qr_code_scanner_outlined)
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          _onScanNewData(null);
                        }
                      }, //params
                    ),
                    floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
                      builder: (BuildContext context, HomeState state) {
                        return AnimatedBottomNavigationBar(
                          gapLocation: GapLocation.center,
                          iconSize: 45,
                          activeColor: const Color(0xFF16a34a),
                          inactiveColor: Colors.white,
                          icons: const [Icons.people_rounded, Icons.payments_outlined],
                          backgroundColor: Colors.black.withOpacity(.6),
                          notchSmoothness: NotchSmoothness.verySmoothEdge,
                          leftCornerRadius: 12,
                          rightCornerRadius: 12,
                          activeIndex: state.selection,
                          onTap: (int) {
                            homeBloc.add(ChangeSelectionEvent(selection: int));
                          },
                        );
                      },
                    )),
                  if (state.isLoading)
                    const Opacity(
                      opacity: 0.8,
                      child: ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                  if (state.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ]
            );
          },
        )


      ),
    );
  }
}

Container getMidScreen(int index, BuildContext ctx) {
  if (index == 0) {
    return getPersonContainer(ctx);
  } else {
    return getPaymentContainer(ctx);
  }
}

Container getPersonContainer(BuildContext ctx) {

  final TextEditingController _locationCode = TextEditingController();
  final TextEditingController _customerQRCode = TextEditingController();


  _openLocationFromCode(){
    ctx.read<HomeBloc>().add(
        LocationOpenFromCode(
            locationCode:
            _locationCode.text.toUpperCase()));
  }

  _openCustomerFromCode(){
    ctx.read<HomeBloc>().add(
        CustomerOpenFromCode(
            customerQRCode:
            int.parse(_locationCode.text)));
  }

  _openLocationSearchDialog(){
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title:
          const Text("Enter Location Code"),
          content: Text("GPCode"

            ,style:
            const TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _locationCode,
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
                      hintText: "Location Code",
                      labelText: "Enter Code",
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
                SizedBox(height: 18,),
                ElevatedButton(
                    onPressed: () {
                      if(_locationCode.text == "" || _locationCode.text == "0"){
                        Navigator.of(ctx).pop();
                        showDialog<void>(
                            context: ctx,
                            builder: (_) => MsgDialog(msg: "Location Code Cannot Be Empty"));
                      }
                      else{
                        Navigator.of(ctx).pop();
                        _openLocationFromCode();

                      }
                    },
                    child: const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Search Location"),
                        Icon(Icons.location_disabled_outlined)
                      ],
                    )),

              ],
            )
          ],
        );
      },
    );
  }

  _openCustomerCodeSearchDialog(){
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title:
          const Text("Enter Customer Code"),
          content: Text("Qr Code"

            ,style:
            const TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _customerQRCode,
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
                      hintText: "Customer Code",
                      labelText: "QR Code",
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
                SizedBox(height: 18,),
                ElevatedButton(
                    onPressed: () {
                      if(_customerQRCode.text == "" ||
                          _customerQRCode.text == "0" ||
                          _customerQRCode.text.length < 7
                      ){
                        Navigator.of(ctx).pop();
                        showDialog<void>(
                            context: ctx,
                            builder: (_) => MsgDialog(msg: "Customer Code Empty/Invalid"));
                      }
                      else{
                        Navigator.of(ctx).pop();
                        _openCustomerFromCode();

                      }
                    },
                    child: const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Search Location"),
                        Icon(Icons.location_disabled_outlined)
                      ],
                    )),

              ],
            )
          ],
        );
      },
    );
  }


  bool addNewLocationQRValid(String value) {
    if (value != null) {
      if (value.contains("https://nexteraportal.com/location")) {
        return true;
      }
    }
    return false;
  }

  bool addNewToleQRValid(String value) {
    if (value != null) {
      if (value.contains("https://nexteraportal.com/tole")) {
        return true;
      }
    }
    return false;
  }

  _onScanQRForLocationAdd() async {
    String? data = await openQRScanner();
    if (data != null) {
      if (!addNewLocationQRValid(data)) {
        showDialog<void>(
          context: ctx,
          builder: (_) => const QRErrorDialog(),
        );
      } else {
        String dataFinal = data.substring(data.lastIndexOf('=') + 1);
        ctx.read<HomeBloc>().add(LocationAddQRScannedEvent(id: dataFinal));
      }
    }
  }

  _onScanQRForToleAdd() async {
    String? data = await openQRScanner();
    if (data != null) {
      if (!addNewToleQRValid(data)) {
        showDialog<void>(
          context: ctx,
          builder: (_) => const QRErrorDialog(),
        );
      } else {
        String dataFinal = data.substring(data.lastIndexOf('=') + 1);
        ctx.read<HomeBloc>().add(ToleAddQRScannedEvent(id: dataFinal));
      }
    }
  }

  return Container(
    color: Colors.transparent,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(.51),
              shadowColor: Colors.redAccent.withOpacity(.55),
              elevation: 3,
              padding: const EdgeInsets.all(9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              minimumSize: const Size(333, 69), //////// HERE
            ),
            onPressed: () {
              _onScanQRForToleAdd();
            },
            child: const Column(
              children: [
                Icon(Icons.reduce_capacity),
                Text(
                  'TOLE दर्ता गर्नुहोस्',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ), //Tole Add
          const SizedBox(
            height: 33,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(.51),
              shadowColor: Colors.redAccent.withOpacity(.55),
              elevation: 3,
              padding: const EdgeInsets.all(9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              minimumSize: const Size(333, 69), //////// HERE
            ),
            onPressed: () {
              _onScanQRForLocationAdd();
            },
            child: const Column(
              children: [
                Icon(Icons.location_on_rounded),
                Text(
                  'LOCATION दर्ता गर्नुहोस्',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ), //Location Add
          const SizedBox(
            height: 33,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withOpacity(.51),
                shadowColor: Colors.redAccent.withOpacity(.55),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                minimumSize: const Size(333, 69),
                //////// HERE
                padding: const EdgeInsets.all(9)),
            onPressed: () {
              _openLocationSearchDialog();
            },
            child: const Column(
              children: [
                Icon(Icons.location_searching),
                Text(
                  'लोकेशन खोजि',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ), //Search Location BY GPCode

        ],
      ),
    ),
  );
}

Container getPaymentContainer(BuildContext ctx) {

  final TextEditingController _customerQRCode = TextEditingController();

  _openCustomerFromCode(){
    ctx.read<HomeBloc>().add(
        CustomerOpenFromCode(
            customerQRCode:
            int.parse(_customerQRCode.text)));
  }

  _openCustomerCodeSearchDialog(){
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title:
          const Text("Enter Customer Code"),
          content: Text("Qr Code"
            ,style:
            const TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _customerQRCode,
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
                      hintText: "Customer Code",
                      labelText: "QR Code",
                      suffixIcon: const Icon(Icons.payments),
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
                SizedBox(height: 18,),
                ElevatedButton(
                    onPressed: () {
                      if(_customerQRCode.text == "" ||
                          _customerQRCode.text == "0" ||
                          _customerQRCode.text.length < 7
                      ){
                        Navigator.of(ctx).pop();
                        showDialog<void>(
                            context: ctx,
                            builder: (_) => MsgDialog(msg: "Customer Code Empty/Invalid"));
                      }
                      else{
                        Navigator.of(ctx).pop();
                        _openCustomerFromCode();

                      }
                    },
                    child: const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Search Customer"),
                        Icon(Icons.person)
                      ],
                    )),

              ],
            )
          ],
        );
      },
    );
  }

  return Container(
    color: Colors.transparent,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            height: 27,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withOpacity(.51),
                shadowColor: Colors.redAccent.withOpacity(.55),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                minimumSize: const Size(333, 69),
                //////// HERE
                padding: const EdgeInsets.all(9)),
            onPressed: () {
              _openCustomerCodeSearchDialog();
            },
            child: const Column(
              children: [
                Icon(Icons.payments_outlined),
                Text(
                  'OPEN CUSTOMER WITH CODE \n         कोड द्वारा भुक्तानी खोल्ने',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ), //Payment Details
          const SizedBox(
            height: 45,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(.51),
              shadowColor: Colors.redAccent.withOpacity(.55),
              elevation: 3,
              padding: const EdgeInsets.all(9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              minimumSize: const Size(333, 69),
            ),
            onPressed: () {
              Navigator.of(ctx)
                  .push(Nexteramapscreen.route());
            },
            child: const Column(
              children: [
                Icon(Icons.map),
                Text(
                  'OPEN MAP \n       ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ), //Add Payments
          const SizedBox(
            height: 45,
          ),
        ],
      ),
    ),
  );
}



Card topArea(String name, BuildContext ctx) {
  final homeBloc = ctx.read<HomeBloc>();
  return Card(
    margin: const EdgeInsets.all(9.0),
    elevation: 11.0,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0))),
    child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF047857), Color(0xff0e7490)])),
        padding: const EdgeInsets.all(5.0),
        // color: Color(0xFF015FFF),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BlocBuilder<HomeBloc, HomeState>(
                    builder: (BuildContext context, HomeState state) {
                  return IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 33,
                    ),
                    onPressed: () {
                      context
                          .read<HomeBloc>()
                          .add(FetchTotalCollectionAmount());
                    },
                  );
                }),
                Text(name,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 20.0)),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 33,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: ctx,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Would you like to Logout?"),
                          actions: [
                            TextButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                ctx.read<HomeBloc>().add(LogOutEvent());
                              },
                            ),
                            TextButton(
                              child: const Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
            BlocBuilder<HomeBloc, HomeState>(
                builder: (BuildContext context, HomeState state) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: state.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text(
                      "Today\'s Data ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24.0)),
                ),
              );
            }),
            BlocBuilder<HomeBloc, HomeState>(
                builder: (BuildContext context, HomeState state) {
              if (state.isTotalAmountLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        state.todayTotalCustCreatedString,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800)),
                  ),
                );
              }
            }),
            const SizedBox(height: 27.0),
          ],
        )),
  );
}



