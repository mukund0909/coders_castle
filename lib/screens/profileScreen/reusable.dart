// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatformCard extends StatefulWidget {
  const PlatformCard(
      {Key key,
      @required this.path,
      @required this.platformName,
      @required this.stringKey,
      @required this.boolKey})
      : super(key: key);
  final String path, platformName, stringKey, boolKey;

  @override
  State<PlatformCard> createState() => _PlatformCardState();
}

class _PlatformCardState extends State<PlatformCard> {
  bool isVisible = false, showUserName = false;
  String username = "";

  Future getUserName() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String name = sharedPref.getString(widget.stringKey);
    setState(() {
      username = name;
      showUserName = (username == null) ? false : true;
    });
  }

  Future updateChanges() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(widget.stringKey, username);
    setState(() {
      isVisible = false;
      showUserName = true;
    });
  }

  @override
  void initState() {
    getUserName().whenComplete(() => {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 7.5, top: 3, bottom: 3),
                      child: SizedBox(
                        height: 40,
                        width: 30,
                        child: Image.asset(widget.path),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.platformName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Visibility(
                          visible: showUserName,
                          child: Text(
                            'Username : $username',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible;
                        showUserName = !showUserName;
                      });
                    },
                    child: Icon(
                      (isVisible)
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isVisible,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      onChanged: (value) {
                        username = value;
                      },
                      controller: TextEditingController(text: username),
                      // cursorColor: primaryColour,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.8)),
                        ),
                        hintText: "Enter your Username",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      updateChanges();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Update',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}