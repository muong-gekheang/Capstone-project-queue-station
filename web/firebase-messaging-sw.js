importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCuvtrA1S3-UDc5YcpfYSnHOE6ogJfCV_4",
  authDomain: "queue-station.firebaseapp.com",
  projectId: "queue-station",
  storageBucket: "queue-station.firebasestorage.app",
  messagingSenderId: "1078138551100",
  appId: "1:1078138551100:web:60a7601e9def4bf71b3c39",
});

const messaging = firebase.messaging();