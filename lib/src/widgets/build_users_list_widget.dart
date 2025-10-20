import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:flutter/material.dart';

class BuildUsersListWidget extends StatefulWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String accountType;
  const BuildUsersListWidget({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.accountType,
  });

  @override
  State<BuildUsersListWidget> createState() => _BuildUsersListWidgetState();
}

class _BuildUsersListWidgetState extends State<BuildUsersListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: screenWidth(context),
        decoration: BoxDecoration(
          color: AppColors.managersScreenListItemContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Flexible(
                          child: Text(
                            widget.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    (widget.phoneNumber.isEmpty || widget.phoneNumber == "")
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              BuildSvgIcon(
                                assetImagePath: AppAssets.phoneIcon,
                                iconHeight: 15,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.phoneNumber,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                    (widget.phoneNumber.isEmpty || widget.phoneNumber == "")
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 6),
                    Row(
                      children: [
                        BuildSvgIcon(
                          assetImagePath: AppAssets.mailIcon,
                          iconHeight: 15,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.email,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    (widget.address.isEmpty || widget.address == "")
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              BuildSvgIcon(
                                assetImagePath: AppAssets.locationIcon,
                                iconHeight: 15,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.address,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(widget.accountType),
            ],
          ),
        ),
      ),
    );
  }
}
