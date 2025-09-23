
import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenu;
  final VoidCallback onSearch;
  final VoidCallback onCart;
  final Widget? logo;
  const AppHeader({super.key, required this.onMenu, required this.onSearch, required this.onCart, this.logo});

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.headerHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppDimens.headerHeight,
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: onMenu),
              Expanded(
                child: Center(child: logo ?? Text('NewYorkRents', style: Theme.of(context).textTheme.titleMedium)),
              ),
              IconButton(icon: const Icon(Icons.search), onPressed: onSearch),
              IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: onCart),
            ],
          ),
        ),
      ),
    );
  }
}
