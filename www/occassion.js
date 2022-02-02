// Adapted heavily from:
// https://codepen.io/barrytsmith/pen/kXKAXb
// https://codepen.io/havardob/pen/KzoOMB
// https://codepen.io/mkurapov/pen/vLRVjm

// Convo function
     function GetConvo() {
        const convo = [
          {
            title: "Eat, Pray, Love",
            rec1: "You're gonna love this",
            rec2: "On this trip you'll be doing a classic <b>Eat, Pray, Love</b> scenario",
            send1: "What does that entail?",
            rec3: "You know, drink some wine, eat a risotto, start a journal. Find yourself!",
            send2: "You had me at risotto",
            rec4: "Bon appétit and bon voyage!"            
          },
          {
            title: "Girls Trip",
            rec1: "I got you girl",
            rec2: "Because this time you're going on a <b>Girl's Trip</b>!",
            send1: "Sounds exciting! But what if I've never done one of these before?",
            rec3: "No worries, a Girl's Trip is more of a state of mind than anything. Just be ready to have fun, get flirty, and eat lots of brunch",
            send2: "I certainly wouldn't mind flirting with a bottomless mimosa",
            rec4: "You and me both sister"            
          },
          {
            title: "Honeymoon",
            rec1: "Fasten your seatbelts, it's going to be a bumpy night",
            rec2: "Or at least I hope so, because you'll be traveling for your <b>Honeymoon</b>",
            send1: "👀",
            rec3: "But remember, the honeymoon's not just about what happens behind closed doors. There are plenty of activities that are better with a loved one - it's your job to plan them",
            send2: "Sounds like this trip with be love at first <em>flight</em>",
            rec4: "🙄"            
          },
          {
            title: "Pure Relaxation",
            rec1: "Turn off your phone, light some candles, and run a bath",
            rec2: "Because the name of the game for this trip is <b>Pure Relaxation</b>",
            send1: "Self love you say? Now there's a novel idea",
            rec3: "That's right, this trip is all about you. Embrace your wants, your needs. Live a little!",
            send2: "I can feel my chakras aligning already",
            rec4: "Um TMI"            
          },
          {
            title: "Vlog",
            rec1: "This Playcation is all about the 'gram baby",
            rec2: "Because you're setting out to record your very own <b>Travel Vlog</b>",
            send1: "But I don't know the first thing about search engine optimization",
            rec3: "No worries, just focus on capturing experiences that are so amazing it'll make other people feel bad about their boring lives",
            send2: "That sounds pretty dark",
            rec4: "Not if you use the right filter #notdark"            
          },
          {
            title: "Business Trip",
            rec1: "I hope you packed your pantsuit",
            rec2: "Because this time you're heading out on a <b>Business Trip</b>",
            send1: "Sounds like a lot of, well...work",
            rec3: "Just because it's business doesn't mean it can't also be for pleasure. You just need to make sure you maximize fun while you maximize profits",
            send2: "I'll be sure to put the <em>sin</em> in 'synergy'",
            rec4: "We're going to plan a tag-up after your trip to discuss these puns"            
          }
      ];
       
      randind = Math.floor(Math.random()*convo.length);
       
      var rec_1 = convo[randind].rec1;
      var rec_2 = convo[randind].rec2;
      var rec_3 = convo[randind].rec3;
      var rec_4 = convo[randind].rec4;
      var send_1 = convo[randind].send1;
      var send_2 = convo[randind].send2;
      document.getElementById("rec1").innerHTML=rec_1;
      document.getElementById("rec2").innerHTML=rec_2;
      document.getElementById("rec3").innerHTML=rec_3;
      document.getElementById("rec4").innerHTML=rec_4;
      document.getElementById("send1").innerHTML=send_1; 
      document.getElementById("send2").innerHTML=send_2; 
}

// Messenger
var messenger = {

  bubbles : document.getElementsByClassName('message'),
  counter : 0,
  
  bubbleTimer : function(){
    var interval = (Math.random() * 2000) + 5000;
    var t = this;
    var x = setTimeout(function(){
        t.showBubbles();
    }, interval); //random time between 1 and 4 seconds
  },
  
  showBubbles : function(){
    if(this.bubbles[this.counter].classList.contains('received') && !document.getElementById('conversation').classList.contains('pending')){
      document.getElementById('conversation').classList.add('pending');
      this.bubbleTimer();
     }else{
       if(this.counter < this.bubbles.length){
         this.bubbles[this.counter].classList.add('show');
         document.getElementById('conversation').classList.remove('pending')
         this.counter++;
         this.bubbleTimer(); 
       }
    } 
  }, // end showBubbles
  
  rerun : function(){
    for(var i = 0; i < this.bubbles.length; i++){
      this.bubbles[i].classList.remove('show');
    }
    this.counter = 0;
    this.showBubbles();
  },
  reset : function(){
    for(var i = 0; i < this.bubbles.length; i++){
      this.bubbles[i].classList.remove('show');
    }
    this.counter = 0;
  },
} // end messenger

// Play messages
document.getElementById('send').onclick = function(){
  messenger.reset();
  GetConvo();
  messenger.showBubbles();
  //messenger.rerun(); 
};


// Set time on iphone
var times = new Date();
times = times.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
document.getElementById('date-time').innerHTML=times;