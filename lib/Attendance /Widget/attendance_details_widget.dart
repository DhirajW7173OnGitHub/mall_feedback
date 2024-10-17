import 'package:flutter/material.dart';

class AttendanceCardWidget extends StatelessWidget {
  const AttendanceCardWidget({
    super.key,
    required this.date,
    required this.startTime,
    required this.reportedTime,
    required this.endTime,
    required this.status,
    required this.userName,
  });

  final String userName;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String reportedTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // CircleAvatar(
                  //   maxRadius: 30,
                  //   child: Image.asset(
                  //     "assets/images/person.png",
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 6,
                  // ),
                  Text(
                    userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const Spacer(),
                  Container(
                    height: 24,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.16,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      border: Border.all(
                        color: Colors.purple,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Date : ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Start Time : ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    startTime,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "End Time : ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    endTime,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Reported Time : ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    reportedTime,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
