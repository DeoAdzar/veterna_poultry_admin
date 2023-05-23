import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:veterna_poultry_admin/db/auth.dart';
import 'package:veterna_poultry_admin/utils/constant.dart';
import 'package:veterna_poultry_admin/utils/dimen.dart';
import 'package:veterna_poultry_admin/utils/my_colors.dart';
import 'package:veterna_poultry_admin/utils/pages.dart';

import '../../db/database_methods.dart';

class HomeChatRoom extends StatelessWidget {
  const HomeChatRoom({Key? key}) : super(key: key);

  String readTimestamp(Timestamp timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm');
    var date = DateTime.parse(timestamp.toDate().toString());
    var diff = now.difference(date);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = '${diff.inDays} DAY AGO';
      } else {
        time = '${diff.inDays} DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = '${(diff.inDays / 7).floor()} WEEK AGO';
      } else {
        time = '${(diff.inDays / 7).floor()} WEEKS AGO';
      }
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: Text(
          'Konsultasi',
          style: GoogleFonts.inter(
              color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseMethod()
                      .firestore
                      .collection('conversation')
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return conversation(
                              snapshot.data!.docs[index].id, map, context);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget conversation(
      String id, Map<String, dynamic> map, BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppPages.CHAT_ROOM, arguments: {
          Constant.CONVERSATION_ID: id,
          Constant.CONVERSATION_SENDER_NAME: map['senderName'],
          Constant.CONVERSATION_SENDER_ID: map['senderId']
        });
      },
      child: Container(
        width: Dimen(context).width,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            //ini buat custom warnanya sama rounded nya button
            color: MyColors.cardHomeMessage,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 2)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              height: 45,
              width: 45,
              child: map['senderImage'] == ""
                  ? const Image(
                      image: AssetImage('assets/user_profile.png'),
                      fit: BoxFit.fill,
                    )
                  : Image(
                      image: NetworkImage(map['senderImage']),
                      fit: BoxFit.fill,
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    map['senderName'],
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: Dimen(context).height * 0.008,
                  ),
                  Text(
                    map['lastMessage'],
                    style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            Text(
              map['time'] != null ? readTimestamp(map['time']) : "",
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
