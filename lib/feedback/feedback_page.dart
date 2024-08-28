import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Validation/validation_mixin.dart';
import 'package:mall_app/feedback/Model/feedback_model.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> with ValidationMixin {
  final _mobileFormKey = GlobalKey<FormState>();

  List<bool> isCheckedList = [];

  Map<int, int> selectedRadioValues = {};

  int selectedStars = 0;
  int selectedSmiley = -1;

  int? rating;

  @override
  void initState() {
    super.initState();
    globalBloc.doFetchFeedBackQueData();
  }

  selectEmojiFeedback(int index) {
    switch (index) {
      case 1:
        return "Terrible";
      case 2:
        return "Bad";
      case 3:
        return "Good";
    }
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
                    // Widget answerWidget;

                    // Initialize the isCheckedList based on the number of options for Checkbox type
                    if (feedbackData.answerType == 'Checkbox' &&
                        isCheckedList.length != feedbackData.options.length) {
                      isCheckedList =
                          List<bool>.filled(feedbackData.options.length, false);
                    }

                    // Initialize answerWidget to a default widget
                    Widget answerWidget = const SizedBox.shrink();

                    // Check the type of question and create the appropriate input widget
                    switch (feedbackData.answerType) {
                      case 'TextBox':
                        switch (feedbackData.inputType) {
                          case "text":
                            answerWidget = const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  hintText: 'Enter your answer',
                                  contentPadding: EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            );
                            break;
                          case "number":
                            answerWidget = Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Form(
                                key: _mobileFormKey,
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your answer',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: phoneValidation,
                                  onChanged: (value) {
                                    _mobileFormKey.currentState!.validate();
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                            break;
                        }
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
                                isCheckedList = List<bool>.filled(
                                    feedbackData.options.length, false);
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
                              iconSize: 32,
                              icon: Icon(
                                starIndex < selectedStars
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                              color: starIndex < selectedStars
                                  ? Colors.purple
                                  : Colors.grey,
                              onPressed: () {
                                setState(() {
                                  selectedStars = starIndex + 1;
                                });
                                log('Selected Stars: $selectedStars');
                              },
                            );
                          }),
                        );
                        break;

                      case 'Smiley':
                        answerWidget = EmojiFeedback(
                          elementSize: 40,
                          labelTextStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w400),
                          onChanged: (value) {
                            log('!!!!!!!!:$value');
                          },
                        );
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Icons.sentiment_very_dissatisfied,
                        //     Icons.sentiment_dissatisfied,
                        //     Icons.sentiment_neutral,
                        //     Icons.sentiment_satisfied,
                        //     Icons.sentiment_very_satisfied,
                        //   ].asMap().entries.map<Widget>((entry) {
                        //     int smileyIndex = entry.key;
                        //     IconData icon = entry.value;
                        //     return IconButton(
                        //       iconSize: 40,
                        //       icon: Icon(
                        //         icon,
                        //         color: smileyIndex == selectedSmiley
                        //             ? Colors.purple
                        //             : Colors.grey,
                        //       ),
                        //       onPressed: () {
                        //         setState(() {
                        //           selectedSmiley = smileyIndex;
                        //         });
                        //         log('Selected Smiley: $selectedSmiley');
                        //       },
                        //     );
                        //   }).toList(),
                        // );
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
