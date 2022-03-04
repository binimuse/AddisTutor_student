import 'package:addistutor_student/Screens/Home/components/design_course_app_theme.dart';
import 'package:addistutor_student/constants.dart';

import 'package:flutter/material.dart';

class ProductDescriptionPage extends StatefulWidget {
  final String name, image;

  const ProductDescriptionPage({Key? key, this.name = '', this.image = ''})
      : super(key: key);
  @override
  _ProductDescriptionPageState createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  // initialize reusable widget

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 4);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Material(
            color: Colors.white,
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(AppBar().preferredSize.height),
              child: const Icon(
                Icons.arrow_back_ios,
                color: DesignCourseAppTheme.nearlyBlack,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Text(
            "Terms of Service ",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'WorkSans',
            ),
          ),
        ),
        body: ListView(
          children: [
            _createProductImageAndTitle(boxImageSize),
            Divider(height: 0, color: Colors.grey[400]),
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                '1. Payment \nAs soon as a tutor accepts your request, you are ecpected to finalise payment within 24 hrs. Failure to do so means NextGen won’t be able to guarantee the same tutor.\n\n'
                '2. Siblings\nA sibling can join a session provided that s/he is in the same category (KG, first cycle primary, second cycle primary, secondary or Preparatory) as the child to whom the service is requested. In such instances no additional payment is required. However, if the sibling is not in the same category or it is more than one sibling, a separate bookings needs to be made.\n\n'
                '3. Set up\nParents should prepare a proper study area, free from noise and other distractions. We recommend that sessions take place under adult supervision. Our tutors can wait a maximum of 20 minutes from the agreed start time in rare cases where children are not ready. If session starts more than 20 minutes later, the tutor has the right to finish the session at the originally agreed time and charge for the whole session. \n\n'
                '4. Confirmation of service delivery\n Parents have the responsibility to ensure that the QR code is available for scanning at the end of each session as a way of confirmation of service delivery. If the QR code is not scanned for any reason, the system will automatically assume that service has successfully been delivered and deduct payment from the available balance. If the tutor is absent, it is your responsibility to inform the office before the system automatically deducts from your balance. \n\n'
                '5. Cancellation and tardiness\n You can cancel or postpone a session 24 hours in advance at no cost. However, cancellations or postponements less than 24 hours will result in full charge for the planned sessions.  \n\n'
                '6. Treatment of tutors\nNo meals should be served during sessions. We expect that all our tutors will be accorded a professional treatment. Any mistreatment of tutors in any form by any member of the family won’t be tolerated and may result in the parent/child being suspended from service. Parents can report any concerns or misconduct on the part of the tutor to the office.\n\n'
                '7. Dressing code\nChildren should dress up in decency for their tutorial. A tutor has the right to ask a child to dress up properly or cancel a session. \n\n'
                '8. Liability\nNextGen tutors are screened for their competence and character. However, NextGen cannot be liable for any underperformance, damage or loss caused by its tutors. In no event shall the aggregate liability of NextGen exceed the amount you paid for a session. NextGen will strive to find a suitable replacement if you ask for it. \n\n'
                '9. Dealing with a tutor outside of the system\nAll dealings with a tutor should be done through NextGen. This includes schedule arrangement, additional bookings, payment, etc. If a parent deals with a tutor without the knowledge of the company, NextGen won’t take any responsibility whatsoever. Parents and tutors found doing this will be barred from using NextGen Tutorial Services. \n\n',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.4,
                  height: 0.9,
                  wordSpacing: 0.4,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ));
  }

  Widget _createProductImageAndTitle(boxImageSize) {
    return Container(
        margin: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: Image.asset('assets/images/lg3.png',
                    width: boxImageSize, height: boxImageSize)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Terms of service of tutors",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      height: 0.9,
                      color: kPrimaryColor,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
