import 'package:flutter/material.dart';
import 'package:theme_looks/functions/custom_size.dart';
import 'package:theme_looks/variables/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeveloperInfo extends StatefulWidget {
  const DeveloperInfo({Key? key}) : super(key: key);

  @override
  _DeveloperInfoState createState() => _DeveloperInfoState();
}

class _DeveloperInfoState extends State<DeveloperInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Developer Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Email',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenSize(context, .05)),
            ),
            InkWell(
              onTap: () {
                String url =
                    "mailto:masihur96@gmail.com?subject=Greetings&body=Write Something Here";

                _launchURL(url);
              },
              child: Text(
                'masihur96@gmail.com',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: screenSize(context, .04)),
              ),
            ),
            SizedBox(height: screenSize(context, .04)),
            Text(
              'Phone No',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenSize(context, .05)),
            ),
            InkWell(
              onTap: () {
                String url = 'tel:01740719204';
                _launchURL(url);
              },
              child: Text(
                '01740719204',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: screenSize(context, .04)),
              ),
            ),
            SizedBox(height: screenSize(context, .04)),
            Text(
              'Address',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenSize(context, .05)),
            ),
            Text(
              'Gazipur, Dhaka',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: screenSize(context, .04)),
            ),
            SizedBox(
              height: screenSize(context, .05),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      String url =
                          'https://www.facebook.com/people/HM-Sumon/100011385289585/';
                      _launchURL(url);
                    },
                    child: const Icon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                    )),
                InkWell(
                    onTap: () {
                      _launchURL(
                          'https://www.linkedin.com/in/masihur-rohman-279b201b6/');
                    },
                    child: Icon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.blue,
                    )),
                InkWell(
                    onTap: () {
                      _launchURL('https://github.com/masihur96');
                    },
                    child: Icon(
                      FontAwesomeIcons.github,
                      color: Colors.black87,
                    )),
              ],
            )
          ],
        ),
      ),
    ));
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
