import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart';

class DeleteReservationDialog extends StatelessWidget {
  final int bookId;

  const DeleteReservationDialog({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TableBloc>(),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Отменить брон?',
          style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Нет',
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
                          DeleteTableBookEvent(bookId),
                        );
                      },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(
                  state is TableLoading ? 'Отменение...' : 'Да',
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
