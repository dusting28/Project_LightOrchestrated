const int pulsePin = 8;           // Digital output pin
const int currentSensePin = A0;   // Analog input for current monitoring
const int currentThreshold = 800; // Overcurrent threshold (~40 A)

const unsigned long pulseWidth = 17;     // Pulse duration (ms)
const unsigned long pulseInterval = 549; // Interval between pulses (ms)

void setup() {
  pinMode(pulsePin, OUTPUT);
  digitalWrite(pulsePin, LOW);
}

void loop() {

  // Start pulse
  unsigned long pulseStart = millis();
  digitalWrite(pulsePin, HIGH);
  delay(2);

  // Monitor during the pulse
  while (millis() - pulseStart < pulseWidth) {
    int currentValue = analogRead(currentSensePin);
    if (currentValue > currentThreshold) {
      digitalWrite(pulsePin, LOW);  // Immediately cut pulse
    }
  }

  // Normal pulse end
  digitalWrite(pulsePin, LOW);

  // Wait for next pulse (no need to monitor here)
  delay(pulseInterval);
}



/*
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
*/