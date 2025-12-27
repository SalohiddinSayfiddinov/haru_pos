import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/utils/date_extensions.dart';
import 'package:haru_pos/features/hall/domain/entities/table_entity.dart';
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart';
import 'package:haru_pos/features/hall/presentation/widgets/add_table_dialog.dart';
import 'package:haru_pos/features/hall/presentation/widgets/delete_reservation_dialog.dart';
import 'package:haru_pos/features/hall/presentation/widgets/delete_table_dialog.dart';
import 'package:haru_pos/features/hall/presentation/widgets/reserve_table_dialog.dart';

class TableCard extends StatelessWidget {
  final TableEntity table;

  const TableCard({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 341,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: table.status ? AppColors.primary : Color(0xFFAEAEAE),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Стол ${table.tableNumber}',
                style: GoogleFonts.inter(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.black),
                color: Colors.white,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Изменить',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 18, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Удалить',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _showEditTableDialog(context, table);
                      break;
                    case 'delete':
                      _showDeleteTableDialog(context, table);
                      break;
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 15.0),
          if (table.tableBooks.isNotEmpty)
            Text(
              'Забронирован',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          SizedBox(height: 5),
          ...table.tableBooks.map((item) {
            return Row(
              crossAxisAlignment: .start,
              mainAxisAlignment: .spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      '${item.dateAndTime.toRuFancy()}, ${item.fullName}\n${item.phoneNumber}',
                    ),
                    if (table.tableBooks.indexOf(item) !=
                        table.tableBooks.length - 1)
                      Divider(),
                  ],
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    onPressed: () {
                      _showDeleteReservationDialog(context, item.id);
                    },
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      shape: CircleBorder(
                        side: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    icon: Icon(Icons.remove, size: 14.0),
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: .end,
            children: [_buildTableStatus(context, table)],
          ),
        ],
      ),
    );
  }

  Widget _buildTableStatus(BuildContext context, TableEntity table) {
    return SizedBox(
      height: 30.0,
      child: ElevatedButton(
        onPressed: () {
          _showReserveTableDialog(context, table);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: table.status
              ? AppColors.primary
              : const Color(0xFF1BB90C),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          table.status ? 'Освободить' : 'Занять',
          style: GoogleFonts.inter(fontSize: 12.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showEditTableDialog(BuildContext context, TableEntity table) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<TableBloc>(),
        child: AddTableDialog(table: table),
      ),
    );
    if (result == true) {
      context.read<TableBloc>().add(LoadTablesEvent());
    }
  }

  void _showDeleteTableDialog(BuildContext context, TableEntity table) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<TableBloc>(),
        child: DeleteTableDialog(
          tableId: table.id,
          tableNumber: table.tableNumber,
        ),
      ),
    );

    if (result == true) {
      context.read<TableBloc>().add(LoadTablesEvent());
    }
  }

  void _showDeleteReservationDialog(BuildContext context, int bookId) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<TableBloc>(),
        child: DeleteReservationDialog(bookId: bookId),
      ),
    );

    if (result == true) {
      context.read<TableBloc>().add(LoadTablesEvent());
    }
  }

  void _showReserveTableDialog(BuildContext context, TableEntity table) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<TableBloc>(),
        child: ReserveTableDialog(table: table),
      ),
    );

    if (result == true) {
      context.read<TableBloc>().add(LoadTablesEvent());
    }
  }
}
