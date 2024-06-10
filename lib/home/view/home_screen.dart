import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/home/bloc/home_bloc/home_bloc.dart';
import 'package:next_era_collector/home/repository/home_reposioty.dart';

import 'home_page.dart';


class HomeScreen extends StatelessWidget {
  final String? prevGPCode;
   HomeScreen({super.key , this.prevGPCode});

  static Route<void> route({String? prevGPCode}) {
    return MaterialPageRoute<void>(builder: (_) =>  HomeScreen(prevGPCode: prevGPCode,));
  }
 final _authRepo = AuthenticationRepository();
   final _homeRepo = HomeRepository();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>  HomeBloc(authenticationRepository: _authRepo , homeRepository: _homeRepo),
        child:  HomePage(prevGPCode: prevGPCode,),
      ),
    );
  }
}
