// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quick_card/screens/mobile_scanner_screen.dart';
import 'package:quick_card/screens/svg_display_screen.dart';

import '../components/card_tile.dart';
import '../service/card_service.dart';
import 'package:quick_card/entity/card.dart' as qc;
import 'package:barcode/src/barcode.dart' as bc;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String message = 'No code scanned yet';
  final CardService _cardService = CardService();
  List<qc.Card> _cards = [];
  List<int> _keys = [];


  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final allCards = _cardService.getAllCards();
    setState(() {
      _cards = allCards;
      _keys = List.generate(allCards.length, (index) => index); // Store keys based on index
    });
  }

  void _deleteCard(int index) async {
    await _cardService.deleteCardByIndex(index); // Delete from the database

    // After deletion, refresh the list of cards
    setState(() {
      // Remove card by finding the index of the key
      int indexToRemove = _keys.indexOf(index);
      if (indexToRemove != -1) {
        _cards.removeAt(indexToRemove); // Remove card from the list
        _keys.removeAt(indexToRemove); // Remove the corresponding key
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loyalty Cards')),
      body: _cards.isEmpty ?
          Center(
            child: Text(
              message,
              style: TextStyle(fontSize: 20.0),
            ),
          )
      :
      ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          final key = _keys[index]; // Get the corresponding key
          return CardTile(
            card: card,
            deleteFunction: (context) => _deleteCard(key), // Pass the key to delete
            onTap: () {
              Navigator.push(
                context,
              MaterialPageRoute(builder: (context) => SvgDisplayScreen(svg: card.svg)));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewCard(); // Implement this function to handle adding a new card
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xff8EE4DF),
      ),
    );
  }

  Future<void> _addNewCard() async {

    final result = await Navigator.push(
        context,
    MaterialPageRoute(builder: (context) => MobileScannerScreen()));

    if (result != null && result is Map<String, dynamic>) {

      String barcodeData = result['data'];
      bc.Barcode barcodeFormat = result['format'];

      qc.Card newCard = qc.Card(
        name: 'Card Name',
        data: barcodeData,
        barcodeFormat: barcodeFormat.toString(),
        svg: barcodeFormat.toSvg(barcodeData, width: 300, height: 100),
      );


      // Save the new card and get the autogenerated key
      int key = await _cardService.saveCard(newCard);
      setState(() {
        _loadCards(); // Reload cards to reflect the new addition
      });

    }

  }

  @override
  void dispose() {
    _cardService.close();
    super.dispose();
  }
}
