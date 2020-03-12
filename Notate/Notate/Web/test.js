// Create an SVG renderer and attach it to the DIV element named "boo".

// line height: 350

function generate(str) {
    var vf = new Vex.Flow.Factory({renderer: {elementId: 'boo', height: 520}});
    var score = vf.EasyScore();
    var system = vf.System();
    
    system.addStave({
      voices: [
        score.voice(score.notes(str, {stem: 'up'})),
      ]
    }).addClef('treble');
    
//    system.addStave({
//      voices: [
//        score.voice(score.notes('C#5/q, B4, A4, G#4', {stem: 'up'})),
//        score.voice(score.notes('C#4/h, C#4', {stem: 'down'}))
//      ]
//    }).addClef('treble');
//
//    system.addStave({
//      voices: [
//        score.voice(score.notes('C#3/q, B2, A2/8, B2, C#3, D3', {clef: 'bass', stem: 'up'})),
//        score.voice(score.notes('C#2/h, C#2', {clef: 'bass', stem: 'down'}))
//      ]
//    }).addClef('bass').addTimeSignature('4/4');
//
//    system.addStave({
//      voices: [
//        score.voice(
//          score.notes('C#5/q, B4')
//            .concat(score.beam(score.notes('A4/8, E4, C4, D4')))
//        )
//      ]
//    }).addClef('treble').addTimeSignature('4/4');
//
//    system.addStave({
//      voices: [
//        score.voice(score.notes('C#3/q, B2, A2/8, B2, C#3, D3', {clef: 'bass', stem: 'up'})),
//        score.voice(score.notes('C#2/h, C#2', {clef: 'bass', stem: 'down'}))
//      ]
//    }).addClef('bass').addTimeSignature('4/4');

    vf.draw();

}

//generate('C#5/q, B4, A4, G#4')

