
function showSheet(shit) {
  // var vf = new Vex.Flow.Factory({renderer: {elementId: 'boo', height: 120}});
  // var score = vf.EasyScore();
  // var system = vf.System();

  var para = document.createElement("p");
  var node = document.createTextNode("ni ma bi");
  para.appendChild(node);
  var element = document.getElementById("div1");
  element.appendChild(para);

  for (i=0; i<3; i++) {
    let cao = shit[i];
    system.addStave({
    voices: [
      score.voice(score.notes(cao, {stem: 'up'}))
    ]
  }).addClef('treble');
  }

  // system.addStave({
  //   voices: [
  //     score.voice(score.notes('C#3/q, B2, A2/8, B2, C#3, D3', {clef: 'bass', stem: 'up'})),
  //     score.voice(score.notes('C#2/h, C#2', {clef: 'bass', stem: 'down'}))
  //   ]
  // }).addClef('bass').addTimeSignature('4/4');
  //
  // system.addStave({
  //   voices: [
  //     score.voice(
  //       score.notes('C#5/q, B4')
  //         .concat(score.beam(score.notes('A4/8, E4, C4, D4')))
  //     )
  //   ]
  // }).addClef('treble').addTimeSignature('4/4');
  //
  // system.addStave({
  //   voices: [
  //     score.voice(score.notes('C#3/q, B2, A2/8, B2, C#3, D3', {clef: 'bass', stem: 'up'})),
  //     score.voice(score.notes('C#2/h, C#2', {clef: 'bass', stem: 'down'}))
  //   ]
  // }).addClef('bass').addTimeSignature('4/4');
  //
  // vf.draw();
}

// var notes = ["C#5/q, B4, A4, G#4", "D#5/q, C4, D4, G#4"];
// showSheet(notes);

