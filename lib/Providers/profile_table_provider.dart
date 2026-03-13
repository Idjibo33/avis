import 'package:avis/Models/profile.dart';
import 'package:avis/Services/Supabase/profile_table_services.dart';
import 'package:flutter/material.dart';

class ProfileTableProvider extends ChangeNotifier {
  final ProfileTableServices _profileTableServices = ProfileTableServices();
  bool _chargement = false;
  bool get chargement => _chargement;
  String _messageErreur = "";

  Future createRow({required Profile item}) async {
    try {
      _chargement = true;
      notifyListeners();
      await _profileTableServices.addData(item);
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
    }
  }

  Future updateRow({required Profile item}) async {
    try {
      _chargement = false;
      notifyListeners();
      await _profileTableServices.updateData(item);
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
    }
  }

  Future deleteRow({required Profile item}) async {
    try {
      _chargement = true;
      notifyListeners();
      await _profileTableServices.deletedata(item);
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
    }
  }

  Future readRow({required Profile item}) async {
    try {
      _chargement = true;
      notifyListeners();
      await _profileTableServices.readDataOnce(item.id!);
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
    }
  }
}
