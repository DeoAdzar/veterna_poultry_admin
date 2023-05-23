class AppPages {
  static const HOME = PagePath.HOME;
  static const LOGIN = PagePath.LOGIN;
  static const FORGOT_PASSWORD = PagePath.FORGOT_PASSWORD;
  static const CHAT_ROOM = PagePath.CHAT_ROOM;
  static const HOME_CHAT_ROOM = PagePath.HOME_CHAT_ROOM;
}

abstract class PagePath {
  static const HOME = '/';
  static const LOGIN = '/login';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const WIDGET_TREE = '/widget-tree';
  static const HOME_CHAT_ROOM = '/home-chat-room';
  static const CHAT_ROOM = '/chat-room';
}
