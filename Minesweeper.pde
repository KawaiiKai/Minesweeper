import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public int flgged = 0;
public int flgcnt = 0;
public int bomb = 20;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
         buttons[r][c] = new MSButton(r,c);
      }
    }
    
    
    setMines(bomb);
}
public void setMines(int num)
{
    
    for(int i = 0; i < num; i++){
      int r = (int)(Math.random()*NUM_ROWS);
      int c = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[r][c])){
      mines.add(buttons[r][c]);
      
     
    }else{
      i--;
    }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    if (flgcnt == flgged) {
    if (flgcnt == bomb) {
 
      return true;
    }
  }
  return false;
}
public void displayLosingMessage()
{
  for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        if(mines.contains(buttons[i][j])){
          buttons[i][j].clicked = true; 
        }
      }
    }  
    
    buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("Y"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("U"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("");
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("B"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 ].setLabel("L");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("E"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("W");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel("");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 4].setLabel("U"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 5].setLabel("P");
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2 - 7].setLabel("Y"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 6].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("U"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel(" "); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("D"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("I"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("D");
    buttons[NUM_ROWS/2][NUM_COLS/2 ].setLabel("N"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("'"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("T"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel(" "); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 4].setLabel("B"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 5].setLabel("L");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 6].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 +7].setLabel("W");
 
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && r >= 0){
    if(c < NUM_COLS && c >= 0)
    return true; 
  }
  return false;
}
public int countMines(int row, int col)
{
    
   int count = 0;
  for(int r = row-1;r<=row+1;r++)
    for(int c = col-1; c<=col+1;c++)
      if(isValid(r,c) && mines.contains(buttons[r][c]))
        count++;
  if(mines.contains(buttons[row][col]))
    count--;
  return count;

 
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        
        clicked = true;
        if(mouseButton == RIGHT && flagged == true){
         flagged = false; 
         clicked = false;
         flgged -= 1;
        if (mines.contains(buttons[myRow][myCol])) {
          flgcnt -= 1;
        }
      }
        else if(mouseButton == RIGHT && flagged == false){
          flagged = true;
          flgged += 1;
        if (mines.contains(buttons[myRow][myCol])) {
          flgcnt += 1;
        }
        }
        else if(mines.contains(this)){
          displayLosingMessage();
        }
        else if(countMines(myRow,myCol) > 0){
          setLabel(countMines(myRow,myCol));
        }
        else{ 
          for(int r = myRow-1;r<=myRow+1;r++){
          for(int c = myCol-1; c<=myCol+1;c++){
            if(isValid(r,c) == true && buttons[r][c].clicked == false){
              buttons[r][c].clicked = true;
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
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
         
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
