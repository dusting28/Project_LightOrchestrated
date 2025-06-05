const int ledPin = 12;  // PWM-capable on Mega

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  analogWrite(ledPin, 255);
  delay(120000);
  analogWrite(ledPin, 0);
  delay(600000);
}