import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';

/// Service for reading portfolio data from Firebase Firestore
///
/// Optimized for Vercel hosting - uses one-time fetches (get()) instead of
/// real-time listeners (snapshots()) to avoid ping/long-polling issues.
///
/// For real-time updates, consider using Firebase Hosting instead of Vercel.
class FirebaseService {
  static const String _collectionName = 'portfolio';
  static const String _documentId = 'data';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get reference to the portfolio document
  DocumentReference<Map<String, dynamic>> get _portfolioDoc =>
      _firestore.collection(_collectionName).doc(_documentId);

  // Personal Info (one-time fetch)
  Future<PersonalInfo?> getPersonalInfo() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null || !data.containsKey('personalInfo')) return null;
      return PersonalInfo.fromJson(
        Map<String, dynamic>.from(data['personalInfo']),
      );
    } catch (e) {
      print('Error fetching personal info: $e');
      return null;
    }
  }

  // Skills (one-time fetch)
  Future<List<Skill>> getSkills() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('skills')) return [];
      final List<dynamic> skillsList = data['skills'];
      return skillsList
          .map((json) => Skill.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('Error fetching skills: $e');
      return [];
    }
  }

  // Projects (one-time fetch)
  Future<List<Project>> getProjects() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('projects')) return [];
      final List<dynamic> projectsList = data['projects'];
      return projectsList
          .map((json) => Project.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  // Experiences (one-time fetch)
  Future<List<Experience>> getExperiences() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('experiences')) return [];
      final List<dynamic> experiencesList = data['experiences'];
      return experiencesList
          .map((json) => Experience.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('Error fetching experiences: $e');
      return [];
    }
  }

  // Social Links (one-time fetch)
  Future<List<SocialLink>> getSocialLinks() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('socialLinks')) return [];
      final List<dynamic> linksList = data['socialLinks'];
      return linksList
          .map((json) => SocialLink.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('Error fetching social links: $e');
      return [];
    }
  }

  // Get all data at once (one-time fetch)
  Future<Map<String, dynamic>> getAllData() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return {};
      return doc.data() ?? {};
    } catch (e) {
      print('Error fetching all data: $e');
      return {};
    }
  }
}
