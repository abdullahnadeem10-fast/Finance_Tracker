class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.title,
    required this.date,
    this.receiptUrl,
    this.notes,
  });

  final String id;
  final double amount;
  final String type;
  final String category;
  final String title;
  final DateTime date;
  final String? receiptUrl;
  final String? notes;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'title': title,
      'date': date.toIso8601String(),
      'receiptUrl': receiptUrl,
      'notes': notes,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    final rawAmount = map['amount'];
    final rawDate = map['date'];

    return TransactionModel(
      id: (map['id'] ?? '') as String,
      amount: rawAmount is num ? rawAmount.toDouble() : 0,
      type: (map['type'] ?? 'expense') as String,
      category: (map['category'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      date: rawDate is DateTime
          ? rawDate
          : DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now(),
      receiptUrl: map['receiptUrl'] as String?,
      notes: map['notes'] as String?,
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? category,
    String? title,
    DateTime? date,
    String? receiptUrl,
    String? notes,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      date: date ?? this.date,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      notes: notes ?? this.notes,
    );
  }
}