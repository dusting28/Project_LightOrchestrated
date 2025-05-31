const int ledPin = 12;  // PWM-capable on Mega
const int numPulses = 100;
const int pulseWidthMicros = 30;  // 1/120 sec = ~8.33 ms
const int pulseSpacingMs = 1000;

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  TCCR1B = TCCR1B & 0b11111000 | 0x01;
}

void loop() {
  for (int i = 0; i < numPulses; i++) {
    int brightness = 100-i;
    analogWrite(ledPin, brightness);

    delay(pulseWidthMicros);

    analogWrite(ledPin, 0);
    delay(pulseSpacingMs);

    Serial.println(brightness);  // Debug output
  }
}