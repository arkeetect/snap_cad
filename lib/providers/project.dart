import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Project with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String url;
  bool isFavorite;
  bool isViewed;
  //DateTime dateViewed;

  Project({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.category,
    @required this.imageUrl,
    @required this.url,
    this.isFavorite = false,
    this.isViewed = false,
    //this.dateViewed,
  }) {
    this.checkFavoriteFromPerfs();
    this.checkIsViewedInPerfs();
  }

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void _setViewed(bool value) {
    isViewed = value;
    notifyListeners();
  }

  Future<void> checkIsViewedInPerfs() async {
    //isViewed = true;
    final dateViewed = DateTime.now();
    final todayDate =
        DateTime(dateViewed.year, dateViewed.month, dateViewed.day);

    final prefs = await SharedPreferences.getInstance();
    String lastViewedDate = prefs.getString(this.id);
    if (lastViewedDate != null &&
        todayDate
                .subtract(Duration(days: 5))
                .compareTo(DateTime.parse(lastViewedDate)) <=
            0) {
      isViewed = true;
    }
  }

  Future<void> setIsViewedInPerfs(String token, String userId) async {
    isViewed = true;
    notifyListeners();
    final dateViewed = DateTime.now();
    final todayDate =
        DateTime(dateViewed.year, dateViewed.month, dateViewed.day);

    final prefs = await SharedPreferences.getInstance();
    // String lastViewedDate = prefs.getString(this.id);
    // if (todayDate
    //         .subtract(Duration(days: 5))
    //         .compareTo(DateTime.parse(lastViewedDate)) <=
    //     0) {
    //   isViewed = true;
    // }
    try {
      await prefs.setString(this.id, todayDate.toString());
    } catch (error) {
      _setViewed(false);
    }
  }

  Future<void> setIsViewed(String token, String userId) async {
    isViewed = true;
    final dateViewed = DateTime.now().toUtc().toString();
    notifyListeners();
    final url = 'https://snap-cad.firebaseio.com/userViewed/$userId/$id.json';
    //'https://snap-cad.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(
        url,
        body: json.encode({
          'id': id,
          'dateViewed': dateViewed,
        }),
      );
      if (response.statusCode >= 400) {
        _setViewed(false);
      }
    } catch (error) {
      _setViewed(false);
    }
  }

  checkFavoriteFromPerfs() {
    SharedPreferences.getInstance().then((prefs) {
      List<String> favs = prefs.getStringList("favorites");
      if (favs != null) {
        if (favs.contains(this.id)) {
          isFavorite = true;
        }
      }
    });
  }

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList("favorites");

    if (favs != null) {
      if (isFavorite) {
        if (!favs.contains(this.id)) {
          favs.add(this.id);
        }
      } else {
        if (favs.contains(this.id)) {
          favs.remove(this.id);
        }
      }
    } else if (isFavorite) {
      favs = List<String>();
      favs.add(this.id);
    }
    try {
      await prefs.setStringList("favorites", favs);
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://snap-cad.firebaseio.com/userFavorites/$userId/$id.json';
    //'https://snap-cad.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
