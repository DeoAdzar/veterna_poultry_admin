class AppPages {
  static const HOME = PagePath.HOME;
  static const LOGIN = PagePath.LOGIN;
  static const CHAT_ROOM = PagePath.CHAT_ROOM;
  static const HOME_CHAT_ROOM = PagePath.HOME_CHAT_ROOM;
  static const PRODUCT = PagePath.PRODUCT;
  static const ADD_PRODUCT = PagePath.ADD_PRODUCT;
  static const ORDER = PagePath.ORDER;
  static const DETAIL_ORDER = PagePath.DETAIL_ORDER;
}

abstract class PagePath {
  static const HOME = '/';
  static const LOGIN = '/login';
  static const WIDGET_TREE = '/widget-tree';
  static const HOME_CHAT_ROOM = '/home-chat-room';
  static const CHAT_ROOM = '/chat-room';
  static const PRODUCT = '/product';
  static const ADD_PRODUCT = '/add-product';
  static const ORDER = '/order';
  static const DETAIL_ORDER = '/detail-order';
}
