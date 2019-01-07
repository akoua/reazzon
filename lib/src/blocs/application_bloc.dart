import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  User reazzonUser;

  PublishSubject<List<String>> _reazzonsController = PublishSubject<List<String>>();
  BehaviorSubject<FirebaseUser> _currentUserController = BehaviorSubject<FirebaseUser>();
  Sink<FirebaseUser> get inCurrentUser => _currentUserController.sink;
  Stream<FirebaseUser> get outCurrentUser => _currentUserController.stream;
  Stream<List<String>> get outReazzons => _reazzonsController.stream;

  ApplicationBloc(){
    var _availableReazzons = new List<String>();
    _availableReazzons.addAll([
        '#Divorce', '#Perfectionist', '#Breakups', '#Loneliness', '#Grief', 
        '#WorkStress', '#FinancialStress', '#KidsCustody', '#Bullying', '#Insomnia'
        '#ManagingEmotions', '#MoodSwings', '#Anxiety', '#Breakups', '#Cheating',
        '#SelfEsteem', '#BodyImage', '#ExerciseMotivation', '#PreasureToSucceed'
      ]);
    _currentUserController.listen(_setCurrentUser);
  }

  void _setCurrentUser(FirebaseUser authenticatedUser)
  {
    if(authenticatedUser == null)
      throw new ArgumentError.notNull(authenticatedUser.runtimeType.toString());

    reazzonUser = new User(authenticatedUser);
  }

  @override
  void dispose() {
    _currentUserController.close();
    _reazzonsController.close();
  }
}