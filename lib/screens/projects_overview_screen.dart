import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/projects_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/projects.dart';

enum FilterOptions {
  Favorites,
  Recent,
  All,
}

class ProjectsOverviewScreen extends StatefulWidget {
  @override
  _ProjectsOverviewScreenState createState() => _ProjectsOverviewScreenState();
}

class _ProjectsOverviewScreenState extends State<ProjectsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  var _showRecent = false;

  @override
  void initState() {
    // Provider.of<Projects>(context).fetchAndSetProjects(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Projects>(context).fetchAndSetProjects();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Projects>(context).fetchAndSetProjects().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SnapCAD       ' +
              (_showOnlyFavorites
                  ? 'Favorites'
                  : _showRecent ? 'Recently Viewed' : ''),
          textAlign: TextAlign.left,
          textScaleFactor: 0.7,
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
                if (selectedValue == FilterOptions.Recent) {
                  _showRecent = true;
                } else {
                  _showRecent = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                  style: TextStyle(fontSize: 14, color: Colors.purple),
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Recently Viewed',
                  style: TextStyle(fontSize: 14, color: Colors.purple),
                ),
                value: FilterOptions.Recent,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                  style: TextStyle(fontSize: 14, color: Colors.purple),
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.message,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/');
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProjectsGrid(_showOnlyFavorites, _showRecent),
    );
  }
}
