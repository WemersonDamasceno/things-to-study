package com.example.things_to_study

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.Manifest
import android.content.pm.PackageManager
import java.util.UUID

class MainActivity: FlutterActivity() {
    private val CHANNEL = "things_to_study.bluetooth/channel"
    private val REQUEST_CODE_PERMISSIONS = 1
    private var bluetoothSocket: BluetoothSocket? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Configura o MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isHeadphoneConnected" -> result.success(isHeadphoneConnected())
                    "getBluetoothDevices" -> {
                        if (hasBluetoothPermissions()) {
                            result.success(getBluetoothDevices())
                        } else {
                            requestBluetoothPermissions()
                            result.error("PERMISSION_DENIED", "Permissões de Bluetooth não concedidas", null)
                        }
                    }
                    "connectToDevice" -> {
                        val macAddress = call.argument<String>("macAddress")
                        if (macAddress != null) {
                            val connectResult = connectToDevice(macAddress)
                            result.success(connectResult)
                        } else {
                            result.error("INVALID_ARGUMENT", "O endereço MAC do dispositivo não pode ser nulo", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // Verifica se o fone está conectado
    private fun isHeadphoneConnected(): Boolean {
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        return bluetoothAdapter?.isEnabled == true &&
               bluetoothAdapter.getProfileConnectionState(BluetoothAdapter.STATE_CONNECTED) == BluetoothAdapter.STATE_CONNECTED
    }

    // Busca dispositivos Bluetooth emparelhados
    private fun getBluetoothDevices(): List<Map<String, String>> {
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        val devices: Set<BluetoothDevice>? = bluetoothAdapter?.bondedDevices
        return devices?.map { device ->
            mapOf(
                "name" to (device.name ?: "Dispositivo Desconhecido"), // Usando um nome padrão
                "macAddress" to device.address // Endereço MAC
            )
        } ?: emptyList()
    }

    // Verifica se as permissões necessárias foram concedidas
    private fun hasBluetoothPermissions(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            return ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED &&
                   ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
        }
        return true
    }

    // Solicita as permissões de Bluetooth para Android 12+
    private fun requestBluetoothPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_CONNECT
                ),
                REQUEST_CODE_PERMISSIONS
            )
        }
    }

    // Método para conectar ao dispositivo Bluetooth usando o MAC Address
    private fun connectToDevice(macAddress: String): String {
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        val device = bluetoothAdapter?.getRemoteDevice(macAddress) // Obtém o dispositivo usando o MAC Address

        return if (device != null) {
            try {
                // Usando um UUID padrão para conexão Bluetooth
                val uuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
                bluetoothSocket = device.createRfcommSocketToServiceRecord(uuid)
                bluetoothSocket?.connect()
                "Conectado a ${device.name}"
            } catch (e: Exception) {
                "Erro ao conectar: ${e.message}"
            }
        } else {
            "Dispositivo não encontrado"
        }
    }   

}
