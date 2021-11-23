import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   SocketIO socket;
   SocketIOManager manager;
   StreamSubscription echoSubscription;

  @override
  void initState() {
    // TODO: implement initState

    getSocketData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  Future<void> getSocketData() async {
    IO.Socket socket = IO.io('https://datting-app-test.herokuapp.com/');
    socket.onConnect((_) {
      print('connect');
      socket.emit('newUser', '613c7d5162b43b6f2392a174');
    });
    /*socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));*/
  }
}
