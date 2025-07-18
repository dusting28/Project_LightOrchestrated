const int pulsePin = 8;           // Digital output pin
const int currentSensePin = A0;   // Analog input for current monitoring
const int currentThreshold = 950; // Overcurrent threshold (~40 A)

void setup() {
  pinMode(pulsePin, OUTPUT);
  digitalWrite(pulsePin, LOW);
}

void loop() {

  // Start pulse
  digitalWrite(pulsePin, HIGH);
  delay(2);

  // Monitor during the pulse
  bool flag = true;
  while (flag) {
    int currentValue = analogRead(currentSensePin);
    if (currentValue > currentThreshold) {
      digitalWrite(pulsePin, LOW);  // Immediately cut pulse
      flag = false;
    }
  }

  // Wait for next pulse (no need to monitor here)
  delay(4294967295); 
}

