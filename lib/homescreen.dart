import 'package:currency_calculator/services/network.dart';
import 'package:flutter/material.dart';
import 'coins.dart';
import 'package:flutter/cupertino.dart';

const appID = ''; //Enter your UPI Key here

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCurrency = 'AUD';
  // ignore: non_constant_identifier_names
  int BTCPrice = 0;
  // ignore: non_constant_identifier_names
  int ETHPrice = 0;
  // ignore: non_constant_identifier_names
  int LTCPrice = 0;

  bool isWaiting = false;

  CupertinoPicker myCupertinoPicker() {
    List<Text> myCupertinoPickerListItem = [];
    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
      myCupertinoPickerListItem.add(newItem);
    }
    return CupertinoPicker(
      magnification: 2,
      itemExtent: 28,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = currenciesList[index];
          fetchData();
          //print(selectedCurrency);
        });
      },
      children: myCupertinoPickerListItem,
    );
  }

  void fetchData() async {
    isWaiting = true;
    try {
      MyNetwork myNetwork = MyNetwork();
      int getBTCPrice = await myNetwork.fetchPrice(
          'https://api.nomics.com/v1/currencies/ticker?key=$appID&ids=BTC&convert=$selectedCurrency');
      int getETHPrice = await myNetwork.fetchPrice(
          'https://api.nomics.com/v1/currencies/ticker?key=$appID&ids=ETH&convert=$selectedCurrency');
      int getLTCPrice = await myNetwork.fetchPrice(
          'https://api.nomics.com/v1/currencies/ticker?key=$appID&ids=LTC&convert=$selectedCurrency');
      isWaiting = false;
      setState(() {
        BTCPrice = getBTCPrice;
        ETHPrice = getETHPrice;
        LTCPrice = getLTCPrice;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.orange.shade200,
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Center(
                child: MyCard(
                  deviceWidth: deviceWidth,
                  value: isWaiting ? '?' : BTCPrice.toString(),
                  coinType: 'BTC',
                  selectedCurrency: selectedCurrency,
                ),
              ),
              MyCard(
                deviceWidth: deviceWidth,
                value: isWaiting ? '?' : ETHPrice.toString(),
                coinType: 'ETH',
                selectedCurrency: selectedCurrency,
              ),
              MyCard(
                deviceWidth: deviceWidth,
                value: isWaiting ? '?' : LTCPrice.toString(),
                coinType: 'LTC',
                selectedCurrency: selectedCurrency,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: deviceWidth,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          spreadRadius: 6.0,
                          color: Colors.orange.shade300,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: myCupertinoPicker(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({
    Key? key,
    required this.value,
    required this.deviceWidth,
    required this.coinType,
    required this.selectedCurrency,
  }) : super(key: key);

  final double deviceWidth;
  final String value;
  final String? coinType;
  final String? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Container(
        width: deviceWidth,
        child: Card(
          elevation: 20,
          color: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '1 $coinType = $value $selectedCurrency',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

// DropdownButton<String>(
//                       dropdownColor: Colors.orange.shade100,
//                       menuMaxHeight: deviceHeight,
//                       value: selectedCurrency,
//                       iconSize: 50,
//                       style: TextStyle(
//                         fontSize: 25,
//                         color: Colors.black,
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedCurrency = value;
//                         });
//                       },
//                       items: getDropDownMenuItems(),
//                     ),

// List<DropdownMenuItem<String>> getDropDownMenuItems() {
//   List<DropdownMenuItem<String>> myDropDownMenuItemList = [];
//   for (String currency in currenciesList) {
//     var newItem = DropdownMenuItem(
//       child: Text(currency),
//       value: currency,
//     );
//     myDropDownMenuItemList.add(newItem);
//   }
//   return myDropDownMenuItemList;
// }
