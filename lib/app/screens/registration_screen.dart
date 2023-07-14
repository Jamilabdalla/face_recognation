import 'dart:io';
import 'package:face_recognation/app/ML/recognition.dart';
import 'package:face_recognation/app/ML/recognizer.dart';
import 'package:face_recognation/app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RegistrationScreen> {
  late ImagePicker imagePicker;
  File? _image;
  late FaceDetector faceDetector;
  late Recognizer recognizer;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);
    recognizer = Recognizer();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  _imgFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  List<Face> faces = [];
  var image;
  doFaceDetection() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);
    print("Count=${faces.length}");
    performFaceRecognition();
  }

  performFaceRecognition() async {
    _image = await removeRotation(_image!);
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);

    for (Face face in faces) {
      num left = face.boundingBox.left < 0 ? 0 : face.boundingBox.left;
      num top = face.boundingBox.top < 0 ? 0 : face.boundingBox.top;
      num right = face.boundingBox.right > image.width ? image.widt - 1 : face.boundingBox.right;
      num bottom = face.boundingBox.bottom > image.height ? image.height - 1 : face.boundingBox.bottom;

      num width = right - left;
      num height = bottom - top;

      File? cropedFace = await FlutterNativeImage.cropImage(_image!.path, left.toInt(), top.toInt(), width.toInt(), height.toInt());

      var bytes = await cropedFace.readAsBytes();
      img.Image? imgFace = img.decodeImage(bytes);
      Recognition recognition = recognizer.recognize(imgFace!, face.boundingBox);
      showFaceRegistrationDialogue(cropedFace, recognition);
    }
    setState(() {
      _image;
    });

    drawRectangleAroundFaces();
  }

  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await File(inputImage.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(File cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Registro Facial", textAlign: TextAlign.center),
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.file(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(controller: textEditingController, decoration: const InputDecoration(fillColor: Colors.white, filled: true, hintText: "Insira o nome")),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          HomeScreen.registered.putIfAbsent(textEditingController.text, () => recognition);
                          textEditingController.text = "";
                          //Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Rosto Registrado com sucesso!!!"),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                          padding: const EdgeInsets.all(0.0),
                          textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Registrar")),
                  ),
                ],
              )
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  drawRectangleAroundFaces() async {
    print("${image.width}   ${image.height}");
    setState(() {
      image;
      faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Center(child: Text("Registrar Colaborador")),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            image != null
                ? Container(
                    margin: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 0),
                    child: FittedBox(
                      child: SizedBox(
                        width: image.width.toDouble(),
                        height: image.width.toDouble(),
                        child: CustomPaint(
                          painter: FacePainter(facesList: faces, imageFile: image),
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      "images/logo.png",
                      width: screenWidth - 100,
                      height: screenWidth - 100,
                    ),
                  ),
            Container(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.cyan,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
                    child: InkWell(
                      onTap: () {
                        _imgFromGallery();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.image, color: Colors.white, size: screenWidth / 10),
                            const Text(
                              "Galeria de fotos",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.cyan,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
                    child: InkWell(
                      onTap: () {
                        _imgFromCamera();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.camera_alt_sharp, color: Colors.white, size: screenWidth / 10),
                            const Text(
                              "Camera do celular",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
