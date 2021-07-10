import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MainScreen.dart';
import 'SignupScreen.dart';
import 'MemScreen.dart';
import 'SponsorScreen.dart';
import 'StudentScreen.dart';
import 'ProgramScreen.dart';
void main() => runApp(MainApp());


class MainApp extends StatelessWidget {
  //MyConnection con=new MyConnection();
  static const platform = const MethodChannel('samples.flutter.dev/log');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/signup':(context) => SignUpScreen(),
      },
    );
  }
}
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 600,
          height:600,
          child: Card(
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _pwdTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  @override
  void _showMainScreen() {
    Navigator.of(context).pushNamed('/main');
    //Navigator.of(context).pop();
  }
  void _showSignupScreen() {
    Navigator.of(context).pushNamed('/signup');
    //Navigator.of(context).pop();
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _pwdTextController,
      _usernameTextController
    ];


    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }
    _getcall();
    setState(() {
      _formProgress = progress;
    });
  }
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Log in', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Username'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _pwdTextController,
              decoration: InputDecoration(hintText: 'pwd'),
            ),
          ),
            TextButton(
              style: ButtonStyle(
                alignment: Alignment.bottomLeft,
                foregroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.white;
                    }),
                backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.blue;
                    }),
              ),
              onPressed: _formProgress == 1 ? _showMainScreen : null,
              // _login call -> show MainScreen
              //java function
              child: Text('Login'),

            ),
            TextButton(
              style: ButtonStyle(
                alignment: Alignment.bottomRight,
                foregroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.white;
                    }),
                backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? null
                          : Colors.blue;
                    }),
              ),
              onPressed: _showSignupScreen,
              child: Text('Don\'t have an account?'),
            ),
        ],
      ),
    );
  }

  String name="";
  Future<bool> _getcall() async {
    String batteryLevel="";
    try {
      final String result = await MainApp.platform.invokeMethod('calling');
      batteryLevel = '$result';
      print("doneee");
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _formProgress=(batteryLevel.length==1)? 1:0;
    });
    return (batteryLevel.length==1);
  }
}
class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  AnimatedProgressIndicator({
    required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
//Table({Key? key, List<TableRow> children, Map<int, TableColumnWidth>? columnWidths, TableColumnWidth defaultColumnWidth, TextDirection? textDirection, TableBorder? border, TableCellVerticalAlignment defaultVerticalAlignment, TextBaseline? textBaseline})
//TableRow({LocalKey? key, Decoration? decoration, List<Widget>? children})
