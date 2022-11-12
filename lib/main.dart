import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wether/data_service.dart';
import 'package:flutter/material.dart';
import 'package:wether/firebase_options.dart';

import 'models.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();

  WeatherResponse? _response = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //f(WeatherInfo.fromJson(weatherInfoJson)=="Sunny"){
      backgroundColor: Colors.lightBlue,

      appBar: AppBar(
        title:
        Center(child: Text("Weather App",style: TextStyle(color:Colors.blueGrey),),),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_response != null)
              Container(
                width: 400,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15),),
                child: Column(
                  children: [
                    Image.network(_response!.iconUrl),
                    Text(
                      '${_response!.tempInfo.temperature}°',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(_response!.weatherInfo.description)
                  ],
                ),
              ),
            Container(
              height: 300,
              width: 400,
              // color: Colors.blue.shade200,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(15),),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: SizedBox(
                  width: 150,
                  child: TextField(
                      controller: _cityTextController,
                      decoration: InputDecoration(labelText: 'City'),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            ElevatedButton(onPressed: _search, child: Text('Search'))
          ],
        ),
      ),
    );
  }
  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => _response = response);
  }
}


class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = "", _passwd = "";
  bool vis = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Login"),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(9),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  onChanged: (value) {
                    setState(() {
                      _passwd = value.trim();
                    });
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  // color: Theme.of(context).accentColor,
                  child: const Text('Sign-in'),
                  onPressed: () {
                    _auth
                        .signInWithEmailAndPassword(
                        email: _email, password: _passwd)
                        .then((_) {
                      setState(() {
                        vis = false;
                      });
                      if (_auth.currentUser?.uid == null) {
                        setState(() {
                          vis = true;
                        });
                      }

                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Home()));
                    });
                  },
                ),
                ElevatedButton(
                  // color: Theme.of(context).accentColor,
                  child: const Text('Sign-up'),
                  onPressed: () {
                    _auth
                        .createUserWithEmailAndPassword(
                        email: _email, password: _passwd)
                        .then((_) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Home()));
                    });
                  },
                ),
                Visibility(
                    visible: vis,
                    child: const Text(
                      "Login failed",
                      selectionColor: Colors.red,
                    ))
              ])
            ],
          ),
        ));
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Login()
    );
  }




}