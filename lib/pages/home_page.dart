import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterna_poultry_admin/utils/dimen.dart';
import 'package:veterna_poultry_admin/utils/pages.dart';
import 'package:veterna_poultry_admin/widget/button_grey_radius_25.dart';

import '../db/auth.dart';
import '../db/notification_methods.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  Future<void> signOut(BuildContext context) async {
    await NotificationsMethod.setFirebaseMessagingToken("");
    await Auth().signOut(context: context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () {
        signOut(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Konfirmasi"),
      content: const Text("Yakin anda ingin logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonGreyRadius25(
                  text: "Produk",
                  onTap: () {
                    Get.toNamed(AppPages.PRODUCT);
                  }),
              SizedBox(
                height: Dimen(context).height * 0.03,
              ),
              ButtonGreyRadius25(
                  text: "Konsultasi",
                  onTap: () {
                    Get.toNamed(AppPages.HOME_CHAT_ROOM);
                  }),
              SizedBox(
                height: Dimen(context).height * 0.03,
              ),
              ButtonGreyRadius25(
                  text: "Riwayat Pemesanan",
                  onTap: () {
                    Get.toNamed(AppPages.ORDER);
                  }),
              SizedBox(
                height: Dimen(context).height * 0.03,
              ),
              ButtonGreyRadius25(
                  text: "Logout",
                  onTap: () {
                    showAlertDialog(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
