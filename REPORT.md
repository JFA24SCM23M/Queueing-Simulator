# MP Report

## Team

- Name(s): Your Name(s)
- AID(s): A12345678

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The simulator builds without error
- [X] The simulator runs on at least one configuration file without crashing
- [X] Verbose output (via the `-v` flag) is implemented
- [X] I used the provided starter code
- The simulator runs correctly (to the best of my knowledge) on the provided configuration file(s):
  - [X] conf/sim1.yaml
  - [X] conf/sim2.yaml
  - [X] conf/sim3.yaml
  - [X] conf/sim4.yaml
  - [X] conf/sim5.yaml

## Summary and Reflection

### Notable Implementation Decisions and Additional Notes:
In my implementation of the queueing simulator, I prioritized the correct handling of event scheduling and wait times for various process types (singleton, periodic, and stochastic). A key decision was to ensure that event processing logic in `run()` was consistent across different process types, and verbose logging was controlled using the `-v` flag for detailed output. To handle the stochastic process, I introduced fixed values for testing to make the output deterministic during debugging and later ensured randomness could be controlled by setting a seed for the exponential distribution.

I also ensured that the event generation system worked as expected, with all events sorted by arrival time and processed accurately. Per-process statistics, along with summary statistics, were calculated based on the wait times of events. The verbose logging system was fully integrated, allowing detailed simulation trace output when required. Overall, the system behaves as intended, but I acknowledge that certain challenges around randomness in the stochastic process were resolved by using fixed seeds and testing values.

### Reflections:
I enjoyed working through the event-driven nature of the simulation and solving how to handle wait times and event overlaps efficiently. It was rewarding to see the per-process statistics and summary statistics reflect accurately in the output. However, one of the more challenging aspects was managing the randomness in the stochastic process, especially when trying to reproduce expected outputs during debugging. I wish I had known the importance of controlled randomness (e.g., fixed seeds) earlier, as it would have saved some time during testing. Overall, the modular nature of the design allowed for easier debugging and testing of individual components, which I appreciated.
