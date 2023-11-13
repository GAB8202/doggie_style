// lib/view_models/doggie_view_model.dart

import 'package:flutter/material.dart';
import '../models/doggie_model.dart';

class DoggieViewModel extends ChangeNotifier {
  final DoggieModel _doggieModel = DoggieModel(text: "Doggie Style",);

  String get doggieText => _doggieModel.text;

// Add any functions here that will modify the model and call notifyListeners to update the UI
}