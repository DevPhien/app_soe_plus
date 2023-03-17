import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../../../component/use/inlineloadding.dart';
import 'commenttakscontroller.dart';
import 'itemcomment.dart';

class CommentTask extends StatelessWidget {
  CommentTask({Key? key}) : super(key: key);
  final CommentTaskController cmcontroller = Get.put(CommentTaskController());
  @override
  Widget build(BuildContext context) {
    TextStyle label = const TextStyle(color: Colors.black87, fontSize: 13);
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Wrap(
                children: [
                  const Icon(Feather.message_circle, size: 14),
                  const SizedBox(width: 10),
                  Text(
                    "Bình luận (${cmcontroller.comments.length})",
                    style: label,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            if (cmcontroller.isloadding.value) ...[
              const InlineLoadding()
            ] else ...[
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cmcontroller.comments.length,
                itemBuilder: (ct, i) =>
                    ItemCommentTask(item: cmcontroller.comments[i]),
              ),
            ],
          ],
        ));
  }
}
