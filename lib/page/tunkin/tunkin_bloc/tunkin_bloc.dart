import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puskeu/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:puskeu/model/error.dart';
import 'package:http/http.dart' as http;
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/model/tunkin.dart';

part 'tunkin_event.dart';
part 'tunkin_state.dart';
part 'repo_tunkin.dart';

class TunkinBloc extends Bloc<TunkinEvent, TunkinState> {
  final TunkinRepo tunkinrepo;

  TunkinBloc({@required this.tunkinrepo}) : super(null);

  @override
  Stream<TunkinState> mapEventToState(TunkinEvent event) async* {
    if (event is TunkinFetch) {
      try {
        yield TunkinLoading();
        final tunkin = await tunkinrepo.fetchTunkinFilter(
            bulan: event.bulan, tahun: event.tahun);
        yield TunkinDataLoaded(tunkin: tunkin);
      } catch (error) {
        yield TunkinOnFailure(dataError: error);
      }
    } else if (event is TunkinUpdate) {
      try {
        yield TunkinLoading();
        final tunkin = await tunkinrepo.fetchTunkinFilter(
            bulan: event.bulan, tahun: event.tahun);
        yield TunkinDataLoaded(tunkin: tunkin);
      } catch (error) {
        yield TunkinOnFailure(dataError: error);
      }
    }
  }
}
