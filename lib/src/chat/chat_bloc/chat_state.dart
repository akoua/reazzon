
import 'package:equatable/equatable.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_entity.dart';

abstract class ChatsState extends Equatable {}

class ChatsNotLoaded extends ChatsState {
  @override
  String toString() {
    return '{ ChatState: Not Loaded }';
  }
}

class ChatsLoaded extends ChatsState {
  final List<ChatEntity> chatEntities;

  ChatsLoaded(this.chatEntities);

  @override
  String toString() {
    return '{ ChatState: Loaded, chat_entities: $chatEntities}';
  }
}
