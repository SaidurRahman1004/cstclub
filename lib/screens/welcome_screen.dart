import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'webview_screen.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    
    _textSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
    );

    
    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.elasticOut)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: Image.asset(
                    'assets/images/cst_logo.png',
                    height: 120,
                  ),
                ),
                const SizedBox(height: 24),

                
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _logoFadeAnimation, 
                    child: Column(
                      children: [
                        Text(
                          'Welcome To CST Club',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Empowering Tech',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                
                SizedBox(
                  height: 40, 
                  child: DefaultTextStyle(
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 1000),
                      animatedTexts: [
                        FadeAnimatedText('Innovators'),
                        FadeAnimatedText('Doers'),
                        FadeAnimatedText('Changemakers'),
                        FadeAnimatedText('Trailblazers'),
                        FadeAnimatedText('Achievers'),
                        FadeAnimatedText('Visionaries'),
                        FadeAnimatedText('Problem Solvers'),
                        FadeAnimatedText('Builders'),
                        FadeAnimatedText('Thinkers'),
                        FadeAnimatedText('Creators'),
                        FadeAnimatedText('Leaders'),
                        FadeAnimatedText('Digital Warriors'),
                        FadeAnimatedText('Tech Heroes'),
                        FadeAnimatedText('Future Engineers'),
                        FadeAnimatedText('Game Changers'),
                        FadeAnimatedText('Disruptors'),
                      ],
                    ),
                  ),
                ),
                const Spacer(),

                
                ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const WebViewScreen()),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    label: const Text('Continue'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 40), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}