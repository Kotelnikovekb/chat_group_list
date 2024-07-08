import 'package:flutter/material.dart';

import '../../chat_group_list.dart';

class MessageBubble<T extends MessageItem> extends StatelessWidget {
  final Widget Function(BuildContext context, T item) contentBuilder;
  final Widget Function(BuildContext context, T item)? messageInformationBuilder;
  // отвечает за отрисовку хвоста у сообщения
  final CustomPainter Function(BuildContext context, bool itsRight) tailBuilder;

  final double? maxWidth;

  final double primaryRadius;
  final double secondaryRadius;
  final double verticalPaddingInGroup;
  final EdgeInsetsGeometry contentPadding;
  final Color mineBackgroundColor;
  final Color otherBackgroundColor;


  final bool isMine;
  final bool isFirst;
  final bool isLast;
  final T item;

  const MessageBubble({
    super.key,
    required this.isMine,
    required this.isFirst,
    required this.isLast,
    required this.contentBuilder,
    required this.item,
    this.messageInformationBuilder,
    this.maxWidth,
    this.primaryRadius=12,
    this.secondaryRadius=6,
    required this.verticalPaddingInGroup,
    required this.contentPadding,
    required this.tailBuilder, required this.mineBackgroundColor, required this.otherBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    bool needTail=false;
    if (isFirst && isLast) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(primaryRadius),
        topRight: Radius.circular(primaryRadius),
        bottomLeft: Radius.circular(isMine ? primaryRadius : 0),
        bottomRight: Radius.circular(isMine ? 0 : primaryRadius),
      );
      needTail=true;
    } else if (isFirst) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(primaryRadius),
        topRight: Radius.circular(primaryRadius),
        bottomLeft: Radius.circular(isMine ? primaryRadius : secondaryRadius),
        bottomRight: Radius.circular(isMine ? secondaryRadius : primaryRadius),
      );
    } else if (isLast) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(primaryRadius),
        topRight: Radius.circular(primaryRadius),
        bottomLeft: Radius.circular(isMine ? primaryRadius : 0),
        bottomRight: Radius.circular(isMine ? 0 : primaryRadius),
      );
      needTail=true;

    } else {
      borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(isMine ? primaryRadius : secondaryRadius),
        bottomRight: Radius.circular(isMine ? secondaryRadius : primaryRadius),
        topLeft: Radius.circular(isMine ? primaryRadius : secondaryRadius),
        topRight: Radius.circular(isMine ? secondaryRadius : primaryRadius),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPaddingInGroup),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth??MediaQuery.of(context).size.width*0.8,
              ),
              margin: isMine ? EdgeInsets.only(right: 10) : EdgeInsets.only(left: 10),
              padding: contentPadding,
              decoration: BoxDecoration(
                color: isMine ? mineBackgroundColor : otherBackgroundColor,
                borderRadius: borderRadius,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: (isMine)? CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: [
                  contentBuilder.call(context,item),
                  if(messageInformationBuilder!=null)
                    messageInformationBuilder!.call(context,item)
                ],
              ),
            ),
            if(needTail)
              Positioned(
                right: isMine ? 0 : null,
                left: isMine ? null : 0,
                bottom: 0,
                child: CustomPaint(
                  painter: tailBuilder.call(context,isMine),
                  child: SizedBox(
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
