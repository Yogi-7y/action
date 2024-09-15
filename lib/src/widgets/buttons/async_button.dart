import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/resource/colors.dart';

typedef AsyncButtonV2Callback = FutureOr<void> Function();

class AsyncButton extends ConsumerStatefulWidget {
  const AsyncButton({
    required this.onClick,
    required this.text,
    super.key,
  });

  final AsyncButtonV2Callback onClick;
  final String text;

  @override
  ConsumerState<AsyncButton> createState() => _AsyncButtonV2State();
}

class _AsyncButtonV2State extends ConsumerState<AsyncButton> {
  bool _isLoading = false;

  Future<void> _onClick() async {
    try {
      _isLoading = true;
      setState(() {});
      await widget.onClick();
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = maroon;
    const accentColor = Colors.white;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: _onClick,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isLoading ? Colors.transparent : accentColor,
              ),
            ),
            if (_isLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: accentColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
