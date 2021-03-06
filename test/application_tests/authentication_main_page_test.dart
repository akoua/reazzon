import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reazzon/main.dart';
import 'package:reazzon/src/authentication/authentication.dart';
import 'package:reazzon/src/blocs/account_page_bloc.dart';
import 'package:reazzon/src/chat/chat_bloc/chat_bloc.dart';
import 'package:reazzon/src/login/login_bloc.dart';
import 'package:reazzon/src/notifications/notification_bloc.dart';
import 'package:reazzon/src/pages/account_page.dart';
import 'package:reazzon/src/pages/home_page.dart';
import 'package:reazzon/src/settings/setting_bloc.dart';

import '../account_tests/account_mock.dart';
import '../authentication_tests/authentication_mock.dart';
import '../chat_tests/chat_mock.dart';
import '../notification_tests/notification_mock.dart';
import '../settings_tests/settings_mock.dart';

void main() async {
  AuthenticationRepositoryMock _authenticationRepositoryMock;
  NotificationRepositoryMock _notificationRepositoryMock;
  ChatRepositoryMock _chatRepositoryMock;
  SettingsRepositoryMock _settingsRepositoryMock;
  AuthenticationBlocMock _authenticationBlocMock;
  LoginBlocMock _loginBlocMock;
  NotificationBlocMock _notificationBlocMock;
  ChatBlocMock _chatBlocMock;
  AccountPageBloc _accountPageBlocMock;
  SettingsBlocMock _settingsBlocMock;

  Widget makeTestableWidget() {
    //TODO: Make the testable widget register the same providers as the live app
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => _authenticationBlocMock,
        ),
        BlocProvider<LoginBloc>(
          create: (context) => _loginBlocMock
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => _notificationBlocMock,
        ),
        BlocProvider<ChatBloc>(
          create: (context) => _chatBlocMock,
        ),
        BlocProvider<AccountPageBloc>(
          create: (context) => _accountPageBlocMock,
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => _settingsBlocMock,
        )
      ],
      child: ReazzonMainWidget()
    );
  }

  setUp((){
    _authenticationRepositoryMock = AuthenticationRepositoryMock();
    _notificationRepositoryMock = NotificationRepositoryMock();
    _chatRepositoryMock = ChatRepositoryMock();
    _settingsRepositoryMock = SettingsRepositoryMock();

    _authenticationBlocMock = AuthenticationBlocMock(authenticationRepository: _authenticationRepositoryMock);
    _loginBlocMock = LoginBlocMock(authenticationRepository: _authenticationRepositoryMock);
    _notificationBlocMock = NotificationBlocMock(notificationRepository: _notificationRepositoryMock);
    _chatBlocMock = ChatBlocMock(chatRepository: _chatRepositoryMock);
    _accountPageBlocMock = AccountPageBlocMock();
    _settingsBlocMock = SettingsBlocMock(settingsRepository: _settingsRepositoryMock);
  });

  testWidgets('Returns HomePage when Unauthenticated', (WidgetTester tester) async {
    //Arrange
    when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(false));
    whenListen(_authenticationBlocMock, Stream<AuthenticationState>.empty());
    when(_authenticationBlocMock.state)
      .thenReturn(Unauthenticated());

    //Act
    await tester.pumpWidget(makeTestableWidget());

    //Assert
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Return AccountPage when Authenticated', (WidgetTester tester) async {
    //Arrange
    when(_authenticationRepositoryMock.isSignedIn())
        .thenAnswer((_) => Future.value(true));
    whenListen(_authenticationBlocMock, Stream<AuthenticationState>.empty());
    when(_authenticationBlocMock.state)
        .thenReturn((Authenticated()));

    //Act
    await tester.pumpWidget(makeTestableWidget());

    //Assert
    expect(find.byType(AccountPage), findsOneWidget);
  });
}