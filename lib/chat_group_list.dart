library chat_group_list;

import 'package:flutter/material.dart';

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
        this.contentPadding
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
      reverse: true,
      itemBuilder: (context, groupIndex) {
        _MessageGroup<T> group = groupedMessages[groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
class DateHeader extends StatelessWidget {
  final DateTime date;

  const DateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          date.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}
class DateSeparator extends StatelessWidget {
  final DateTime date;

  DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: Text(
        '${date.day}-${date.month}-${date.year}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
class MessageItem{
  final String message;
  final DateTime date;
  final bool isMine;


  MessageItem( {required this.message, required this.date,this.isMine=true});
}
class _MessageGroup<T extends MessageItem>{
  final DateTime date;
  final List<T> messages;

  _MessageGroup({required this.date, required this.messages});
}

class MessageBubble<T extends MessageItem> extends StatelessWidget {
  final Widget Function(BuildContext context, T item) contentBuilder;
  final Widget Function(BuildContext context, T item)? messageInformationBuilder;

  final double? maxWidth;

  final double primaryRadius;
  final double secondaryRadius;
  final double verticalPaddingInGroup;
  final EdgeInsetsGeometry contentPadding;


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
                color: isMine ? Colors.blue : Colors.grey,
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
                  painter: MessageTailPainter(isMine: isMine),
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


class MessageTailPainter extends CustomPainter {
  final bool isMine;

  MessageTailPainter({required this.isMine});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isMine ? Colors.blue : Colors.grey
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

