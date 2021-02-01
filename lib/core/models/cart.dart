class Cart {
  int items;
  double price;
  Cart({this.items,this.price});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: json['items'],
      price: json['price'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'price': price,
      
    };
  }

  void incrimentItems(int value) {
    items = items + value;
  }

   void incrimentPrice(double value) {
    price = price + value;
  }
}
