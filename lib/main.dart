import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Calculator",
    home: SIForm(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  _SIFormState createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();
  var _currencies = ['Dollar', 'Fc', 'Frw'];
  final minPadding = 5.0;
  var _currentSelectedItem = '';

  @override
  void initState() {
    super.initState();
    _currentSelectedItem = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Calculator"),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          autovalidate: true,
          child: Padding(
            padding: EdgeInsets.all(minPadding),
            child: ListView(
                children: <Widget>[
                  getImageAsset(),
                  Padding(padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the principal amount";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Principal",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15.0
                          ),
                          hintText: "Enter the amount to convert",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: roiController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter Rate of interest";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Rate of Interest",
                          hintText: "In Percent",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: textStyle,
                            controller: termController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter the Terms";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Terms",
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.yellowAccent,
                                    fontSize: 15.0
                                ),
                                hintText: "Time in years",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)
                                )
                            ),
                          ),
                        ),

                        Container(
                          width: minPadding * 3,
                        ),

                        Expanded(child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentSelectedItem,
                          onChanged: (String newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          },
                        )
                        )
                      ]
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  this.displayResult = _calculateTotalReturns();
                                }
                              });
                            },
                          )),
                          Expanded(child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ))
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(minPadding * 2),
                    child: Text(
                      this.displayResult,
                      style: textStyle,
                    ),
                  )
                ]),
          )),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/ship.jpg');
    Image image = Image(image: assetImage, width: 125.0, height: 125.0);
    return Container(
      child: image,
      margin: EdgeInsets.all(minPadding * 7),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentSelectedItem = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;
    String results = "After $term years, your Investment will be worth $totalAmountPayable $_currentSelectedItem";
    return results;
  }

  void _reset() {
    principalController.text = '';
    roiController.text       = '';
    termController.text      = '';
    displayResult            = '';
    _currentSelectedItem     = _currencies[0];
  }
}
