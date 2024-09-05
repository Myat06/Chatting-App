import 'package:flutter/material.dart';

class UserTitle extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final int unreadMessageCount;

  const UserTitle(
      {super.key,
      required this.text,
      required this.onTap,
      this.unreadMessageCount = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //icon
                const Icon(Icons.person),
                const SizedBox(width: 20),
                //user name
                Text(text)
              ],
            ),

            //unread count
            unreadMessageCount > 0
                ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: Text(
                          unreadMessageCount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
