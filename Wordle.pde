import java.util.Set;
import java.util.HashSet;

/* @pjs globalKeyEvents="true"; */

final Set<String> words = new HashSet();
String word;

char[][] prevWords = new char[6][5];
int guessNum = 0;

char[] currWord = new char[5];
int currPos = 0;

void setup() {
  size(500, 600);
  for (String word : loadStrings("./valid-wordle-words.txt")) words.add(word);
  background(10, 10, 10);
  word = words.toArray(new String[words.size()])[(int)(Math.random()*words.size())];
  textSize(64);
  textAlign(CENTER, CENTER);
  noLoop();
  rowmode = true;
}

void draw() {
  if (rowmode) {
    rowmode = false;
    int r = guessNum - 1;
    if (r >= 0 && new String(prevWords[r]).equals(word)) {
      background(10, 40, 10);
      text("gg", width/2, height/2);
      return;
    } else if (guessNum >= prevWords.length) {
      background(40, 10, 10);
      text("womp womp", width/2, height/2);
      return;
    }
    for (int c = 0; c < prevWords[guessNum].length; c++) {
      fill(40, 40, 40);
      rect(c*100+10, guessNum*100+10, 80, 80);
    }
    if (r < 0) return;
    char[] wordm = word.toCharArray();
    for (int c = 0; c < prevWords[r].length; c++) {
      int ind;
      for (ind = wordm.length-1; ind >= 0; ind--) if (wordm[ind] == prevWords[r][c]) break;
      if (ind == -1) fill(40, 40, 40);
      else if (word.charAt(c) == prevWords[r][c]) {
        fill(40, 100, 40);
        wordm[c] = 0;
      } else {
        fill(100, 100, 40);
        wordm[ind] = 0;
      }
      rect(c*100+10, r*100+10, 80, 80);
      if (prevWords[r][c] != 0)
      fill(255, 255, 255);
      text(Character.toUpperCase(prevWords[r][c]), c*100+50, r*100+40);
    }
  } else {
    int c = currPos;
    if (indexoffset) c--;
    fill(40, 40, 40);
    rect(c*100+10, guessNum*100+10, 80, 80);
    if (currWord[c] != 0)
    fill(255, 255, 255);
    text(Character.toUpperCase(currWord[c]), c*100+50, guessNum*100+40);
    indexoffset = false;
  }
}

boolean rowmode = false;
boolean indexoffset = false;
void keyPressed() {
  if (keyCode == 10) {
    for (char c : currWord) if (c == 0) return;
    if (!words.contains(new String(currWord))) return;
    prevWords[guessNum++] = currWord;
    rowmode = true;
    currWord = new char[5];
    currPos = 0;
  } else if (keyCode >= 65 && keyCode <= 90) {
    currWord[currPos] = Character.toLowerCase(key);
    if (currPos+1 < 5) {currPos++; indexoffset = true;}
  } else if (keyCode == 8) {
    if (currWord[currPos] == 0 && currPos - 1 >= 0) currPos--;
    currWord[currPos] = 0;
  }
  redraw();
}
