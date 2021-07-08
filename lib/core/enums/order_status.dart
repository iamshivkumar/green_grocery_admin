enum OrderStatus { Ordered, Packed, OutForDelivery, Delivered, Cancelled }

OrderStatus getStatus(String status) {
  switch (status) {
    case "Packed":
      return OrderStatus.Packed;
    case "OutForDelivery":
      return OrderStatus.OutForDelivery;
    case "Delivered":
      return OrderStatus.Delivered;
    case "Cancelled":
      return OrderStatus.Cancelled;
    default:
      return OrderStatus.Ordered;
  }
}
