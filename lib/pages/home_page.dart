import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterna_poultry_admin/utils/dimen.dart';
import 'package:veterna_poultry_admin/utils/pages.dart';
import 'package:veterna_poultry_admin/widget/button_grey_radius_25.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonGreyRadius25(text: "Produk", onTap: () {}),
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
              ButtonGreyRadius25(text: "Riwayat Pemesanan", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
