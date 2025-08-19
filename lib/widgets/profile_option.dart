import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLast;
  final bool isDestructive;

const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLast = false,
    this.isDestructive = false,
  });
@override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final destructiveColor = Colors.red[700];

return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: isDestructive ? destructiveColor : theme.iconTheme.color,
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              color: isDestructive
                  ? destructiveColor
                  : theme.textTheme.bodyLarge?.color,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
           color: theme.iconTheme.color?.withAlpha(153),
            size: 16,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            color: theme.dividerColor,
            height: 1,
           indent: 20,
            endIndent: 20,
          ),
      ],
    );
}
}