


class Level {
  final List<String> itemNames;
  final List<String> itemImages;

  Level({required this.itemNames, required this.itemImages});
}

List<Level> levels = [
  Level(
    itemNames: ['Keyboard', 'Mouse', 'Monitor', 'CPU'],
    itemImages: ['keyboard.jpg', 'mouse.jpg', 'monitor.jpg', 'cpu.jpg'],
  ),
  Level(
    itemNames: ['Keyboard', 'Mouse', 'Monitor', 'CPU', 'Printer', 'Scanner', 'Webcam', 'Laptop'],
    itemImages: ['keyboard.jpg', 'mouse.jpg', 'monitor.jpg', 'cpu.jpg', 'printer.jpg', 'scanner.jpg', 'webcam.jpg', 'laptop.jpg'],
  ),
  Level(
    itemNames: ['Keyboard', 'Mouse', 'Monitor', 'CPU', 'Printer', 'Scanner', 'Webcam', 'Laptop', 'Router', 'Smartphone', 'Tablet', 'Smartwatch'],
    itemImages: ['keyboard.jpg', 'mouse.jpg', 'monitor.jpg', 'cpu.jpg', 'printer.jpg', 'scanner.jpg', 'webcam.jpg', 'laptop.jpg', 'router.jpg', 'smartphone.jpg', 'tablet.jpg', 'smartwatch.jpg'],
  ),
  Level(
    itemNames: ['Keyboard', 'Mouse', 'Monitor', 'CPU', 'Printer', 'Scanner', 'Webcam', 'Laptop', 'Router', 'Smartphone', 'Tablet', 'Smartwatch', 'External Hard Drive', 'Flash Drive', 'Graphic Tablet', 'Headphones'],
    itemImages: ['keyboard.jpg', 'mouse.jpg', 'monitor.jpg', 'cpu.jpg', 'printer.jpg', 'scanner.jpg', 'webcam.jpg', 'laptop.jpg', 'router.jpg', 'smartphone.jpg', 'tablet.jpg', 'smartwatch.jpg', 'external_hard_drive.jpg', 'flash_drive.jpg', 'graphic_tablet.jpg', 'headphones.jpg'],
  ),
  Level(
    itemNames: ['Keyboard', 'Mouse', 'Monitor', 'CPU', 'Printer', 'Scanner', 'Webcam', 'Laptop', 'Router', 'Smartphone', 'Tablet', 'Smartwatch', 'External Hard Drive', 'Flash Drive', 'Graphic Tablet', 'Headphones', 'Microphone', 'Projector', 'Speaker', 'VR Headset'],
    itemImages: ['keyboard.jpg', 'mouse.jpg', 'monitor.jpg', 'cpu.jpg', 'printer.jpg', 'scanner.jpg', 'webcam.jpg', 'laptop.jpg', 'router.jpg', 'smartphone.jpg', 'tablet.jpg', 'smartwatch.jpg', 'external_hard_drive.jpg', 'flash_drive.jpg', 'graphic_tablet.jpg', 'headphones.jpg', 'microphone.jpg', 'projector.jpg', 'speaker.jpg', 'vr_headset.jpg'],
  ),
];
