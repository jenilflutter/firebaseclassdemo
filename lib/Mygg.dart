import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key}) : super(key: key);

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ViewFirebaseData();
  }

  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage("${list[index]['imageurl']}"),
            ),
            title: Text("${list[index]['name']}",style: TextStyle(fontSize: 25),),
          );
        },
      ),
    );
  }


  // StremBuilder
  // FutureBuilder
  // FirebaseAnimated List





  Future<void> ViewFirebaseData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("RoshniRealtime");

    list.clear();

      ref.onValue.listen((event) {

        list.clear();

        Map map = event.snapshot.value as Map;

        map.forEach((key, value) {
          setState(() {
            list.add(value);
          });
        });
      });

    // print("====${de.snapshot.value}");
    // Map map = de.snapshot.value as Map;


  }
}
