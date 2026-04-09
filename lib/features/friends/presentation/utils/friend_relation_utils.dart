import 'package:go_question/core/constants/friends_texts.dart';
import 'package:go_question/features/profile/domain/entities/profile.dart';

abstract final class FriendRelationUtils {
  FriendRelationUtils._();

  static String buildRequestId({
    required String requesterUid,
    required String recipientUid,
  }) {
    return '${requesterUid}_$recipientUid';
  }

  static bool isFriend({
    required Profile? currentProfile,
    required String otherUid,
  }) {
    return currentProfile?.friendIds.contains(otherUid) ?? false;
  }

  static bool isOutgoingRequestPending({
    required Profile? currentProfile,
    required String currentUserId,
    required String otherUid,
  }) {
    if (currentProfile == null || currentUserId.isEmpty || otherUid.isEmpty) {
      return false;
    }

    final requestId = buildRequestId(
      requesterUid: currentUserId,
      recipientUid: otherUid,
    );
    return currentProfile.outgoingFriendRequestIds.contains(requestId);
  }

  static bool isIncomingRequestPending({
    required Profile? currentProfile,
    required String currentUserId,
    required String otherUid,
  }) {
    if (currentProfile == null || currentUserId.isEmpty || otherUid.isEmpty) {
      return false;
    }

    final requestId = buildRequestId(
      requesterUid: otherUid,
      recipientUid: currentUserId,
    );
    return currentProfile.incomingFriendRequestIds.contains(requestId);
  }

  static String actionLabel({
    required Profile? currentProfile,
    required String currentUserId,
    required String otherUid,
  }) {
    if (currentUserId.isNotEmpty && currentUserId == otherUid) {
      return FriendsTexts.selfAccount;
    }
    if (isFriend(currentProfile: currentProfile, otherUid: otherUid)) {
      return FriendsTexts.alreadyFriend;
    }
    if (isOutgoingRequestPending(
      currentProfile: currentProfile,
      currentUserId: currentUserId,
      otherUid: otherUid,
    )) {
      return FriendsTexts.friendRequestPending;
    }
    if (isIncomingRequestPending(
      currentProfile: currentProfile,
      currentUserId: currentUserId,
      otherUid: otherUid,
    )) {
      return FriendsTexts.friendRequestIncoming;
    }
    return FriendsTexts.addFriend;
  }

  static bool canSendRequest({
    required Profile? currentProfile,
    required String currentUserId,
    required String otherUid,
  }) {
    return currentProfile != null &&
        currentUserId.isNotEmpty &&
        currentUserId != otherUid &&
        !isFriend(currentProfile: currentProfile, otherUid: otherUid) &&
        !isOutgoingRequestPending(
          currentProfile: currentProfile,
          currentUserId: currentUserId,
          otherUid: otherUid,
        ) &&
        !isIncomingRequestPending(
          currentProfile: currentProfile,
          currentUserId: currentUserId,
          otherUid: otherUid,
        );
  }
}
