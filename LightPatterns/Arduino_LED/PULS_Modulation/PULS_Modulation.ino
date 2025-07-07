const int outputPin = 8;           // Digital pin for output pulse
const unsigned long pulseWidth = 16; // pulse width in milliseconds (.017 s)
const unsigned long pulseInterval = 539;  // pulse width in milliseconds (.15 s) 

void setup() {
  pinMode(outputPin, OUTPUT);
  digitalWrite(outputPin, LOW);  // Start LOW
}

void loop() {
  digitalWrite(outputPin, HIGH);      // Start pulse
  delay(pulseWidth);      // Hold for 16.667 ms
  digitalWrite(outputPin, LOW);       // End pulse
  delay(539); // Wait until next pulse
}