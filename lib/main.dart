// Used ChatGPT to create this.
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Replace 'Your Name' with your actual name
  final String title = 'Simple Calculator - Your Name';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(title: title),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final String title;
  const CalculatorScreen({Key? key, required this.title}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  /// This string accumulates user input. For example, if the user presses
  /// 2, +, 3, *, 4, and =, it becomes "2+3*4 = 14".
  String _expression = '';

  /// This method handles the input from the digit and operator buttons.
  /// If the previous operation already ended with an '=', it resets the
  /// accumulator when starting a new number.
  void _onButtonPressed(String value) {
    setState(() {
      // If the expression already shows a result (contains '=')
      // and the user starts a new numeric entry, clear first.
      if (_expression.contains('=') && RegExp(r'\d').hasMatch(value)) {
        _expression = '';
      }
      _expression += value;
    });
  }

  /// Clears the entire expression.
  void _clear() {
    setState(() {
      _expression = '';
    });
  }

  /// Evaluates the current expression using the expressions package.
  /// In case of an error (for example, a malformed expression or divide by zero),
  /// it shows 'Error'.
  void _evaluate() {
    // Avoid re-evaluation if equals has already been pressed.
    if (_expression.contains('=')) return;

    try {
      // Parse the expression.
      Expression exp = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      // Evaluate with an empty context since we have no variables.
      var result = evaluator.eval(exp, {});
      setState(() {
        _expression = '$_expression = $result';
      });
    } catch (e) {
      setState(() {
        _expression = 'Error';
      });
    }
  }

  /// Helper method to create a button with the given label and optional color.
  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24),
            backgroundColor: color ?? Colors.blue,
          ),
          onPressed: () {
            if (text == 'C') {
              _clear();
            } else if (text == '=') {
              _evaluate();
            } else {
              _onButtonPressed(text);
            }
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The calculator layout: a display area on top and a grid of buttons below.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Display container shows the accumulated input and result.
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                reverse: true,
                child: Text(
                  _expression,
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          // Button grid
          Column(
            children: [
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('/', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('*', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('0'),
                  _buildButton('C', color: Colors.red),
                  _buildButton('=', color: Colors.green),
                  _buildButton('+', color: Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
