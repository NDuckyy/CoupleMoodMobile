class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final String messageType; // "TEXT" | "IMAGE" | "VIDEO" | "AUDIO" | "FILE"
  final int? referenceId;
  final String? referenceType;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isMine;
  
  // Local state
  final MessageStatus status;
  final String? localId; // For optimistic UI

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.messageType,
    this.referenceId,
    this.referenceType,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
    required this.isMine,
    this.status = MessageStatus.sent,
    this.localId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      conversationId: json['conversationId'] as int,
      senderId: json['senderId'] as int,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String?,
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String,
      referenceId: json['referenceId'] as int?,
      referenceType: json['referenceType'] as String?,
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileSize: json['fileSize'] as int?,
      metadata: json['metadata'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      isMine: json['isMine'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'messageType': messageType,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isMine': isMine,
    };
  }

  Message copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? senderName,
    String? senderAvatar,
    String? content,
    String? messageType,
    int? referenceId,
    String? referenceType,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isMine,
    MessageStatus? status,
    String? localId,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isMine: isMine ?? this.isMine,
      status: status ?? this.status,
      localId: localId ?? this.localId,
    );
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}
