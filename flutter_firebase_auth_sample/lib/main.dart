import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FirebaseAuth',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _firebaseAutn = FirebaseAuth.instance;
  final formkey = new GlobalKey<FormState>();

  String _email;
  String _password;

  Future<String> sginInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAutn.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAutn.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validateAndSave()) {
      try {
        String userId = await sginInWithEmailAndPassword(_email, _password);
        print('Sigind in: $userId');
      } catch (e) {
        print(e);
      }
    }
  }

  void regester() async {
    if (validateAndSave()) {
      try {
          String userId = await createUserWithEmailAndPassword(_email, _password);
          print('Regestered in: $userId');
      } catch (e) {
        print(e);
      }
    }
  }

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("FirebaseAuth"),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          child: new Form(
            key: formkey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            ),
          ),
        ),
      );
    }

    List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'メールアドレスを入力してください' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'PassWord'),
        validator: (value) => value.isEmpty ? 'パスワードを入力してください' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      new RaisedButton(
        splashColor: Colors.blueGrey,
        child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
        onPressed: submit,
      ),
      new RaisedButton(
        splashColor: Colors.blueGrey,
        child: new Text('Create an Account', style: new TextStyle(fontSize: 20.0)),
        onPressed: regester,
      ),
    ];
  }
}
