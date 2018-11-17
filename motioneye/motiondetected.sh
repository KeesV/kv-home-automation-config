#!/bin/bash
curl -X POST -H "Authorization: Bearer $HA_TOKEN" -H "Content-Type: application/json" -d '{"state": "on", "attributes": {"friendly_name": "Babycam beweging", "device_class": "motion" }}' http://homeassistant:8123/api/states/binary_sensor.babycam_motion
