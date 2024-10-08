import 'package:flutter/material.dart';
import 'package:meetup/models/notification.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    required this.notification,
    Key? key,
  }) : super(key: key);

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Notification Details",
      showAppBar: true,
      showLeadingAction: true,
      body: SafeArea(
        child: VStack(
          [
            //title
            "${notification.title}"
                .text
                .bold
                .xl2
                .fontFamily(GoogleFonts.nunito().fontFamily!)
                .make(),
            //time
            notification.formattedTimeStamp.text.medium
                .color(Colors.grey)
                .fontFamily(GoogleFonts.nunito().fontFamily!)
                .make()
                .pOnly(bottom: 10),
            //body
            "${notification.body}"
                .text
                .lg
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .fontFamily(GoogleFonts.nunito().fontFamily!)
                .make(),
          ],
        ).p20().scrollVertical(),
      ),
    );
  }
}
