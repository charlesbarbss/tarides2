import 'package:cloud_firestore/cloud_firestore.dart';

class Invite {
  Invite({
    required this.inviteId,
    required this.requestedCommunityId,
    required this.inviter,
    required this.invitee,
    required this.communityName
  });

  final String inviteId;
  final String requestedCommunityId;
  final String inviter;
    final String invitee;
    final String communityName;

  factory Invite.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;

    return Invite(
      inviteId: data['inviteId'] as String? ?? '',
      requestedCommunityId: data['requestedCommunityId'] as String? ?? '',
      inviter: data['inviter'] as String? ?? '',
      invitee: data['invitee'] as String? ?? '',
      communityName: data['communityName'] as String? ?? '',
    );
  }
}