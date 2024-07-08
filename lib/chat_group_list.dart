library chat_group_list;

import 'package:chat_group_list/src/model/message_item.dart';
import 'package:chat_group_list/src/presentation/data_separator.dart';
import 'package:chat_group_list/src/presentation/date_header.dart';
import 'package:chat_group_list/src/presentation/message_bubble.dart';
import 'package:flutter/material.dart';

export 'src/model/message_item.dart';

class ChatGroupList<T extends MessageItem> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) contentBuilder;
  final Widget Function(BuildContext context, DateTime data)? dataSeparatorBuilder;
  final Widget Function(BuildContext context, T item)? messageInformationBuilder;
  final double? maxWidth;
  final double? primaryRadius;
  final double? secondaryRadius;
  /// Отступы между сообщениями внутри одной группы
  final double verticalPaddingInGroup;
  final EdgeInsetsGeometry? contentPadding;
  final CustomPainter Function(BuildContext context, bool isMine)? tailBuilder;
  final Color mineBackgroundColor;
  final Color otherBackgroundColor;
  final ScrollController? controller;



  const ChatGroupList(
      {super.key,
      required this.items,
      required this.contentBuilder,
        this.dataSeparatorBuilder,
        this.messageInformationBuilder,
        this.maxWidth,
        this.primaryRadius,
        this.secondaryRadius,
        this.verticalPaddingInGroup=3,
        this.contentPadding,
        this.tailBuilder,
        this.mineBackgroundColor=Colors.blue,
        this.otherBackgroundColor=Colors.black26,
        this.controller
      });

  @override
  State<ChatGroupList> createState() => _ChatGroupListState<T>();
}

class _ChatGroupListState<T extends MessageItem> extends State<ChatGroupList<T>> {
  @override
  Widget build(BuildContext context) {
    List<_MessageGroup<T>> groupedMessages = groupMessages(widget.items);
    return ListView.builder(
      itemCount: groupedMessages.length,
      controller: widget.controller,
      //reverse: true,
      itemBuilder: (context, groupIndex) {
        _MessageGroup<T> group = groupedMessages[groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(groupIndex==0)
              widget.dataSeparatorBuilder?.call(context, group.date)??DateSeparator(date: group.date),
            if(groupIndex!=0 && group.date.day!=groupedMessages[groupIndex-1].date.day)
              widget.dataSeparatorBuilder?.call(context, group.date)??DateHeader(date: group.date),
            ...List.generate(group.messages.length, (index) {
              return MessageBubble<T>(
                isMine: group.messages[index].isMine,
                isFirst: index == 0,
                isLast: index == group.messages.length - 1,
                contentBuilder: widget.contentBuilder,
                item: group.messages[index],
                messageInformationBuilder: widget.messageInformationBuilder,
                primaryRadius: widget.primaryRadius??12,
                secondaryRadius: widget.secondaryRadius??6,
                verticalPaddingInGroup: widget.verticalPaddingInGroup,
                contentPadding: widget.contentPadding??const EdgeInsets.all(8),
                tailBuilder: widget.tailBuilder ??
                    (
                            (context, itsRight) => MessageTailPainter(
                                isMine: itsRight,
                                color: itsRight
                                    ? widget.mineBackgroundColor
                                    : widget.otherBackgroundColor
                            )
                    ),
                mineBackgroundColor: widget.mineBackgroundColor,
                otherBackgroundColor: widget.otherBackgroundColor,
              );
            }),
          ],
        );
      },
    );
  }
  List<_MessageGroup<T>> groupMessages<T extends MessageItem>(List<T> messages) {
    if (messages.isEmpty) return [];
    messages.sort((a, b) => a.date.compareTo(b.date));

    List<_MessageGroup<T>> groupedMessages = [];
    List<T> currentGroupMessages = [messages.first];
    DateTime currentGroupDate = messages.first.date;

    for (var i = 1; i < messages.length; i++) {
      if (messages[i].isMine != messages[i - 1].isMine ||
          messages[i].date.day != currentGroupDate.day ||
          messages[i].date.month != currentGroupDate.month ||
          messages[i].date.year != currentGroupDate.year) {
        groupedMessages.add(_MessageGroup(date: currentGroupDate, messages: currentGroupMessages));
        currentGroupDate = messages[i].date;
        currentGroupMessages = [messages[i]];
      } else {
        currentGroupMessages.add(messages[i]);
      }
    }
    groupedMessages.add(_MessageGroup(date: currentGroupDate, messages: currentGroupMessages));

    return groupedMessages;
  }
}


class _MessageGroup<T extends MessageItem>{
  final DateTime date;
  final List<T> messages;

  _MessageGroup({required this.date, required this.messages});
}



class MessageTailPainter extends CustomPainter {
  final bool isMine;
  final Color color;

  MessageTailPainter( {required this.isMine,required this.color,});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isMine) {
      path.moveTo(size.width, size.height);
      path.lineTo(size.width - 10, size.height - 10);
      path.lineTo(size.width - 10, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(10, size.height - 10);
      path.lineTo(10, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

