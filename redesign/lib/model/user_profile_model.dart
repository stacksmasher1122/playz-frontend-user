import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String docId;
  final String fullName;
  final String username;
  final String primaryEmail;
  final String secondaryEmail;
  final String primaryPhone;
  final String secondaryPhone;
  final String bio;
  final String dob;
  final String profileImageUrl;
  final List<String> favoriteSports;
  final bool isPublicProfile;
  final bool isTrainer;
  final String tier;
  final int xpPoints;
  final int zCoins;
  final String subscriptionStatus; // 'FREE', 'Z PREMIUM'
  final String referralCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel({
    required this.docId,
    this.fullName = '',
    this.username = '',
    this.primaryEmail = '',
    this.secondaryEmail = '',
    this.primaryPhone = '',
    this.secondaryPhone = '',
    this.bio = '',
    this.dob = '',
    this.profileImageUrl = '',
    this.favoriteSports = const ['Cricket', 'Badminton', 'Football'],
    this.isPublicProfile = true,
    this.isTrainer = false,
    this.tier = 'ROOKIE',
    this.xpPoints = 100,
    this.zCoins = 200,
    this.subscriptionStatus = 'FREE',
    this.referralCode = '',
    this.createdAt,
    this.updatedAt,
  });

  String get effectiveUsername {
    if (username.trim().isNotEmpty) return username.startsWith('@') ? username : '@$username';
    if (fullName.trim().isNotEmpty) return '@${fullName.toLowerCase().replaceAll(' ', '')}';
    return '@player';
  }

  factory UserProfileModel.fromMap(String id, Map<String, dynamic> map) {
    final name = (map['fullName'] ?? '').toString();
    final uname = (map['username'] ?? '').toString();
    final defaultUname = uname.isNotEmpty
        ? uname
        : (name.isNotEmpty ? '@${name.toLowerCase().replaceAll(' ', '')}' : '@player');

    return UserProfileModel(
      docId: id,
      fullName: name,
      username: defaultUname,
      primaryEmail: map['primaryEmail'] ?? '',
      secondaryEmail: map['secondaryEmail'] ?? '',
      primaryPhone: map['primaryPhone'] ?? '',
      secondaryPhone: map['secondaryPhone'] ?? '',
      bio: map['bio'] ?? 'Sports Enthusiast & PlayZ Athlete 🏆',
      dob: map['dob'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      favoriteSports: List<String>.from(map['favoriteSports'] ?? ['Cricket', 'Badminton', 'Football']),
      isPublicProfile: map['isPublicProfile'] ?? true,
      isTrainer: map['isTrainer'] ?? false,
      tier: (map['tier'] ?? 'ROOKIE').toString().toUpperCase(),
      xpPoints: (map['xpPoints'] as num?)?.toInt() ?? 100,
      zCoins: (map['zCoins'] as num?)?.toInt() ?? 200,
      subscriptionStatus: (map['subscriptionStatus'] ?? 'FREE').toString().toUpperCase(),
      referralCode: map['referralCode'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'username': effectiveUsername,
      'primaryEmail': primaryEmail,
      'secondaryEmail': secondaryEmail,
      'primaryPhone': primaryPhone,
      'secondaryPhone': secondaryPhone,
      'bio': bio,
      'dob': dob,
      'profileImageUrl': profileImageUrl,
      'favoriteSports': favoriteSports,
      'isPublicProfile': isPublicProfile,
      'isTrainer': isTrainer,
      'tier': tier,
      'xpPoints': xpPoints,
      'zCoins': zCoins,
      'subscriptionStatus': subscriptionStatus,
      'referralCode': referralCode,
      'isProfileComplete': true,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserProfileModel copyWith({
    String? docId,
    String? fullName,
    String? username,
    String? primaryEmail,
    String? secondaryEmail,
    String? primaryPhone,
    String? secondaryPhone,
    String? bio,
    String? dob,
    String? profileImageUrl,
    List<String>? favoriteSports,
    bool? isPublicProfile,
    bool? isTrainer,
    String? tier,
    int? xpPoints,
    int? zCoins,
    String? subscriptionStatus,
    String? referralCode,
  }) {
    return UserProfileModel(
      docId: docId ?? this.docId,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      favoriteSports: favoriteSports ?? this.favoriteSports,
      isPublicProfile: isPublicProfile ?? this.isPublicProfile,
      isTrainer: isTrainer ?? this.isTrainer,
      tier: tier ?? this.tier,
      xpPoints: xpPoints ?? this.xpPoints,
      zCoins: zCoins ?? this.zCoins,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      referralCode: referralCode ?? this.referralCode,
    );
  }
}
