import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:veterna_poultry_admin/db/database_methods.dart';
import 'package:veterna_poultry_admin/utils/my_colors.dart';
import 'package:veterna_poultry_admin/utils/show_image.dart';
import 'package:veterna_poultry_admin/widget/show_snackbar.dart';

import '../db/notification_methods.dart';
import '../utils/currency_format.dart';
import '../utils/dimen.dart';

class DetailOrder extends StatefulWidget {
  const DetailOrder({super.key});

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  Map<String, dynamic> data = Get.arguments['data'];
  String? fcmToken;
  File? imageFile;

  void getFcmToken() async {
    fcmToken = await NotificationsMethod.getFirebaseMessagingTokenFromUser(
        data['customer']);
  }

  @override
  void initState() {
    getFcmToken();
    super.initState();
  }

  updateData(String status) async {
    String message = "", title = "";
    try {
      await DatabaseMethod()
          .firestore
          .collection("order")
          .doc(data['transactionCode'])
          .update({"status": status});
      if (status == 'process') {
        title = "Pesanan ${data['transactionCode']} telah dikonfirmasi";
        message =
            "Pesanan anda dengan kode transaksi ${data['transactionCode']} telah dikonfirmasi, informasi selengkapnya dapat dilihat di riwayat pesanan anda ...";
      } else if (status == 'sent') {
        title = "Pesanan ${data['transactionCode']} dalam perjalanan";
        message =
            "Pesanan anda dengan kode transaksi ${data['transactionCode']} telah dikirim oleh kurir ke alamat penerima";
      } else if (status == 'done') {
        title = "Pesanan ${data['transactionCode']} telah diterima";
        message =
            "Pesanan anda dengan kode transaksi ${data['transactionCode']} telah diterima oleh penerima di alamat penerima";
      }
      NotificationsMethod.sendPushNotificationTextGeneral(
          fcmToken, title, message);
      Navigator.pop(context);

      ShowSnackbar.snackBarSuccess("Status Update Successfully");
    } on FirebaseException catch (e) {
      ShowSnackbar.snackBarError(e.message.toString());
    }
  }

  takePicture() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.camera, imageQuality: 25).then(
      (xFile) {
        if (xFile != null) {
          setState(() {
            imageFile = File(xFile.path);
            updateTransactionImage('done');
          });
        }
      },
    );
  }

  updateTransactionImage(String status) async {
    String fileName = const Uuid().v1();
    String? imageUrl;
    String message = "", title = "";

    try {
      var ref = FirebaseStorage.instance
          .ref()
          .child('order/images')
          .child("$fileName.jpg");
      if (imageFile != null) {
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        await DatabaseMethod()
            .firestore
            .collection("order")
            .doc(data['transactionCode'])
            .update({"transactionImage": imageUrl, "status": status});
        ShowSnackbar.snackBarSuccess("Image Upload Successfully");
        if (status == 'process') {
          title = "Pesanan ${data['transactionCode']} telah dikonfirmasi";
          message =
              "Pesanan anda dengan kode transaksi ${data['transactionCode']} telah dikonfirmasi, informasi selengkapnya dapat dilihat di riwayat pesanan anda ...";
        } else if (status == 'sent') {
          title = "Pesanan ${data['transactionCode']} dalam perjalanan";
          message =
              "Pesanan anda dengan kode transaksi ${data['transactionCode']} telah dikirim oleh kurir ke alamat penerima";
        } else if (status == 'done') {
          title = "Pesanan ${data['transactionCode']} telah diterima";
          message =
              "Pesanan anda dengan kode transaksi ${data['transactionCode']} telah diterima oleh penerima di alamat penerima";
        }
        NotificationsMethod.sendPushNotificationTextGeneral(
            fcmToken, title, message);
        Navigator.pop(context);

        ShowSnackbar.snackBarSuccess("Status Update Successfully");
      }
    } on FirebaseException catch (e) {
      ShowSnackbar.snackBarError(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: Text(
          "Detail Pesanan",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                    data['paymentMethod'] == '0'
                        ? 'Bayar di tempat'
                        : "Transfer ",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: Dimen(context).height * 0.02,
              ),
              Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama Lengkap : ${data['name']}",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: Dimen(context).height * 0.04,
                    ),
                    Text("Nomor Telepon : ${data['phone']}",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: Dimen(context).height * 0.04,
                    ),
                    Text("Alamat : ${data['address']}",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(
                height: Dimen(context).height * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Detail Pesanan",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: Dimen(context).height * 0.01,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data['listProduct'].length,
                            itemBuilder: (context, index) {
                              return itemProduct(
                                context,
                                data['listProduct'][index]['productTitle'],
                                data['listProduct'][index]['productQuantity'],
                                data['listProduct'][index]['productTotalPrice'],
                              );
                            }),
                        SizedBox(
                          height: Dimen(context).height * 0.02,
                        ),
                        Divider(
                          height: 5,
                          thickness: 4,
                          color: Colors.grey.shade500,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(data['totalPrice']),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dimen(context).height * 0.05,
              ),
              setButtonAccess()
            ],
          ),
        ),
      ),
    );
  }

  Widget itemProduct(context, name, qty, price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                ),
                SizedBox(
                  height: Dimen(context).height * 0.01,
                ),
                Text(
                  '${qty}x',
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            width: Dimen(context).width * 0.02,
          ),
          Text(
            CurrencyFormat.convertToIdr(price),
            style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget setButtonAccess() {
    if (data['status'] == 'pending') {
      return data['paymentMethod'] == '0'
          ?
          //jika bayar ditempat
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: MyColors.mainColor),
                  onPressed: () {
                    updateData('process');
                  },
                  child: Text("Terima Pesanan")),
            )
          :
          //jika transfer
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () =>
                          Get.to(ShowImage(imageUrl: data['transferImage'])),
                      child: Text("Bukti Transfer")),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () {
                        updateData('process');
                      },
                      child: Text("Terima Pesanan"))
                ],
              ),
            );
    } else if (data['status'] == 'process') {
      return data['paymentMethod'] == '0'
          ?
          //jika bayar ditempat
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: MyColors.mainColor),
                  onPressed: () {
                    updateData('sent');
                  },
                  child: Text("Kirim Pesanan")),
            )
          :
          //jika transfer
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () =>
                          Get.to(ShowImage(imageUrl: data['transferImage'])),
                      child: Text("Bukti Transfer")),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () {
                        updateData('sent');
                      },
                      child: Text("Kirim Pesanan"))
                ],
              ),
            );
    } else if (data['status'] == 'sent') {
      return data['paymentMethod'] == '0'
          ?
          //jika bayar ditempat
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: MyColors.mainColor),
                  onPressed: () {
                    takePicture();
                  },
                  child: Text("Upload Bukti Transaksi")),
            )
          :
          //jika transfer
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () =>
                          Get.to(ShowImage(imageUrl: data['transferImage'])),
                      child: Text("Bukti Transfer")),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () {
                        takePicture();
                      },
                      child: Text("Upload Bukti Pengiriman"))
                ],
              ),
            );
    } else {
      return data['paymentMethod'] == '0'
          ?
          //jika bayar ditempat
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: MyColors.mainColor),
                  onPressed: () =>
                      Get.to(ShowImage(imageUrl: data['transactionImage'])),
                  child: Text("Bukti COD")),
            )
          :
          //jika transfer
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () =>
                          Get.to(ShowImage(imageUrl: data['transferImage'])),
                      child: Text("Bukti Transfer")),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: MyColors.mainColor),
                      onPressed: () {
                        Get.to(ShowImage(imageUrl: data['transactionImage']));
                      },
                      child: Text("Bukti COD"))
                ],
              ),
            );
    }
  }
}
