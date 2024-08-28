import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/feedback/Model/feedback_model.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  List<bool> isCheckedList = [];

  Map<int, int> selectedRadioValues = {};

  String rating = "";

  @override
  void initState() {
    super.initState();
    globalBloc.doFetchFeedBackQueData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('SUBMIT'),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<FeedbackModel>(
            stream: globalBloc.getFeedbackQueData.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Data"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (context, index) {
                    var feedbackData = snapshot.data!.data[index];
                    Widget answerWidget;

                    // Initialize the isCheckedList based on the number of options for Checkbox type
                    if (feedbackData.answerType == 'Checkbox' &&
                        isCheckedList.length != feedbackData.options.length) {
                      isCheckedList =
                          List<bool>.filled(feedbackData.options.length, false);
                    }

                    // Check the type of question and create the appropriate input widget
                    switch (feedbackData.answerType) {
                      case 'TextBox':
                        answerWidget = const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your answer',
                              contentPadding: EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        );
                        break;
                      case 'Checkbox':
                        answerWidget = Column(
                            children: feedbackData.options
                                .asMap()
                                .entries
                                .map<Widget>((entry) {
                          int optionIndex = entry.key;
                          var option = entry.value;
                          return CheckboxListTile(
                            title: Text(option.optionText),
                            value: isCheckedList[optionIndex],
                            activeColor: Colors.purple,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedList[optionIndex] = value!;
                                log('Is checked Click : ${isCheckedList[optionIndex]}');
                              });
                            },
                          );
                        }).toList());
                        break;
                      case 'Radio Button':
                        answerWidget = Column(
                            children:
                                feedbackData.options.map<Widget>((option) {
                          return RadioListTile(
                            title: Text(option.optionText),
                            value: option.id,
                            groupValue: selectedRadioValues[index],
                            onChanged: (int? value) {
                              setState(() {
                                selectedRadioValues[index] = value!;
                              });
                              log('Selected Radio Button: ${selectedRadioValues[index]}');
                            },
                          );
                        }).toList());
                        break;
                      case 'Stars':
                        answerWidget = Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(5, (starIndex) {
                            return IconButton(
                              icon: Icon(
                                starIndex < 0 ? Icons.star : Icons.star_border,
                              ),
                              onPressed: () {},
                            );
                          }),
                        );
                        break;
                      case 'Smiley':
                        answerWidget = Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(Icons.sentiment_very_dissatisfied),
                            Icon(Icons.sentiment_dissatisfied),
                            Icon(Icons.sentiment_neutral),
                            Icon(Icons.sentiment_satisfied),
                            Icon(Icons.sentiment_very_satisfied),
                          ].map<Widget>((icon) {
                            return IconButton(
                              icon: icon,
                              onPressed: () {
                                // Handle smiley selection
                              },
                            );
                          }).toList(),
                        );
                        break;
                      default:
                        answerWidget = const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  feedbackData.questions,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              answerWidget, // Add the input widget below the question
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
