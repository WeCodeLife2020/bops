import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BuildPopupMenuButtonWidget extends StatefulWidget {
  const BuildPopupMenuButtonWidget(
      {super.key, required this.title, required this.onPress,required this.secondTitle,});
  final String title;
  final String secondTitle;
  final Function(int value) onPress;


  @override
  State<BuildPopupMenuButtonWidget> createState() =>
      _BuildPopupMenuButtonWidgetState();
}

class _BuildPopupMenuButtonWidgetState
    extends State<BuildPopupMenuButtonWidget> {
  bool isMenu = true;
  Widget build(BuildContext context) {
    return isMenu
        ? PopupMenuButton<int>(
            color: AppColors.blue20,
            iconColor: AppColors.moreButtonColor,
            itemBuilder: (context) => [
              // PopupMenuItem 1
              PopupMenuItem(
                  value: 1,
                  child: Center(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
              PopupMenuItem(
                  value: 2,
                  child: Center(
                    child: Text(
                      widget.secondTitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
            ],
            onSelected: (event) {
              widget.onPress(event);
              // push(context, const HelpCentreScreen());
            },
            offset: Offset(0, 40),
          )
        : IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_outlined,
              // color: AppColorDark.moreButtonColor,
            ),
          );
  }
}
