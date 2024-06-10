import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/custlist/bloc/custlist_bloc.dart';
import 'package:next_era_collector/custlist/custrepo/CustListRepo.dart';
import 'package:next_era_collector/custlist/view/custlist_page.dart';

import '../../home/bloc/home_bloc/home_bloc.dart';

class CustListScreen extends StatelessWidget {
  final String title;
   CustListScreen({super.key, required this.title});

  static Route<void> route(String title) {
    return MaterialPageRoute<void>(builder: (_) =>  CustListScreen(title: title,));
  }
  final _custListRepo = CustListRepo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>  CustListBloc(repo: _custListRepo),
        child:  CustListPage(title: title),
      ),
    );
  }
}
