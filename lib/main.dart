import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var inController = TextEditingController();
  var result = "";
  var bgColor = Colors.indigo.shade200;
  List<Exercise> suggestedExercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        color: bgColor,
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BMI',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 21),
                TextField(
                  controller: wtController,
                  decoration: InputDecoration(
                    label: Text('Enter your weight in Kg'),
                    prefixIcon: Icon(Icons.line_weight),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 11),
                TextField(
                  controller: ftController,
                  decoration: InputDecoration(
                    label: Text('Enter your height in feet'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 11),
                TextField(
                  controller: inController,
                  decoration: InputDecoration(
                    label: Text('Enter your height in inch'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    var wt = wtController.text;
                    var ft = ftController.text;
                    var inch = inController.text;

                    if (wt.isNotEmpty && ft.isNotEmpty && inch.isNotEmpty) {
                      var iWt = int.parse(wt);
                      var iFt = int.parse(ft);
                      var iInch = int.parse(inch);

                      var tInch = (iFt * 12) + iInch;
                      var tCm = tInch * 2.54;
                      var tM = tCm / 100;
                      var bmi = iWt / (tM * tM);

                      var msg;
                      suggestedExercises.clear();

                      if (bmi > 25) {
                        msg = "You are OverWeight!!";
                        bgColor = Colors.orange.shade200;
                        suggestedExercises.addAll(overweightExercises);
                      } else if (bmi < 18.5) {
                        msg = "You are UnderWeight!!";
                        bgColor = Colors.red.shade200;
                        suggestedExercises.addAll(underweightExercises);
                      } else {
                        msg = "You are Healthy!!";
                        bgColor = Colors.green.shade500;
                        suggestedExercises.addAll(healthyExercises);
                      }

                      setState(() {
                        result = "$msg \n Your BMI is: ${bmi.toStringAsFixed(2)}";
                      });
                    } else {
                      setState(() {
                        result = "Please fill all the required fields!!";
                      });
                    }
                  },
                  child: Text('Calculate'),
                ),
                SizedBox(height: 30),
                Text(
                  result,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 20),

                if (suggestedExercises.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: ListView.builder(
                              itemCount: suggestedExercises.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(suggestedExercises[index].name),
                                  subtitle: Text(suggestedExercises[index].description),
                                  trailing: Icon(Icons.arrow_forward),
                                  onTap: () {
                                    _launchURL(suggestedExercises[index].tutorialUrl);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Suggested Exercises'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Exercise {
  final String name;
  final String description;
  final String tutorialUrl;

  Exercise({required this.name, required this.description, required this.tutorialUrl});
}

final List<Exercise> underweightExercises = [
  Exercise(
    name: "Yoga",
    description: "A set of asanas to improve body flexibility and strength.",
    tutorialUrl: "https://www.youtube.com/watch?v=v7AYKMP6rOE",
  ),
  Exercise(
    name: "Light Weight Training",
    description: "Basic weight training exercises.",
    tutorialUrl: "https://www.youtube.com/watch?v=U0bhE67HuDY",
  ),
];

final List<Exercise> healthyExercises = [
  Exercise(
    name: "Running",
    description: "A great cardio exercise for overall fitness.",
    tutorialUrl: "https://www.youtube.com/watch?v=7KIz7l_2gGg",
  ),
  Exercise(
    name: "Cycling",
    description: "A fun way to keep fit and explore your surroundings.",
    tutorialUrl: "https://www.youtube.com/watch?v=1Vn_1Dy-F8k",
  ),
];

final List<Exercise> overweightExercises = [
  Exercise(
    name: "Aerobics",
    description: "An excellent way to burn calories and lose weight.",
    tutorialUrl: "https://www.youtube.com/watch?v=4PgDUMNxsTY",
  ),
  Exercise(
    name: "Swimming",
    description: "A full-body workout that's easy on the joints.",
    tutorialUrl: "https://www.youtube.com/watch?v=cH8ZArSp-n4",
  ),
];
