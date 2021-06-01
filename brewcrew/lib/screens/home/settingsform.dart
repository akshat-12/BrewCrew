import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/database.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  String _currentName = '';
  String _currentSugars = '0';
  int _currentStrength = 100;
  bool sugarIsChanged = false;
  bool nameIsChanged = false;
  bool strengthIsChanged = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ModelUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userdata = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew settings',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userdata!.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) {
                      setState(() {
                        _currentName = val;
                        nameIsChanged = true;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      value: userdata.sugars,
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text(
                            '$sugar sugars',
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _currentSugars = val.toString();
                          sugarIsChanged = true;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Slider(
                    activeColor: Colors.brown[_currentStrength],
                    inactiveColor: Colors.brown[_currentStrength],
                    value: _currentStrength.toDouble(),
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (value) {
                      setState(() {
                        _currentStrength = value.round();
                        strengthIsChanged = true;
                      });
                    },
                  ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String submitName;
                        String submitSugar;
                        int submitStrength;
                        if (nameIsChanged) {
                          submitName = _currentName;
                        } else {
                          submitName = userdata.name;
                        }
                        if (sugarIsChanged) {
                          submitSugar = _currentSugars;
                        } else {
                          submitSugar = userdata.sugars;
                        }
                        if (strengthIsChanged) {
                          submitStrength = _currentStrength;
                        } else {
                          submitStrength = userdata.strength;
                        }
                        await DatabaseService(uid: user.uid).updateUserData(
                            submitSugar, submitName, submitStrength);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
