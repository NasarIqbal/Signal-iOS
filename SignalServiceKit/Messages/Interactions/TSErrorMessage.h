//
// Copyright 2018 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

#import <SignalServiceKit/OWSReadTracking.h>
#import <SignalServiceKit/TSMessage.h>

NS_ASSUME_NONNULL_BEGIN

@class AciObjC;
@class SSKProtoEnvelope;
@class SignalServiceAddress;
@class TSErrorMessageBuilder;

typedef NS_CLOSED_ENUM(int32_t, TSErrorMessageType) {
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageNoSession,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageWrongTrustedIdentityKey,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageInvalidKeyException,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageMissingKeyId,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageInvalidMessage,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageDuplicateMessage,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageInvalidVersion,
    /// Represents a "safety number change"; i.e, we learned that another user's
    /// identity key has changed.
    TSErrorMessageNonBlockingIdentityChange,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageUnknownContactBlockOffer,
    /// - Note This case is deprecated, but may be persisted in legacy messages.
    TSErrorMessageGroupCreationFailed,
    /// Represents that we performed a legacy session-reset with another user
    /// because a message from them failed to decrypt and the automatic retry
    /// system is disabled.
    /// - Important
    /// The automatic "request resend of message that failed to decrypt" system
    /// should mean that these are never used. However, since that system can
    /// be disabled via remote config these messages remain relevant.
    TSErrorMessageSessionRefresh,
    /// Represents a message that has permanently failed to decrypt. For
    /// example, this may represent a message for which we requested a resend
    /// but didn't receive one in time.
    TSErrorMessageDecryptionFailure,
};

extern NSUInteger TSErrorMessageSchemaVersion;

#pragma mark -

@interface TSErrorMessage : TSMessage <OWSReadTracking, OWSPreviewText>

- (instancetype)initMessageWithBuilder:(TSMessageBuilder *)messageBuilder NS_UNAVAILABLE;

- (instancetype)initWithGrdbId:(int64_t)grdbId
                          uniqueId:(NSString *)uniqueId
               receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                            sortId:(uint64_t)sortId
                         timestamp:(uint64_t)timestamp
                    uniqueThreadId:(NSString *)uniqueThreadId
                              body:(nullable NSString *)body
                        bodyRanges:(nullable MessageBodyRanges *)bodyRanges
                      contactShare:(nullable OWSContact *)contactShare
          deprecated_attachmentIds:(nullable NSArray<NSString *> *)deprecated_attachmentIds
                         editState:(TSEditState)editState
                   expireStartedAt:(uint64_t)expireStartedAt
                expireTimerVersion:(nullable NSNumber *)expireTimerVersion
                         expiresAt:(uint64_t)expiresAt
                  expiresInSeconds:(unsigned int)expiresInSeconds
                         giftBadge:(nullable OWSGiftBadge *)giftBadge
                 isGroupStoryReply:(BOOL)isGroupStoryReply
    isSmsMessageRestoredFromBackup:(BOOL)isSmsMessageRestoredFromBackup
                isViewOnceComplete:(BOOL)isViewOnceComplete
                 isViewOnceMessage:(BOOL)isViewOnceMessage
                       linkPreview:(nullable OWSLinkPreview *)linkPreview
                    messageSticker:(nullable MessageSticker *)messageSticker
                     quotedMessage:(nullable TSQuotedMessage *)quotedMessage
      storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
             storyAuthorUuidString:(nullable NSString *)storyAuthorUuidString
                storyReactionEmoji:(nullable NSString *)storyReactionEmoji
                    storyTimestamp:(nullable NSNumber *)storyTimestamp
                wasRemotelyDeleted:(BOOL)wasRemotelyDeleted NS_UNAVAILABLE;

- (instancetype)initErrorMessageWithBuilder:(TSErrorMessageBuilder *)errorMessageBuilder NS_DESIGNATED_INITIALIZER
    NS_SWIFT_NAME(init(errorMessageWithBuilder:));

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                            body:(nullable NSString *)body
                      bodyRanges:(nullable MessageBodyRanges *)bodyRanges
                    contactShare:(nullable OWSContact *)contactShare
        deprecated_attachmentIds:(nullable NSArray<NSString *> *)deprecated_attachmentIds
                       editState:(TSEditState)editState
                 expireStartedAt:(uint64_t)expireStartedAt
              expireTimerVersion:(nullable NSNumber *)expireTimerVersion
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
                       giftBadge:(nullable OWSGiftBadge *)giftBadge
               isGroupStoryReply:(BOOL)isGroupStoryReply
  isSmsMessageRestoredFromBackup:(BOOL)isSmsMessageRestoredFromBackup
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
           storyAuthorUuidString:(nullable NSString *)storyAuthorUuidString
              storyReactionEmoji:(nullable NSString *)storyReactionEmoji
                  storyTimestamp:(nullable NSNumber *)storyTimestamp
              wasRemotelyDeleted:(BOOL)wasRemotelyDeleted
                       errorType:(TSErrorMessageType)errorType
                            read:(BOOL)read
                recipientAddress:(nullable SignalServiceAddress *)recipientAddress
                          sender:(nullable SignalServiceAddress *)sender
             wasIdentityVerified:(BOOL)wasIdentityVerified
NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(grdbId:uniqueId:receivedAtTimestamp:sortId:timestamp:uniqueThreadId:body:bodyRanges:contactShare:deprecated_attachmentIds:editState:expireStartedAt:expireTimerVersion:expiresAt:expiresInSeconds:giftBadge:isGroupStoryReply:isSmsMessageRestoredFromBackup:isViewOnceComplete:isViewOnceMessage:linkPreview:messageSticker:quotedMessage:storedShouldStartExpireTimer:storyAuthorUuidString:storyReactionEmoji:storyTimestamp:wasRemotelyDeleted:errorType:read:recipientAddress:sender:wasIdentityVerified:));

// clang-format on

// --- CODE GENERATION MARKER

@property (nonatomic, readonly) TSErrorMessageType errorType;
@property (nullable, nonatomic, readonly) SignalServiceAddress *sender;
@property (nullable, nonatomic, readonly) SignalServiceAddress *recipientAddress;

// This property only applies if errorType == .nonBlockingIdentityChange.
@property (nonatomic, readonly) BOOL wasIdentityVerified;

@end

NS_ASSUME_NONNULL_END
