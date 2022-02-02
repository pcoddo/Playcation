/**
 Adapted from "Grim Reaper's Used Cars - Deal Wheel" 
by: Ryan Mulligan
https://codepen.io/hexagoncircle/pen/bGqVyxm

-------------------------------------------------
 * Prize data will space out evenly on the deal wheel based on the amount of items available.
 * @param text [string] name of the prize
 * @param color [string] background color of the prize
 */
const prizes = [
  {
    text: "Roughing It",
    color: "hsl(2 60% 55%)",
    reaction: "no"
  },
  { 
    text: "Clooney",
    color: "hsl(173 58% 39%)",
    reaction: "yes"
  },
  { 
    text: "Luxury",
    color: "hsl(43 74% 66%)",
    reaction: "no"
  },
  {
    text: "Economy",
    color: "hsl(27 87% 67%)",
    reaction: "no"
  },
  {
    text: "Extreme Comfort",
    color: "hsl(91 43% 54%)",
    reaction: "no"
  }
];

const wheel = document.querySelector(".deal-wheel");
const spinner = wheel.querySelector(".spinner");
const trigger = wheel.querySelector(".btn-spin");
const ticker = wheel.querySelector(".ticker");

const prizeSlice = 360 / prizes.length;
const prizeOffset = Math.floor(180 / prizes.length);
const spinClass = "is-spinning";
const selectedClass = "selected";
const spinnerStyles = window.getComputedStyle(spinner);
let tickerAnim;
let rotation = 0;
let currentSlice = 0;
let prizeNodes;

const createPrizeNodes = () => {
  prizes.forEach(({ text, color, reaction }, i) => {
    const rotation = ((prizeSlice * i) * -1) - prizeOffset;
    
    if(reaction=="no") {
        spinner.insertAdjacentHTML(

            "beforeend",
            `<li class="prize" data-reaction=${reaction} style="--rotate: ${rotation}deg">
              <span class="text">${text}</span>
            </li>`
        );
    } else {
      spinner.insertAdjacentHTML(

        "beforeend",
        `<li class="prize" data-reaction=${reaction} style="--rotate: ${rotation}deg">
         <img src="clooney.png" class="Cloon" width="90%" data-rotate="180">
            </li>`
      );
    }
    
  });
};

const createConicGradient = () => {
  spinner.setAttribute(
    "style",
    `background: conic-gradient(
      from -90deg,
      ${prizes
        .map(({ color }, i) => `${color} 0 ${(100 / prizes.length) * (prizes.length - i)}%`)
        .reverse()
      }
    );`
  );
};


const setupWheel = () => {
  createConicGradient();
  createPrizeNodes();
  prizeNodes = wheel.querySelectorAll(".prize");
};

const spinertia = (min, max) => {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

const runTickerAnimation = () => {
  // https://css-tricks.com/get-value-of-css-rotation-through-javascript/
  const values = spinnerStyles.transform.split("(")[1].split(")")[0].split(",");
  const a = values[0];
  const b = values[1];  
  let rad = Math.atan2(b, a);
  
  if (rad < 0) rad += (2 * Math.PI);
  
  const angle = Math.round(rad * (180 / Math.PI));
  const slice = Math.floor(angle / prizeSlice);

  if (currentSlice !== slice) {
    ticker.style.animation = "none";
    setTimeout(() => ticker.style.animation = null, 10);
    currentSlice = slice;
  }

  tickerAnim = requestAnimationFrame(runTickerAnimation);
};

const selectPrize = () => {
  const selected = Math.floor(rotation / prizeSlice);
  prizeNodes[selected].classList.add(selectedClass);
  
};

trigger.addEventListener("click", () => {

  trigger.disabled = true;
  rotation = Math.floor(Math.random() * 360 + spinertia(2000, 5000));
  prizeNodes.forEach((prize) => prize.classList.remove(selectedClass));
  wheel.classList.add(spinClass);
  spinner.style.setProperty("--rotate", rotation);
  ticker.style.animation = "none";
  runTickerAnimation();
});

spinner.addEventListener("transitionend", () => {
  cancelAnimationFrame(tickerAnim);
  trigger.disabled = false;
  trigger.focus();
  rotation %= 360;
  selectPrize();
  wheel.classList.remove(spinClass);
  spinner.style.setProperty("--rotate", rotation);
});

setupWheel();