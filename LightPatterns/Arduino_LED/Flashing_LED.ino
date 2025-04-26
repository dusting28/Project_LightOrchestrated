const int ledPin = 11;  // Use a PWM-capable pin
const int numPulses = 100;
const float pulseWidthMs = 1000.0 / 120.0;  // ~8.33 ms
const int pulseSpacingMs = 100;

void setup() {
  pinMode(ledPin, OUTPUT);
}

void loop() {
  for (int i = 0; i < numPulses; i++) {
    // Linearly decrease brightness from 255 to 0
    int brightness = map(i, 0, numPulses - 1, 255, 0);

    analogWrite(ledPin, brightness);   // Turn on with decreasing brightness
    delay(pulseWidthMs);              // Wait ~8.33 ms
    analogWrite(ledPin, 0);           // Turn off
    delay(pulseSpacingMs);            // Wait 100 ms
  }
}