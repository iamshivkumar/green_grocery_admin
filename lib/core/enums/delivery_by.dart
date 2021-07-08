enum DeliveyBy { Morning, Afternoon, Evening }
DeliveyBy getDeliveyBy(String status) {
  switch (status) {
    case "Afternoon":
      return DeliveyBy.Afternoon;
    case "Evening":
      return DeliveyBy.Evening;
    default:
      return DeliveyBy.Morning;
  }
}
