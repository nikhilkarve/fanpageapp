import 'package:flutter/material.dart';

class MessageDesign extends StatelessWidget {
  MessageDesign(this.message, this.dateMessage);
  final String message;
  final String dateMessage;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: 120,
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: 'Raleway'),
            ),
            Text(
                //format
                //      .format(documents[index]['createdAt']
                //        .toDate())
                //  .toString() ??
                dateMessage,
                textAlign: TextAlign.end,
                style:
                    const TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
          ],
        ));
  }
}
