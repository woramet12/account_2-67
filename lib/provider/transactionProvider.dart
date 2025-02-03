import 'package:account/model/transactionItem.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier{
  List<TransactionItem> transactions = [
    TransactionItem(title: 'หนังสือ', amount: 1000, date: DateTime.now()),
    TransactionItem(title: 'เสื้อยืด', amount: 200),
    TransactionItem(title: 'รองเท้า', amount: 1500),
    TransactionItem(title: 'กระเป๋า', amount: 1000, date: DateTime.now()),
    TransactionItem(title: 'KFC', amount: 300),
    TransactionItem(title: 'McDonald', amount: 200),
  ];

  List<TransactionItem> getTransaction() {
    return transactions;
  }

  void addTransaction(TransactionItem transaction) {
    transactions.add(transaction);
  }

}

