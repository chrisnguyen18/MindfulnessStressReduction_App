import 'package:flutter/material.dart';
import 'dart:async';

// global temp storage
List<int> globalMoodHistory = [];
List<String> globalThoughts =[];

void main() => runApp(const MindfulnessApp());

class MindfulnessApp extends StatelessWidget {
  const MindfulnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mindfulness & Stress Reduction',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Mindfulness & Stress Reduction',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),

            // Daily affirmation
            _AffirmationCard(),
            SizedBox(height: 24),

            // Buttons
            _HomeButton(
              label: 'Guided Exercises',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GuidedExercisesPage()),
                );
              },
            ),
            SizedBox(height: 12),
            _HomeButton(
              label: 'Mood Tracker',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MoodTrackerPage()),
                  );
                },
              ),
            SizedBox(height: 12),
            _HomeButton(
              label: 'Log Thoughts',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LogThoughtsPage()),
                );
              },
            ),
            SizedBox(height: 12),
            _HomeButton(label: 'View Submissions'),
          ],
        ),
      ),
    );
  }
}

class _AffirmationCard extends StatelessWidget {
  const _AffirmationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF808000)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Daily Affirmation',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            '“Placeholder for quote.”',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const _HomeButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

// Guided Exercises page
class GuidedExercisesPage extends StatelessWidget {
  const GuidedExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = const [
      'Exercise 1 (4-7-8 Breathing)',
      'Exercise 2 (Meditation Audio)',
      'Exercise 3 (Mindful Pause)',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Guided Exercises')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exercises[index]),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              if (index == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FirstExercisePage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening: ${exercises[index]}')),
                );
              }
            },
          );
        },
        separatorBuilder: (context, _) => const Divider(height: 1),
      ),
    );
  }
}

// Exercise 1 page (4-7-8 Breathing)
class FirstExercisePage extends StatefulWidget {
  const FirstExercisePage({super.key});

  @override
  State<FirstExercisePage> createState() => _FirstExercisePageState();
}

class _FirstExercisePageState extends State<FirstExercisePage> {
  String _phase = 'Ready';
  int _secondsLeft = 0;
  Timer? _timer;

  void _start() {
    _timer?.cancel();
    setState(() {
      _phase = 'Inhale';
      _secondsLeft = 4;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        if (_phase == 'Inhale') {
          setState(() {
            _phase = 'Hold';
            _secondsLeft = 7;
          });
        } else if (_phase == 'Hold') {
          setState(() {
            _phase = 'Exhale';
            _secondsLeft = 8;
          });
        } else if (_phase == 'Exhale') {
          t.cancel();
          setState(() {
            _phase = 'Done';
            _secondsLeft = 0;
          });
        }
      }
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _phase = 'Ready';
      _secondsLeft = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4-7-8 Breathing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Phase: $_phase',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _secondsLeft > 0 ? 'Seconds left: $_secondsLeft' : '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _phase == 'Ready' || _phase == 'Done' ? _start : null,
                child: const Text('Start'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _reset,
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ),
      ),
    );
  }
}


// Mood tracker page
class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  int? _selectedMood; // 0 = mad, 1 = neutral, 2 = happy
  List<int> _moodHistory = []; //temp storage of moods
  String? get _selectedLabel {
  switch (_selectedMood) {
    case 0: return 'Mad';
    case 1: return 'Neutral';
    case 2: return 'Happy';
    default: return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How are you feeling today?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MoodFace(
                  label: '😡',
                  isSelected: _selectedMood == 0,
                  onTap: () => setState(() => _selectedMood = 0),
                ),
                _MoodFace(
                  label: '😐',
                  isSelected: _selectedMood == 1,
                  onTap: () => setState(() => _selectedMood = 1),
                ),
                _MoodFace(
                  label: '😄',
                  isSelected: _selectedMood == 2,
                  onTap: () => setState(() => _selectedMood = 2),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // show mood text
            _selectedMood == null
              ? const SizedBox.shrink()
              : Text(
                'Selected: ${_selectedLabel!}',
                textAlign: TextAlign.center,
              ),
            // submit button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedMood == null
                    ? null
                    : () {
                        globalMoodHistory.add(_selectedMood!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mood submitted')),
                        );
                        setState(() => _selectedMood = null);
                      },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodFace extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _MoodFace({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBDBDBD) : null,
          border: Border.all(color: isSelected ? const Color(0xFF808000) : Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}

// Log Thoughts page
class LogThoughtsPage extends StatefulWidget { 
  const LogThoughtsPage({super.key});

  @override
  State<LogThoughtsPage> createState() => _LogThoughtsPageState();
}

class _LogThoughtsPageState extends State<LogThoughtsPage> {
  final TextEditingController _controller = TextEditingController();
  bool _canSubmit = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Thoughts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Write your thoughts...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _canSubmit = value.trim().isNotEmpty);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _canSubmit
                    ? () {
                        globalThoughts.add(_controller.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Entry Submitted')),
                        );
                        _controller.clear();
                        setState(() => _canSubmit = _canSubmit = false);
                      }
                    : null,
                  child: const Text('Submit'),
                 ),
               ),
            ],
          ),
        ),
      );
  }
}
