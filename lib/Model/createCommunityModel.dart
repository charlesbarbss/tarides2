import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  Community(
      {required this.communityName,
      required this.communityId,
      required this.isPrivate,
      required this.communityDescription,
      required this.communityAdmin,
      required this.communityMember,
      required this.communityPic
      });

  final String communityName;
  final String communityId;
  final bool isPrivate;
   final String communityDescription;
  final String communityAdmin;
  final List<String> communityMember;
    final String communityPic;
  

  
  factory Community.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
  final data = document.data() as Map<String, dynamic>;
  final List<dynamic> membersData = data['communityMember'] ?? [];
  final List<String> members = membersData.map((memberData) {
    return memberData as String;
  }).toList();
  return Community(
    communityId: data['communityId'] as String? ?? '',
    communityName: data['communityName'] as String? ?? '',
    isPrivate: data['isPrivate'] as bool? ?? false,
     communityDescription: data['communityDescription'] as String,
    communityAdmin: data['communityAdmin'] as String? ?? '',
    communityMember: members,
    communityPic: data['communityPic'] as String? ?? '',
   
  );
}
}
