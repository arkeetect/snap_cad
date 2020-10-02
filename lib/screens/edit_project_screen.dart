// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/project.dart';
import '../providers/projects.dart';

class EditProjectScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController(
      text:
          'https://cdn.pixabay.com/photo/2017/02/01/13/45/technical-drawing-2030247_1280.jpg');
  final _urlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProject = Project(
    id: null,
    title: '',
    category: '',
    description: '',
    imageUrl: '',
    url: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'category': '',
    'imageUrl': '',
    'url': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _urlFocusNode.addListener(_updateUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProject =
            Provider.of<Projects>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProject.title,
          'description': _editedProject.description,
          'category': _editedProject.category.toString(),
          // 'imageUrl': _editedProject.imageUrl,
          'imageUrl': '',
          'url': '',
        };
        _imageUrlController.text = _editedProject.imageUrl;
        _urlController.text = _editedProject.url;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _urlFocusNode.removeListener(_updateUrl);
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _urlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _updateUrl() {
    if (!_urlFocusNode.hasFocus) {
      if ((!_urlController.text.startsWith('http') &&
          !_urlController.text.startsWith('https'))) {
        return;
      }
      _imageUrlController.text = _fetchThumbnail(_urlController.text);
      setState(() {});
    }
  }

  _fetchThumbnail(String value) {
    if (value.length > 0) {
      final videoId = YoutubePlayer.convertUrlToId(value);
      final thumbNail =
          YoutubePlayer.getThumbnail(videoId: videoId, webp: false);
      _imageUrlController.text = thumbNail;
      return thumbNail;
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProject.id != null) {
      await Provider.of<Projects>(context, listen: false)
          .updateProject(_editedProject.id, _editedProject);
    } else {
      try {
        await Provider.of<Projects>(context, listen: false)
            .addProject(_editedProject);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Project',
          textScaleFactor: 0.7,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProject = Project(
                            title: value,
                            category: _editedProject.category,
                            description: _editedProject.description,
                            imageUrl: _editedProject.imageUrl,
                            id: _editedProject.id,
                            isFavorite: _editedProject.isFavorite,
                            url: _editedProject.url);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['category'],
                      decoration: InputDecoration(labelText: 'Category'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_urlFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a category.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProject = Project(
                            title: _editedProject.title,
                            category: value,
                            description: _editedProject.description,
                            imageUrl: _editedProject.imageUrl,
                            id: _editedProject.id,
                            isFavorite: _editedProject.isFavorite,
                            url: _editedProject.url);
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      decoration: InputDecoration(labelText: 'Youtube URL'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      controller: _urlController,
                      focusNode: _urlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Youtube URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProject = Project(
                            title: _editedProject.title,
                            category: _editedProject.category,
                            description: _editedProject.description,
                            imageUrl: _fetchThumbnail(value),
                            id: _editedProject.id,
                            isFavorite: _editedProject.isFavorite,
                            url: value);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProject = Project(
                          title: _editedProject.title,
                          category: _editedProject.category,
                          description: value,
                          imageUrl: _editedProject.imageUrl,
                          id: _editedProject.id,
                          isFavorite: _editedProject.isFavorite,
                          url: _editedProject.url,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter an image URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Image URL (auto generated)'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              // if (!value.startsWith('http') &&
                              //     !value.startsWith('https')) {
                              //   return 'Please enter a valid URL.';
                              // }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProject = Project(
                                title: _editedProject.title,
                                category: _editedProject.category,
                                description: _editedProject.description,
                                imageUrl: value,
                                id: _editedProject.id,
                                isFavorite: _editedProject.isFavorite,
                                url: _editedProject.url,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
