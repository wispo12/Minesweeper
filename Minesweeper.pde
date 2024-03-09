import de.bezier.guido.*;
public int NUM_ROWS = 10;
public int NUM_COLS = 10;
public int setMines = (int)(Math.random()*10 + 5);
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines= new ArrayList <MSButton>();  

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  for (int ce = 0; ce < setMines; ce++) {
    int mr = (int)(Math.random()*NUM_ROWS);
    int mc = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[mr][mc])) {
      mines.add(buttons[mr][mc]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int myFlags = setMines;
  int clickedBoxes = (NUM_ROWS * NUM_COLS) - setMines;
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int n = 0; n < NUM_COLS; n++) {
      if (mines.contains(buttons[i][n])) {
        if (buttons[i][n].flagged)
          myFlags --;
      } else if (buttons[i][n].clicked)
        clickedBoxes --;
    }
  }    

  if ( myFlags == 0 && clickedBoxes == 0) {

    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  for(int i =0; i < buttons.length; i++){
  mines.get(i).setClicked(true);
  buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("Y"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("U"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("L"); 
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("S"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("E");
  }
}
public void displayWinningMessage()
{
   
 buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("Y"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("U"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("W"); 
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("I"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("N"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("!");
}
public boolean isValid(int r, int c)
{
  if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
    return true;
  else
    return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<=row+1; r++)
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines++;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = (float)400.0/(float)NUM_COLS;
    height = (float)400.0/(float)NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isClicked() {
    return clicked;
  }

  public void setClicked(boolean val) {
    clicked = val;
  }

  // called by manager
  public void mousePressed ()
  {
    clicked = true;


    if (mouseButton==RIGHT) {
      if (flagged==true) {
        flagged = false;
        clicked = false;
      } else if (flagged==false) {
        flagged = true;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol)>0) {
      setLabel(countMines(myRow, myCol));
    } else {
       
        for (int r = myRow-1; r<=myRow+1; r++) {    
          for (int c = myCol-1; c<=myCol+1; c++) {
            if (isValid(r, c)==true&&!buttons[r][c].clicked) {
              buttons[r][c].mousePressed();
            }
          }
        }
     
    }
  }
  public void draw ()
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(255,182,193);
    else if (clicked)
      fill( 255 );
    else
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}  
