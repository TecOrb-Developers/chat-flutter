import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/login_screen.dart';
import '../widgets/logo_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController(initialPage: 0);
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _index = index;
              });
            },
            children: [
              Stack(
                children: [
                  Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/thailand.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const FakeWidget(
                    title: "Share your location with\nyour family in real time",
                  )
                ],
              ),
              Stack(
                children: [
                  Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/paddleboarding.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const FakeWidget(
                    title: "Coordinate easily with\nSmart Notification",
                  ),
                ],
              ),
            ],
          ),
          //LOGO, DOT INDICATOR, BUTTONS
          Stack(
            children: [
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 19),
                      const SizedBox(
                        height: 150,
                        width: 150,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dotIndicator(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 0),
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: const ShapeDecoration(
                            color: primaryColor,
                            shape: StadiumBorder(),
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> dotIndicator() {
    List<Widget> dots = [];

    for (int i = 0; i <= 1; i++) {
      dots.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _index == i ? 8 : 6,
          width: _index == i ? 8 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 30),
          decoration: BoxDecoration(
            color: _index == i ? Colors.white : Colors.white70,
            shape: BoxShape.circle,
          ),
        ),
      );
    }
    return dots;
  }
}

class FakeWidget extends StatelessWidget {
  const FakeWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 19),
            Container(
              height: 150,
              width: 150,
              color: Colors.transparent,
            ),
            const Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
              height: 8,
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 12,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
              width: double.maxFinite,
              alignment: Alignment.center,
              child: const Text(
                "",
                style: TextStyle(
                  color: Colors.transparent,
                  fontSize: 21,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
