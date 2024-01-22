import 'package:flutter/material.dart';
import 'package:word_search/widgets/mytextfield.dart';

import 'griddisplay_screen.dart';

class GridSetupScreen extends StatefulWidget {
  const GridSetupScreen({super.key});

  @override
  State<GridSetupScreen> createState() => _GridSetupScreenState();
}

class _GridSetupScreenState extends State<GridSetupScreen> {
  TextEditingController rowsController = TextEditingController();
  TextEditingController columnsController = TextEditingController();
  TextEditingController wordController = TextEditingController();

  void createGrid(){
    if (rowsController.text.isNotEmpty &&
        columnsController.text.isNotEmpty &&
        wordController.text.isNotEmpty) {
      int rows = int.parse(rowsController.text);
      int columns = int.parse(columnsController.text);
      String alphabets = wordController.text.toUpperCase();

      if (rows > alphabets.length && columns > alphabets.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GridDisplayScreen(
              rows: rows,
              columns: columns,
              alphabets: alphabets,
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                'The length of Rows and Columns must be greater than the length of Alphabets.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter values for rows, columns, and alphabets.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Setup'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(hintText: 'Enter Number of Rows', controller: rowsController),
            const SizedBox(height: 10),
            MyTextField(hintText: 'Enter Number of Columns', controller: columnsController),
            const SizedBox(height: 10),
            MyTextField(hintText: 'Enter Your Alphabets', controller: wordController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createGrid,
              child: const Text('Create Grid'),
            ),
          ],
        ),
      ),
    );
  }
}
