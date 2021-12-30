import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/model/conversation/message.dart';
import 'package:imagecaptioning/src/repositories/data_repository.dart';

abstract class UserBehavior {
  Future<GetConversationResponseMessage?> getConversations();

  Future<GetConversationResponseMessage?> getMoreConversations(
      {required String dateBoundary});
  Future<GetMessageResponseMessage?> getMessages(
      {required String conversationId});

  Future<GetMessageResponseMessage?> getMoreMessages(
      {required String conversationId, required String dateBoundary});
}

class ConversationRepository extends UserBehavior {
  final DataRepository _dataRepository = DataRepository();
  @override
  Future<GetConversationResponseMessage?> getConversations() async {
    try {
      GetConversationResponseMessage resMessage =
          await _dataRepository.getConversations();
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetConversationResponseMessage resMessage =
              GetConversationResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetConversationResponseMessage?> getMoreConversations(
      {required String dateBoundary}) async {
    try {
      GetConversationResponseMessage resMessage =
          await _dataRepository.getMoreConversations(dateBoundary);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetConversationResponseMessage resMessage =
              GetConversationResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetMessageResponseMessage?> getMessages(
      {required String conversationId}) async {
    try {
      GetMessageResponseMessage resMessage =
          await _dataRepository.getMessages(conversationId);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetMessageResponseMessage resMessage =
              GetMessageResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetMessageResponseMessage?> getMoreMessages(
      {required String conversationId, required String dateBoundary}) async {
    try {
      GetMessageResponseMessage resMessage =
          await _dataRepository.getMoreMessages(conversationId, dateBoundary);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetMessageResponseMessage resMessage =
              GetMessageResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }
}
