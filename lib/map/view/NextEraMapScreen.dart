import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_era_collector/map/bloc/map_bloc.dart';
import 'package:next_era_collector/map/repo/MapRepo.dart';
import 'package:next_era_collector/map/view/NextEraMap.dart';

class Nexteramapscreen extends StatelessWidget {
   Nexteramapscreen({super.key});

  static Route<void> route( ) {
    return MaterialPageRoute<void>(builder: (_) =>  Nexteramapscreen());
  }
  final _mapRepo = MapRepo();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>  MapBloc(mapRepo: _mapRepo),
      child:  Nexteramap(),
    );
  }
}
