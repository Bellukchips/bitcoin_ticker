import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectCurrency = 'AUD';

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItem = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItem.add(newItem);
    }
    return DropdownButton<String>(
      value: selectCurrency,
      items: dropDownItem,
      onChanged: (value) {
        setState(() {
          selectCurrency = value;
          getCurrency();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerTimes = [];
    for (String currency in currenciesList) {
      pickerTimes.add(Text(currency));
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (index) {
          selectCurrency = currenciesList[index];
          getCurrency();
        },
        children: pickerTimes);
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropDown();
    }
  }

  Map<String, String> coinvalues = {};
  bool isWaiting = false;
  String btcValueInUsd = '?';

  void getCurrency() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoin(selectCurrency);
      isWaiting = false;
      setState(() {
        coinvalues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: CryptoCard(
              cryptoCurrency: 'BTC',
              value: isWaiting ? '?' : coinvalues['BTC'],
              selectedCurrency: selectCurrency,
            )),
            Expanded(
                child: CryptoCard(
              cryptoCurrency: 'ETH',
              value: isWaiting ? '?' : coinvalues['ETH'],
              selectedCurrency: selectCurrency,
            )),
            Expanded(
                child: CryptoCard(
              cryptoCurrency: 'LTC',
              value: isWaiting ? '?' : coinvalues['LTC'],
              selectedCurrency: selectCurrency,
            )),
            Container(
              height: 130.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker(),
            )
          ]),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final String value;
  final String cryptoCurrency;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
