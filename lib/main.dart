import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyCounterApp());
}

class MyCounterApp extends StatelessWidget {
  const MyCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
      ),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;
  int _target = 10;
  final TextEditingController _goalController = TextEditingController();

  void _vibrate() => HapticFeedback.mediumImpact();

  void _increment() {
    _vibrate();
    setState(() {
      _count++;
      if (_count == _target) {
        _showGoalReachedDialog();
      }
    });
  }

  void _decrement() {
    if (_count > 0) {
      _vibrate();
      setState(() => _count--);
    }
  }

  void _reset() {
    _vibrate();
    setState(() => _count = 0);
  }

  void _updateGoal() {
    int? newGoal = int.tryParse(_goalController.text);
    if (newGoal != null && newGoal > 0) {
      setState(() {
        _target = newGoal;
        _count = 0;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("New Goal set to $_target!"), behavior: SnackBarBehavior.floating),
      );
    }
  }

  void _showGoalReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Goal Achieved! 🎉"),
        content: Text("You have reached your target of $_target."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Awesome")),
        ],
      ),
    );
  }

  void _showSetGoalSheet() {
    _goalController.text = _target.toString();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20, left: 20, right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Set Your Target Goal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateGoal,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Set Goal & Reset Counter"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = _count / _target;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tally Master"),
        actions: [
          IconButton(onPressed: _showSetGoalSheet, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Target: $_target", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.teal)),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 15,
                    backgroundColor: Colors.teal.withOpacity(0.1),
                    color: _count >= _target ? Colors.orange : Colors.teal,
                  ),
                ),
                Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text('$_count', key: ValueKey(_count), style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold)),
                    ),
                    Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 20, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(Icons.remove, Colors.redAccent, _decrement),
                const SizedBox(width: 25),
                _actionBtn(Icons.add, Colors.teal, _increment, isLarge: true),
                const SizedBox(width: 25),
                _actionBtn(Icons.refresh, Colors.blueGrey, _reset),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback action, {bool isLarge = false}) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(isLarge ? 25 : 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Icon(icon, color: color, size: isLarge ? 40 : 28),
      ),
    );
  }
}