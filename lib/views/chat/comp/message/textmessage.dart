import 'package:flutter/material.dart';
import 'package:soe/plugin/EmojiTextSpan.dart';
import 'package:soe/utils/golbal/golbal.dart';
import 'package:soe/views/component/Html/flutter_html.dart';

class TextMessage extends StatelessWidget {
  final dynamic message;
  const TextMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget prviewLink(String nd) {
    //   final urlRegExp = RegExp(
    //       r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    //   final urlMatches = urlRegExp.allMatches(nd);
    //   List<String> urls = urlMatches
    //       .map((urlMatch) => nd.substring(urlMatch.start, urlMatch.end))
    //       .toList();
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Linkable(text: nd),
    //       const SizedBox(height: 10),
    //       ListView.builder(
    //           shrinkWrap: true,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemBuilder: (ct, i) => InkWell(
    //                 // onTap: () {
    //                 //   launchUrl(urls[i]);
    //                 // },
    //                 child: FlutterLinkPreview(
    //                   url: urls[i],
    //                   titleStyle: const TextStyle(
    //                     color: Colors.blue,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //           itemCount: urls.length),
    //     ],
    //   );
    // }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: (message["noiDung"] ?? "").toString().contains("img")
          ? Html(
              data: message["noiDung"] ?? "",
              padding: const EdgeInsets.all(8.0),
              api: Golbal.congty!.api,
            )
          : RichText(
              textAlign: TextAlign.left,
              text: EmojiTextSpan(
                text: message["noiDung"] ?? "",
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black87,
                ),
              ),
            ),
    );
  }
}
