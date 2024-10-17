import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/addnewtole/bloc/addnewtole_bloc.dart';
import 'package:next_era_collector/addnewtole/repo/AddNewToleRepo.dart';
import 'package:next_era_collector/addnewtole/view/addnewtole_page.dart';

class AddNewToleScreen extends StatelessWidget {
  final int ne_qrtoleadd_id;
  AddNewToleScreen({super.key ,required this.ne_qrtoleadd_id});

  static Route<void> route({ required int ne_qrtoleadd_id}) {
    return MaterialPageRoute<void>(builder: (_) =>  AddNewToleScreen( ne_qrtoleadd_id: ne_qrtoleadd_id));
  }
  final AddNewToleRepo _addNewToleRepo = AddNewToleRepo();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: BlocProvider(
        create: (_) =>  AddNewToleBloc(addnewtoleRepo: _addNewToleRepo),
        child:  AddNewTolePage( ne_qrtoleadd_id: ne_qrtoleadd_id),
      ),
    );

  }
}