import 'package:budget_tracker/UI/screens/AddScreen.dart';
import 'package:budget_tracker/UI/screens/profile.dart';
import 'package:budget_tracker/UI/screens/withdrawscreen.dart';
import 'package:budget_tracker/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homescreen> {
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  List<Map<String, dynamic>> transactions = [];
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    fetchTransactionsFromFirestore();
  }

  void fetchTransactionsFromFirestore() {
    if (currentUserId == null) {
      Fluttertoast.showToast(
        msg: "User not logged in",
        backgroundColor: pro_color.redcolor,
        textColor: pro_color.whitecolor,
      );
      return;
    }
    FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .listen((snapshot) {
      double newTotalIncome = 0.0;
      double newTotalExpenses = 0.0;
      List<Map<String, dynamic>> newTransactions = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final type = data['type'];
        final amount = data['amount'] ?? 0.0;

        // Parse and format the date correctly
        final rawDate = data['date'] != null
            ? DateTime.parse(data['date'])
            : DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd hh:mm a').format(rawDate);

        if (type == 'income') {
          newTotalIncome += amount;
        } else if (type == 'expense') {
          newTotalExpenses += amount;
        }
        newTransactions.add({
          "title": type == 'income' ? "Income" : "Expense",
          "amount": amount,
          "type": type,
          "time": formattedDate, // Use the formatted date here
        });
      }
      setState(() {
        totalIncome = newTotalIncome;
        totalExpenses = newTotalExpenses;
        totalBalance = totalIncome - totalExpenses;
        transactions = newTransactions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pro_color.whitecolor,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
          child: Icon(
            Icons.person,
            color: pro_color.blackcolor,
          ),
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 36),
            child: Text(
              'ExpenseEase',
              style: TextStyle(
                  fontSize: 20,
                  color: pro_color.blackcolor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            // Gradient Container
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${totalBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pro_color.bluecolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddScreen()),
                    );
                  },
                  child: Text(
                    'Add Income',
                    style: TextStyle(color: pro_color.whitecolor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pro_color.maincolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (totalBalance <= 0) {
                      Fluttertoast.showToast(
                        msg: "Insufficient balance to withdraw",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeductScreen(
                                  totalBalance: totalBalance,
                                )),
                      );
                    }
                  },
                  child: Text(
                    'WithDraw',
                    style: TextStyle(color: pro_color.whitecolor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Transaction List
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'No transactions yet!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.separated(
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => Divider(height: 20),
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: transaction['type'] == 'income'
                                ? Colors.green
                                : pro_color.redcolor,
                            child: Icon(
                              transaction['type'] == 'income'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(transaction['title']),
                          subtitle: Text(transaction['time']), // Formatted time
                          trailing: Text(
                            '${transaction['type'] == 'income' ? '+' : '-'}${transaction['amount'].toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction['type'] == 'income'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
