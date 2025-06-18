const int ledPin = 12;  // PWM-capable on Mega

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  for (int i = 0; i <= 600; i++) {
    analogWrite(ledPin, 255);
    delay(17);
    analogWrite(ledPin, 0);
    delay(150);
  }
  delay(600000);
}