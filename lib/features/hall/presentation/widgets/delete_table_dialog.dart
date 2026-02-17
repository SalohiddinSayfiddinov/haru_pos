import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart';

class DeleteTableDialog extends StatelessWidget {
  final int tableId;
  final int tableNumber;

  const DeleteTableDialog({
    super.key,
    required this.tableId,
    required this.tableNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TableBloc>(),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          LocaleKeys.hall_delete_table_title.tr(),
          style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        content: Text(
          LocaleKeys.hall_delete_table_confirmation.tr(
            args: [tableNumber.toString()],
          ),
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleKeys.hall_cancel.tr(),
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          BlocConsumer<TableBloc, TableState>(
            listener: (context, state) {
              if (state is TableOperationSuccess) {
                Navigator.pop(context, true);
              } else if (state is TableError) {
                AppSnackbar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is TableLoading
                    ? null
                    : () {
                        context.read<TableBloc>().add(
                          DeleteTableEvent(tableId),
                        );
                      },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(
                  state is TableLoading
                      ? LocaleKeys.hall_deleting.tr()
                      : LocaleKeys.hall_delete.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
