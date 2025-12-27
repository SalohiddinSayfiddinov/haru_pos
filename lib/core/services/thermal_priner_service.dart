import 'dart:io';
import 'dart:typed_data';

import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/orders/domain/entities/orders_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class ThermalPrinterService {
  static const String printerIp = '192.168.0.8';
  static const int printerPort = 9100;
  static const int timeout = 5; // seconds

  // ESC/POS Commands
  static final Uint8List _init = Uint8List.fromList([0x1B, 0x40]);
  static final Uint8List _setCP866 = Uint8List.fromList([0x1B, 0x74, 0x11]);
  static final Uint8List _alignCenter = Uint8List.fromList([0x1B, 0x61, 0x01]);
  static final Uint8List _boldOn = Uint8List.fromList([0x1B, 0x45, 0x01]);
  static final Uint8List _boldOff = Uint8List.fromList([0x1B, 0x45, 0x00]);
  static final Uint8List _doubleOn = Uint8List.fromList([0x1D, 0x21, 0x11]);
  static final Uint8List _doubleOff = Uint8List.fromList([0x1D, 0x21, 0x00]);

  static final Uint8List _cutPaper = Uint8List.fromList([
    0x1D,
    0x56,
    0x41,
    0x00,
  ]);
  static final Uint8List _newLine = Uint8List.fromList([0x0A]);

  /// Print order receipt (Uzbek)
  Future<bool> printOrderBill(OrderEntity order) async {
    try {
      final socket = await Socket.connect(
        printerIp,
        printerPort,
        timeout: Duration(seconds: timeout),
      );

      final billData = _generateBillData(order);
      socket.add(billData);
      await socket.flush();
      await Future.delayed(Duration(milliseconds: 500));
      await socket.close();
      return true;
    } catch (e) {
      print('Printer error: $e');
      return false;
    }
  }

  Uint8List _generateBillData(OrderEntity order) {
    final buffer = BytesBuilder();

    // Init printer & CP866
    buffer.add(_init);
    buffer.add(_setCP866);

    // Header
    buffer.add(_alignCenter);
    buffer.add(_doubleOn);
    buffer.add(_boldOn);
    buffer.add(_encode('HARU'));
    buffer.add(_newLine);
    buffer.add(_doubleOff);
    buffer.add(_boldOff);
    buffer.add(_encode(_line(32)));
    buffer.add(_newLine);

    // Order info
    buffer.add(_encode('Buyurtma #${order.id}'));
    buffer.add(_newLine);
    buffer.add(_encode('Turi: ${order.type.typeToUz()}'));

    if (order.table != null) {
      buffer.add(_newLine);
      buffer.add(_encode('Stol: ${order.table!.tableNumber}'));
    }

    if (order.user != null) {
      buffer.add(_newLine);
      buffer.add(_encode('Xizmatchi: ${order.user!.username}'));
    }

    buffer.add(_newLine);
    buffer.add(_encode('Sana: ${_formatDateTime(order.createdAt)}'));
    buffer.add(_newLine);
    buffer.add(_encode(_line(32)));
    buffer.add(_newLine);

    // Items header
    buffer.add(_boldOn);
    buffer.add(
      _encode(
        _padRight('Mahsulot', 16) + _padLeft('Soni', 4) + _padLeft('Narxi', 12),
      ),
    );
    buffer.add(_newLine);
    buffer.add(_boldOff);
    buffer.add(_encode(_line(32)));
    buffer.add(_newLine);

    // Items
    for (final item in order.orderItems) {
      final name = item.product.nameUz.length > 16
          ? item.product.nameUz.substring(0, 16)
          : item.product.nameUz;

      buffer.add(
        _encode(
          _padRight(name, 16) +
              _padLeft('${item.amount}x', 4) +
              _padLeft('${item.amount * item.product.price}', 12),
        ),
      );
      buffer.add(_newLine);
    }

    buffer.add(_encode(_line(32)));
    buffer.add(_newLine);

    // Total
    buffer.add(_doubleOn);
    buffer.add(_boldOn);
    buffer.add(_alignCenter);
    buffer.add(_encode('JAMI: ${order.fullPrice.formatCurrencyUz()}'));
    buffer.add(_newLine);
    buffer.add(_doubleOff);
    buffer.add(_boldOff);
    buffer.add(_encode(_line(32)));
    buffer.add(_newLine);
    // Footer
    buffer.add(_alignCenter);
    buffer.add(_encode('Tashrifingiz uchun rahmat!'));
    buffer.add(_newLine);
    buffer.add(_encode('Yana kelishingizni kutamiz'));
    buffer.add(_newLine);
    buffer.add(_cutPaper);

    return buffer.toBytes();
  }

  /// Encode string to CP866
  Uint8List _encode(String text) {
    return Uint8List.fromList(_cp866Encode(text));
  }

  /// CP866 encoder with optional Russian uppercase
  List<int> _cp866Encode(String text) {
    final result = <int>[];
    for (final char in text.runes) {
      int code = char;
      // Russian letters: convert to uppercase
      if ((code >= 0x0410 && code <= 0x042F) ||
          (code >= 0x0430 && code <= 0x044F)) {
        code = code < 0x0430 ? code : code - 32; // lowercase → uppercase
      }

      // ASCII
      if (code < 128) {
        result.add(code);
      }
      // Cyrillic uppercase А-Я
      else if (code >= 0x0410 && code <= 0x042F) {
        result.add(code - 0x0410 + 0x80);
      } else {
        // Special characters
        switch (code) {
          case 0x0401: // Ё
            result.add(0xF0);
            break;
          case 0x2116: // №
            result.add(0xFC);
            break;
          default:
            result.add(0x3F); // ?
        }
      }
    }
    return result;
  }

  String _line(int length) => '-' * length;

  String _padRight(String text, int width) => text.length >= width
      ? text.substring(0, width)
      : text + ' ' * (width - text.length);

  String _padLeft(String text, int width) => text.length >= width
      ? text.substring(0, width)
      : ' ' * (width - text.length) + text;

  String _formatDateTime(DateTime dt) =>
      DateFormat('dd.MM.yyyy HH:mm').format(dt);
}
