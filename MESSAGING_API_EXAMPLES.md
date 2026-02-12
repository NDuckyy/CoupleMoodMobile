# Messaging API - Request/Response Examples

Tài liệu này chứa các ví dụ thực tế về Request và Response của tất cả API Messaging.

---

## 1. Tạo Conversation Mới

**Endpoint:** `POST /api/messaging/conversations`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

### Request Body - Tạo Group Chat
```json
{
  "type": "GROUP",
  "name": "Nhóm bạn thân",
  "memberIds": [101, 102, 103, 104]
}
```

### Request Body - Tạo Direct Chat
```json
{
  "type": "DIRECT",
  "memberIds": [105]
}
```

### Response - 201 Created
```json
{
  "id": 1,
  "type": "GROUP",
  "name": "Nhóm bạn thân",
  "createdBy": 100,
  "createdAt": "2026-02-12T10:30:00Z",
  "members": [
    {
      "userId": 100,
      "username": "user100",
      "fullName": "Nguyễn Văn A",
      "avatar": "https://example.com/avatars/100.jpg",
      "role": "ADMIN",
      "joinedAt": "2026-02-12T10:30:00Z",
      "isOnline": true
    },
    {
      "userId": 101,
      "username": "user101",
      "fullName": "Trần Thị B",
      "avatar": "https://example.com/avatars/101.jpg",
      "role": "MEMBER",
      "joinedAt": "2026-02-12T10:30:00Z",
      "isOnline": false
    }
  ],
  "otherUser": null,
  "lastMessage": null,
  "unreadCount": 0
}
```

---

## 2. Lấy hoặc Tạo Direct Conversation

**Endpoint:** `POST /api/messaging/conversations/direct/{otherUserId}`

**Example:** `POST /api/messaging/conversations/direct/105`

### Response - 200 OK
```json
{
  "id": 2,
  "type": "DIRECT",
  "name": null,
  "createdBy": 100,
  "createdAt": "2026-02-12T10:35:00Z",
  "members": [
    {
      "userId": 100,
      "username": "user100",
      "fullName": "Nguyễn Văn A",
      "avatar": "https://example.com/avatars/100.jpg",
      "role": "MEMBER",
      "joinedAt": "2026-02-12T10:35:00Z",
      "isOnline": true
    },
    {
      "userId": 105,
      "username": "user105",
      "fullName": "Phạm Văn C",
      "avatar": "https://example.com/avatars/105.jpg",
      "role": "MEMBER",
      "joinedAt": "2026-02-12T10:35:00Z",
      "isOnline": true
    }
  ],
  "otherUser": {
    "userId": 105,
    "username": "user105",
    "fullName": "Phạm Văn C",
    "avatar": "https://example.com/avatars/105.jpg",
    "role": "MEMBER",
    "joinedAt": "2026-02-12T10:35:00Z",
    "isOnline": true
  },
  "lastMessage": null,
  "unreadCount": 0
}
```

---

## 3. Lấy Danh Sách Conversations

**Endpoint:** `GET /api/messaging/conversations`

### Response - 200 OK
```json
[
  {
    "id": 1,
    "type": "GROUP",
    "name": "Nhóm bạn thân",
    "createdBy": 100,
    "createdAt": "2026-02-12T10:30:00Z",
    "members": [
      {
        "userId": 100,
        "username": "user100",
        "fullName": "Nguyễn Văn A",
        "avatar": "https://example.com/avatars/100.jpg",
        "role": "ADMIN",
        "joinedAt": "2026-02-12T10:30:00Z",
        "isOnline": true
      }
    ],
    "otherUser": null,
    "lastMessage": {
      "id": 15,
      "conversationId": 1,
      "senderId": 101,
      "senderName": "Trần Thị B",
      "senderAvatar": "https://example.com/avatars/101.jpg",
      "content": "Hẹn gặp 5h chiều nha!",
      "messageType": "TEXT",
      "referenceId": null,
      "referenceType": null,
      "fileUrl": null,
      "fileName": null,
      "fileSize": null,
      "metadata": null,
      "createdAt": "2026-02-12T14:20:00Z",
      "updatedAt": "2026-02-12T14:20:00Z",
      "isMine": false
    },
    "unreadCount": 3
  },
  {
    "id": 2,
    "type": "DIRECT",
    "name": null,
    "createdBy": 100,
    "createdAt": "2026-02-12T10:35:00Z",
    "members": [
      {
        "userId": 100,
        "username": "user100",
        "fullName": "Nguyễn Văn A",
        "avatar": "https://example.com/avatars/100.jpg",
        "role": "MEMBER",
        "joinedAt": "2026-02-12T10:35:00Z",
        "isOnline": true
      },
      {
        "userId": 105,
        "username": "user105",
        "fullName": "Phạm Văn C",
        "avatar": "https://example.com/avatars/105.jpg",
        "role": "MEMBER",
        "joinedAt": "2026-02-12T10:35:00Z",
        "isOnline": true
      }
    ],
    "otherUser": {
      "userId": 105,
      "username": "user105",
      "fullName": "Phạm Văn C",
      "avatar": "https://example.com/avatars/105.jpg",
      "role": "MEMBER",
      "joinedAt": "2026-02-12T10:35:00Z",
      "isOnline": true
    },
    "lastMessage": {
      "id": 20,
      "conversationId": 2,
      "senderId": 105,
      "senderName": "Phạm Văn C",
      "senderAvatar": "https://example.com/avatars/105.jpg",
      "content": "Ok bạn ơi",
      "messageType": "TEXT",
      "referenceId": null,
      "referenceType": null,
      "fileUrl": null,
      "fileName": null,
      "fileSize": null,
      "metadata": null,
      "createdAt": "2026-02-12T15:00:00Z",
      "updatedAt": "2026-02-12T15:00:00Z",
      "isMine": false
    },
    "unreadCount": 1
  }
]
```

---

## 4. Lấy Conversation theo ID

**Endpoint:** `GET /api/messaging/conversations/{conversationId}`

**Example:** `GET /api/messaging/conversations/1`

### Response - 200 OK
```json
{
  "id": 1,
  "type": "GROUP",
  "name": "Nhóm bạn thân",
  "createdBy": 100,
  "createdAt": "2026-02-12T10:30:00Z",
  "members": [
    {
      "userId": 100,
      "username": "user100",
      "fullName": "Nguyễn Văn A",
      "avatar": "https://example.com/avatars/100.jpg",
      "role": "ADMIN",
      "joinedAt": "2026-02-12T10:30:00Z",
      "isOnline": true
    },
    {
      "userId": 101,
      "username": "user101",
      "fullName": "Trần Thị B",
      "avatar": "https://example.com/avatars/101.jpg",
      "role": "MEMBER",
      "joinedAt": "2026-02-12T10:30:00Z",
      "isOnline": false
    },
    {
      "userId": 102,
      "username": "user102",
      "fullName": "Lê Văn D",
      "avatar": "https://example.com/avatars/102.jpg",
      "role": "MEMBER",
      "joinedAt": "2026-02-12T10:30:00Z",
      "isOnline": true
    }
  ],
  "otherUser": null,
  "lastMessage": {
    "id": 15,
    "conversationId": 1,
    "senderId": 101,
    "senderName": "Trần Thị B",
    "senderAvatar": "https://example.com/avatars/101.jpg",
    "content": "Hẹn gặp 5h chiều nha!",
    "messageType": "TEXT",
    "referenceId": null,
    "referenceType": null,
    "fileUrl": null,
    "fileName": null,
    "fileSize": null,
    "metadata": null,
    "createdAt": "2026-02-12T14:20:00Z",
    "updatedAt": "2026-02-12T14:20:00Z",
    "isMine": false
  },
  "unreadCount": 3
}
```

---

## 5. Gửi Tin Nhắn

**Endpoint:** `POST /api/messaging/messages`

### Request Body - Tin nhắn text
```json
{
  "conversationId": 1,
  "content": "Xin chào mọi người!",
  "messageType": "TEXT"
}
```

### Request Body - Tin nhắn có hình ảnh
```json
{
  "conversationId": 1,
  "content": "Check ảnh này nè",
  "messageType": "IMAGE",
  "fileUrl": "https://example.com/uploads/images/abc123.jpg",
  "fileName": "photo.jpg",
  "fileSize": 2048576
}
```

### Request Body - Tin nhắn có file đính kèm
```json
{
  "conversationId": 1,
  "content": "File báo cáo đây",
  "messageType": "FILE",
  "fileUrl": "https://example.com/uploads/files/report.pdf",
  "fileName": "BaoCao_ThangNam.pdf",
  "fileSize": 5242880
}
```

### Request Body - Tin nhắn có reference
```json
{
  "conversationId": 1,
  "content": "Chúng ta đi địa điểm này nhé!",
  "messageType": "TEXT",
  "referenceId": 456,
  "referenceType": "VENUE_LOCATION"
}
```

### Response - 201 Created
```json
{
  "id": 25,
  "conversationId": 1,
  "senderId": 100,
  "senderName": "Nguyễn Văn A",
  "senderAvatar": "https://example.com/avatars/100.jpg",
  "content": "Xin chào mọi người!",
  "messageType": "TEXT",
  "referenceId": null,
  "referenceType": null,
  "fileUrl": null,
  "fileName": null,
  "fileSize": null,
  "metadata": null,
  "createdAt": "2026-02-12T15:30:00Z",
  "updatedAt": "2026-02-12T15:30:00Z",
  "isMine": true
}
```

### Response - Tin nhắn có file
```json
{
  "id": 26,
  "conversationId": 1,
  "senderId": 100,
  "senderName": "Nguyễn Văn A",
  "senderAvatar": "https://example.com/avatars/100.jpg",
  "content": "Check ảnh này nè",
  "messageType": "IMAGE",
  "referenceId": null,
  "referenceType": null,
  "fileUrl": "https://example.com/uploads/images/abc123.jpg",
  "fileName": "photo.jpg",
  "fileSize": 2048576,
  "metadata": "{\"fileUrl\":\"https://example.com/uploads/images/abc123.jpg\",\"fileName\":\"photo.jpg\",\"fileSize\":2048576}",
  "createdAt": "2026-02-12T15:31:00Z",
  "updatedAt": "2026-02-12T15:31:00Z",
  "isMine": true
}
```

---

## 6. Lấy Tin Nhắn (Phân Trang)

**Endpoint:** `GET /api/messaging/conversations/{conversationId}/messages`

**Example:** `GET /api/messaging/conversations/1/messages?pageNumber=1&pageSize=20`

### Query Parameters
- `pageNumber` (int, default: 1) - Trang hiện tại
- `pageSize` (int, default: 50) - Số tin mỗi trang

### Response - 200 OK
```json
{
  "messages": [
    {
      "id": 25,
      "conversationId": 1,
      "senderId": 100,
      "senderName": "Nguyễn Văn A",
      "senderAvatar": "https://example.com/avatars/100.jpg",
      "content": "Xin chào mọi người!",
      "messageType": "TEXT",
      "referenceId": null,
      "referenceType": null,
      "fileUrl": null,
      "fileName": null,
      "fileSize": null,
      "metadata": null,
      "createdAt": "2026-02-12T15:30:00Z",
      "updatedAt": "2026-02-12T15:30:00Z",
      "isMine": true
    },
    {
      "id": 24,
      "conversationId": 1,
      "senderId": 101,
      "senderName": "Trần Thị B",
      "senderAvatar": "https://example.com/avatars/101.jpg",
      "content": "Chào bạn!",
      "messageType": "TEXT",
      "referenceId": null,
      "referenceType": null,
      "fileUrl": null,
      "fileName": null,
      "fileSize": null,
      "metadata": null,
      "createdAt": "2026-02-12T15:25:00Z",
      "updatedAt": "2026-02-12T15:25:00Z",
      "isMine": false
    },
    {
      "id": 23,
      "conversationId": 1,
      "senderId": 102,
      "senderName": "Lê Văn D",
      "senderAvatar": "https://example.com/avatars/102.jpg",
      "content": "File tài liệu đây",
      "messageType": "FILE",
      "referenceId": null,
      "referenceType": null,
      "fileUrl": "https://example.com/uploads/files/document.pdf",
      "fileName": "TaiLieu.pdf",
      "fileSize": 3145728,
      "metadata": "{\"fileUrl\":\"https://example.com/uploads/files/document.pdf\",\"fileName\":\"TaiLieu.pdf\",\"fileSize\":3145728}",
      "createdAt": "2026-02-12T15:20:00Z",
      "updatedAt": "2026-02-12T15:20:00Z",
      "isMine": false
    }
  ],
  "pageNumber": 1,
  "pageSize": 20,
  "totalPages": 5,
  "hasNextPage": true
}
```

---

## 7. Đánh Dấu Đã Đọc

**Endpoint:** `POST /api/messaging/messages/read`

### Request Body
```json
{
  "conversationId": 1,
  "messageId": 25
}
```

### Response - 204 No Content
(Không có nội dung trả về)

---

## 8. Thêm Thành Viên vào Nhóm

**Endpoint:** `POST /api/messaging/conversations/{conversationId}/members`

**Example:** `POST /api/messaging/conversations/1/members`

### Request Body
```json
[106, 107, 108]
```

### Response - 204 No Content
(Không có nội dung trả về)

---

## 9. Xóa Thành Viên khỏi Nhóm

**Endpoint:** `DELETE /api/messaging/conversations/{conversationId}/members/{memberId}`

**Example:** `DELETE /api/messaging/conversations/1/members/106`

### Response - 204 No Content
(Không có nội dung trả về)

---

## 10. Rời Khỏi Conversation

**Endpoint:** `POST /api/messaging/conversations/{conversationId}/leave`

**Example:** `POST /api/messaging/conversations/1/leave`

### Response - 204 No Content
(Không có nội dung trả về)

---

## 11. Xóa Tin Nhắn

**Endpoint:** `DELETE /api/messaging/messages/{messageId}`

**Example:** `DELETE /api/messaging/messages/25`

### Response - 204 No Content
(Không có nội dung trả về)

---

## 12. Tìm Kiếm Tin Nhắn

**Endpoint:** `GET /api/messaging/conversations/{conversationId}/messages/search`

**Example:** `GET /api/messaging/conversations/1/messages/search?searchTerm=báo cáo`

### Query Parameters
- `searchTerm` (string, required) - Từ khóa tìm kiếm

### Response - 200 OK
```json
[
  {
    "id": 26,
    "conversationId": 1,
    "senderId": 100,
    "senderName": "Nguyễn Văn A",
    "senderAvatar": "https://example.com/avatars/100.jpg",
    "content": "File báo cáo đây",
    "messageType": "FILE",
    "referenceId": null,
    "referenceType": null,
    "fileUrl": "https://example.com/uploads/files/report.pdf",
    "fileName": "BaoCao_ThangNam.pdf",
    "fileSize": 5242880,
    "metadata": "{\"fileUrl\":\"https://example.com/uploads/files/report.pdf\",\"fileName\":\"BaoCao_ThangNam.pdf\",\"fileSize\":5242880}",
    "createdAt": "2026-02-12T15:31:00Z",
    "updatedAt": "2026-02-12T15:31:00Z",
    "isMine": true
  },
  {
    "id": 18,
    "conversationId": 1,
    "senderId": 101,
    "senderName": "Trần Thị B",
    "senderAvatar": "https://example.com/avatars/101.jpg",
    "content": "Báo cáo tuần này như thế nào?",
    "messageType": "TEXT",
    "referenceId": null,
    "referenceType": null,
    "fileUrl": null,
    "fileName": null,
    "fileSize": null,
    "metadata": null,
    "createdAt": "2026-02-12T14:00:00Z",
    "updatedAt": "2026-02-12T14:00:00Z",
    "isMine": false
  }
]
```

---

## Lưu Ý về MessageType

Các giá trị hợp lệ cho `messageType`:
- `TEXT` - Tin nhắn văn bản
- `IMAGE` - Hình ảnh
- `FILE` - File đính kèm
- `VIDEO` - Video
- `AUDIO` - File âm thanh/voice message

## Lưu Ý về ConversationType

Các giá trị hợp lệ cho `type`:
- `DIRECT` - Chat 1-1 giữa 2 người
- `GROUP` - Nhóm chat nhiều người

## Lưu Ý về Member Role

Các giá trị hợp lệ cho `role`:
- `ADMIN` - Quản trị viên nhóm
- `MEMBER` - Thành viên thường

---

## Error Cases & Edge Cases

### 1. Tạo Conversation - Error Cases

#### Request thiếu memberIds
**Request:**
```json
{
  "type": "GROUP",
  "name": "Nhóm mới"
}
```

**Response - 400 Bad Request:**
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "MemberIds": [
      "At least one member is required"
    ]
  }
}
```

#### Request thiếu type
**Request:**
```json
{
  "name": "Nhóm mới",
  "memberIds": [101, 102]
}
```

**Response - 400 Bad Request:**
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "Type": [
      "Conversation type is required"
    ]
  }
}
```

#### Tạo GROUP nhưng không có tên
**Request:**
```json
{
  "type": "GROUP",
  "memberIds": [101, 102]
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Group name is required for GROUP conversation"
}
```

#### MemberIds chứa user không tồn tại
**Request:**
```json
{
  "type": "GROUP",
  "name": "Nhóm test",
  "memberIds": [101, 999999]
}
```

**Response - 404 Not Found:**
```json
{
  "message": "User with ID 999999 not found"
}
```

---

### 2. Lấy/Tạo Direct Conversation - Error Cases

#### otherUserId không tồn tại
**Request:** `POST /api/messaging/conversations/direct/999999`

**Response - 404 Not Found:**
```json
{
  "message": "User not found"
}
```

#### Tạo conversation với chính mình
**Request:** `POST /api/messaging/conversations/direct/100` (user 100 đang đăng nhập)

**Response - 400 Bad Request:**
```json
{
  "message": "Cannot create conversation with yourself"
}
```

---

### 3. Lấy Conversation theo ID - Error Cases

#### Conversation không tồn tại
**Request:** `GET /api/messaging/conversations/999999`

**Response - 404 Not Found:**
```json
{
  "message": "Conversation not found"
}
```

#### User không phải member của conversation
**Request:** `GET /api/messaging/conversations/5`

**Response - 403 Forbidden:**
```json
{
  "message": "You are not a member of this conversation"
}
```

#### Conversation đã bị xóa (soft delete)
**Request:** `GET /api/messaging/conversations/3`

**Response - 404 Not Found:**
```json
{
  "message": "Conversation has been deleted"
}
```

---

### 4. Gửi Tin Nhắn - Error Cases

#### Thiếu conversationId
**Request:**
```json
{
  "content": "Hello",
  "messageType": "TEXT"
}
```

**Response - 400 Bad Request:**
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "ConversationId": [
      "Conversation ID is required"
    ]
  }
}
```

#### Gửi TEXT message nhưng không có content
**Request:**
```json
{
  "conversationId": 1,
  "messageType": "TEXT"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Message content is required for text messages"
}
```

#### Gửi IMAGE nhưng không có fileUrl
**Request:**
```json
{
  "conversationId": 1,
  "content": "Xem ảnh này",
  "messageType": "IMAGE"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "File URL is required for IMAGE messages"
}
```

#### Gửi FILE nhưng không có fileUrl
**Request:**
```json
{
  "conversationId": 1,
  "messageType": "FILE",
  "fileName": "document.pdf"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "File URL is required for FILE messages"
}
```

#### User không phải member của conversation
**Request:**
```json
{
  "conversationId": 5,
  "content": "Hello",
  "messageType": "TEXT"
}
```

**Response - 403 Forbidden:**
```json
{
  "message": "You are not a member of this conversation"
}
```

#### Conversation không tồn tại
**Request:**
```json
{
  "conversationId": 999999,
  "content": "Hello",
  "messageType": "TEXT"
}
```

**Response - 404 Not Found:**
```json
{
  "message": "Conversation not found"
}
```

#### MessageType không hợp lệ
**Request:**
```json
{
  "conversationId": 1,
  "content": "Test",
  "messageType": "INVALID_TYPE"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Invalid message type. Supported types: TEXT, IMAGE, FILE, VIDEO, AUDIO"
}
```

#### Content quá dài (>10000 ký tự)
**Request:**
```json
{
  "conversationId": 1,
  "content": "Lorem ipsum...(10001 characters)...",
  "messageType": "TEXT"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Message content exceeds maximum length of 10000 characters"
}
```

#### ReferenceId tồn tại nhưng ReferenceType không hợp lệ
**Request:**
```json
{
  "conversationId": 1,
  "content": "Check this",
  "messageType": "TEXT",
  "referenceId": 123,
  "referenceType": "INVALID_REFERENCE"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Invalid reference type"
}
```

---

### 5. Lấy Tin Nhắn (Phân Trang) - Error Cases

#### Conversation không tồn tại
**Request:** `GET /api/messaging/conversations/999999/messages`

**Response - 404 Not Found:**
```json
{
  "message": "Conversation not found"
}
```

#### User không phải member
**Request:** `GET /api/messaging/conversations/5/messages`

**Response - 403 Forbidden:**
```json
{
  "message": "You are not a member of this conversation"
}
```

#### PageNumber hoặc PageSize không hợp lệ
**Request:** `GET /api/messaging/conversations/1/messages?pageNumber=0&pageSize=-5`

**Response - 400 Bad Request:**
```json
{
  "message": "Page number must be greater than 0 and page size must be between 1 and 100"
}
```

#### PageSize quá lớn (>100)
**Request:** `GET /api/messaging/conversations/1/messages?pageSize=500`

**Response - 400 Bad Request:**
```json
{
  "message": "Page size must not exceed 100"
}
```

---

### 6. Đánh Dấu Đã Đọc - Error Cases

#### Thiếu conversationId hoặc messageId
**Request:**
```json
{
  "conversationId": 1
}
```

**Response - 400 Bad Request:**
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "MessageId": [
      "Message ID is required"
    ]
  }
}
```

#### Message không thuộc conversation
**Request:**
```json
{
  "conversationId": 1,
  "messageId": 999
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Message does not belong to this conversation"
}
```

#### User không phải member của conversation
**Request:**
```json
{
  "conversationId": 5,
  "messageId": 25
}
```

**Response - 403 Forbidden:**
```json
{
  "message": "You are not a member of this conversation"
}
```

#### Message không tồn tại
**Request:**
```json
{
  "conversationId": 1,
  "messageId": 999999
}
```

**Response - 404 Not Found:**
```json
{
  "message": "Message not found"
}
```

---

### 7. Thêm Thành Viên vào Nhóm - Error Cases

#### Request body rỗng
**Request:** `POST /api/messaging/conversations/1/members`
```json
[]
```

**Response - 400 Bad Request:**
```json
{
  "message": "At least one member is required"
}
```

#### Conversation là DIRECT (không phải GROUP)
**Request:** `POST /api/messaging/conversations/2/members`
```json
[106, 107]
```

**Response - 400 Bad Request:**
```json
{
  "message": "Cannot add members to direct conversation"
}
```

#### User không phải ADMIN của group
**Request:** `POST /api/messaging/conversations/1/members`
```json
[106]
```

**Response - 403 Forbidden:**
```json
{
  "message": "Only group admin can add members"
}
```

#### Thêm user đã là member
**Request:** `POST /api/messaging/conversations/1/members`
```json
[101]
```

**Response - 400 Bad Request:**
```json
{
  "message": "User 101 is already a member of this conversation"
}
```

#### Thêm user không tồn tại
**Request:** `POST /api/messaging/conversations/1/members`
```json
[999999]
```

**Response - 404 Not Found:**
```json
{
  "message": "User with ID 999999 not found"
}
```

#### Conversation không tồn tại
**Request:** `POST /api/messaging/conversations/999999/members`
```json
[106]
```

**Response - 404 Not Found:**
```json
{
  "message": "Conversation not found"
}
```

---

### 8. Xóa Thành Viên khỏi Nhóm - Error Cases

#### Conversation là DIRECT
**Request:** `DELETE /api/messaging/conversations/2/members/105`

**Response - 400 Bad Request:**
```json
{
  "message": "Cannot remove members from direct conversation"
}
```

#### User không phải ADMIN
**Request:** `DELETE /api/messaging/conversations/1/members/101`

**Response - 403 Forbidden:**
```json
{
  "message": "Only group admin can remove members"
}
```

#### Xóa chính mình (ADMIN tự xóa mình)
**Request:** `DELETE /api/messaging/conversations/1/members/100`

**Response - 400 Bad Request:**
```json
{
  "message": "Use leave endpoint to remove yourself from the conversation"
}
```

#### Member không tồn tại trong conversation
**Request:** `DELETE /api/messaging/conversations/1/members/200`

**Response - 404 Not Found:**
```json
{
  "message": "User is not a member of this conversation"
}
```

#### Xóa ADMIN cuối cùng
**Request:** `DELETE /api/messaging/conversations/1/members/100`

**Response - 400 Bad Request:**
```json
{
  "message": "Cannot remove the last admin. Assign another admin first"
}
```

---

### 9. Rời Khỏi Conversation - Error Cases

#### User không phải member
**Request:** `POST /api/messaging/conversations/5/leave`

**Response - 403 Forbidden:**
```json
{
  "message": "You are not a member of this conversation"
}
```

#### Conversation không tồn tại
**Request:** `POST /api/messaging/conversations/999999/leave`

**Response - 404 Not Found:**
```json
{
  "message": "Conversation not found"
}
```

#### Rời DIRECT conversation
**Request:** `POST /api/messaging/conversations/2/leave`

**Response - 400 Bad Request:**
```json
{
  "message": "Cannot leave direct conversation. Delete it instead"
}
```

#### ADMIN cuối cùng rời nhóm
**Request:** `POST /api/messaging/conversations/1/leave`

**Response - 400 Bad Request:**
```json
{
  "message": "You are the last admin. Assign another admin before leaving or delete the group"
}
```

---

### 10. Xóa Tin Nhắn - Error Cases

#### Message không tồn tại
**Request:** `DELETE /api/messaging/messages/999999`

**Response - 404 Not Found:**
```json
{
  "message": "Message not found"
}
```

#### Xóa tin nhắn của người khác (không phải sender)
**Request:** `DELETE /api/messaging/messages/24`

**Response - 403 Forbidden:**
```json
{
  "message": "You can only delete your own messages"
}
```

#### Message đã bị xóa trước đó
**Request:** `DELETE /api/messaging/messages/20`

**Response - 400 Bad Request:**
```json
{
  "message": "Message has already been deleted"
}
```

#### User không phải member của conversation chứa message
**Request:** `DELETE /api/messaging/messages/25`

**Response - 403 Forbidden:**
```json
{
  "message": "You are not a member of this conversation"
}
```

---

### 11. Tìm Kiếm Tin Nhắn - Error Cases

#### searchTerm rỗng hoặc null
**Request:** `GET /api/messaging/conversations/1/messages/search?searchTerm=`

**Response - 400 Bad Request:**
```json
{
  "message": "Search term is required"
}
```

#### searchTerm quá ngắn (<2 ký tự)
**Request:** `GET /api/messaging/conversations/1/messages/search?searchTerm=a`

**Response - 400 Bad Request:**
```json
{
  "message": "Search term must be at least 2 characters"
}
```

#### Conversation không tồn tại
**Request:** `GET /api/messaging/conversations/999999/messages/search?searchTerm=test`

**Response - 404 Not Found:**
```json
{
  "message": "Conversation not found"
}
```

#### User không phải member
**Request:** `GET /api/messaging/conversations/5/messages/search?searchTerm=test`

**Response - 403 Forbidden:**
```json
{
  "message": "You are not a member of this conversation"
}
```

---

## Authentication & Authorization Errors

### 401 Unauthorized - Token không hợp lệ hoặc hết hạn
**Headers:**
```
Authorization: Bearer invalid_or_expired_token
```

**Response - 401 Unauthorized:**
```json
{
  "message": "Unauthorized",
  "detail": "Token is invalid or expired"
}
```

### 401 Unauthorized - Thiếu token
**Headers:**
```
(Không có Authorization header)
```

**Response - 401 Unauthorized:**
```json
{
  "message": "Unauthorized",
  "detail": "Authorization header is missing"
}
```

---

## Edge Cases & Special Scenarios

### 1. Gửi tin nhắn liên tục quá nhanh (Rate Limiting)
**Scenario:** User gửi >10 tin nhắn trong 1 giây

**Response - 429 Too Many Requests:**
```json
{
  "message": "Rate limit exceeded. Please slow down",
  "retryAfter": 5
}
```

### 2. Conversation có quá nhiều members (>100 người)
**Request:** `POST /api/messaging/conversations/1/members`
```json
[106, 107, 108, ...]
```

**Response - 400 Bad Request:**
```json
{
  "message": "Group cannot have more than 100 members"
}
```

### 3. File size quá lớn (>50MB)
**Request:**
```json
{
  "conversationId": 1,
  "messageType": "FILE",
  "fileUrl": "https://example.com/large-file.zip",
  "fileName": "large-file.zip",
  "fileSize": 104857600
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "File size exceeds maximum allowed size of 50MB"
}
```

### 4. Conversation đã đầy tin nhắn (Archive scenario)
**Request:** Gửi tin nhắn vào conversation có >1,000,000 messages

**Response - 400 Bad Request:**
```json
{
  "message": "Conversation has reached maximum message limit. Please create a new conversation"
}
```

### 5. User bị banned/blocked
**Request:** Bất kỳ action nào

**Response - 403 Forbidden:**
```json
{
  "message": "Your account has been suspended"
}
```

### 6. Concurrent modification conflict
**Scenario:** 2 users cùng lúc cố gắng remove cùng 1 member

**Response - 409 Conflict:**
```json
{
  "message": "The resource has been modified by another request. Please try again"
}
```

### 7. Database connection timeout
**Response - 503 Service Unavailable:**
```json
{
  "message": "Service temporarily unavailable. Please try again later",
  "retryAfter": 30
}
```

### 8. Invalid UTF-8 characters trong content
**Request:**
```json
{
  "conversationId": 1,
  "content": "\uD800\uD800 invalid unicode",
  "messageType": "TEXT"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Invalid characters in message content"
}
```

### 9. Metadata JSON không hợp lệ
**Request:**
```json
{
  "conversationId": 1,
  "content": "Test",
  "messageType": "TEXT",
  "metadata": "not a valid json string {"
}
```

**Response - 400 Bad Request:**
```json
{
  "message": "Invalid JSON format in metadata field"
}
```

### 10. Reference không tồn tại
**Request:**
```json
{
  "conversationId": 1,
  "content": "Check this location",
  "messageType": "TEXT",
  "referenceId": 999999,
  "referenceType": "VENUE_LOCATION"
}
```

**Response - 404 Not Found:**
```json
{
  "message": "Referenced resource not found"
}
```

---

## HTTP Status Codes - Tổng Hợp

| Status Code | Ý nghĩa | Khi nào xảy ra |
|------------|---------|----------------|
| **200 OK** | Thành công | GET requests thành công |
| **201 Created** | Tạo mới thành công | POST tạo conversation/message thành công |
| **204 No Content** | Thành công không trả data | DELETE, PUT thành công |
| **400 Bad Request** | Request không hợp lệ | Validation errors, missing required fields, invalid data format |
| **401 Unauthorized** | Chưa xác thực | Token không hợp lệ, hết hạn, hoặc thiếu |
| **403 Forbidden** | Không có quyền | User không phải member, không phải admin khi cần |
| **404 Not Found** | Không tìm thấy | Conversation, message, user không tồn tại |
| **409 Conflict** | Xung đột dữ liệu | Concurrent modification, duplicate resource |
| **429 Too Many Requests** | Quá nhiều requests | Rate limiting triggered |
| **500 Internal Server Error** | Lỗi server | Unexpected server error |
| **503 Service Unavailable** | Service không khả dụng | Database down, service maintenance |

---

## Best Practices & Tips

### 1. Pagination
- Luôn sử dụng pagination khi lấy messages
- Default pageSize = 50, max = 100
- Kiểm tra `hasNextPage` để load thêm

### 2. Real-time Updates
- Sử dụng SignalR Hub (`/hubs/messaging`) để nhận tin nhắn real-time
- Subscribe vào conversation khi mở chat
- Unsubscribe khi đóng chat để tiết kiệm tài nguyên

### 3. File Upload
- Upload file trước qua `/api/fileupload` endpoint
- Nhận được `fileUrl` mới gửi message với type IMAGE/FILE/VIDEO/AUDIO
- Validate file size < 50MB trước khi upload

### 4. Message Type Selection
- **TEXT**: Tin nhắn văn bản thông thường
- **IMAGE**: Ảnh, gif, sticker
- **FILE**: Documents, PDFs, archives
- **VIDEO**: Video files
- **AUDIO**: Voice messages, audio files

### 5. Error Handling
- Luôn check status code trước khi parse response
- Hiển thị message thân thiện với user
- Retry logic cho 503, 429 errors
- Re-authenticate cho 401 errors

### 6. Offline Handling
- Cache messages locally
- Queue outgoing messages khi offline
- Sync khi online trở lại
- Hiển thị pending/sent/failed status

### 7. Performance Tips
- Load conversations list với lastMessage summary
- Lazy load full message history khi open chat
- Implement infinite scroll cho messages
- Cache member info để tránh load lại

### 8. Security
- Luôn gửi token trong Authorization header
- Không hardcode token trong code
- Refresh token khi gần hết hạn
- Validate user permissions trước mỗi action

### 9. UX Recommendations
- Hiển thị typing indicator khi người khác đang gõ
- Show online/offline status cho members
- Mark messages as read tự động khi scroll qua
- Hiển thị unread count rõ ràng

### 10. Rate Limiting
- Tối đa 10 messages/giây/user
- Tối đa 100 requests/phút/user cho API calls
- Implement backoff strategy khi hit rate limit
- Show warning khi gần đạt limit

---

## Testing Checklist

### Unit Tests
- ✅ Validate request models với valid/invalid data
- ✅ Test response deserialization
- ✅ Mock API calls
- ✅ Test error handling cho mọi status code

### Integration Tests
- ✅ Test full flow: tạo conversation → gửi message → đọc message
- ✅ Test permissions: admin actions, member restrictions
- ✅ Test edge cases: empty lists, null values, max limits
- ✅ Test concurrent operations: multiple users cùng action

### E2E Tests
- ✅ User journey: login → list conversations → open chat → send/receive
- ✅ Real-time: SignalR message delivery
- ✅ File upload → send as message → download
- ✅ Search functionality across conversations

### Load Tests
- ✅ 1000 concurrent users
- ✅ 10,000 messages/second throughput
- ✅ 100MB+ conversation history pagination
- ✅ Rate limiting behavior under stress

---

## Common Integration Patterns

### 1. Load Conversation List
```javascript
// Step 1: Fetch conversations
GET /api/messaging/conversations

// Step 2: Subscribe to real-time updates
SignalR.connect("/hubs/messaging")

// Step 3: Handle new messages
on("ReceiveMessage", (message) => {
  // Update conversation list
  // Update unread count
})
```

### 2. Open Conversation & Load Messages
```javascript
// Step 1: Get conversation details
GET /api/messaging/conversations/{id}

// Step 2: Load recent messages (page 1)
GET /api/messaging/conversations/{id}/messages?pageNumber=1&pageSize=50

// Step 3: Join conversation room (SignalR)
SignalR.invoke("JoinConversation", conversationId)

// Step 4: Mark as read
POST /api/messaging/messages/read
{
  "conversationId": 1,
  "messageId": 25 // Last message ID
}
```

### 3. Send Message with File
```javascript
// Step 1: Upload file
POST /api/fileupload
FormData: { file: selectedFile }
→ Response: { url: "https://..." }

// Step 2: Send message with file info
POST /api/messaging/messages
{
  "conversationId": 1,
  "content": "Check this file",
  "messageType": "FILE",
  "fileUrl": "https://...",
  "fileName": "document.pdf",
  "fileSize": 2048576
}
```

### 4. Infinite Scroll Messages
```javascript
let currentPage = 1;

function loadMore() {
  GET /api/messaging/conversations/1/messages
    ?pageNumber=${currentPage}
    &pageSize=50
  
  if (response.hasNextPage) {
    currentPage++;
    // Append messages to list
  } else {
    // No more messages
  }
}

// Trigger on scroll to top
onScrollTop(() => loadMore());
```

### 5. Search Messages
```javascript
// Debounced search
let searchTimeout;
function searchMessages(term) {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(() => {
    GET /api/messaging/conversations/1/messages/search
      ?searchTerm=${encodeURIComponent(term)}
  }, 300); // Wait 300ms after user stops typing
}
```

---

## Frequently Asked Questions (FAQ)

### Q1: Làm sao để biết có tin nhắn mới?
**A:** Sử dụng SignalR Hub để nhận real-time notifications. Subscribe vào event `ReceiveMessage`.

### Q2: Có giới hạn về số lượng members trong group không?
**A:** Có, tối đa 100 members/group.

### Q3: File size tối đa là bao nhiêu?
**A:** 50MB cho mỗi file.

### Q4: Message có thể chỉnh sửa được không?
**A:** Hiện tại chưa support edit, chỉ có thể delete (soft delete).

### Q5: Làm sao để phân biệt tin nhắn của mình và người khác?
**A:** Check field `isMine` trong `MessageResponse`.

### Q6: Có thể recover tin nhắn đã xóa không?
**A:** Soft delete nên administrator có thể recover, nhưng user thường không thể.

### Q7: Typing indicator hoạt động như thế nào?
**A:** Gửi qua SignalR Hub, không qua REST API. Sử dụng `TypingIndicatorRequest`.

### Q8: Làm sao để biết ai đang online?
**A:** Check field `isOnline` trong `ConversationMemberResponse`. Update qua SignalR.

### Q9: Có thể forward message không?
**A:** Tạo message mới với cùng content, hoặc sử dụng `referenceId` + `referenceType`.

### Q10: Pagination được sort theo thứ tự nào?
**A:** Messages được sort theo `createdAt` DESC (mới nhất → cũ nhất).
