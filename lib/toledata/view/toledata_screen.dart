import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/toledata/bloc/toledata_bloc.dart';
import 'package:next_era_collector/toledata/repo/toledata_repo.dart';
import 'package:next_era_collector/toledata/view/toledata_page.dart';


class ToleDataScreen extends StatelessWidget {
  final int toleID;
  ToleDataScreen({super.key, required this.toleID});

  static Route<void> route({required int toleID}) {
    return MaterialPageRoute<void>(builder: (_) =>  ToleDataScreen(toleID : toleID));
  }
  final ToleDataRepo _toleDataRepo = ToleDataRepo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>  ToleDataBloc(toleDataRepo: _toleDataRepo),
        child:  ToledataPage(toleID : toleID)
      ),
    );
  }
}

