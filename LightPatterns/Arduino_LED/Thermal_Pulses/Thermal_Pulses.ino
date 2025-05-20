const int ledPin = 12;  // PWM-capable on Mega
const int pulseWidth = 500;  // ms
const int numPulse = 50;

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  for (int iter1 = 1; iter1 <= numPulse; iter1++) {
    analogWrite(ledPin, 255);
    delay(pulseWidth+(25*iter1));

    analogWrite(ledPin, 0);
    delay(120000);
  }
}