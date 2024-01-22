import 'package:flutter/material.dart';
import 'package:word_search/widgets/mytextfield.dart';

class GridDisplayScreen extends StatefulWidget {
  final int rows;
  final int columns;
  final String alphabets;
  const GridDisplayScreen({super.key, required this.rows, required this.columns, required this.alphabets});

  @override
  State<GridDisplayScreen> createState() => _GridDisplayScreenState();
}

class _GridDisplayScreenState extends State<GridDisplayScreen> {
  List<List<String>> grid = [];
  TextEditingController wordController = TextEditingController();
  List<List<bool>> highlightedCells = [];

  @override
  void initState() {
    super.initState();
    initializeGrid();
  }

  void initializeGrid() {
    if (widget.alphabets.isEmpty) {
      return;
    }
    for (int i = 0; i < widget.rows; i++) {
      grid.add([]); // Add an empty list for each row
      for (int j = 0; j < widget.columns; j++) {
        int index = (i * widget.columns + j) % widget.alphabets.length;
        grid[i].add(widget.alphabets[index]);
      }
    }

    highlightedCells = List.generate(widget.rows, (index) => List.filled(widget.columns, false));
  }


  void searchWord() {
    String targetWord = wordController.text.toUpperCase();

    for (int i = 0; i < widget.rows; i++) {
      for (int j = 0; j < widget.columns; j++) {
        // Check for word in all directions: East, South, Southeast
        if (checkWordInDirection(i, j, targetWord, 1, 0) || // East
            checkWordInDirection(i, j, targetWord, 0, 1) || // South
            checkWordInDirection(i, j, targetWord, 1, 1)) { // Southeast
          markWordInDirection(i, j, targetWord, 1, 0); // East
          return;
        }
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Word not found in the grid.'),
      ),
    );
  }

  bool checkWordInDirection(int row, int col, String word, int rowIncrement, int colIncrement) {
    int wordLength = word.length;
    if (row + rowIncrement * (wordLength - 1) >= widget.rows ||
        col + colIncrement * (wordLength - 1) >= widget.columns) {
      return false;
    }

    for (int i = 0; i < wordLength; i++) {
      if (grid[row + i * rowIncrement][col + i * colIncrement] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void markWordInDirection(int row, int col, String word, int rowIncrement, int colIncrement) {
    int wordLength = word.length;

    setState(() {
      for (int i = 0; i < wordLength; i++) {
        int newRow = row + i * rowIncrement;
        int newCol = col + i * colIncrement;
        if (newRow >= 0 && newRow < widget.rows && newCol >= 0 && newCol < widget.columns) {
          highlightedCells[newRow][newCol] = true;
        }
      }
    });
  }


  void resetGrid() {
    initializeGrid();
    wordController.clear();
    setState(() {
      highlightedCells = List.generate(widget.rows, (index) => List.filled(widget.columns, false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Grid Display'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Display Grid using a GridView
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columns,
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0,
                ),
                itemCount: widget.rows * widget.columns,
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ widget.columns;
                  int col = index % widget.columns;

                  return Container(
                    color: highlightedCells[row][col] ? Colors.deepPurpleAccent : Colors.grey,
                    child: Center(
                      child: Text(
                        grid[row][col],
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              MyTextField(hintText: 'Enter word to search', controller: wordController),
              const SizedBox(height: 20),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: searchWord,
                    child: const Text('Search Word'),
                  ),
                  ElevatedButton(
                    onPressed: resetGrid,
                    child: const Text('Reset Setup'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
