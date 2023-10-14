#!/usr/bin/env python3
import serial
import json
from azure.iot.device import IoTHubDeviceClient, Message
from datetime import datetime

CONNECTION_STRING = ""

def iothub_client_init():
    clientIoT = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)
    return clientIoT

def convert_to_json(pmtwo, pmten):
    json_body = {
            'eventdate': datetime.now().isoformat(),
            'measurement': 'airq_measurements',
            'device_id': 'rpi-airq',
            'measurement_pm25': pmtwo,
            'measurement_pm10': pmten
    }
    return json.dumps(json_body)

def send_to_iothub(payload):
    try:
        message = Message(payload)
        clientIoT.send_message(message)
    except KeyboardInterrupt:
        print ( "IoTHubClient stopped" )

if __name__ == '__main__':
    print ( "Press Ctrl-C to exit" )
    print ( "Initializing" )
    ser = serial.Serial('/dev/ttyUSB0')
    clientIoT = iothub_client_init()

    while True:
        data = []
        for index in range(0,10):
            datum = ser.read()
            data.append(datum)
        pmtwo = int.from_bytes(b''.join(data[2:4]), byteorder='little') / 10
        pmten = int.from_bytes(b''.join(data[4:6]), byteorder='little') / 10
        formatted_data = convert_to_json(pmtwo, pmten)
        print ( formatted_data )
        send_to_iothub(formatted_data)
