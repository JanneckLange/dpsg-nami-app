import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nami/model/nami_stats_model.dart';
import 'package:nami/utilities/hive/settings.dart';
import 'nami-member.service.dart';

/// läd Nami Dashboard Statistiken
Future<NamiStatsModel> loadNamiStats() async {
  String url = getNamiLUrl();
  String? cookie = getNamiApiCookie();
  final response = await http.get(
      Uri.parse('$url/ica/rest/dashboard/stats/stats'),
      headers: {'Cookie': cookie});
  Map<String, dynamic> json = jsonDecode(response.body);
  if (response.statusCode == 200 && json['success']) {
    Map<String, dynamic> json = jsonDecode(response.body);
    NamiStatsModel stats = NamiStatsModel.fromJson(json);
    return stats;
  } else {
    throw Exception('Failed to load album');
  }
}

/// returns the id of the current gruppierung | return 0 when there are multiple or 0 gruppierungen
Future<int> loadGruppierung({node = 'root'}) async {
  String url = getNamiLUrl();
  String path = getNamiPath();
  String cookie = getNamiApiCookie();
  String fullUrl =
      '$url$path/gruppierungen/filtered-for-navigation/gruppierung/node/$node';
  final response =
      await http.get(Uri.parse(fullUrl), headers: {'Cookie': cookie});

  if (response.statusCode != 200) {
    return 0;
  }

  if (jsonDecode(response.body)['data'].length == 1) {
    int currentGruppierungId = jsonDecode(response.body)['data'][0]['id'];
    if (currentGruppierungId > 0) {
      int nextGruppierungId = await loadGruppierung(node: currentGruppierungId);
      return nextGruppierungId == 0 ? currentGruppierungId : nextGruppierungId;
    }
  }

  return 0;
}

void syncNamiData() async {
  await syncGruppierung();
  syncMember();
  //syncStats
  //syncProfile
}

syncGruppierung() async {
  int gruppierung = getGruppierung() ?? await loadGruppierung();
  if (gruppierung == 0) {
    throw Exception("Keine eindeutige Gruppierung gefunden");
  }
  setGruppierung(gruppierung);
}