import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_pos/core/assets/app_icons.dart';
import 'package:haru_pos/core/assets/app_images.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/widgets/app_header.dart';
import 'package:haru_pos/core/routes/app_pages.dart';

class HomeScaffold extends StatefulWidget {
  final Widget body;
  final EdgeInsets? padding;
  const HomeScaffold({super.key, required this.body, this.padding});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  late String _currentUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUrl = GoRouterState.of(context).uri.toString();
  }

  void _onTap(String page) {
    if (_currentUrl != page) {
      context.go(page);
    }
  }

  final List<_Helper> pages = [
    _Helper(
      name: "Главный панель",
      path: AppPages.dashboard,
      icon: AppIcons.main,
    ),
    _Helper(
      name: "Категории",
      path: AppPages.categories,
      icon: AppIcons.categories,
    ),
    _Helper(name: "Продукты", path: AppPages.products, icon: AppIcons.products),
    _Helper(name: "Зал", path: AppPages.hall, icon: AppIcons.hall),
    _Helper(name: "Заказы", path: AppPages.orders, icon: AppIcons.orders),
    _Helper(
      name: "Сотрудники",
      path: AppPages.employees,
      icon: AppIcons.employees,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            color: Colors.white,
            width: 240.0,
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Image.asset(AppImages.logo, height: 60),
                const SizedBox(height: 32),

                // Navigation items
                Expanded(
                  child: ListView(
                    children: pages.map((page) {
                      final isActive = location == page.path;
                      return ListTile(
                        leading: SvgPicture.asset(
                          page.icon,
                          colorFilter: ColorFilter.mode(
                            isActive
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: Text(
                          page.name,
                          style: TextStyle(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selected: isActive,
                        selectedTileColor: AppColors.primary.withValues(
                          alpha: .1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () => _onTap(page.path),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Helper {
  final String name;
  final String path;
  final String icon;

  const _Helper({required this.name, required this.path, required this.icon});
}
