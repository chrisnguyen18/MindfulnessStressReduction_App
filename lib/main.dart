import 'package:flutter/material.dart';

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
            _HomeButton(label: 'Guided Exercises'),
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
  const _HomeButton({super.key, required this.label, this.onPressed});

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

// Mood tracker page (No storage yet)
class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  int? _selectedMood; // 0 = mad, 1 = neutral, 2 = happy
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
            _selectedMood == null
                ? const SizedBox.shrink()
                : Text(
                    'Selected: ${_selectedLabel!}',
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedMood == null
                    ? null
                    : () {
                        // No saving function yet
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

// Log Thoughts page (no storage yet)
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Entry submitted')),
                        );
                        _controller.clear();
                        setState(() => _canSubmit = false);
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
