import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addnewlocation/repo/AddNewLocationRepo.dart';

import '../bloc/addlocation_bloc.dart';
import 'addlocation_page.dart';

class AddLocationScreen extends StatelessWidget {
  final int ne_qrlocationadd_id;
  AddLocationScreen({super.key ,required this.ne_qrlocationadd_id});

  static Route<void> route({ required int ne_qrlocationadd_id}) {
    return MaterialPageRoute<void>(builder: (_) =>  AddLocationScreen( ne_qrlocationadd_id: ne_qrlocationadd_id));
  }
  final AddnewlocationRepo _addnewlocationRepo = AddnewlocationRepo();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: BlocProvider(
        create: (_) =>  AddLocationBloc(addnewlocationRepo: _addnewlocationRepo),
        child:  AddLocationPage( ne_qrlocationadd_id: ne_qrlocationadd_id),
      ),
    );

  }
}
