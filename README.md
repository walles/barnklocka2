[![test-and-deploy](https://github.com/walles/barnklocka2/actions/workflows/test-and-deploy.yaml/badge.svg)](https://github.com/walles/barnklocka2/actions/workflows/test-and-deploy.yaml)

# Johans Barnklocka II

Run it here: <https://walles.github.io/barnklocka2>

## TODO

- Show progress while playing, are we there yet?
- Tune clock vs real-world clock image to make it readable and look nice
- Consider reenabling `avoid_print` in `analysis_options.yaml`
- Enable the Go! button and text field entry only when the text field contains a
  valid (although not necessarily correct) time

### DONE

- Set a random time on startup
- Add a text entry field for entering the digital time
- Add a "Go!" button next to the text entry field
- Add initial tests
- Make the tests pass
- Add CI running our tests
- If the text entry field is correct when the Go button is pressed, randomize a
  new time on the analog clock and clear the field
- If the text entry field is wrong when the Go button is pressed, highlight that
  somehow.
- Handle <https://github.com/furkantektas/analog_clock/issues/16>. Made my own
  clock.
- Show "First half of the day" / "Second half of the day" so that we don't have
  to guess
- Refocus text field after user presses Enter or clicks the Go! button
- Set up CI for deploying to GitHub pages
- Make it work at 262x352 window size. This emulates what I have on my phone
  with the keyboard up.
- At the same time
  - OK: Make it work at 229x352 window size
    - OK: Correct answer
    - OK: Incorrect answer
  - OK: Make it work in a larger window
    - OK: Correct answer
    - OK: Incorrect answer
- Test it on somebody
- Prevent the AM/PM text from wrapping on smaller displays, prefer shrinking the
  font size: https://pub.dev/packages/auto_size_text
- Choose among whole hours, half hours, quarters, five minute spans or one
  minute spans. Pick easier flavors more often.
- Start screen: Show stats for the most recent round. How many
  correct-at-first-attempt answers and how long it took.
- Start screen: Before the first round, when we don't have any existing stats,
  center the start button vertically and make it fill all space horizontally.
- Start screen: Show a top 5 list and the result of the most recent round.
  Primary sort key is number of correct-on-first-attempt answers, secondary is
  how long it took.
- Make the game 10 rounds
- For the 10 rounds:
  - 1, 2 and 3: Whole hours
  - 4, 5: Half hours
  - 6, 7: Quarters
  - 8, 9: Five minute intervals
  - 10: One minute intervals
- Persist top 5 list between page reloads / app restarts
- Adapt clock and everything else to dark theme / light theme
