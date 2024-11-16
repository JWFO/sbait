import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/timer_settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class CountdownScreen extends StatefulWidget {
  final TimerSettings settings;

  const CountdownScreen({super.key, required this.settings});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Timer _timer;
  late Duration _timeLeft;
  bool _isRunning = false;
  int _currentHost = 1;
  int _currentGuest = 2;
  int _currentPosition = 0;
  final List<String> _enabledPositions = [];
  //int _completedPairs = 0;
  bool _roundComplete = false;
  int _messageCount = 0;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.settings.duration;
    _initializePositions();
  }

  void _initializePositions() {
    _enabledPositions.clear();
    if (widget.settings.positionsEnabled) {
      if (widget.settings.neutralEnabled) _enabledPositions.add('Neutral');
      if (widget.settings.topEnabled) _enabledPositions.add('Top');
      if (widget.settings.bottomEnabled) _enabledPositions.add('Bottom');
    }
  }

  void _resetPositions() {
    setState(() {
      _currentPosition = 0;
      //_completedPairs = 0;
      _roundComplete = false;
    });
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_timeLeft.inMilliseconds <= 0) {
          _handleTimerComplete();
        } else {
          _timeLeft = _timeLeft - const Duration(milliseconds: 100);
        }
      });
    });
  }

  void _handleTimerComplete() {
    _timer.cancel();
    if (widget.settings.alarmEnabled) {
      Vibration.vibrate(pattern: [300, 500, 300, 1500], amplitude: 200);
      //HapticFeedback.heavyImpact();

    }
    _nextPair();
  }

//adding reset timer function
  void _resetTimer() {
    if (_isRunning) {
      _timer.cancel();
    }
    setState(() {
      _isRunning = false;
      _timeLeft = widget.settings.duration;
    });
  }

  void _nextPair() {
    setState(() {
      _isRunning = false;
      _timeLeft = widget.settings.duration;

      // Increment guest
      _currentGuest++;
      _messageCount = 1;

        // If guest exceeds group size, move to next host
        if (_currentGuest > widget.settings.groupSize) {
          _currentGuest = 1;
        }

        // Skip if guest equals host
        if (_currentGuest == _currentHost) {
          _currentHost++;
          _currentGuest = _currentHost + 1;
          // If guest exceeds group size, move to next host
          if (_currentGuest > widget.settings.groupSize) {
            _currentGuest = 1;
          }
          _messageCount = 2;
        }
              // If we've completed all hosts
        if (_currentHost > widget.settings.groupSize) {
          _currentHost = 1;
          _currentGuest = 2;
          
          // Move to next position if enabled
          if (_enabledPositions.isNotEmpty) {
            if (_currentPosition >= _enabledPositions.length - 1) {
              _roundComplete = true;
              _resetPositions();
            } else {
              _currentPosition++;
              _messageCount = 3;
            }
          }
        }
    //  } // commented out code went below this line
        _alertMessage();
    });
  }

/*/ start comment
      // Increment guest
      _currentGuest++;
      _messageCount = 1;

      // Skip if guest equals host
      if (_currentGuest == _currentHost) {
        _currentGuest++;
      }

      // If guest exceeds group size, move to next host
      if (_currentGuest > widget.settings.groupSize) {
        _currentHost++;
        _currentGuest = (_currentHost + 1);//this was = 1;
        _messageCount = 2;

        // Skip if guest would equal host
        if (_currentGuest == _currentHost) {
          _currentGuest++;
        }

        // If we've completed all hosts
        if (_currentHost > widget.settings.groupSize) {
          _currentHost = 1;
          _currentGuest = 2;
          
          // Move to next position if enabled
          if (_enabledPositions.isNotEmpty) {
            if (_currentPosition >= _enabledPositions.length - 1) {
              _roundComplete = true;
              _resetPositions();
            } else {
              _currentPosition++;
              _messageCount = 3;
            }
          }
        }
// end comment        */
//      }

  void _toggleTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() => _isRunning = false);
    } else {
      _startTimer();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits((duration.inSeconds % 60));
    final tenths = (duration.inMilliseconds % 1000 ~/ 100);
    return '$minutes:$seconds.$tenths';
  }

  void _alertMessage(){
    if (widget.settings.alarmEnabled) {
      if (_messageCount == 1) {
        _timeUp();
      } else {
        if (_messageCount == 2) {
          _nextSharkBait();
        } else {
          if (_messageCount == 3) {
            _switchPosition();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_enabledPositions.isNotEmpty) ...[
                Column(
                  children: _enabledPositions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final position = entry.value;
                    return Text(
                      position,
                      style: TextStyle(
                        fontSize: index == _currentPosition ? 40 : 18, //changed from 32 to adding the index
                        fontWeight: index == _currentPosition ? FontWeight.bold : FontWeight.normal,
                        color: index == _currentPosition ? Colors.green : Colors.black,
                        decoration: index < _currentPosition || _roundComplete ? TextDecoration.lineThrough : null,
                      ),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                        textAlign: TextAlign.center,
                        'RESET POSITIONS?',),
                      content: const Text(
                        textAlign: TextAlign.center,
                        'Press OK to reset positions.',),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                            _resetPositions();
                            }
                            ),
                      ],
                    ),
                  ),
                  child: const Text(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 62, 55, 55),
                        ),
                    'Reset Positions'),
                ),
              ],
              Text(
                _formatDuration(_timeLeft),
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Text(
                'SHARK BAIT: $_currentHost\nSHARK: $_currentGuest',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _toggleTimer,
                      child: Text(
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        _isRunning ? 'PAUSE' : 'START'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        backgroundColor: Colors.red,
                      ),
                      onPressed: _resetTimer,
                      child: const Text(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        'RESET TIME'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _timeUp() {
   showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          textAlign: TextAlign.center,
          'TIME IS UP',
                style: TextStyle(fontSize: 40),),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              //Text(textAlign: TextAlign.center,'TIME IS UP',),
              Text(textAlign: TextAlign.center, 'Switch Shark',
                style: TextStyle(fontSize: 26),),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _nextSharkBait() {
   showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          textAlign: TextAlign.center,
          'NEXT ROUND',
                style:  TextStyle(fontSize: 40),),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              //Text(textAlign: TextAlign.center, 'NEXT ROUND',),
              Text(textAlign: TextAlign.center, 'Rotate in the next Shark Bait',
                style:  TextStyle(fontSize: 26),),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _switchPosition() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(textAlign: TextAlign.center,'ROUND OVER',
                style:  TextStyle(fontSize: 40),),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(textAlign: TextAlign.center,'NEXT POSITION',
                style:  TextStyle(fontSize: 26),),
                Text(textAlign: TextAlign.center,'Start next round.',
                style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }
}