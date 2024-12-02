import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MessageSendController extends GetxController {
  RxInt availableMessage = 0.obs;

  String getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formattedDate.toString();
  }

  void getMessageBalance() async {
    Map<String, String> queryParams = {
      "action": "balance",
      "user": "mah265989",
      "key": "868c68b307e242aa021a903582d85150"
    };
    var url = "https://sendmysms.net/api.php";
    var urlWithParams = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await http.get(urlWithParams);
    var responseData = jsonDecode(response.body);
    if (responseData["status"] == "OK") {
      availableMessage.value = int.parse(responseData["credit"]);
    }
  }

  void sendMessage(
      String utility_bill,
      String account_type,
      String account_ref,
      String account_number,
      String energy_cost,
      String charges,
      String service_support,
      String customer_phone_number,
      String total) async {
    var url = "https://sendmysms.net/api.php";
    Map<String, dynamic> requestBody = {
      "key": "868c68b307e242aa021a903582d85150",
      "user": "mah265989",
      "to": customer_phone_number,
      "msg":
          "Message Form #Swad Enterprize\nUtility Bill: ${utility_bill}\nA/C Type: ${account_type}\nA/C Ref: ${account_ref}\nA/C No: ${account_number}\nEnergy Cost: ${energy_cost}\nCharges: ${charges}\nTotal: ${total}\nStatus: Paid\nDate: ${getCurrentDate()}\nNB:Contact to ${service_support} for support"
    };
    if (customer_phone_number.isNotEmpty) {}
    var response = await http.post(Uri.parse(url),
        body: requestBody,
        headers: {"Content-Type": "application/x-www-form-urlencoded"});
    var resonseData = jsonDecode(response.body);
    print(resonseData);
  }
}
