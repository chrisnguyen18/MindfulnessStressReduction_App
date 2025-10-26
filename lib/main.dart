import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';


//global temporary storage (only saves during user session, will erase when user exits app)
List<int> globalMoodHistory = [];
List<String> globalThoughts = [];
List<Map<String, String>> favoriteQuotes = [];


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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<_AffirmationCardState> _affirmationKey = GlobalKey();

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
            const SizedBox(height: 12),

            // Daily affirmation with key
            AffirmationCard(key: _affirmationKey),
            const SizedBox(height: 24),

            // Buttons
            _HomeButton(
              label: 'Guided Exercises',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GuidedExercisesPage()),
                ).then((_) => _affirmationKey.currentState?._loadRandomQuote());
              },
            ),
            const SizedBox(height: 12),
            _HomeButton(
              label: 'Mood Tracker',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MoodTrackerPage()),
                ).then((_) => _affirmationKey.currentState?._loadRandomQuote());
              },
            ),
            const SizedBox(height: 12),
            _HomeButton(
              label: 'Log Thoughts',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LogThoughtsPage()),
                ).then((_) => _affirmationKey.currentState?._loadRandomQuote());
              },
            ),
            const SizedBox(height: 12),
            _HomeButton(
              label: 'View Submissions',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ViewSubmissionsPage()),
                ).then((_) => _affirmationKey.currentState?._loadRandomQuote());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AffirmationCard extends StatefulWidget {
  const AffirmationCard({super.key});

  @override
  State<AffirmationCard> createState() => _AffirmationCardState();
}

class _AffirmationCardState extends State<AffirmationCard> {
  String _quote = 'Loading...';
  String _author = '';

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  Future<void> _loadRandomQuote() async {
    try {
      final csvData = await rootBundle.loadString('assets/quotes.csv');
      final rows = const CsvToListConverter(eol: '\n', shouldParseNumbers: false).convert(csvData);
      final validRows = rows.where((row) => row.length >= 2 && row[0] != 'Quote').toList();

      if (validRows.isEmpty) {
        setState(() {
          _quote = 'No quotes available';
          _author = '';
        });
        return;
      }

      final randomRow = validRows[Random().nextInt(validRows.length)];
      setState(() {
        _quote = randomRow[0].toString();
        _author = randomRow[1].toString();
      });
    } catch (e) {
      setState(() {
        _quote = 'Error loading quote';
        _author = '';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          const Text(
            'Daily Affirmation',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(_quote, textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic)),
          if (_author.isNotEmpty) Text('- $_author', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {
                favoriteQuotes.add({'quote': _quote, 'author': _author});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to favorites!')),
                );
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Save as Favorite'),
            ),
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


// Guided Exercises Page
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
              switch (index) {
                case 0: // Breathing exercise
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BreathingExercisePage()),
                  );
                  break;

                case 1: // Meditation audio
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MeditationAudioPage()),
                  );
                  break;

                case 2: // Mindful pause
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MindfulPausePage()),
                  );
                  break;
              }
            },
          );
        },
        separatorBuilder: (context, _) => const Divider(height: 1),
      ),
    );
  }
}

// Exercise 1: 4-7-8 Breathing
class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});
  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> {
  int _step = 0;
  int _seconds = 0;
  Timer? _timer;
  final List<String> _steps = ['Inhale', 'Hold', 'Exhale'];
  final List<int> _durations = [4, 7, 8];

  void _startExercise() {
    _timer?.cancel();
    _step = 0;
    _seconds = _durations[_step];

    setState(() {}); // initial value will be 4 instead of 3

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else {
          _step = (_step + 1) % _steps.length;
          _seconds = _durations[_step];
        }
      });
    });
  }

  void _stopExercise() {
    _timer?.cancel();
    setState(() {
      _step = 0;
      _seconds = 0;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _steps[_step],
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('$_seconds seconds', style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _startExercise, child: const Text('Start')),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: _stopExercise, child: const Text('Stop')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// Exercise 2: Meditation Audio with timeline
class MeditationAudioPage extends StatefulWidget {
  const MeditationAudioPage({super.key});
  @override
  State<MeditationAudioPage> createState() => _MeditationAudioPageState();
}

class _MeditationAudioPageState extends State<MeditationAudioPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onDurationChanged.listen((d) => setState(() => _duration = d));
    _player.onPositionChanged.listen((p) => setState(() => _position = p));
    _player.onPlayerComplete.listen((_) => setState(() {
      _isPlaying = false;
      _position = Duration.zero;
    }));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meditation Audio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _togglePlay,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlaying ? 'Pause Meditation' : 'Play Meditation'),
            ),
            const SizedBox(height: 24),
            if (_duration.inSeconds > 0)
              Slider(
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble(),
                onChanged: (value) async {
                  final newPos = Duration(seconds: value.toInt());
                  await _player.seek(newPos);
                  setState(() => _position = newPos);
                },
              ),
            Text(
              '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / '
              '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }
}


// Exercise 3: Mindful Pause
class MindfulPausePage extends StatefulWidget {
  const MindfulPausePage({super.key});
  @override
  State<MindfulPausePage> createState() => _MindfulPausePageState();
}

class _MindfulPausePageState extends State<MindfulPausePage> {
  int _secondsRemaining = 10;
  Timer? _timer;

  void _startPause() {
    _timer?.cancel();
    _secondsRemaining = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pause complete!')));
        }
      });
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
      appBar: AppBar(title: const Text('Mindful Pause')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_secondsRemaining seconds remaining', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _startPause, child: const Text('Start Mindful Pause')),
          ],
        ),
      ),
    );
  }
}


// Mood Tracker Page 
class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  int? _selectedMood;

  String? get _selectedLabel {
    switch (_selectedMood) {
      case 0:
        return 'Mad';
      case 1:
        return 'Neutral';
      case 2:
        return 'Happy';
      default:
        return null;
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
                _MoodFace(label: '😡', isSelected: _selectedMood == 0, onTap: () => setState(() => _selectedMood = 0)),
                _MoodFace(label: '😐', isSelected: _selectedMood == 1, onTap: () => setState(() => _selectedMood = 1)),
                _MoodFace(label: '😄', isSelected: _selectedMood == 2, onTap: () => setState(() => _selectedMood = 2)),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedMood != null)
              Text('Selected: ${_selectedLabel!}', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedMood == null
                    ? null
                    : () {
                        globalMoodHistory.add(_selectedMood!);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mood submitted')));
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
  const _MoodFace({required this.label, required this.isSelected, required this.onTap});

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
        child: Text(label, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}


// Log Thoughts Page 
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
              onChanged: (value) => setState(() => _canSubmit = value.trim().isNotEmpty),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _canSubmit
                    ? () {
                        globalThoughts.add(_controller.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry Submitted')));
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

// View Submissions Page
class ViewSubmissionsPage extends StatelessWidget {
  const ViewSubmissionsPage({super.key});

  String _moodEmoji(int mood) {
    switch (mood) {
      case 0:
        return '😡 Mad';
      case 1:
        return '😐 Neutral';
      case 2:
        return '😄 Happy';
      default:
        return '❓ Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Submissions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Mood History 
            const Text('Mood History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (globalMoodHistory.isEmpty)
              const Text('No moods logged yet.')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: globalMoodHistory.map((m) => Text('• ${_moodEmoji(m)}')).toList(),
              ),
            const SizedBox(height: 24),

            // Journal Entries 
            const Text('Journal Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (globalThoughts.isEmpty)
              const Text('No thoughts logged yet.')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: globalThoughts.map((t) => Text('• $t')).toList(),
              ),
            const SizedBox(height: 24),

            //  Favorite Quotes (Extra Creative Feature)
            const Text('Favorite Quotes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (favoriteQuotes.isEmpty)
              const Text('No favorites saved yet.')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: favoriteQuotes
                    .map((f) => Text('• "${f['quote']}" - ${f['author']}'))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
