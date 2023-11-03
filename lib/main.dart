import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  final _firstnameController = new TextEditingController();
  final _lastnameController = new TextEditingController();
  final _professionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo Home Page" , style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _lastnameController,
                  keyboardType: TextInputType.text ,
                  decoration: InputDecoration(
                    icon : Icon(Icons.person),
                    hintText: "Entrer votre nom",
                    labelText: "Nom"
                  ),
                  validator: (String? value) {
                    return ( value == null ||value == "") ? "Ce champ est obligatoire" : null ;
                  },
                ),
                TextFormField(
                  controller: _firstnameController,
                  keyboardType: TextInputType.text ,
                  decoration: InputDecoration(
                      icon : Icon(Icons.person),
                      hintText: "Entrer votre prenom",
                      labelText: "Prenom"
                  ),
                  validator: (String? value) {
                    return ( value == null ||value == "") ? "Ce champ est obligatoire" : null ;
                  },
                ),
                TextFormField(
                  controller: _professionController,
                  keyboardType: TextInputType.text ,
                  decoration: InputDecoration(
                      icon : Icon(Icons.shopping_bag),
                      hintText: "Entrer votre profession",
                      labelText: "Profession"
                  ),
                  validator: (String? value) {
                    return ( value == null ||value == "") ? "Ce champ est obligatoire" : null ;
                  },
                )
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()) {

                    final prefs = await SharedPreferences.getInstance();

                    prefs.setString("lastname", _lastnameController.text) ;
                    prefs.setString("firstname", _firstnameController.text) ;
                    prefs.setString("profession", _professionController.text) ;

                    Fluttertoast.showToast(
                        msg: "Les messages ont été soumis avec succes",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM
                    );
                }
              },
              child: Text("Valider" , style: TextStyle(color: Colors.green))
          ) ,
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context ,
                    MaterialPageRoute(builder:  (context) => const PageSuivante())
                );
              },
              child: Text("Page suivante" , style: TextStyle(color: Colors.green))
          )
        ],
      ),
    );
  }
}

class PageSuivante extends StatefulWidget {
  const PageSuivante({Key? key}) : super(key: key);

  @override
  State<PageSuivante> createState() => _PageSuivanteState();
}

class _PageSuivanteState extends State<PageSuivante> {

  String _lastname = "" ;
  String _firstname = "";
  String _profession = "" ;

  _loadInformation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastname = prefs.getString("lastname") ?? "" ;
      _firstname = prefs.getString("firstname") ?? "" ;
      _profession = prefs.getString("profession") ?? "" ;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _loadInformation()) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page d'informations" , style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text : "Nom :" , style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text : _lastname + "\n"),
                TextSpan(text : "Prenom :" , style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text : _firstname + "\n"),
                TextSpan(text : "Profession :" , style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text : _profession + "\n"),
              ],
            ),
          ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context ,
                  MaterialPageRoute(builder:  (context) => const MyHomePage())
                );
              },
              child: Text("Retour" , style: TextStyle(color: Colors.black))
          )
        ]
      ),
    );
  }
}