import 'dart:async';

import 'package:fleet_management/models/expense.dart';
import 'package:fleet_management/models/expensetype.dart';
import 'package:fleet_management/models/result.dart';
import 'package:fleet_management/models/vehicleddmodel.dart';
import 'package:fleet_management/services/expenseservice.dart';
import 'package:fleet_management/services/masterservice.dart';
import 'package:fleet_management/utils.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  AddExpensePage(
      {Key key,
      this.title,
      this.orgId,
      this.userId,
      this.userName,
      this.emailId})
      : super(key: key);
  final String title;
  final int orgId;
  final int userId;
  final String userName;
  final String emailId;
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  bool isLoading = false;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _amountctrl = new TextEditingController();
  VehicleDdModel selectedVechicle;
  TextEditingController _notesctrl = new TextEditingController();
  TextEditingController _vehiclectrl = new TextEditingController();
  TextEditingController _expdatectrl = new TextEditingController();
  TextEditingController _readingctrl = new TextEditingController();
  TextEditingController _quantityctrl = new TextEditingController();
  List<ExpenseTypeModel> _expenseTypes; // getStaticExpenseTypes();
  List<VehicleDdModel> _vehicleDD;
  ExpenseTypeModel selectedExpType;
  VehicleDdModel selectedVehcile;

  void _clearForm() {
    setState(() {
      _amountctrl.text = '';
      selectedExpType = null;
      selectedVechicle = null;
      _notesctrl.text = '';
      _vehiclectrl.text = '';
      _expdatectrl.text = '';
      _readingctrl.text = '';
      _quantityctrl.text = '';
    });
  }

  void _onSaveExpense() {
    if (_formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      ExpenseModel exp = new ExpenseModel(
          userId: widget.userId,
          amount: double.parse(_amountctrl.text != null ? _amountctrl.text : 0),
          orgId: widget.orgId,
          expenseTypeId: selectedExpType.id,
          vehicleId: selectedVechicle != null ? selectedVechicle.id : null,
          notes: _notesctrl.text,
          vin: _vehiclectrl.text != null ? _vehiclectrl.text : "",
          odometerReading: double.tryParse(
              _readingctrl.text != null ? _readingctrl.text : ""),
          quantity: double.tryParse(
              _quantityctrl.text != null ? _quantityctrl.text : ""));

      Future<ResultModel> expFuture = saveExpense(exp, _expdatectrl.text);
      expFuture.then((result) {
        Future<Null> dialogFuture;
        if (result.status) {
          _clearForm();
          dialogFuture = userDialog(context, result.successMessage, 'Ok');
        } else {
          dialogFuture = userDialog(context, result.errorMessage, 'Retry');
        }

        dialogFuture.then((temp) {
          setState(() {
            isLoading = false;
          });
        });
      });
    }
  }

  Widget buildExpenseTypes() {
    if (_expenseTypes == null) {
      return Text('Expense Types');
    } else {
      return InputDecorator(
        decoration: InputDecoration(
          icon: Icon(Icons.build),
          labelText: "Expense type",
        ),
        isEmpty: selectedExpType == null,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ExpenseTypeModel>(
            isDense: true,
            value: selectedExpType,
            onChanged: (ExpenseTypeModel newValue) {
              setState(() {
                selectedExpType = newValue;
              });
            },
            items: _expenseTypes.map((ExpenseTypeModel exptype) {
              return DropdownMenuItem<ExpenseTypeModel>(
                value: exptype,
                child: Text(
                    exptype.expenseType != null ? exptype.expenseType : ""),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  Widget buildVehicleDropdown() {
    if (_vehicleDD == null) {
      return Text('Vehicles');
    } else {
      return InputDecorator(
        decoration: InputDecoration(
          icon: Icon(Icons.directions_bus),
          labelText: 'Vehicle',
        ),
        isEmpty: selectedVechicle == null,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<VehicleDdModel>(
            isDense: true,
            value: selectedVechicle,
            onChanged: (VehicleDdModel newValue) {
              setState(() {
                selectedVechicle = newValue;
              });
            },
            items: _vehicleDD.map((VehicleDdModel vehicle) {
              return DropdownMenuItem<VehicleDdModel>(
                value: vehicle,
                child: Text(
                  vehicle.vin != null ? vehicle.vin : "",
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  DateTime _date = new DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime(2030));

    if (picked != null) {
      setState(() {
        _expdatectrl.text = toyyyyMMdd(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getExpenseTypes(widget.orgId).then((exptypes) {
      setState(() {
        _expenseTypes = exptypes;
        if (exptypes != null) {
          selectedExpType = exptypes.elementAt(0);
        }
      });
    });

    getVehicles(widget.orgId).then((vehicles) {
      setState(() {
        _vehicleDD = vehicles;
      });
    });

    setState(() {
      _expdatectrl.text = toyyyyMMdd(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _onSaveExpense,
            tooltip: 'Save expense',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(backgroundColor: Colors.blueAccent),
            )
          : SafeArea(
              top: false,
              bottom: false,
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.attach_money),
                        hintText: "Enter expense amount",
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                      controller: _amountctrl,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required';
                        }
                      },
                    ),
                    buildExpenseTypes(),

                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      leading: Icon(Icons.calendar_today),

                      title: Text(_expdatectrl.text),
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //     hintText: "yyyy-MM-dd",
                      //     labelText: 'Expense date',
                      //   ),
                      //   keyboardType: TextInputType.datetime,
                      //   controller: _expdatectrl,
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'This field is required';
                      //     }
                      //   },
                      // ),
                      onTap: () {
                        _selectDate(context);
                      },
                    ),

                    buildVehicleDropdown(),
                    // TextFormField(
                    //   decoration: new InputDecoration(
                    //     icon: Icon(Icons.directions_bus),
                    //     hintText: "Enter vehicle id",
                    //     labelText: 'Vehicle',
                    //   ),
                    //   keyboardType: TextInputType.text,
                    //   controller: _vehiclectrl,
                    // ),

                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.timelapse),
                          hintText: 'Enter odometer reading',
                          labelText: 'Odometer reading'),
                      keyboardType: TextInputType.number,
                      controller: _readingctrl,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          double parsedvalue = double.tryParse(value);
                          if (parsedvalue == null) {
                            return 'Please enter valid reading';
                          }
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.timelapse),
                          hintText: 'Enter respective quantity',
                          labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      controller: _quantityctrl,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          double parsedvalue = double.tryParse(value);
                          if (parsedvalue == null) {
                            return 'Please enter valid quantity';
                          }
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.note),
                        hintText: "Enter expense notes",
                        labelText: 'Notes',
                      ),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      controller: _notesctrl,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
