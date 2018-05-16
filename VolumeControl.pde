class VolumeControl {
  Dial dial;
  Gain gain;
  AudioPlayer[] players;

  VolumeControl(AudioPlayer[] p, Dial d) {
    players = p;
    dial = d;
  }

  void update() {
    for (AudioPlayer player : players) { 

      if ( player.hasControl(Controller.GAIN) )
      {
        // map the mouse position to the audible range of the gain
        float val = map(dial.getSetting(), dial.max, dial.min, 6, -30);
        // if a gain control is not available, this will do nothing
        player.setGain(val); 
      }
      
    }
  }
  
}
