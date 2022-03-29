import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'dart:io';
import 'dart:convert';
import "package:hex/hex.dart";
import 'dart:async';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'person.dart';


import 'package:flutter/services.dart' as rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EarthFace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'EarthFace'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: no_logic_in_create_state
  State<MyHomePage> createState() => _MyHomePageState([]);
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController ?controller;
  List<AndroidBluetoothLack> _blueLack = [];
  IosBluetoothState _iosBlueState = IosBluetoothState.unKnown;
  List<ScanResult> _scanResultList = [];
  List<HideConnectedDevice> _hideConnectedList = [];
  final List<_ConnectedItem> _connectedList = [];
  bool _isScaning = false;
  List<String> myList = [];
  List<String> myList1 = [];
  List<String> myList2 = [];
  var conc = StringBuffer();
  var dt = "";
  String rawJson = '{"type":"testdata","number":1,"testld":"TEST001","rgbValues":[[150,100,20],[150,100,20],[150,100,20],[150,100,20],[150,100,20],[150,100,20],[150,100,20],[150,100,20],[150,100,20],[150,100,20]],"rawValues":[[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55 ,12.634,9.654],[11.55,12.634,9.654]],"calibratedValues":[[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634,9.654],[11.55,12.634, 9.654]],"@":648}';


  var txt = "Disconnected";
  var clr = Colors.red;
  String dataStr = '';
  var op, op1, op2,cmbtxt,parsedJson;
  String ip = "";
  String ?str;
  String nw = '';
  String nw1 = '{"type":"testdata"," number":1,"testld":" TEST001 ","rgbValues" :[[150,100,20],[150, 100,20],[150,100,20] [150,100,20],[150,1 00,20],[150,100,20], [150,100,20],[150,10 0,20],[150,100,20],[ 150,100,20]],"rawVal ues":[[11.55,12.634, 9.654],[11.55,12.634 9.654],[11.55,12.63 4,9.654],[11.55,12.6 34,9.654],[11.55,12. 634,9.654],[11.55,12 .634,9.654],[11.55,1 2.634,9.654],[11.55, 12.634,9.654],[11.55 ,12.634,9.654],[11.5 5,12.634,9.654]],"ca libratedValues":[[11 55,12.634,9.654],[1 1.55,12.634,9.654],[ 11.55,12.634,9.654], [11.55,12.634,9.654] [11.55,12.634,9.654 ],[11.55,12.634,9.65 4],[11.55,12.634,9.6 54],[11.55,12.634,9. 654],[11.55,12.634,9 .654],[11.55,12.634, 9.654]],"@":648}';
  String n ='';
  String nw2 = '';
  var path;
  late int r = 0,g = 0,b = 0, count = 0;
  double o = 1.0;
  var status = Permission.bluetooth.status;
  var statusloc = Permission.location.status;


  final List<_ServiceListItem> _serviceInfos;
  final TextEditingController _sendDataTextController = TextEditingController();
  late DeviceState _deviceState;
  List<_LogItem> _logs = [];
  late int _mtu;
  late StreamSubscription<BleService> _serviceDiscoveryStream;
  late StreamSubscription<DeviceState> _stateStream;
  late StreamSubscription<DeviceSignalResult> _deviceSignalResultStream;
  Person ?person;

  _MyHomePageState(this._serviceInfos);


  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 2000),
        Platform.isAndroid ? androidGetBlueLack : iosGetBlueState);
    getHideConnectedDevice();
    if (_blueLack.contains(
        AndroidBluetoothLack.locationPermission)) {
      FlutterBlueElves.instance
          .androidApplyLocationPermission((isOk) {
        print(isOk
            ? "User agrees to grant location permission"
            : "User does not agree to grant location permission");
      });
    }


    if (_blueLack.contains(
        AndroidBluetoothLack.locationFunction)) {
      FlutterBlueElves.instance
          .androidOpenLocationService((isOk) {
        print(isOk
            ? "The user agrees to turn on the positioning function"
            : "The user does not agree to enable the positioning function");
      });
    }

    if (_blueLack.contains(
        AndroidBluetoothLack.bluetoothPermission)) {
      FlutterBlueElves.instance
          .androidApplyBluetoothPermission((isOk) {
        print(isOk
            ? "User agrees to grant Bluetooth permission"
            : "User does not agree to grant Bluetooth permission");
      });
    }

    if (_blueLack.contains(
        AndroidBluetoothLack.bluetoothFunction)) {
      FlutterBlueElves.instance
          .androidOpenBluetoothService((isOk) {
        print(isOk
            ? "The user agrees to turn on the Bluetooth function"
            : "The user does not agree to enable the Bluetooth function");
      });
    }
    if (status.isGranted == false) {
      Permission.storage.request();
        }
    FlutterBlueElves.instance.startScan(5000).listen((event) {
      if(event.name == "EarthFace") {
        setState(() {
          txt = "CONNECTED";
          // clr = Colors.green;
          print(event);

          Device toConnectDevice = event.connect(connectTimeout: 10000);
          setState(() {
            _connectedList.insert(0, _ConnectedItem(toConnectDevice,));
          });
          _ConnectedItem currentConnected = _connectedList[0];


          _mtu = currentConnected._device.mtu;
          _serviceDiscoveryStream =
              currentConnected._device.serviceDiscoveryStream.listen((event) {
                setState(() {
                  if (event.serviceUuid == "6e400001-b5a3-f393-e0a9-e50e24dcca9e") {
                    _serviceInfos.add(_ServiceListItem(event, false));
                  }
                });
              });
          _deviceState = currentConnected._device.state;
          if (_deviceState == DeviceState.connected) {
            currentConnected._device.discoveryService();
          }
          _stateStream = currentConnected._device.stateStream.listen((event) {
            if (event == DeviceState.connected) {
              setState(() {
                _mtu = currentConnected._device.mtu;
                _serviceInfos.clear();
              });
              currentConnected._device.discoveryService();
            }
            setState(() {
              _deviceState = event;
            });
          });
          _deviceSignalResultStream = currentConnected._device.deviceSignalResultStream.listen((event) {
            // print("Result");
            String data = '';
            op2 = event;

            if (op2.data != null && op2.data!.isNotEmpty) {
              data = '';
              for (int i = 0; i < op2.data!.length; i++) {
                String currentStr = op2.data![i].toRadixString(16);
                if (currentStr.length < 2) {
                  currentStr = "0" + currentStr;
                }
                data = data + currentStr;
              }
              data = String.fromCharCodes(HEX.decode(data));
              if(!data.contains('send') && !data.contains('\n') && !data.contains("\n\n⌃\n") && !data.contains(" ") && !data.contains(' ') && !data.contains('^')) {


                setState(() {
                  print('$data');
                  nw += data;
                  n += nw;
                  myList.insert(0, data);

                });
              }
            }
          });
        });
      }
    }).onDone(() {
      setState(() {
        _isScaning = false;
      });
    });
     }
  void iosGetBlueState(timer) {
    FlutterBlueElves.instance.iosCheckBluetoothState().then((value) {
      setState(() {
        _iosBlueState = value;
      });
    });
  }

  void androidGetBlueLack(timer) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((values) {
      setState(() {
        _blueLack = values;
      });
    });
  }

  void getHideConnectedDevice() {
    FlutterBlueElves.instance.getHideConnectedDevices().then((values) {
      setState(() {
        _hideConnectedList = values;
      });
    });
  }

  write(String nw) async {
    final Directory? directory = await getDownloadsDirectory();
    final File file = File('${directory!.path}/my_file.txt');
    await file.writeAsString(nw);
  }


  void press(){
    r = 0;
    g = 0;
    b = 0;
    nw = '';
    print("On Pressed");
    myList.clear();
    _logs.clear();
    myList1.clear();
    _ConnectedItem currentConnected = _connectedList[0];
    _serviceInfos.map((service) {
      op = service;
    }).toList();
    currentConnected._device.setNotify(op._serviceInfo.serviceUuid, "6e400003-b5a3-f393-e0a9-e50e24dcca9e", true);
    op._serviceInfo.characteristics.map((characteristic) {
      op1 = characteristic;
    }).toList();
    dataStr = '73656E64';
    Uint8List data1 = Uint8List(dataStr.length ~/ 2);
    for (int i = 0; i < dataStr.length ~/ 2; i++) {
      data1[i] = int.parse(
          dataStr.substring(i * 2, i * 2 + 2),
          radix: 16);
    }
    setState(() {
      print(data1);
      dataStr = "";
      currentConnected._device.writeData(op._serviceInfo.serviceUuid, op1.uuid, true, data1);
      print(data1.length);

    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        if (nw != null && nw.length >= 4) {
          nw = nw.substring(0, nw.length - 4);
        }
        Map<String, dynamic> map = jsonDecode(nw);
        Person person = Person.fromJson(map);
        print((person.rgbValues));
        for(int i = 0; i<10;i++){
          for(int j=0; j<3;j++){
            if(j==0) {
              setState(() {
                r = person.rgbValues[i][j];
                print(r);
              });
            }
            if(j==1) {
              setState(() {
                g = person.rgbValues [i][j];
                print(g);
              });
            }
            if(j==2) {
              setState(() {
                b = person.rgbValues[i][j];
                print(b);
              });
            }

          }
        }
        setState(() {
          op = person.rgbValues;
          count = 10;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              // margin: EdgeInsets.all(25),
              child: RaisedButton(
                child: Text(
                  "EarthFace $txt",style: TextStyle(fontSize:20.0),
                ) ,
                color: clr,
                textColor: Colors.white,
                onPressed: (){
                  if(txt == "CONNECTED"){
                    setState(() {
                      clr = Colors.green;

                    });
                  }

                },
              ),

            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                  child: Text('Write', style: TextStyle(fontSize: 20.0),),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: press,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: 550,
              child: ListView.builder(
                  padding: const EdgeInsets.all(80),
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      child: Card(

                        color: Color.fromRGBO(r, g, b, o),
                        child: Center(child: Text('[$r,' '$g,' '$b]')),
                      ),
                    );
                  }
              )
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectedItem {
  final Device _device;

  _ConnectedItem(this._device);
}


class _ServiceListItem {
  final BleService _serviceInfo;
  bool _isExpanded;

  _ServiceListItem(this._serviceInfo, this._isExpanded);
}

class _LogItem {
  dynamic _data;
  _LogItem(this._data);
}
class Person {
  String type;
  int number;
  var testId;
  var rgbValues;
  var rawValues;
  var calibratedValues;
  int length;

  Person(this.type, this.number, this.testId, this.rgbValues, this.rawValues,
      this.calibratedValues, this.length);

  // named constructor
  Person.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        number = json['number'],
        testId = json['testId'],
        rgbValues = json['rgbValues'],
        rawValues = json['rawValues'],
        calibratedValues = json['calibratedValues'],
        length = json['@'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'number': number,
      'testId': testId,
      'rgbValues': rgbValues,
      'rawValues': rawValues,
      'calibratedValues': calibratedValues,
      '@': length,

    };
  }
}









