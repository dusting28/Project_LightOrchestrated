const int analogPin = A0;   // Analog input pin
int analogValue = 0;        // Variable to store the analog value

void setup() {
  Serial.begin(2000000);     // Start serial communication at 115200 baud
}

void loop() {
  analogValue = analogRead(analogPin);   // Read the analog input (0–1023)
  Serial.println(analogValue);           // Send the value to the Serial Monitor
}