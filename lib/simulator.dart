import 'package:yaml/yaml.dart';
import 'processes.dart';

class Simulator {
  final bool verbose;
  final List<Process> processes = [];
  List<Event> allEvents = []; // To store all events for final statistics

  Simulator(YamlMap yamlData, {this.verbose = false}) {
    for (final name in yamlData.keys) {
      final fields = yamlData[name];
      switch (fields['type']) {
        case 'singleton':
          processes.add(
              SingletonProcess(name, fields['duration'], fields['arrival']));
          break;
        case 'periodic':
          processes.add(PeriodicProcess(
              name,
              fields['duration'],
              fields['interarrival-time'],
              fields['first-arrival'],
              fields['num-repetitions']));
          break;
        case 'stochastic':
          processes.add(StochasticProcess(
              name,
              fields['mean-duration'],
              fields['mean-interarrival-time'],
              fields['first-arrival'],
              fields['end']));
          break;
        default:
          throw ArgumentError('Unknown process type: ${fields['type']}');
      }
    }
  }

  void run() {
    List<Event> eventQueue = [];

    // Generate events from each process
    for (var process in processes) {
      eventQueue.addAll(process.generateEvents());
    }

    // Sort events by arrival time
    eventQueue.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));

    int currentTime =
        0; // Keeps track of the system's time as events are processed
    allEvents = []; // Initialize allEvents to store processed events

    // Simulate the queueing system
    for (var event in eventQueue) {
      // If the event arrives after the current time, jump to its arrival time
      if (event.arrivalTime > currentTime) {
        currentTime = event.arrivalTime;
      }

      // Set the event's start time
      event.startAt(currentTime);

      // Calculate wait time as the difference between the start time and arrival time
      int waitTime = event.startTime - event.arrivalTime;

      // Print detailed log showing event progress
      if (waitTime == 0) {
        print(
            't=$currentTime: ${event.processName}, duration ${event.duration} started '
            '(arrived @ ${event.arrivalTime}, no wait)');
      } else {
        print(
            't=$currentTime: ${event.processName}, duration ${event.duration} started '
            '(arrived @ ${event.arrivalTime}, waited $waitTime)');
      }

      // Move the current time forward by the event's duration
      currentTime += event.duration;

      // Add the event to allEvents for report generation later
      allEvents.add(event);
    }
  }

  void printReport() {
    // Per-process statistics
    final Map<String, List<Event>> eventsByProcess = {};

    for (var event in allEvents) {
      if (!eventsByProcess.containsKey(event.processName)) {
        eventsByProcess[event.processName] = [];
      }
      eventsByProcess[event.processName]!.add(event);
    }

    print("--------------------------------------------------------------");
    for (var processName in eventsByProcess.keys) {
      var events = eventsByProcess[processName]!;
      var totalWaitTime =
          events.fold<int>(0, (sum, event) => sum + event.waitTime);
      var avgWaitTime = totalWaitTime / events.length;

      print("$processName:");
      print("  Events generated:  ${events.length}");
      print("Total wait time:   ${totalWaitTime.toStringAsFixed(1)}");
      print("  Average wait time: ${avgWaitTime.toStringAsFixed(2)}\n");
    }

    // Summary statistics
    var totalNumEvents = allEvents.length;
    var totalWaitTime =
        allEvents.fold<int>(0, (sum, event) => sum + event.waitTime);
    var avgWaitTime = totalWaitTime / totalNumEvents;

    print("--------------------------------------------------------------");
    print("Total num events:  $totalNumEvents");
    print("Total wait time:   ${totalWaitTime.toStringAsFixed(1)}");
    print("Average wait time: ${avgWaitTime.toStringAsFixed(2)}");
  }
}
