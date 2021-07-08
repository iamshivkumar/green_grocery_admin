class Payment {
  final String id;
  final double amount;

  Payment({required this.amount, required this.id});

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      amount: map["amount"],
      id: map["id"]
    );
  }
}
