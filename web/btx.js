"use strict";
window.onload = function() {
  var websocket_uri;
  if (window.location.protocol === "https:") {
    websocket_uri = "wss:";
  } else {
    websocket_uri = "ws:";
  }
  websocket_uri += "//" + window.location.host;
  websocket_uri += "/btxws";

  var btxSocket = new WebSocket(websocket_uri)
  btxSocket.binaryType = "arraybuffer";
  var emulator = window.emulator = new V86Starter({
    memory_size: 2 * 1024 * 1024,
    vga_memory_size: 1 * 1024 * 1024,
    screen_container: document.getElementById("screen_container"),
    bios: {
      url: "seabios.bin",
    },
    vga_bios: {
      url: "vgabios.bin",
    },
    fda: {
      url: "btx.img",
    },
    autostart: true,
  });
  btxSocket.onopen = function() {
    emulator.add_listener('serial0-output-char', function(c) {
      var ab = new ArrayBuffer(1)
      var abv = new Uint8Array(ab)
      abv[0] = c.charCodeAt(0)
      btxSocket.send(ab)
      // console.log("sent " + c)
    })
  }
  btxSocket.onmessage = function(event) {
    var data = event.data
    if (event.data instanceof ArrayBuffer) {
      data = new Uint8Array(event.data)
      emulator.serial_send_bytes(0, data)
      // console.log("received " + data)
    } else {
      console.log("received data in unsupported format: " + data)
    }
  }

  const codes = {
    "ini": [0x3b, 0xbb],
    "ter": [0x3c, 0xbc],
    "dct": [0x3d, 0xbd],
    "dial": [0x44, 0xc4],
    "1": [0x02, 0x82],
    "2": [0x03, 0x83],
    "3": [0x04, 0x84],
    "4": [0x05, 0x85],
    "5": [0x06, 0x86],
    "6": [0x07, 0x87],
    "7": [0x08, 0x88],
    "8": [0x09, 0x89],
    "9": [0x0a, 0x8a],
    "0": [0x0b, 0x8b],
  }
  for (let i of Object.keys(codes)) {
    var e = document.getElementById("keyboard-" + i)
    e.addEventListener("click", function(event) {
      var code = codes[i]
      console.log("sending keys " + code)
      emulator.keyboard_send_scancodes(code)
    })
  }
}
