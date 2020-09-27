import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'project.dart';

class Projects with ChangeNotifier {
  List<Project> _items = [
    // Project(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Project(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Project(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Project(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Projects(this.authToken, this.userId, this._items);

  List<Project> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return _items.toList();
  }

  List<Project> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Project findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProjects([bool filterByUser = false]) async {
    //filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://snap-cad.firebaseio.com/projects.json';
    //'https://snap-cad.firebaseio.com/projects.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      //url =
      //'https://snap-cad.firebaseio.com/userFavorites/$userId.json';
      //'https://snap-cad.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      //final favoriteResponse = await http.get(url);
      //final favoriteData = json.decode(favoriteResponse.body);
      final List<Project> loadedProjects = [];
      extractedData.forEach((projId, projData) {
        loadedProjects.add(Project(
          id: projId,
          title: projData['title'],
          description: projData['description'],
          category: projData['category'],
          isFavorite: false,
          imageUrl: projData['imageUrl'],
          url: projData['url'],
        ));
      });
      _items = loadedProjects;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProject(Project project) async {
    final url = 'https://snap-cad.firebaseio.com/projects.json';
    //'https://snap-cad.firebaseio.com/projects.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': project.title,
          'description': project.description,
          'imageUrl': project.imageUrl,
          'category': project.category,
          //'creatorId': userId,
          'url': project.url,
        }),
      );
      final newProject = Project(
        title: project.title,
        description: project.description,
        category: project.category,
        imageUrl: project.imageUrl,
        id: json.decode(response.body)['name'],
        url: project.url,
      );
      _items.add(newProject);
      // _items.insert(0, newProject); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProject(String id, Project newProject) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://snap-cad.firebaseio.com/projects/$id.json';
      //'https://snap-cad.firebaseio.com/projects/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProject.title,
            'description': newProject.description,
            'imageUrl': newProject.imageUrl,
            'category': newProject.category,
            //'viewedDate': newProject.isViewed ?? DateTime.now(),
          }));
      _items[prodIndex] = newProject;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProject(String id) async {
    final url = 'https://snap-cad.firebaseio.com/projects/$id.json';
    //'https://snap-cad.firebaseio.com/projects/$id.json?auth=$authToken';
    final existingProjectIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProject = _items[existingProjectIndex];
    _items.removeAt(existingProjectIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProjectIndex, existingProject);
      notifyListeners();
      throw HttpException('Could not delete project.');
    }
    existingProject = null;
  }
}
