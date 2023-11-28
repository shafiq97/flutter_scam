import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fraudrader/view/appDrawer.dart';
import 'package:fraudrader/view/Bank/bankFraudScreen.dart';
import 'package:fraudrader/view/Mobile/mobilefraudScreen.dart';

class HomeAct extends StatefulWidget {
  final User user;
  const HomeAct({super.key, required this.user});

  @override
  State<HomeAct> createState() => _HomeActState();
}

class _HomeActState extends State<HomeAct> with SingleTickerProviderStateMixin {
  TextEditingController mobile = TextEditingController();
  TextEditingController bank = TextEditingController();

  String name = '';
  String email = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    //   print(FirebaseAuth.instance.currentUser);
    name = widget.user.displayName!;
    email = widget.user.email!;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(userName: name, userEmail: email),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        title: const Text("Fraud Rader"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Phone Search',
                  ),
                  Tab(text: 'Bank Account Search'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MobileFraudScreen(
                      user: widget.user,
                    ),
                    BankFraudScreen(user: widget.user),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
