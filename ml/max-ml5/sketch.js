/*
  MaxAndP5js (c) 2016-18, Paweł Janicki (https://paweljanicki.jp)
      a simple messaging system between patches created in MaxMSP
      (https://cycling74.com) and sketches written with P5*js
      (https://p5js.org).

  P5js sketch (as any HTML/JavaScript document loaded inside jweb) can
  communicate with Max. Max can call functions from P5js sketches. P5js
  sketch can read/write content of Max dictionaries and send messages to Max.

  However, there is a namespace conflict between Max API binded to the
  "window" object (accessible from within jweb) and P5js API binded by
  default to the same object (in so called "global mode").

  There are several methods to circumvent this problem, and one of the
  simpler ones (requiring editing only the "sketch.js" file) is using P5js in
  so called "instance mode". Look at the code in the "sketch.js" file attached 
  to this example to see how to prevent the namespaces conflict and how to
  effectively interact with P5js sketches inside jweb object.

  For more informations about differences between "global" and "instance"
  modes of the P5js look at the "p5.js overview" document (available at
  https://github.com/processing/p5.js/wiki/p5.js-overview). For more
  information about communication between Max patcher and content loaded jweb
  object check the "Communicating with Max from within jweb" document (part
  of Max documentation).
*/

// *************************************************************************

/*
  This is a basic helper function checking if the P5js sketch is loaded inside
  Max jweb object.
*/
function detectMax() {
  try {
    /*
      For references to all functions attached to window.max object read the
      "Communicating with Max from within jweb" document from Max documentation.
    */
    window.max.outlet('Hello Max!');
    return true;
  }
  catch(e) {
    console.log('Max, where are you?');
  }
  return false;
}

const s = (sketch) => {

  // let's test and memorize if the sketch is loaded inside Max jweb object
  var maxIsDetected = detectMax();

  let featureExtractor;
  let video;
  let sending;

  sketch.setup = () => {
    sketch.noCanvas();
    // Create a video element
    video = sketch.createCapture(sketch.VIDEO);
    video.parent('videoContainer');
    video.size(320, 240);
    
    sending = false;

    // Extract the already learned features from MobileNet
    featureExtractor = ml5.featureExtractor('MobileNet', sketch.modelReady);

  }

  // A function to be called when the model has been loaded
  sketch.modelReady = () => {    
    sending = true;
    sketch.select('#modelStatus').html('MobileNet Loaded!');
  }

  sketch.showFeatures = () => {
    const features = featureExtractor.infer(video);
    const logits = features.dataSync();
    var featString = '';
    for (var i = 0; i < logits.length; i++) {
      featString += logits[i] + ' ';
    }
  //  console.log(logits[0]);
    window.max.outlet('features '+ featString);
  }

  sketch.draw = () => {
    if (sending)
      sketch.showFeatures();
  }
}

let myp5 = new p5(s);



