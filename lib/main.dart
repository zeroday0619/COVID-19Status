import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar: AppBar(title: Text("코로나 현황")),
    body: MyApp(),
  )

));

class Cov19 {
  final patient;
  final before_patient;

  final quarantine;
  final before_quarantine;

  final inisolation;
  final before_inisolation;
  final before_death;
  var death;

  Cov19({
    this.patient,
    this.before_patient,
    this.quarantine,
    this.before_quarantine,
    this.inisolation,
    this.before_inisolation,
    this.death,
    this.before_death
  });
  factory Cov19.FromJson(Map<String, dynamic> CovMap) {
    return Cov19(
      patient: CovMap['krstatus']['patient'],
      before_patient: CovMap['krstatus']['before_patient'],
      quarantine: CovMap['krstatus']['quarantine'],
      before_quarantine: CovMap['krstatus']['before_quarantine'],
      inisolation: CovMap['krstatus']['inisolation'],
      before_inisolation: CovMap['krstatus']['before_inisolation'],
      death: CovMap['krstatus']['death'],
      before_death: CovMap['krstatus']['before_death'],
    );
  }
}

Future<Cov19> fetchCov19() async {
  final response = await http.get("https://ncov.zeroday0619.kr/kr/status");
  if (response.statusCode == 200){
    final CovMap = json.decode(response.body);
    return Cov19.FromJson(CovMap);
  }
  throw Exception("Api Error");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 30, height:2.0);
    return FutureBuilder(
          future: fetchCov19(),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              var patient = snapshot.data.patient.toString();
              var before_patient = snapshot.data.before_patient.toString();
              var quarantine = snapshot.data.quarantine.toString();
              var before_quarantine = snapshot.data.before_quarantine.toString();
              var inisolation = snapshot.data.inisolation.toString();
              var before_inisolation = snapshot.data.before_inisolation.toString();
              var death = snapshot.data.death.toString();
              var before_death = snapshot.data.before_death.toString();

              return ListView(
                children: <Widget>[
                  Card(child: Text("확진환자: $patient명", style: style)),
                  Card(child: Text("전일 대비 확진 환자: $before_patient명", style: style)),
                  Card(child: Text("격리 중: $quarantine명", style: style)),
                  Card(child: Text("전일 대비 격리 환자: $before_quarantine명", style: style)),
                  Card(child: Text("격리 해제: $inisolation명", style: style)),
                  Card(child: Text("전일 대비 격리 해제: $before_inisolation명", style: style)),
                  Card(child: Text("사망: $death명", style: style)),
                  Card(child: Text("전일 대비 사망: $before_death명", style: style)),
                  Card(child: Text("copyright (C) 2020 Euiseo Cha", style: style)),
                ],

              );

          } else if (snapshot.hasError) {return Text('${snapshot.error}');}
            return CircularProgressIndicator();
        },
    );
  }
}