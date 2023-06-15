import 'package:get/get.dart';
import 'package:veterna_poultry_admin/pages/add_product.dart';
import 'package:veterna_poultry_admin/pages/chat/chat_room.dart';
import 'package:veterna_poultry_admin/pages/chat/home_chat_room.dart';
import 'package:veterna_poultry_admin/pages/detail_order.dart';
import 'package:veterna_poultry_admin/pages/product_page.dart';
import 'package:veterna_poultry_admin/pages/tab/tab_view.dart';
import 'package:veterna_poultry_admin/utils/pages.dart';
import 'package:veterna_poultry_admin/utils/widget_tree.dart';

import '../pages/login_page.dart';

class AppRoutes {
  static const INITIAL = AppPages.LOGIN;
  static final pages = [
    GetPage(name: PagePath.LOGIN, page: () => const LoginPage()),
    GetPage(name: PagePath.WIDGET_TREE, page: () => const WidgetTree()),
    GetPage(name: PagePath.CHAT_ROOM, page: () => const ChatRoom()),
    GetPage(name: PagePath.HOME_CHAT_ROOM, page: () => const HomeChatRoom()),
    GetPage(name: PagePath.PRODUCT, page: () => const ProductPage()),
    GetPage(name: PagePath.ADD_PRODUCT, page: () => const AddProductPage()),
    GetPage(name: PagePath.ORDER, page: () => const TabViewPage()),
    GetPage(name: PagePath.DETAIL_ORDER, page: () => const DetailOrder()),
  ];
}
