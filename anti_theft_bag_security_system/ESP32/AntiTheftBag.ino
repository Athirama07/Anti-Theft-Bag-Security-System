#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <math.h>
#include "BluetoothSerial.h"

// ======================================================
// ANTI-THEFT BAG SECURITY SYSTEM
// ESP32 BACKEND - VERSION 5
// Bluetooth + Sensors + Alarm
// ======================================================


// ======================================================
// 1. BLUETOOTH
// ======================================================

BluetoothSerial SerialBT;


// Bluetooth device name
const char* bluetoothName = "AntiTheftBag";


// ======================================================
// 2. SETTINGS
// ======================================================

String correctPIN = "1234";

bool isArmed = false;


// ======================================================
// 3. PIN DEFINITIONS
// ======================================================

const int REED_PIN = 27;

const int BUZZER_PIN = 25;

const int LED_PIN = 26;


// ======================================================
// 4. MPU6050
// ======================================================

Adafruit_MPU6050 mpu;

bool mpuConnected = false;

float motionThreshold = 2.0;

unsigned long lastMotionAlert = 0;

const unsigned long motionCooldown = 3000;


// ======================================================
// 5. REED SWITCH
// ======================================================

bool lastReedState = HIGH;

unsigned long lastReedChange = 0;

const unsigned long reedDebounce = 300;


// ======================================================
// 6. ALARM
// ======================================================

bool alarmActive = false;


// ======================================================
// SETUP
// ======================================================

void setup() {

  // ----------------------------------------------------
  // Serial Monitor
  // ----------------------------------------------------

  Serial.begin(115200);

  delay(1000);

  Serial.println();
  Serial.println("======================================");
  Serial.println("   ANTI-THEFT BAG SECURITY SYSTEM");
  Serial.println("           ESP32 VERSION 5");
  Serial.println("======================================");
  Serial.println();


  // ----------------------------------------------------
  // Pins
  // ----------------------------------------------------

  pinMode(REED_PIN, INPUT_PULLUP);

  pinMode(BUZZER_PIN, OUTPUT);

  pinMode(LED_PIN, OUTPUT);

  digitalWrite(BUZZER_PIN, LOW);

  digitalWrite(LED_PIN, LOW);


  // ----------------------------------------------------
  // I2C
  // ----------------------------------------------------

  Wire.begin(21, 22);


  // ----------------------------------------------------
  // MPU6050
  // ----------------------------------------------------

  Serial.println("Starting MPU6050...");

  if (!mpu.begin()) {

    Serial.println("WARNING: MPU6050 not detected!");

    mpuConnected = false;

  }

  else {

    Serial.println("MPU6050 connected successfully.");

    mpuConnected = true;

    mpu.setAccelerometerRange(MPU6050_RANGE_8_G);

    mpu.setGyroRange(MPU6050_RANGE_500_DEG);

    mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
  }


  // ----------------------------------------------------
  // Reed switch
  // ----------------------------------------------------

  lastReedState = digitalRead(REED_PIN);

  Serial.println("Reed switch initialized.");


  // ----------------------------------------------------
  // Bluetooth
  // ----------------------------------------------------

  Serial.println("Starting Bluetooth...");

  if (SerialBT.begin(bluetoothName)) {

    Serial.println("Bluetooth started successfully.");

    Serial.print("Bluetooth name: ");

    Serial.println(bluetoothName);
  }

  else {

    Serial.println("ERROR: Bluetooth failed to start.");
  }


  // ----------------------------------------------------
  // System information
  // ----------------------------------------------------

  Serial.println();

  Serial.println("System status: DISARMED");

  Serial.println();

  Serial.println("Bluetooth commands:");

  Serial.println("STATUS");

  Serial.println("ARM:1234");

  Serial.println("DISARM:1234");

  Serial.println("FIND:1234");

  Serial.println();

}


// ======================================================
// MAIN LOOP
// ======================================================

void loop() {


  // ====================================================
  // SERIAL COMMANDS
  // ====================================================

  if (Serial.available()) {

    String command = Serial.readStringUntil('\n');

    command.trim();

    processCommand(command);
  }


  // ====================================================
  // BLUETOOTH COMMANDS
  // ====================================================

  if (SerialBT.available()) {

    String command = SerialBT.readStringUntil('\n');

    command.trim();

    processCommand(command);
  }


  // ====================================================
  // SENSOR CHECKING
  // ====================================================

  if (isArmed) {

    checkMotion();

    checkReedSwitch();
  }


  delay(100);
}


// ======================================================
// PROCESS COMMAND
// ======================================================

void processCommand(String command) {

  Serial.print("Received command: ");

  Serial.println(command);


  // ====================================================
  // STATUS
  // ====================================================

  if (command == "STATUS") {

    if (isArmed) {

      sendResponse("STATUS:ARMED");
    }

    else {

      sendResponse("STATUS:DISARMED");
    }
  }


  // ====================================================
  // ARM
  // ====================================================

  else if (command.startsWith("ARM:")) {

    String enteredPIN = command.substring(4);


    if (enteredPIN == correctPIN) {

      isArmed = true;

      alarmActive = false;

      stopAlarm();

      sendResponse("ARMED");
    }

    else {

      sendResponse("WRONG PIN");
    }
  }


  // ====================================================
  // DISARM
  // ====================================================

  else if (command.startsWith("DISARM:")) {

    String enteredPIN = command.substring(7);


    if (enteredPIN == correctPIN) {

      isArmed = false;

      alarmActive = false;

      stopAlarm();

      sendResponse("DISARMED");
    }

    else {

      sendResponse("WRONG PIN");
    }
  }


  // ====================================================
  // FIND MY BAG
  // ====================================================

  else if (command.startsWith("FIND:")) {

    String enteredPIN = command.substring(5);


    if (enteredPIN == correctPIN) {

      sendResponse("FIND");

      findBag();
    }

    else {

      sendResponse("WRONG PIN");
    }
  }


  // ====================================================
  // UNKNOWN COMMAND
  // ====================================================

  else {

    sendResponse("UNKNOWN COMMAND");
  }
}


// ======================================================
// SEND RESPONSE TO SERIAL + BLUETOOTH
// ======================================================

void sendResponse(String message) {

  // Send to Arduino Serial Monitor

  Serial.println(message);


  // Send to Flutter through Bluetooth

  SerialBT.println(message);
}


// ======================================================
// MOTION DETECTION
// ======================================================

void checkMotion() {

  if (!mpuConnected) {

    return;
  }


  sensors_event_t acceleration;

  sensors_event_t gyro;

  sensors_event_t temperature;


  mpu.getEvent(
    &acceleration,
    &gyro,
    &temperature
  );


  // Calculate total acceleration

  float totalAcceleration = sqrt(

    acceleration.acceleration.x *
    acceleration.acceleration.x

    +

    acceleration.acceleration.y *
    acceleration.acceleration.y

    +

    acceleration.acceleration.z *
    acceleration.acceleration.z
  );


  // Difference from normal gravity

  float accelerationChange =
    fabs(totalAcceleration - 9.81);


  // Detect movement

  if (accelerationChange > motionThreshold) {

    unsigned long currentTime = millis();


    if (currentTime - lastMotionAlert >
        motionCooldown) {

      sendResponse("MOTION");

      startAlarm();

      lastMotionAlert = currentTime;
    }
  }
}


// ======================================================
// REED SWITCH / ZIPPER
// ======================================================

void checkReedSwitch() {

  bool currentReedState =
    digitalRead(REED_PIN);


  if (currentReedState != lastReedState) {

    unsigned long currentTime = millis();


    if (currentTime - lastReedChange >
        reedDebounce) {

      lastReedChange = currentTime;

      lastReedState = currentReedState;


      // ZIPPER OPEN

      if (currentReedState == HIGH) {

        sendResponse("ZIP_OPEN");

        startAlarm();
      }


      // ZIPPER CLOSED

      else {

        sendResponse("ZIP_CLOSED");
      }
    }
  }
}


// ======================================================
// START ALARM
// ======================================================

void startAlarm() {

  alarmActive = true;

  digitalWrite(LED_PIN, HIGH);

  digitalWrite(BUZZER_PIN, HIGH);
}


// ======================================================
// STOP ALARM
// ======================================================

void stopAlarm() {

  alarmActive = false;

  digitalWrite(BUZZER_PIN, LOW);

  digitalWrite(LED_PIN, LOW);
}


// ======================================================
// FIND MY BAG
// ======================================================

void findBag() {

  stopAlarm();


  // Three short beeps

  for (int i = 0; i < 3; i++) {

    digitalWrite(BUZZER_PIN, HIGH);

    digitalWrite(LED_PIN, HIGH);

    delay(200);

    digitalWrite(BUZZER_PIN, LOW);

    digitalWrite(LED_PIN, LOW);

    delay(200);
  }
}