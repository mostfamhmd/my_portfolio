import 'package:flutter/material.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';
import '../services/storage_service.dart';

/// PortfolioProvider - Optimized for Vercel hosting
///
/// Removed real-time listeners to fix Vercel ping/long-polling issues.
/// Data is now loaded on-demand and can be refreshed manually.
class PortfolioProvider with ChangeNotifier {
  final StorageService _storage;

  PortfolioProvider(this._storage) {
    _loadData();
    // Listen for loading status changes
    _storage.setOnLoadingStatusChanged((status, error) {
      _loadingStatus = status;
      _errorMessage = error;
      notifyListeners();
    });

    // Note: Real-time data sync removed for Vercel compatibility
    // Use refresh() method to manually reload data when needed
  }

  // State
  PersonalInfo _personalInfo = PersonalInfo.empty;
  List<Skill> _skills = [];
  List<Project> _projects = [];
  List<Experience> _experiences = [];
  List<SocialLink> _socialLinks = [];
  bool _isLoading = false;
  LoadingStatus _loadingStatus = LoadingStatus.initial;
  String? _errorMessage;

  // Getters
  PersonalInfo get personalInfo => _personalInfo;
  List<Skill> get skills => List.unmodifiable(_skills);
  List<Project> get projects => List.unmodifiable(_projects);
  List<Experience> get experiences => List.unmodifiable(_experiences);
  List<SocialLink> get socialLinks => List.unmodifiable(_socialLinks);
  bool get isLoading => _isLoading;
  LoadingStatus get loadingStatus => _loadingStatus;
  String? get errorMessage => _errorMessage;
  bool get isDataLoading => _loadingStatus == LoadingStatus.loading;
  bool get hasLoadError => _loadingStatus == LoadingStatus.error;

  // Clear error
  void clearError() {
    _storage.clearError();
  }

  // Categorized skills
  Map<String, List<Skill>> get skillsByCategory {
    final Map<String, List<Skill>> categorized = {};
    for (var skill in _skills) {
      if (!categorized.containsKey(skill.category)) {
        categorized[skill.category] = [];
      }
      categorized[skill.category]!.add(skill);
    }
    return categorized;
  }

  // Featured projects
  List<Project> get featuredProjects =>
      _projects.where((p) => p.isFeatured).toList();

  // Work experiences
  List<Experience> get workExperiences =>
      _experiences.where((e) => e.type == 'work').toList();

  // Education experiences
  List<Experience> get educationExperiences =>
      _experiences.where((e) => e.type == 'education').toList();

  // Load all data
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _personalInfo = await _storage.getPersonalInfo();
      _skills = await _storage.getSkills();
      _projects = await _storage.getProjects();
      _experiences = await _storage.getExperiences();
      _socialLinks = await _storage.getSocialLinks();
    } catch (e) {
      print('Error loading data: $e');
      // Keep existing data or defaults
    }

    _isLoading = false;
    notifyListeners();
  }

  // Note: All write operations are managed by the portfolio_dashboard app
  // This is a read-only view that automatically syncs with Firebase

  // Refresh data
  Future<void> refresh() async {
    await _loadData();
  }
}
