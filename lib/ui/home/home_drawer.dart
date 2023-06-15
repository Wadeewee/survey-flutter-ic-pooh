import 'package:flutter/material.dart';
import 'package:survey_flutter_ic/extension/context_extension.dart';
import 'package:survey_flutter_ic/gen/assets.gen.dart';
import 'package:survey_flutter_ic/gen/colors.gen.dart';
import 'package:survey_flutter_ic/theme/dimens.dart';
import 'package:survey_flutter_ic/ui/home/home_widget_id.dart';

class HomeDrawer extends StatelessWidget {
  final String name;
  final String avatar;
  final VoidCallback onSignOutPressed;

  const HomeDrawer({
    super.key,
    required this.name,
    required this.avatar,
    required this.onSignOutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorName.eerieBlack,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: space40,
            bottom: space20,
            left: space20,
            right: space20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      key: HomeWidgetId.signOutProfileName,
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: fontSize34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: space10),
                  CircleAvatar(
                    key: HomeWidgetId.signOutProfileAvatar,
                    backgroundColor: Colors.white,
                    radius: circleAvatarProfileSize / 2,
                    backgroundImage: avatar.isEmpty
                        ? Assets.images.placeholderAvatar.image().image
                        : FadeInImage.assetNetwork(
                            placeholder: Assets.images.placeholderAvatar.path,
                            image: avatar,
                          ).image,
                  ),
                ],
              ),
              const SizedBox(
                key: HomeWidgetId.signOutDivider,
                height: space50,
                child: Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
              ),
              TextButton(
                key: HomeWidgetId.signOutTextButton,
                onPressed: () => onSignOutPressed.call(),
                child: Text(
                  context.localization.home_sign_out,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: fontSize20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
