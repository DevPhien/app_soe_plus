import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:soe/views/request/comp/homerequest/detail/comment/commentrequestcontroller.dart';
import 'package:soe/views/request/comp/homerequest/detail/comment/itemcomment.dart';

class CommentRequest extends StatelessWidget {
  final CommentRequestController controller =
      Get.put(CommentRequestController());
  CommentRequest({Key? key}) : super(key: key);

  Widget commentWidget() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.comments.length,
      itemBuilder: (ct, i) => ItemCommentRequest(
        item: controller.comments[i],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const breakRow = SizedBox(height: 10);
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        breakRow,
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Wrap(
                        children: [
                          const Icon(Ionicons.chatbubbles_outline,
                              color: Colors.black87, size: 15),
                          const SizedBox(width: 10),
                          Text(
                            "Thảo luận (${controller.comments.length})",
                            style: label,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (controller.comments.isNotEmpty) ...[
                  breakRow,
                  commentWidget(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
