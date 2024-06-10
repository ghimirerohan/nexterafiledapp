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
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../../authentication/bloc/auth_bloc.dart';
import '../../addpayment/view/addpayment_screen.dart';

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
        data.contains("https://nexteraportal.com/location")) {
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
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text(
            "Sure To Exit The App ?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
    final authBloc = context.read<AuthenticationBloc>();
    final homeBloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) async {
        if(state.isLoading){
          showDialog<void>(
              context: context,
              builder: (_) => const Center(child: CircularProgressIndicator()));
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
            Navigator.of(context)
                .push(CustListScreen.route(state.qrData.replaceAll("%2B", "+")));
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


      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (value) {
          if (value) {
            _popBackExitCallBack();
          }
        },
        child: Scaffold(
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
                    height: 57,
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
  bool addNewLocationQRValid(String value) {
    if (value != null) {
      if (value.contains("https://nexteraportal.com/location")) {
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
        String dataFinal = data.substring(data.lastIndexOf('/') + 1);
        ctx.read<HomeBloc>().add(LocationAddQRScannedEvent(id: dataFinal));
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
          const Text(
            'ग्राहक सम्बन्धी',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 51,
            ),
          ),
          const SizedBox(
            height: 45,
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
            onPressed: () {},
            child: const Column(
              children: [
                Icon(Icons.person_search_sharp),
                Text(
                  'CUSTOMER\'S DETAILS \n            ग्राहकको विवरण',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ), //Customer Details
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
              minimumSize: const Size(333, 69), //////// HERE
            ),
            onPressed: () {
              _onScanQRForLocationAdd();
            },
            child: const Column(
              children: [
                Icon(Icons.location_on_rounded),
                Text(
                  'ADD LOCATION \n     दर्ता गर्नुहोस्',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ), //Customer Add
          const SizedBox(
            height: 45,
          ),
        ],
      ),
    ),
  );
}

Container getPaymentContainer(BuildContext ctx) => Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'भुक्तानी सम्बन्धी',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 51,
              ),
            ),
            const SizedBox(
              height: 45,
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
              onPressed: () {},
              child: const Column(
                children: [
                  Icon(Icons.payments_outlined),
                  Text(
                    'PAYMENTS DETAILS \n         भुक्तानीको विवरण',
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
              onPressed: () {},
              child: const Column(
                children: [
                  Icon(Icons.currency_rupee),
                  Text(
                    'NEW PAYMENT \n       नयाँ भुक्तानी',
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

Card topArea(String name, BuildContext ctx) => Card(
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
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("Today\'s Collection - आज जम्मा",
                      style: TextStyle(color: Colors.white, fontSize: 24.0)),
                ),
              ),
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
                      child: Text("Rs. ${state.totalCollected}",
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

class QRErrorDialog extends StatelessWidget {
  const QRErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Scanned QR Not Valid !',
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class MsgDialog extends StatelessWidget {
  String msg;

  MsgDialog({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      msg,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> openQRScanner() async {
  var cameraStatus = await Permission.camera.status;
  if (cameraStatus.isGranted) {
    String? qr = await scanner.scan();
    return qr;
  } else {
    var isGrant = await Permission.camera.request();
    if (isGrant.isGranted) {
      String? qr = await scanner.scan();
      return qr;
    }
  }
}
