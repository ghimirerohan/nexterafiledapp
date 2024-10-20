import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addcustomer/view/addcustomer_page.dart';
import 'package:next_era_collector/configs/utils.dart';
import 'package:next_era_collector/custlist/bloc/custlist_bloc.dart';
import 'package:next_era_collector/custlist/bloc/custlist_events.dart';
import 'package:next_era_collector/custlist/bloc/custlist_states.dart';
import 'package:next_era_collector/custlist/custrepo/CustListRepo.dart';
import 'package:next_era_collector/custlist/widget/addHouseOwner.dart';
import 'package:next_era_collector/home/view/home_screen.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';
import '../../addcustomer/view/addcustomer_screen.dart';
import '../../addpayment/view/addpayment_screen.dart';
import '../../res/utils/OpenQRScanner.dart';
import '../../res/widgets/MsgDialog.dart';
import '../../res/widgets/QRError.dart';

class CustListPage extends StatefulWidget {
  final String title;

  const CustListPage({super.key, required this.title});

  @override
  State<CustListPage> createState() => _CustListPageState();
}

class _CustListPageState extends State<CustListPage> {
  @override
  void initState() {
    context.read<CustListBloc>().add(FetchDataEvent(GPCode: widget.title));
    super.initState();
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
                    HomeScreen.route(prevGPCode: widget.title),
                    (route) => false);
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
      if (!data.contains("https://nexteraportal.com/customer")) {
        showDialog<void>(
          context: context,
          builder: (_) => const QRErrorDialog(),
        );
      } else {
        data = data.substring(data.lastIndexOf("=") + 1);
        context.read<CustListBloc>().add(QRScannedCustEvent(ne_qrcustomeradd_id: int.parse(data)));
      }
    }
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
      child:
      BlocBuilder<CustListBloc, CustListState>(
          builder: (context, state) {

            return Stack(children: [
              Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          HomeScreen.route(prevGPCode: widget.title), (route) => false);
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
                    widget.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF047857),
                ),
                body: BlocListener<CustListBloc, CustListState>(
                  listener: (context, state) {
                    if (state.isAddCustomerInProgressorTaken) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => MsgDialog(msg: state.customerAddMsg),
                      );
                    }
                    switch (state.status) {
                      case CustListStatus.error:
                        Utils.flushBarErrorMessage(
                            state.response.message ?? "Error", context);
                      case CustListStatus.addNew:
                        if (state.c_location == null) {
                          Utils.flushBarErrorMessage(
                              "No Connection Internet / Server Error", context);
                        } else {
                          Navigator.of(context).push(AddCustomerScreen.route(
                              title: widget.title,
                              c_location_id: state.c_location!.id!
                              ,ne_qrcustomeradd_id: state.ne_qrcustomeradd_id));
                        }
                    // case CustListStatus.none:
                    //   context.read<CustListBloc>().add(FetchDataEvent(GPCode: widget.title));
                      case CustListStatus.openPayment:
                        Navigator.of(context).push(AddPaymentScreen.route(
                            title: widget.title, cBpartner: state.selectedPartner!));

                      default:
                    }
                  },
                  child: BlocBuilder<CustListBloc, CustListState>(

                      builder: (context, state) {
                        switch (state.response.status) {
                          case Status.completed:
                            if(state.c_location?.ownerName == null){
                              return AddHouseOwner();
                            }
                            if (state.response.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "\nNo Customers From This Location \nPlease, Add New +",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<CustListBloc>()
                                              .add(FetchDataEvent(GPCode: widget.title));
                                        },
                                        child: const Text(
                                          "Refresh",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                children: [
                                  const CustomerListing(),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<CustListBloc>()
                                                .add(FetchDataEvent(GPCode: widget.title));
                                          },
                                          child: const Text(
                                            "Refresh",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  )
                                ],
                              );
                            }
                          case Status.error:
                            return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(state.response.message ?? "some error"),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          context
                                              .read<CustListBloc>()
                                              .add(FetchDataEvent(GPCode: widget.title));
                                        },
                                        child: const Text("Retry"))
                                  ],
                                ));
                          case null:
                            return const Center(
                              child: Text("Null"),
                            );
                          default:
                            return const Center(
                              child: Text("Customer List"),
                            );
                        }
                      }),
                ),
              ),
              if(state.response.status == Status.loading ||
              state.isAddCustomerQRScanLoading)
                const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              if(state.response.status == Status.loading ||
                  state.isAddCustomerQRScanLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],);
          })
      ,
    );
  }
}

class CustomerListing extends StatelessWidget {
  const CustomerListing({super.key});

  @override
  Widget build(BuildContext context) {
    Color getColorForCard(CPeriod? period, CBpartner customer) {
      if (period != null && customer.toPeriodID != null) {
        if (customer.toPeriodID!.id! >= period.id!) {
          if (customer.lastPayStatus!.id! == "CO") {
            return Colors.green;
          }
          if (customer.lastPayStatus!.id! == "DR") {
            return Colors.yellow;
          }
        }
      }
      return Colors.white;
    }

    final custlistBloc = context.read<CustListBloc>().state;
    final CPeriod? currentPeriod = custlistBloc.currenPeriod;
    final String ownerName = custlistBloc.c_location?.ownerName ?? "No Name Taken";
    final int noOfCustomers = custlistBloc.response.data?.length ?? 0;
    final int totalPricePerMonthOfBuilding = custlistBloc.c_location?.ratePerMonth?.toInt() ?? 0;


    return Expanded(
      child: ListView.builder(
          itemCount: custlistBloc.response.data!.length + 1,
          itemBuilder: (context, index) {
            if(index == 0){
              return Text(
                "\n       Owner Name :  $ownerName"
                  "\n       Number Of Customers :  $noOfCustomers"
                "\n       Total Price/Month :  Rs.$totalPricePerMonthOfBuilding",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    color: Colors.black),
              );
            }
            else{
              index = index - 1;
              final String ownerOrNot = custlistBloc.response.data![index]!.housestoreynumber! > 0 ? "(OWNER) " : "";
              final CBpartner customer = custlistBloc.response.data![index];
              return Card(
                color: getColorForCard(currentPeriod, customer),
                elevation: 5,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 3),
                child: ListTile(
                    onTap: () {
                      // if(custlistBloc.isOnlyDataCollector){
                      //   showDialog<void>(
                      //     context: context,
                      //     builder: (_) =>  MsgDialog(msg: "Data Collector No Access"),
                      //   );
                      // }else{
                      //   context
                      //       .read<CustListBloc>()
                      //       .add(OpenPaymentEvent(cBpartner: customer));
                      // }

                      context
                          .read<CustListBloc>()
                          .add(OpenPaymentEvent(cBpartner: customer));
                    },
                    title: Text(
                      ownerOrNot +
                          (customer.name ?? "No name"),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                        "${customer.phone ?? "No Phone"} - ${customer.cBPGroupID?.identifier ?? "No Group"}",
                        style: const TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.none,
                            color: Colors.black)),
                    trailing: const Icon(Icons.arrow_forward_ios)),
              );
            }

          }),
    );
    ;
  }
}


