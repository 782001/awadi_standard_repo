import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_standred/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:new_standred/features/theme/presentation/cubit/theme_state.dart';

class ThemeSwitchListTile extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;

  const ThemeSwitchListTile({
    super.key,
    this.title = 'Dark Mode',
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return ListTile(
          leading: leadingIcon != null ? Icon(leadingIcon) : null,
          title: Text(title),
          trailing: Switch.adaptive(
            value: isDark,
            onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
            activeColor: Theme.of(context).primaryColor,
          ),
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }
}
