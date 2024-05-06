import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/url_service.dart';

class LinkSection extends StatelessWidget {
  const LinkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            UrlService().launchUri();
          },
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.2,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(25)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: FaIcon(
                  FontAwesomeIcons.youtube,
                  color: Colors.white,
                )),
                Text(
                  'Go to Youtube',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: size.width * 0.4,
            height: size.height * 0.2,
            decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                borderRadius: BorderRadius.circular(25)),
            child: const Center(
                child: FaIcon(
              FontAwesomeIcons.share,
            )),
          ),
        ),
      ],
    );
  }
}
