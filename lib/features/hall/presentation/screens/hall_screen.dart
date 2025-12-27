import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/features/hall/presentation/bloc/table_bloc.dart';
import 'package:haru_pos/features/hall/presentation/widgets/add_table_dialog.dart';
import 'package:haru_pos/features/hall/presentation/widgets/table_card.dart';

class HallScreen extends StatefulWidget {
  const HallScreen({super.key});

  @override
  State<HallScreen> createState() => _HallScreenState();
}

class _HallScreenState extends State<HallScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TableBloc>().add(LoadTablesEvent());
  }

  void _showAddTableDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => getIt<TableBloc>(),
        child: const AddTableDialog(),
      ),
    );
    if (result == true && mounted) {
      context.read<TableBloc>().add(LoadTablesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TableBloc, TableState>(
      listener: (context, state) {
        if (state is TableError) {
          AppSnackbar.error(context, state.message);
        } else if (state is TableOperationSuccess) {
          AppSnackbar.success(context, state.message);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Зал',
                    style: GoogleFonts.inter(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PrimaryButton(
                    height: 30.0,
                    textStyle: GoogleFonts.montserrat(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    title: 'Добавить стол',
                    onPressed: _showAddTableDialog,
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              _buildTablesGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTablesGrid() {
    return BlocBuilder<TableBloc, TableState>(
      builder: (context, state) {
        if (state is TableLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TableError) {
          return Center(
            child: Column(
              children: [
                Text(
                  'Ошибка загрузки столов',
                  style: GoogleFonts.inter(fontSize: 16.0, color: Colors.red),
                ),
                const SizedBox(height: 10.0),
                PrimaryButton(
                  title: 'Попробовать снова',
                  onPressed: () {
                    context.read<TableBloc>().add(LoadTablesEvent());
                  },
                ),
              ],
            ),
          );
        }

        if (state is TablesLoaded) {
          final tables = state.tables;

          if (tables.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(
                    'Столы не найдены',
                    style: GoogleFonts.inter(fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  PrimaryButton(
                    title: 'Добавить стол',
                    onPressed: _showAddTableDialog,
                  ),
                ],
              ),
            );
          }

          return Wrap(
            spacing: 25.0,
            runSpacing: 25.0,
            children: tables.map((table) {
              return TableCard(table: table);
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
