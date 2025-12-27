import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/assets/app_icons.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/di/injection.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/core/utils/token_service.dart';
import 'package:haru_pos/features/auth/presentation/bloc/auth_bloc.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetCurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DropdownButton2(
            items: [
              DropdownMenuItem(value: 'Uz', child: Text('Uz')),
              DropdownMenuItem(value: 'Ру', child: Text('Ру')),
            ],
            value: 'Ру',
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w600,
              color: Color(0xFF646464),
              fontSize: 14.0,
            ),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down, size: 12.0),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
            ),
            underline: SizedBox(),
            onChanged: (v) {},
          ),
          SizedBox(width: 30.0),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return CircularProgressIndicator.adaptive();
              } else if (state is AuthError) {
                return Text(state.message);
              } else if (state is UserLoaded) {
                final user = state.user;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user.image ?? '',
                        fit: BoxFit.cover,
                        width: 45,
                        height: 45,
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 22,
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 19.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF404040),
                          ),
                        ),
                        Text(
                          user.role.roleToString(),
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            color: Color(0xFF565656),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
          SizedBox(width: 30.0),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text("Chiqish"),
                  content: const Text("Haqiqatdan ham chiqmoqchimisiz?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      child: const Text("Bekor qilish"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await getIt<TokenService>().clearTokens();
                        context.replace(AppPages.auth);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text("Tasdiqlash"),
                    ),
                  ],
                ),
              );
            },
            icon: SvgPicture.asset(AppIcons.logout),
          ),
          SizedBox(width: 20.0),
        ],
      ),
    );
  }
}
