[![test-and-deploy](https://github.com/walles/barnklocka2/actions/workflows/test-and-deploy.yaml/badge.svg)](https://github.com/walles/barnklocka2/actions/workflows/test-and-deploy.yaml)

# Johans Barnklocka II

## TODO
* At the same time
  * OK: Make it work at 229x352 window size
    * OK: Correct answer
    * OK: Incorrect answer
  * Make it work in a larger window
    * Correct answer
    * Incorrect answer
* Prevent the AM/PM text from wrapping on smaller displays, prefer shrinking the
  font size: https://pub.dev/packages/auto_size_text
* Test it on somebody
* ...
* Tune clock vs real-world clock image to make it readable and look nice
* Consider reenabling `avoid_print` in `analysis_options.yaml`
* Adapt clock and everything else to dark theme / light theme
* Enable the Go button and text field entry only when the text field contains a
  valid (although not necessarily correct) time

### DONE
* Set a random time on startup
* Add a text entry field for entering the digital time
* Add a "Go!" button next to the text entry field
* Add initial tests
* Make the tests pass
* Add CI running our tests
* If the text entry field is correct when the Go button is pressed, randomize a
  new time on the analog clock and clear the field
* If the text entry field is wrong when the Go button is pressed, highlight that
  somehow.
* Handle <https://github.com/furkantektas/analog_clock/issues/16>. Made my own
  clock.
* Show "First half of the day" / "Second half of the day" so that we don't have
  to guess
* Refocus text field after user presses Enter or clicks the Go! button
* Set up CI for deploying to GitHub pages
* Make it work at 262x352 window size. This emulates what I have on my phone
  with the keyboard up.
