
import 'package:alarmappforufs/presentation/provider/alarm_main_provider/alarm_main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class AlarmMainScreen extends StatefulWidget {
  const AlarmMainScreen({super.key});

  @override
  State<AlarmMainScreen> createState() => _AlarmMainScreenState();
}

class _AlarmMainScreenState extends State<AlarmMainScreen> {
  @override
  void initState() {

    context.read<AlarmMainScreenProvder>().init();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<AlarmMainScreenProvder>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.alarm),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Alarm",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _listView(context,provider)
              )
            ],
          ),
        );
      }),
      floatingActionButton: _floatingAction(context),
    );
  }

  Widget _listView(context,AlarmMainScreenProvder provider)=>ListView.builder(
      itemCount: provider.alarmList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).cardColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd – KK:mm')
                          .format(DateTime.parse(provider
                          .alarmList[index].alarmtime))
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    Text(provider.alarmList[index].label),
                    Row(
                      children: [
                        Text(
                          "Ring in ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TimerCountdown(
                            spacerWidth: 0,
                            endTime: DateTime.parse(provider
                                .alarmList[index].alarmtime),
                            format: CountDownTimerFormat
                                .hoursMinutes,
                            enableDescriptions: true,
                            onEnd: (){
                              provider.showAlarm(index,provider.alarmList[index].label);
                              provider.init();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.alarm_off),
                  onPressed: () {
                    provider.removeAlarm(index);
                  })
            ],
          ),
        ),
      ));

  Widget _floatingAction(context) => Consumer<AlarmMainScreenProvder>(builder: (context, provider, _) {
    return FloatingActionButton(

      child: const Icon(Icons.alarm_add_outlined),
      onPressed: () async {
        DateTime? dateTime = await showOmniDateTimePicker(
          context: context,
          firstDate: DateTime.now(),
        );
        if (dateTime!.isBefore(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Select a future time")));
          return;
        }
        final formKey = GlobalKey<FormState>();
        Future.microtask((){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: provider.labelController,
                        decoration: InputDecoration(
                          label: Text(
                            "label",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? "Enter a label" : null,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              context
                                  .read<AlarmMainScreenProvder>()
                                  .setAlarm(dateTime.toString(),
                                  provider.labelController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Done"))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  });
}
