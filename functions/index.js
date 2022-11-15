//const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
var admin = require("firebase-admin");

// var serviceAccount = require("path/to/serviceAccountKey.json");

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
//   databaseURL: "https://medicbangladesh-default-rtdb.firebaseio.com"
// });

admin.initializeApp();

const messaging = admin.messaging();


exports.scheduledFunctionCrontab = functions.pubsub.schedule(' 1 * * * *')
  .timeZone('America/New_York') // Users can choose timezone - default is America/Los_Angeles
  .onRun((context) => {
  console.log('This will be run every 1 minute!');
  return null;
});


exports.notifySubscribers = functions.https.onCall(async (data, _) => {
    try {

        await messaging.sendToDevice(data.targetDevices, {
            notification: {
                title: data.messageTitle,
                body: data.messageBody
            }
        });
        return true;
    } catch (ex) {
        return false;
    }
});


    // var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    // var res = await func.call(<String, dynamic>{
    //   "targetDevices": [_msgService.token],
    //   "messageTitle": "Test title",
    //   "messageBody": ctrl.text
    // });

    // print("message was ${res.data as bool ? "sent!" : "not sent!"}");