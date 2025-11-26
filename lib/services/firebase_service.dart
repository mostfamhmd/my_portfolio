import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';

/// Service for reading portfolio data from Firebase Firestore
/// This service is used by the my_portfolio app to display data
class FirebaseService {
  static const String _collectionName = 'portfolio';
  static const String _documentId = 'data';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get reference to the portfolio document
  DocumentReference<Map<String, dynamic>> get _portfolioDoc =>
      _firestore.collection(_collectionName).doc(_documentId);

  // Stream for real-time updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> get portfolioStream =>
      _portfolioDoc.snapshots();

  // Personal Info
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

  Stream<PersonalInfo?> get personalInfoStream {
    return portfolioStream.map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null || !data.containsKey('personalInfo')) return null;
      return PersonalInfo.fromJson(
        Map<String, dynamic>.from(data['personalInfo']),
      );
    });
  }

  // Skills
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

  Stream<List<Skill>> get skillsStream {
    return portfolioStream.map((doc) {
      if (!doc.exists) return <Skill>[];
      final data = doc.data();
      if (data == null || !data.containsKey('skills')) return <Skill>[];
      final List<dynamic> skillsList = data['skills'];
      return skillsList
          .map((json) => Skill.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    });
  }

  // Projects
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

  Stream<List<Project>> get projectsStream {
    return portfolioStream.map((doc) {
      if (!doc.exists) return <Project>[];
      final data = doc.data();
      if (data == null || !data.containsKey('projects')) return <Project>[];
      final List<dynamic> projectsList = data['projects'];
      return projectsList
          .map((json) => Project.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    });
  }

  // Experiences
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

  Stream<List<Experience>> get experiencesStream {
    return portfolioStream.map((doc) {
      if (!doc.exists) return <Experience>[];
      final data = doc.data();
      if (data == null || !data.containsKey('experiences'))
        return <Experience>[];
      final List<dynamic> experiencesList = data['experiences'];
      return experiencesList
          .map((json) => Experience.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    });
  }

  // Social Links
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

  Stream<List<SocialLink>> get socialLinksStream {
    return portfolioStream.map((doc) {
      if (!doc.exists) return <SocialLink>[];
      final data = doc.data();
      if (data == null || !data.containsKey('socialLinks'))
        return <SocialLink>[];
      final List<dynamic> linksList = data['socialLinks'];
      return linksList
          .map((json) => SocialLink.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    });
  }

  // Get all data at once
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
