# Consumers

Consumers are MQTT clients of the TagPipe Bus. The TagPipe Bus leverages the [AWS Iot Core](https://aws.amazon.com/iot-core/features/) Message Broker

## Connecting

> Connecting to MQTT Bus

```javascript
// Install the aws iot device sdk 
// from https://www.npmjs.com/package/aws-iot-device-sdk
const awsIot = require('aws-iot-device-sdk')

// Replace the below values with your own
const PRIVATE_KEY_PATH = '/path/to/keys/private.key'
const PEM_KEY_PATH = '/path/to/keys/certificate.pem'
const ROOT_CA_PEM_KEY_PATH = '/path/to/keys/root.ca.pem'
// TBD Retrieve id somehow
const CUSTOMER_ID = '1'

const mqttClient = awsIot.device({
    keyPath: PRIVATE_KEY_PATH,
    certPath: PEM_KEY_PATH,
    caPath: ROOT_CA_PEM_KEY_PATH,
    clientId: `customer-${CUSTOMER_ID}-consumer-` + Date.now(),
    host: 'a11uydwkfjit3.iot.ap-southeast-2.amazonaws.com'
})
```


To connect to the TagPipe Bus you will need the following details, which can be obtained from your Customer Portal by creating a new consumer from the Consumer tab:

1.  **Private Key file** - Available for download after creating a consumer
1.  **Certificate PEM file** - Available for download after creating a consumer
1.  **Root CA file** - Available for download after creating a consumer
1.  **Customer Id** - Available from the Consumer tab

In addition you will need to install the [AWS IoT Device SDK](https://aws.amazon.com/iot/sdk/)


## Inventory MQTT Client

Inventory messages are published by each of your reader's every 10 seconds and includes all tags that were observed during that period, including when they were first seen and last seen during that 10 second period.

### Subscribe to all of your readers

> Subscribe to all of your readers

```javascript
const READER_ID = '+'

mqttClient.subscribe(`${CUSTOMER_ID}/${READER_ID}/inventory`)
mqttClient.on('message', (topic, payload) => {
    console.log('Received inventory message', topic)

    try {
       // Process payload
       let strPayload = payload.toString()
       let messageAsJSON = JSON.parse(strPayload))

        // Now process the message as needed
    } catch (err) {
        console.error('Error processing message payload', err)
    }
})
```

This topic includes inventory messages from all your readers.

`+` is a wildcard character that can be used as the `READER_ID` in the subscription path to subscribe to all your readers inventory messages as shown in the example.

This topic publishes message in the [Inventory message payload format](#inventory-message-payload)

### Subscribe to a specific one of your readers

> Subscribe to a specific one of your readers

```javascript
const READER_ID = '1' // Replace with your reader id

mqttClient.subscribe(`${CUSTOMER_ID}/${READER_ID}/inventory`)
```

This topic includes inventory messages for a specific reader, where the `+` is replaced with the **Reader ID**.

The **Reader ID** can be discovered in the following way:

-   By subscribing to all readers and observing the value of `reader.id` in the message payload

This topic publishes message in the [Inventory message payload format](#inventory-message-payload)

## Inventory Message Payload

> Inventory Message Payload

```json
{
  "tags": [
    {
      "peakRSSI": -51,
      "epc": "4765 6D74 7265 6520 537A 2030 3800",
      "firstSeenTime": 1522894675829578,
      "lastSeenTime": 1522894683531019,
      "antennas": [
        "1"
      ],
      "tid": "E28011702000114B22650912",
      "PcBits": 13312
    },
    {
      "peakRSSI": -59,
      "epc": "5368 6164 7261 6368 2043 6162 2030 3900",
      "firstSeenTime": 1522894675825859,
      "lastSeenTime": 1522894683533232,
      "antennas": [
        "1"
      ],
      "tid": "E28011702000105122600912",
      "PcBits": 15360
    }
  ],
  "reader": {
    "id": "1"
  },
  "customer": {
    "id": "1"
  },
  "count": 2
}
```
The message payload is received as a buffer and needs to be parsed to a JSON object with following structure:

Field | Type | Description 
------|------|------------
`tags`  | Array | Array of objects for each tag that was observed
`tag.peakRSSI` | Number | The best [RSSI](https://en.wikipedia.org/wiki/Received_signal_strength_indication) value, in dBm, observed during the period
`tag.epc` | Number | The [EPC](https://en.wikipedia.org/wiki/Electronic_Product_Code) value in hexadecimal format
`tag.firstSeenTime` | Number | The time the tag was first seen during the 10 second period, in microseconds since the Epoch (00:00:00 UTC, January 1, 1970)
`tag.lastSeenTime` | Number | The time the tag was last seen during the 10 second period, in microseconds since the Epoch (00:00:00 UTC, January 1, 1970)
`tag.antennas` | Array | Array of antenna id's that observed then reader
`tag.tid` | String | Tag identification memory, in a Gen 2 RFID tag, this consists of memory about the tag itself, such as the tag ID
`tag.PcBits` | Number | The Protocol Control Bits (PC bits) of backscattered with the tags EPC
`reader` | Object | Contains information about the reader that published the message
`reader.id` | String | The TiM id of the reader, unique for all TiM readers
`customer` | Object | Contains information about the customer that published the message
`customer.id` | String |  The TiM id of the customer, unique for all TiM customers
`count` | Number | The number of tags in the message
