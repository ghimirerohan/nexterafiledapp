import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_bloc.dart';
import 'package:next_era_collector/addpayment/repo/AddPaymentRepo.dart';
import 'package:next_era_collector/addpayment/view/addpayment_page.dart';
import 'package:server_repository/models.dart';

class AddPaymentScreen extends StatelessWidget {
  final String? title;
  final CBpartner cBpartner;
   AddPaymentScreen({ this.title, required this.cBpartner});

  static Route<void> route({ String? title,
   required CBpartner cBpartner}) {
    return MaterialPageRoute<void>(builder: (_) =>  AddPaymentScreen( title: title,cBpartner: cBpartner,));
  }

  final AddPaymentRepo _paymentRepo = AddPaymentRepo();

  Widget build(BuildContext context) {
    return   Scaffold(
      body: BlocProvider(
        create: (_) =>  AddPaymentBloc(paymentRepository: _paymentRepo),
        child:  AddPaymentPage(title: title , cBpartner: cBpartner),
      ),
    );

  }
}