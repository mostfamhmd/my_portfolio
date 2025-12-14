import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';
import 'firebase_service.dart';

enum LoadingStatus { initial, loading, loaded, error }

/// StorageService - Optimized for Vercel hosting
///
/// Uses one-time fetches (get()) instead of real-time listeners (snapshots())
/// to avoid ping/long-polling issues with Vercel's serverless architecture.
///
/// For real-time updates, consider using Firebase Hosting instead.
class StorageService {
  final FirebaseService _firebaseService = FirebaseService();

  // Loading and error state tracking
  LoadingStatus _loadingStatus = LoadingStatus.initial;
  String? _errorMessage;

  // Callbacks for state changes
  Function()? _onDataChanged;
  Function(LoadingStatus, String?)? _onLoadingStatusChanged;

  LoadingStatus get loadingStatus => _loadingStatus;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _loadingStatus == LoadingStatus.loading;
  bool get hasError => _loadingStatus == LoadingStatus.error;

  void _updateLoadingStatus(LoadingStatus status, [String? error]) {
    _loadingStatus = status;
    _errorMessage = error;
    _onLoadingStatusChanged?.call(status, error);
  }

  Future<void> init() async {
    // Load data from Firebase on initialization (one-time fetch)
    await _loadFromFirebase();

    // Note: Real-time listeners removed to fix Vercel compatibility
    // Data is now fetched on-demand using get() instead of snapshots()
  }

  /// Set callback for when data changes
  void setOnDataChanged(Function() callback) {
    _onDataChanged = callback;
  }

  /// Set callback for loading status changes
  void setOnLoadingStatusChanged(Function(LoadingStatus, String?) callback) {
    _onLoadingStatusChanged = callback;
  }

  /// Load all data from Firebase (one-time fetch - Vercel compatible)
  Future<void> _loadFromFirebase() async {
    _updateLoadingStatus(LoadingStatus.loading);
    try {
      // One-time fetch, no real-time listeners
      await _firebaseService.getAllData();
      _updateLoadingStatus(LoadingStatus.loaded);
    } catch (e) {
      final errorMsg = 'Failed to load data from Firebase: ${e.toString()}';
      _updateLoadingStatus(LoadingStatus.error, errorMsg);
      print(errorMsg);
    }
  }

  // Personal Info
  Future<PersonalInfo> getPersonalInfo() async {
    final info = await _firebaseService.getPersonalInfo();
    return info ?? PersonalInfo.empty;
  }

  // Skills
  Future<List<Skill>> getSkills() async {
    return await _firebaseService.getSkills();
  }

  // Projects
  Future<List<Project>> getProjects() async {
    return await _firebaseService.getProjects();
  }

  // Experiences
  Future<List<Experience>> getExperiences() async {
    return await _firebaseService.getExperiences();
  }

  // Social Links
  Future<List<SocialLink>> getSocialLinks() async {
    return await _firebaseService.getSocialLinks();
  }

  // Refresh data from Firebase
  Future<void> refresh() async {
    await _loadFromFirebase();
    _onDataChanged?.call();
  }

  // Clear error state
  void clearError() {
    _errorMessage = null;
    _loadingStatus = LoadingStatus.loaded;
    _onLoadingStatusChanged?.call(_loadingStatus, null);
  }

  // Note: This is a read-only service
  // The dashboard app handles all write operations
}
