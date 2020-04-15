import 'dart:convert';

import 'package:http/http.dart' as http;

const urlCoin = "https://apiv2.bitcoinaverage.com/indices/global/ticker";
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoin(String selectedCurrency) async {
    Map<String, String> cryptoPrice = {};
    for (String crypto in cryptoList) {
      String requestUrl = '$urlCoin/BTC$selectedCurrency';
      final respon = await http.get(requestUrl);
      if(respon.statusCode == 200){
        var data = jsonDecode(respon.body);
        double price = data['last'];
        cryptoPrice[crypto] = price.toStringAsFixed(0);
      }else{
        print(respon.statusCode);
        throw 'Problem get data';
      }
    }
    return cryptoPrice;
  }
}
