uint8_t led_pin;
uint8_t knob_pin;

void setup() {
  led_pin = 28;
  knob_pin = A0;
  pinMode(led_pin, OUTPUT);
  pinMode(knob_pin, INPUT);
  Serial.begin(9600);
  
  Serial.println("HELLO");
}

void loop() {
  // we map the 10 bit input value to a 8 bit PWM output
  Serial.println("HELLO");
  Serial.println(analogRead(knob_pin));
  analogWrite(led_pin, analogRead(knob_pin) / 4);
}
