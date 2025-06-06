import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vpn_app/Views/core/Constant.dart';


class CountDownTimer extends StatefulWidget {
  final bool startTimer;

  const CountDownTimer({super.key, required this.startTimer});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration _duration = const Duration();
  Timer? _timer;

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = Duration(seconds: _duration.inSeconds + 1);
      });
    });
  }

  _stopTimer() {
    setState(() {
      _timer?.cancel();
      _timer = null;
      _duration = const Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timer == null || !widget.startTimer) {
      widget.startTimer ? _startTimer() : _stopTimer();
    }

    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigit(_duration.inMinutes.remainder(60));
    final seconds = twoDigit(_duration.inSeconds.remainder(60));
    final hours = twoDigit(_duration.inHours.remainder(60));

    return Text('$hours: $minutes: $seconds',
        style: boldStyle.copyWith(color: white,fontSize:20 ));
  }
}
