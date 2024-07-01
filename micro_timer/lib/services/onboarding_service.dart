import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _hasCompletedOnboardingKey = 'hasCompletedOnboarding';

  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedOnboardingKey, true);
  }
}

class OnboardingStep {
  final String message;
  final GlobalKey targetKey;

  OnboardingStep({required this.message, required this.targetKey});
}

class OnboardingOverlay extends StatefulWidget {
  final List<OnboardingStep> steps;
  final VoidCallback onComplete;

  const OnboardingOverlay(
      {Key? key, required this.steps, required this.onComplete})
      : super(key: key);

  @override
  _OnboardingOverlayState createState() => _OnboardingOverlayState();
}

class _OnboardingOverlayState extends State<OnboardingOverlay> {
  int currentStep = 0;

  void _nextStep() {
    if (currentStep < widget.steps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _nextStep,
            child: Container(
              color: Colors.black54,
            ),
          ),
        ),
        _buildHighlight(),
        _buildMessage(),
      ],
    );
  }

  Widget _buildHighlight() {
    final RenderBox? renderBox =
        widget.steps[currentStep].targetKey.currentContext?.findRenderObject()
            as RenderBox?;
    if (renderBox == null) return Container();

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return Positioned(
      left: position.dx - 8,
      top: position.dy - 8,
      width: size.width + 16,
      height: size.height + 16,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.steps[currentStep].message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _nextStep,
              child: Text(
                  currentStep < widget.steps.length - 1 ? 'Next' : 'Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
