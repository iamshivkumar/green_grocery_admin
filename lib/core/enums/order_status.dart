class OrderStatus {
  static const String pending = "Pending";

  static const String packed = "Packed";
  static const String outForDelivery = "Out For Delivery";
  static const String delivered = "Delivered";
  static const String cancelled = "Cancelled";

  static const List<String> values = [
    pending,
    packed,
    outForDelivery,
    delivered,
    cancelled
  ];
}
