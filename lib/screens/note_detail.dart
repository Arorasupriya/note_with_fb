import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_with_fb/models/data_model.dart';

class NoteDetail extends StatefulWidget {
  String? getId;
  int? index;

  NoteDetail({super.key, required this.getId, required this.index});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  var txtTitleController = TextEditingController();
  var txtDescController = TextEditingController();
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    print("id${widget.getId},${widget.index}");
    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor: Colors.cyanAccent.withAlpha(120),
          body: StreamBuilder(
            stream: db.collection("notes").snapshots(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                var currentData = DataModel.fromJson(
                    snapshot.data!.docs[widget.index!].data());
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withAlpha(150),
                                  shape: const CircleBorder(),
                                  elevation: 5
                                  // fixedSize: Size(50, 50)
                                  ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.cyanAccent.withAlpha(250),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withAlpha(150),
                                  shape: const CircleBorder(),
                                  elevation: 5
                                  // fixedSize: Size(50, 50)
                                  ),
                              onPressed: () {
                                txtTitleController.text =
                                    currentData.title.toString();
                                txtDescController.text =
                                    currentData.desc.toString();
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(21),
                                            topLeft: Radius.circular(21))),
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Text(
                                                "Update Note",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: TextField(
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                  controller:
                                                      txtTitleController,
                                                  decoration: InputDecoration(
                                                      hintText: "Enter Title",
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          21))),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: TextField(
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                controller: txtDescController,
                                                maxLines: 8,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Enter Description",
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(21))),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  var title = txtTitleController
                                                      .text
                                                      .toString();
                                                  var desc = txtDescController
                                                      .text
                                                      .toString();
                                                  DateTime nowDT =
                                                      DateTime.now();
                                                  String formattedDate =
                                                      DateFormat('EEE d MMM')
                                                          .format(nowDT);
                                                  db
                                                      .collection("notes")
                                                      .doc(widget.getId)
                                                      .update(DataModel(
                                                        title: title,
                                                        desc: desc,
                                                        dateTime: formattedDate
                                                      ).toJson())
                                                      .then((value) {
                                                    print("value updated");
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.cyanAccent
                                                          .withAlpha(120)),
                                                ))
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.edit,
                                size: 25,
                                color: Colors.cyanAccent.withAlpha(250),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        currentData.title.toString(),
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Text(
                          currentData.desc.toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          )),
    );
  }
}
