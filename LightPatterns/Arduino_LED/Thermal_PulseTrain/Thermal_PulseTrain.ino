const int ledPin = 12;  // PWM-capable on Mega
const int pulseWidth = 17;  // ms
const int numPulse = 150;

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  for (int iter1 = 1; iter1 <= numPulse; iter1++) {
    analogWrite(ledPin, 255);
    delay(pulseWidth);

    analogWrite(ledPin, 0);
    delay(83);
  }
  delay(100000);
}