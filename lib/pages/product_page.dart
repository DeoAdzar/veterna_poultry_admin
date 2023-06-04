import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veterna_poultry_admin/widget/button_blue_radius_25.dart';

import '../db/database_methods.dart';
import '../utils/dimen.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethod()
                    .firestore
                    .collection('products')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 10,
                            color: Colors.grey,
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(map['img_path']),
                                      )),
                                ),
                                SizedBox(
                                  width: Dimen(context).width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        map['title'],
                                        style: GoogleFonts.inter(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: Dimen(context).height * 0.02,
                                      ),
                                      Text(
                                        'Rp.${map['price']}',
                                        style: GoogleFonts.inter(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete_forever),
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
          height: 55,
          color: Colors.transparent,
          child: ButtonBlueRadius25(text: "Tambah Produk", onTap: () {})),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
