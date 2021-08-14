import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puskeu/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:puskeu/model/data.dart';
import 'package:puskeu/model/error.dart';
import 'package:http/http.dart' as http;
import 'package:puskeu/model/save_token.dart';

part 'gaji_event.dart';
part 'gaji_state.dart';
part 'repo_gaji.dart';

class GajiBloc extends Bloc<GajiEvent, GajiState> {
  final GajiRepo gajirepo;

  GajiBloc({@required this.gajirepo}) : super(null);

  @override
  Stream<GajiState> mapEventToState(GajiEvent event) async* {
    if (event is GajiFetch) {
      try {
        yield GajiLoading();
        final dataList = await gajirepo.fetchDataFilter(
            bulan: event.bulan, tahun: event.tahun);
        yield GajiDataLoaded(dataList: dataList);
      } catch (error) {
        yield GajiOnFailure(dataError: error);
      }
    } else if (event is GajiUpdate) {
      try {
        yield GajiLoading();
        final dataList = await gajirepo.fetchDataFilter(
            bulan: event.bulan, tahun: event.tahun);
        yield GajiDataLoaded(dataList: dataList);
      } catch (error) {
        yield GajiOnFailure(dataError: error);
      }
    }
  }
}
