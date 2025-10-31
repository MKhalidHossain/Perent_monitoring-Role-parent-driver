import 'package:flutter/foundation.dart';
import 'package:bbpool/models/message_model.dart';

class MessageController extends ChangeNotifier {
  List<MessageModel> _messages = [];
  List<ChatMessageModel> _chatMessages = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<MessageModel> get messages => _messages;
  List<ChatMessageModel> get chatMessages => _chatMessages;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<MessageModel> get filteredMessages {
    if (_searchQuery.isEmpty) {
      return _messages;
    }
    return _messages.where((message) =>
        message.senderName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        message.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Initialize with sample data
  void initializeMessages() {
    _messages = [
      MessageModel(
        id: '1',
        senderId: 'driver_sam',
        senderName: 'Driver Sam',
        senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=50&h=50&fit=crop&crop=face',
        lastMessage: 'Stand up for what you believe in',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 9,
        isOnline: true,
      ),
      MessageModel(
        id: '2',
        senderId: 'nathan_scott',
        senderName: 'Nathan Scott',
        senderAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=50&h=50&fit=crop&crop=face',
        lastMessage: 'One day you\'re seventeen and planning for someday. And then quietly and without...',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        isOnline: false,
      ),
      MessageModel(
        id: '3',
        senderId: 'brooke_davis',
        senderName: 'Brooke Davis',
        senderAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=50&h=50&fit=crop&crop=face',
        lastMessage: 'I am who I am. No excuses.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        unreadCount: 9,
        isOnline: true,
      ),
      MessageModel(
        id: '4',
        senderId: 'jamie_scott',
        senderName: 'Jamie Scott',
        senderAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=50&h=50&fit=crop&crop=face',
        lastMessage: 'Some people are a little different. I think that\'s cool.',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        unreadCount: 0,
        isOnline: false,
      ),
      MessageModel(
        id: '5',
        senderId: 'antwon_taylor',
        senderName: 'Antwon Taylor',
        senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=50&h=50&fit=crop&crop=face',
        lastMessage: 'Last night in the NBA the Charlotte Bobcats quietly made a move that most sports fans...',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: false,
      ),
    ];
    notifyListeners();
  }

  // Get chat messages for a specific conversation
  void loadChatMessages(String userId) {
    setLoading(true);
    
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _chatMessages = [
        ChatMessageModel(
          id: '1',
          senderId: userId,
          receiverId: 'current_user',
          message: 'Hello! How are you doing today?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '2',
          senderId: 'current_user',
          receiverId: userId,
          message: 'Hi! I\'m doing great, thanks for asking. How about you?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '3',
          senderId: userId,
          receiverId: 'current_user',
          message: 'I\'m good too! Are you available for the ride tomorrow?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '4',
          senderId: 'current_user',
          receiverId: userId,
          message: 'Yes, I\'ll be ready at 8 AM as planned.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isRead: false,
        ),
      ];
      setLoading(false);
    });
  }

  // Send a new message
  void sendMessage(String receiverId, String message) {
    final newMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _chatMessages.add(newMessage);
    
    // Update the last message in the message list
    final messageIndex = _messages.indexWhere((m) => m.senderId == receiverId);
    if (messageIndex != -1) {
      _messages[messageIndex] = MessageModel(
        id: _messages[messageIndex].id,
        senderId: _messages[messageIndex].senderId,
        senderName: _messages[messageIndex].senderName,
        senderAvatar: _messages[messageIndex].senderAvatar,
        lastMessage: message,
        timestamp: DateTime.now(),
        unreadCount: _messages[messageIndex].unreadCount,
        isOnline: _messages[messageIndex].isOnline,
      );
    }

    notifyListeners();
  }

  // Mark message as read
  void markAsRead(String messageId) {
    final messageIndex = _messages.indexWhere((m) => m.id == messageId);
    if (messageIndex != -1) {
      _messages[messageIndex] = MessageModel(
        id: _messages[messageIndex].id,
        senderId: _messages[messageIndex].senderId,
        senderName: _messages[messageIndex].senderName,
        senderAvatar: _messages[messageIndex].senderAvatar,
        lastMessage: _messages[messageIndex].lastMessage,
        timestamp: _messages[messageIndex].timestamp,
        unreadCount: 0,
        isOnline: _messages[messageIndex].isOnline,
      );
      notifyListeners();
    }
  }
}
