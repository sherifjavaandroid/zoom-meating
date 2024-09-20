import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/services/ai.service.dart';
import 'package:meetup/view_models/home.vm.dart';
import 'package:meetup/views/pages/ai.page.dart';
import 'package:meetup/views/pages/history.page.dart';
import 'package:meetup/views/pages/meeting/lounge.page.dart';
import 'package:meetup/views/pages/meeting/meeting.page.dart';
import 'package:meetup/views/pages/profile.page.dart';
import 'package:line_icons/line_icons.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      //History
      const HistoryPage(),
      //Meeting
      const MeetingPage(),
      //
      const LoungePage(),
      //profile
      const ProfilePage(),
    ];

    //
    List<GButton> _navBars = [
      GButton(
        icon: LineIcons.list,
        text: 'History'.tr(),
      ),
      GButton(
        icon: LineIcons.video,
        text: 'Meeting'.tr(),
      ),
      GButton(
        icon: LineIcons.globeWithAfricaShown,
        text: 'Lounge'.tr(),
      ),
      GButton(
        icon: LineIcons.user,
        text: 'Profile'.tr(),
      ),
    ];

    //if the any of the ai features is enabled
    if (ApiService().isAIChatEnabled ||
        ApiService().isAIImageGenerationEnabled) {
      //use the center index
      int newIndex = (_pages.length / 2).floor();
      _pages.insert(
        newIndex,
        const AIPage(),
      );
      _navBars.insert(
        newIndex,
        GButton(
          icon: LineIcons.robot,
          text: 'AI'.tr(),
        ),
      );
    }

    //
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _navBars[model.currentIndex].text,
            ),
          ),
          extendBody: true,
          body: SafeArea(
            child: Stack(
              children: [
                PageView(
                  controller: model.pageViewController,
                  onPageChanged: model.onPageChanged,
                  children: _pages,
                ),

                //ad
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: AdWidget(ad: model.myBanner!),
                    width: model.myBanner!.size.width.toDouble(),
                    height: model.myBanner!.size.height.toDouble(),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: VxBox(
              child: SafeArea(
                child: GNav(
                  gap: 8,
                  activeColor: Colors.white,
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  tabBorderRadius: 12,
                  duration: const Duration(milliseconds: 100),
                  tabBackgroundColor: context.accentColor,
                  tabs: _navBars,
                  selectedIndex: model.currentIndex,
                  onTabChange: model.onTabChange,
                ),
              ),
            )
                .padding(const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ))
                .shadow
                .withRounded(value: 15)
                .color(context.backgroundColor)
                .make(),
          ),
        );
      },
    );
  }
}
