import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_bloc.dart';
import 'package:next_era_collector/addcustomer/repo/AddCustomerRepository.dart';
import 'package:next_era_collector/addcustomer/view/addcustomer_page.dart';

class AddCustomerScreen extends StatelessWidget {
  final String title;
  final int c_location_id;
  final int ne_qrcustomeradd_id;
   AddCustomerScreen({super.key, required this.title, required this.c_location_id
   , required this.ne_qrcustomeradd_id});

  static Route<void> route({ required String title , required int c_location_id , required int ne_qrcustomeradd_id}) {
    return MaterialPageRoute<void>(builder: (_) =>  AddCustomerScreen(
      title: title, c_location_id: c_location_id,ne_qrcustomeradd_id: ne_qrcustomeradd_id));
  }
  final AddCustomerRepository _customerRepository = AddCustomerRepository();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: BlocProvider(
        create: (_) =>  AddCustomerBloc(customerRepository: _customerRepository),
        child:  AddCustomerPage(title: title , c_location_id: c_location_id
        ,ne_qrcustomeradd_id:ne_qrcustomeradd_id),
      ),
    );

  }
}
