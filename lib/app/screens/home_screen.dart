import 'package:face_recognation/app/ML/recognition.dart';
import 'package:face_recognation/app/screens/recognition_screen.dart';
import 'package:face_recognation/app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static Map<String, Recognition> registered = Map();
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        title: const Center(child: Text("Reconhecimento Facial")),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 100),
                child: Image.asset(
                  "images/logo.png",
                  width: screenWidth - 40,
                  height: screenWidth - 40,
                )),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  const SizedBox(
                     height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                            padding: const EdgeInsets.all(0.0),
                            textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          child: const Text(
                            "Registrar Pessoa",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RecognitionScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                            padding: const EdgeInsets.all(0.0),
                            textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          child: const Text(
                            "Reconhecer Pessoa",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
