import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';
import '../models/user_profile.dart';

class ProfileProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  List<UserProfile> _profiles = [];
  int _currentIndex = 0;

  List<UserProfile> get profiles => _profiles;
  int get currentIndex => _currentIndex;
  
  UserProfile? get currentProfile {
    if (_profiles.isEmpty || _currentIndex < 0 || _currentIndex >= _profiles.length) {
      return null;
    }
    return _profiles[_currentIndex];
  }

  bool get hasProfiles => _profiles.isNotEmpty;

  ProfileProvider(this._prefs) {
    _loadProfiles();
  }

  void _loadProfiles() {
    final List<String> serializedList = _prefs.getStringList(StorageKeys.profilesList) ?? [];
    _profiles = serializedList.map((item) {
      try {
        final Map<String, dynamic> json = jsonDecode(item) as Map<String, dynamic>;
        return UserProfile.fromJson(json);
      } catch (e) {
        return UserProfile(id: '', name: '', title: '', url: '');
      }
    }).where((profile) => profile.id.isNotEmpty).toList();

    _currentIndex = _prefs.getInt(StorageKeys.activeProfileIndex) ?? 0;
    if (_currentIndex >= _profiles.length) {
      _currentIndex = 0;
    }
  }

  Future<void> saveProfile(String? id, String name, String title, String url) async {
    final String cleanName = name.trim();
    final String cleanTitle = title.trim();
    
    // Normalize URL: Ensure it starts with http:// or https://
    String normalizedUrl = url.trim();
    if (normalizedUrl.isNotEmpty && 
        !normalizedUrl.startsWith('http://') && 
        !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'https://$normalizedUrl';
    }

    final String finalId = id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final newProfile = UserProfile(id: finalId, name: cleanName, title: cleanTitle, url: normalizedUrl);

    final existingIndex = _profiles.indexWhere((p) => p.id == finalId);
    if (existingIndex != -1) {
      _profiles[existingIndex] = newProfile;
      _currentIndex = existingIndex;
    } else {
      _profiles.add(newProfile);
      _currentIndex = _profiles.length - 1;
    }

    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    final indexToDelete = _profiles.indexWhere((p) => p.id == id);
    if (indexToDelete == -1) return;

    _profiles.removeAt(indexToDelete);

    if (_profiles.isEmpty) {
      _currentIndex = 0;
    } else if (_currentIndex >= _profiles.length) {
      _currentIndex = _profiles.length - 1;
    } else if (_currentIndex > indexToDelete) {
      _currentIndex--;
    }

    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> setCurrentIndex(int index) async {
    if (index >= 0 && index < _profiles.length) {
      _currentIndex = index;
      await _prefs.setInt(StorageKeys.activeProfileIndex, _currentIndex);
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final List<String> serializedList = _profiles.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs.setStringList(StorageKeys.profilesList, serializedList);
    await _prefs.setInt(StorageKeys.activeProfileIndex, _currentIndex);
  }
}
