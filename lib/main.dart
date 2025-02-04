// Completed using ChatGPT
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Replace 'Your Name' with your actual name.
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
  /// This string accumulates user input. For example,
  /// if the user presses 2, +, 3, *, 4, and =,
  /// it becomes "2+3*4 = 14".
  String _expression = '';

  /// Handles input from digit and operator buttons.
  /// If a result is already present (the expression contains '='),
  /// and the user starts entering a new number, we clear first.
  void _onButtonPressed(String value) {
    setState(() {
      if (_expression.contains('=') && RegExp(r'\d').hasMatch(value)) {
        _expression = '';
      }
      _expression += value;
    });
  }

  /// Clears the current expression.
  void _clear() {
    setState(() {
      _expression = '';
    });
  }

  /// Evaluates the current expression using the expressions package.
  /// If the evaluation fails (e.g. due to a malformed expression or division by zero),
  /// the display shows 'Error'.
  void _evaluate() {
    // Avoid re-evaluation if equals has already been pressed.
    if (_expression.contains('=')) return;

    try {
      // Parse and evaluate the expression.
      Expression exp = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
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

  /// Squares the last number entered in the expression.
  /// It uses a regular expression to find the last numeric token.
  /// If no valid number is found, it sets the display to 'Error'.
  void _squareLastNumber() {
    setState(() {
      // If the expression already shows a result, clear it first.
      if (_expression.contains('=')) {
        _expression = '';
      }

      // Regular expression to match the last number (supports integers and decimals, including negatives).
      final regex = RegExp(r'(-?\d+(\.\d+)?)$');
      final match = regex.firstMatch(_expression);
      if (match != null) {
        final numberStr = match.group(0)!;
        try {
          final value = double.parse(numberStr);
          final squared = value * value;
          // Replace the last number with its squared value.
          _expression = _expression.substring(0, match.start) + squared.toString();
        } catch (e) {
          _expression = 'Error';
        }
      } else {
        _expression = 'Error';
      }
    });
  }

  /// Helper method to build a calculator button.
  /// For special buttons ('C', '=', 'x²'), we override the default onPressed behavior.
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
            } else if (text == 'x²') {
              _squareLastNumber();
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
    // The layout: a display area at the top and the button grid below.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Display container shows the current expression and result.
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
          // New row for extra feature buttons: modulo (%) and square (x²).
          Row(
            children: [
              _buildButton('%', color: Colors.teal),
              _buildButton('x²', color: Colors.pink),
              // Two empty Expanded widgets for spacing/alignment.
              const Expanded(child: SizedBox()),
              const Expanded(child: SizedBox()),
            ],
          ),
          // Calculator button grid.
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
    );
  }
}
