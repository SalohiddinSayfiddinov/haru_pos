import 'dart:io';
import 'dart:typed_data';

import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class KitchenPrinterService {
  // Usually Kitchen printers have a different IP (e.g., ending in .200 or .9)
  static const String printerIp = '192.168.0.8';
  static const int printerPort = 9100;
  static const int timeout = 5;

  // ESC/POS Commands
  static final Uint8List _init = Uint8List.fromList([0x1B, 0x40]);
  static final Uint8List _setCP866 = Uint8List.fromList([0x1B, 0x74, 0x11]);
  static final Uint8List _alignCenter = Uint8List.fromList([0x1B, 0x61, 0x01]);
  static final Uint8List _alignLeft = Uint8List.fromList([0x1B, 0x61, 0x00]);

  // Font Sizes
  static final Uint8List _boldOn = Uint8List.fromList([0x1B, 0x45, 0x01]);
  static final Uint8List _boldOff = Uint8List.fromList([0x1B, 0x45, 0x00]);
  static final Uint8List _doubleOn = Uint8List.fromList([0x1D, 0x21, 0x11]);
  static final Uint8List _doubleHeight = Uint8List.fromList([
    0x1D,
    0x21,
    0x01,
  ]); // Just Height
  static final Uint8List _normalSize = Uint8List.fromList([0x1D, 0x21, 0x00]);

  static final Uint8List _cutPaper = Uint8List.fromList([
    0x1D,
    0x56,
    0x41,
    0x00,
  ]);
  static final Uint8List _newLine = Uint8List.fromList([0x0A]);

  // BUZZER / BEEP Command (Standard ESC/POS beep)
  // 0x1B 0x42 <count> <duration>
  static final Uint8List _beep = Uint8List.fromList([0x1B, 0x42, 0x03, 0x02]);

  /// Print Kitchen Order Ticket (KOT)
  Future<bool> printKitchenTicket(OrderEntity order) async {
    try {
      final socket = await Socket.connect(
        printerIp,
        printerPort,
        timeout: Duration(seconds: timeout),
      );

      final data = _generateKitchenData(order);
      socket.add(data);
      await socket.flush();
      await Future.delayed(Duration(milliseconds: 500));
      await socket.close();
      return true;
    } catch (e) {
      print('Kitchen Printer error: $e');
      return false;
    }
  }

  Uint8List _generateKitchenData(OrderEntity order) {
    final buffer = BytesBuilder();

    // 1. Initialize & Beep
    buffer.add(_init);
    buffer.add(_setCP866);
    buffer.add(_beep); // Alert the chef!

    // 3. Critical Info (Table & Type) - Make this HUGE
    buffer.add(_alignLeft);
    buffer.add(_doubleOn); // Big text
    buffer.add(_boldOn);

    print(order.table != null);
    if (order.table != null) {
      buffer.add(_encode('STOL: ${order.table!.tableNumber}'));
    } else {
      buffer.add(_encode(order.type.typeToUz().toUpperCase()));
    }

    buffer.add(_newLine);
    buffer.add(_normalSize);
    buffer.add(_boldOff);

    // 4. Order Meta (ID, Time, Waiter)
    buffer.add(_encode('Buyurtma: #${order.id}'));
    buffer.add(_newLine);
    buffer.add(_encode('Vaqt: ${_formatTime(order.createdAt)}'));
    buffer.add(_newLine);

    if (order.user != null) {
      buffer.add(_encode('Ofitsiant: ${order.user!.username}'));
      buffer.add(_newLine);
    }

    buffer.add(_encode(_line(32)));
    buffer.add(_newLine);

    // 5. Order Items (The Food)
    buffer.add(_alignLeft);

    for (final item in order.orderItems) {
      // 5.1 QUANTITY - Make it standout (Bold)
      buffer.add(_boldOn);
      buffer.add(_doubleHeight); // Taller text for readability
      buffer.add(_encode('${item.amount} x '));

      // 5.2 NAME - Standard width, but tall
      // We don't truncate names as aggressively in kitchen, they need to know what it is.
      // But we wrap if too long ideally, or just print full line.
      buffer.add(_encode('${item.product.nameUz}'));

      buffer.add(_normalSize);
      buffer.add(_boldOff);
      buffer.add(_newLine);

      // 5.3 Modifiers / Notes (Optional but recommended for kitchen)
      // If you have notes in your entity, print them here in small font.
      // if (item.notes != null) {
      //    buffer.add(_encode('   (${item.notes})'));
      //    buffer.add(_newLine);
      // }

      // Add a small spacing between items
      buffer.add(_newLine);
    }

    buffer.add(_encode(_line(32)));
    buffer.add(_newLine);

    // 6. Footer
    buffer.add(_cutPaper);

    return buffer.toBytes();
  }

  // --- Helpers (Reused from your existing service) ---

  Uint8List _encode(String text) {
    return Uint8List.fromList(_cp866Encode(text));
  }

  List<int> _cp866Encode(String text) {
    final result = <int>[];
    for (final char in text.runes) {
      int code = char;
      // Russian letters: convert to uppercase for consistency if needed,
      // or keep your existing logic.
      if ((code >= 0x0410 && code <= 0x042F) ||
          (code >= 0x0430 && code <= 0x044F)) {
        code = code < 0x0430 ? code : code - 32;
      }

      if (code < 128) {
        result.add(code);
      } else if (code >= 0x0410 && code <= 0x042F) {
        result.add(code - 0x0410 + 0x80);
      } else {
        switch (code) {
          case 0x0401:
            result.add(0xF0);
            break; // Ё
          case 0x2116:
            result.add(0xFC);
            break; // №
          default:
            result.add(0x3F); // ?
        }
      }
    }
    return result;
  }

  String _line(int length) => '-' * length;

  String _formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);
}
