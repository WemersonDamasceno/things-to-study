import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BluetoothDropdown extends StatefulWidget {
  const BluetoothDropdown({super.key});

  @override
  _BluetoothDropdownState createState() => _BluetoothDropdownState();
}

class _BluetoothDropdownState extends State<BluetoothDropdown> {
  static const platform = MethodChannel('things_to_study.bluetooth/channel');
  List<DeviceBluetoothModel> devices = []; // Lista de dispositivos Bluetooth
  DeviceBluetoothModel? selectedDevice; // Dispositivo selecionado
  String connectionStatus = 'Desconectado'; // Status da conexão

  @override
  void initState() {
    super.initState();
    _getBluetoothDevices();
  }

  Future<void> _getBluetoothDevices() async {
    try {
      final List<dynamic> result =
          await platform.invokeMethod('getBluetoothDevices');
      setState(() {
        devices = result.map<DeviceBluetoothModel>((device) {
          return DeviceBluetoothModel.fromMap(device);
        }).toList();
      });
    } on PlatformException catch (e) {
      print("Error: '${e.message}'.");
    }
  }

  Future<void> _connectToDevice(DeviceBluetoothModel device) async {
    try {
      final result = await platform.invokeMethod('connectToDevice', {
        'macAddress': device.macAddress, // Passando o MAC Address
      });
      setState(() {
        connectionStatus = result; // Atualiza o status da conexão
      });
    } on PlatformException catch (e) {
      log("Error: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: Center(
        child: devices.isEmpty
            ? const CircularProgressIndicator() // Exibe um carregando enquanto busca dispositivos
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<DeviceBluetoothModel>(
                    value: selectedDevice,
                    hint: const Text('Selecione um dispositivo'),
                    onChanged: (DeviceBluetoothModel? newValue) {
                      setState(() {
                        selectedDevice = newValue;
                      });
                      if (newValue != null) {
                        _connectToDevice(
                            newValue); // Conecta ao dispositivo selecionado
                      }
                    },
                    items: devices.map<DropdownMenuItem<DeviceBluetoothModel>>(
                        (DeviceBluetoothModel device) {
                      return DropdownMenuItem<DeviceBluetoothModel>(
                        value: device,
                        child:
                            Text(device.name), // Exibindo o nome do dispositivo
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(connectionStatus), // Exibe o status da conexão
                ],
              ),
      ),
    );
  }
}

class DeviceBluetoothModel {
  final String name; // Nome do dispositivo
  final String macAddress; // Endereço MAC do dispositivo

  DeviceBluetoothModel({required this.name, required this.macAddress});

  // Método para converter um mapa em uma instância de DeviceBluetoothModel
  factory DeviceBluetoothModel.fromMap(dynamic map) {
    return DeviceBluetoothModel(
      name: map['name'] as String,
      macAddress: map['macAddress'] as String,
    );
  }

  // Método para converter a instância em um mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'macAddress': macAddress,
    };
  }
}
