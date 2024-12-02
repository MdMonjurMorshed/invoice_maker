class MockBluetoothDevice {
  final String address;
  final String name;

  MockBluetoothDevice({required this.address, required this.name});
}

class MockPrinterBluetooth {
  final MockBluetoothDevice device;

  MockPrinterBluetooth(this.device);

  String get name => device.name;
  String get address => device.address;
}
