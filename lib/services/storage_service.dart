import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';
import 'firebase_service.dart';

enum LoadingStatus { initial, loading, loaded, error }

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
    // Load data from Firebase on initialization
    await _loadFromFirebase();

    // Listen for real-time updates
    _listenToFirebaseUpdates();
  }

  /// Set callback for when data changes
  void setOnDataChanged(Function() callback) {
    _onDataChanged = callback;
  }

  /// Set callback for loading status changes
  void setOnLoadingStatusChanged(Function(LoadingStatus, String?) callback) {
    _onLoadingStatusChanged = callback;
  }

  /// Load all data from Firebase
  Future<void> _loadFromFirebase() async {
    _updateLoadingStatus(LoadingStatus.loading);
    try {
      // Just verify connection, actual data loaded on demand
      await _firebaseService.getAllData();
      _updateLoadingStatus(LoadingStatus.loaded);
    } catch (e) {
      final errorMsg = 'Failed to load data from Firebase: ${e.toString()}';
      _updateLoadingStatus(LoadingStatus.error, errorMsg);
      print(errorMsg);
    }
  }

  /// Listen for real-time updates from Firebase
  void _listenToFirebaseUpdates() {
    _firebaseService.portfolioStream.listen((snapshot) {
      if (snapshot.exists) {
        // Notify listeners of data changes
        _onDataChanged?.call();
      }
    });
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
