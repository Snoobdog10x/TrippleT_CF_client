class Orders {
  String? addressID;
  bool? isSuccess;
  String? orderId;
  String? orderBy;
  String? orderTime;
  String? paymentDetails;
  List<dynamic>? productIDs;
  String? status;
  String? totalAmount;

  Orders({
    this.addressID,
    this.isSuccess,
    this.orderId,
    this.orderBy,
    this.orderTime,
    this.paymentDetails,
    this.productIDs,
    this.status,
    this.totalAmount,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    this.addressID = json["addressID"];
    this.isSuccess = json["isSuccess"];
    this.orderBy = json["orderBy"];
    this.orderId = json["orderId"];
    this.orderTime = json["orderTime"];
    this.paymentDetails = json["paymentDetails"];
    this.productIDs = json["productIDs"];
    this.status = json["status"];
    this.totalAmount = json["totalAmount"];
  }
  separateOrderItemIDs() {
    List<String> separateItemIDsList = [], defaultItemList = [];
    int i = 0;

    defaultItemList = List<String>.from(productIDs!);

    for (i; i < defaultItemList.length; i++) {
      //this format => 34567654:7
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");

      //to this format => 34567654
      String getItemId = (pos != -1) ? item.substring(0, pos) : item;

      separateItemIDsList.add(getItemId);
    }

    return separateItemIDsList;
  }

  separateOrderItemQuantities() {
    List<String> separateItemQuantityList = [];
    List<String> defaultItemList = [];
    int i = 0;

    defaultItemList = List<String>.from(productIDs!);

    for (i; i < defaultItemList.length; i++) {
      //this format => 34567654:7
      String item = defaultItemList[i].toString();

      //to this format => 7
      List<String> listItemCharacters = item.split(":").toList();

      //converting to int
      var quanNumber = int.parse(listItemCharacters[1].toString());

      separateItemQuantityList.add(quanNumber.toString());
    }

    return separateItemQuantityList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["addressID"] = addressID;
    data["isSuccess"] = isSuccess;
    data["orderId"] = orderId;
    data["orderBy"] = orderBy;
    data["orderTime"] = orderTime;
    data["paymentDetails"] = paymentDetails;
    data["productIDs"] = productIDs;
    data["status"] = status;
    data["totalAmount"] = totalAmount;
    return data;
  }
}
